#!/usr/bin/env bun
import { Command } from 'commander';
import { cleanupOldTmp } from './utils/cleanup';
import { detectPlatform } from './utils/platform';

const VERSION = '2.0.0';

// Color support
let NO_COLOR = !process.stdout.isTTY;

const program = new Command();
program
  .name('tribucket')
  .description('Lightweight portable package manager')
  .option('--no-color', 'Disable colored output')
  .option('--json', 'JSON output (with --version)')
  .hook('preAction', (thisCommand) => {
    const opts = thisCommand.opts();
    if (opts.noColor || process.env.NO_COLOR) {
      NO_COLOR = true;
    }
  });

// Handle --version separately to support --json
const args = process.argv.slice(2);
if (args.includes('--version') || args.includes('-V')) {
  const jsonOutput = args.includes('--json');
  if (jsonOutput) {
    console.log(JSON.stringify({
      version: VERSION,
      python: `${process.version}`,
      platform: detectPlatform(),
    }));
  } else {
    console.log(`tribucket ${VERSION}`);
  }
  process.exit(0);
}

program.version(VERSION);

// install
program
  .command('install')
  .description('Install a package')
  .argument('<name>', 'Package name')
  .option('-d, --dir <path>', 'Install directory (default: cwd)')
  .option('--link', 'Create symlink in ~/.tribucket/bin/')
  .option('--force', 'Overwrite existing installation')
  .option('--mirror <mode>', 'Mirror mode: auto / cn / direct', 'auto')
  .action(async (name, opts) => {
    const { installPackage } = await import('./commands/install');
    const ok = await installPackage(name, opts);
    if (!ok) process.exit(1);
  });

// uninstall
program
  .command('uninstall')
  .description('Uninstall a package')
  .argument('<name>', 'Package name')
  .action(async (name) => {
    const { loadConfig, saveConfig } = await import('./config/store');
    const { binDir, backupDir } = await import('./config/paths');
    const { existsSync, readdirSync, unlinkSync, rmSync } = await import('fs');
    const { join } = await import('path');

    const config = loadConfig();
    const info = config.packages[name];
    if (!info) { console.error(`Error: '${name}' is not tracked.`); process.exit(5); }

    if (existsSync(info.path)) { rmSync(info.path, { recursive: true }); console.log(`Deleted: ${info.path}`); }

    const bd = binDir();
    if (existsSync(bd)) {
      for (const f of readdirSync(bd)) {
        const link = join(bd, f);
        try { if (link.startsWith(info.path)) { unlinkSync(link); console.log(`Removed symlink: ${link}`); } } catch {}
      }
    }

    const bk = join(backupDir(), name);
    if (existsSync(bk)) { rmSync(bk, { recursive: true }); console.log(`Removed backup: ${bk}`); }

    delete config.packages[name];
    saveConfig(config);
  });

// track
program
  .command('track')
  .description('Track an existing package')
  .argument('<name>', 'Package name')
  .argument('[path]', 'Package path (default: cwd)')
  .action(async (name, path) => {
    const { track } = await import('./commands/track');
    if (!track(name, path)) process.exit(1);
  });

// untrack
program
  .command('untrack')
  .description('Stop tracking a package')
  .argument('<name>', 'Package name')
  .action(async (name) => {
    const { untrack } = await import('./commands/track');
    if (!untrack(name)) process.exit(3);
  });

// list
program
  .command('list')
  .description('List tracked packages')
  .option('--json', 'JSON output')
  .option('--sort <key>', 'Sort by: name / status', 'name')
  .option('--check', 'Run version detection for all packages')
  .action(async (opts) => {
    const { listPackages } = await import('./commands/list');
    await listPackages(opts);
  });

// check
program
  .command('check')
  .description('Check package versions')
  .argument('[targets...]', 'Package names or paths')
  .option('--all', 'Check all tracked packages')
  .option('--refresh', 'Force remote version check')
  .option('--local-only', 'Skip remote check')
  .option('--json', 'JSON output')
  .action(async (targets, opts) => {
    const { checkPackage, formatCheckResult } = await import('./commands/check');
    const { loadConfig } = await import('./config/store');

    let names: string[] = targets;
    if (opts.all) {
      const config = loadConfig();
      names = Object.keys(config.packages);
    }
    if (names.length === 0) { console.error('Specify package names or use --all'); process.exit(2); }

    // Concurrent check with 4 workers
    const WORKERS = 4;
    const results: any[] = [];
    for (let i = 0; i < names.length; i += WORKERS) {
      const batch = names.slice(i, i + WORKERS);
      const batchResults = await Promise.all(batch.map(t => checkPackage(t, opts)));
      results.push(...batchResults);
    }

    if (opts.json) {
      const output: Record<string, any> = {};
      for (const r of results) output[r.name || '?'] = { local: r.local, remote: r.remote, status: r.status, source: r.local_source };
      console.log(JSON.stringify(output, null, 2));
      return;
    }

    for (const r of results) {
      if (r.error) console.log(`${r.name?.padEnd(20)}  ✗ ${r.error}`);
      else console.log(formatCheckResult(r.name!, r.local!, r.local_source!, r.remote, r.path_exists));
    }
  });

// update
program
  .command('update')
  .description('Update a package')
  .argument('[name]', 'Package name')
  .option('--all', 'Update all packages')
  .option('--force', 'Force re-download')
  .option('--dry-run', 'Show what would be updated')
  .option('--mirror <mode>', 'Mirror mode: auto / cn / direct', 'auto')
  .option('--no-backup', 'Skip backup')
  .action(async (name, opts) => {
    if (opts.all) {
      const { loadConfig } = await import('./config/store');
      const config = loadConfig();
      const names = Object.keys(config.packages);
      if (names.length === 0) { console.log('No packages tracked.'); return; }

      if (opts.dry) {
        const { checkPackage } = await import('./commands/check');
        for (const n of names) {
          const r = await checkPackage(n, { localOnly: false });
          if (r.remote && r.local !== r.remote) console.log(`${n}: ${r.local} → ${r.remote} (would update)`);
          else console.log(`${n}: ${r.local} — already up to date`);
        }
        return;
      }

      // Concurrent update with 4 workers
      const WORKERS = 4;
      let success = 0, failed = 0;
      const updateOne = async (n: string) => {
        const { updatePackage } = await import('./commands/update');
        try { if (await updatePackage(n, opts)) success++; else failed++; } catch { failed++; }
      };

      for (let i = 0; i < names.length; i += WORKERS) {
        const batch = names.slice(i, i + WORKERS);
        await Promise.all(batch.map(updateOne));
      }

      console.log(`\n${success} updated, ${failed} failed.`);
      process.exit(failed > 0 ? 1 : 0);
      return;
    }

    if (!name) { console.error('Specify a package name or use --all'); process.exit(2); }

    if (opts.dry) {
      const { checkPackage } = await import('./commands/check');
      const r = await checkPackage(name);
      if (r.remote && r.local !== r.remote) console.log(`${name}: ${r.local} → ${r.remote} (would update)`);
      else console.log(`${name}: ${r.local} — already up to date`);
      return;
    }

    const { updatePackage } = await import('./commands/update');
    if (!await updatePackage(name, opts)) process.exit(1);
  });

// info
program
  .command('info')
  .description('Show package details')
  .argument('<name>', 'Package name')
  .action(async (name) => {
    const { loadConfig } = await import('./config/store');
    const { existsSync, readFileSync } = await import('fs');
    const { join } = await import('path');

    const config = loadConfig();
    const info = config.packages[name];
    if (!info) { console.error(`Error: '${name}' is not tracked.`); process.exit(3); }

    console.log(`Name:        ${name}`);
    const tjPath = join(info.path, 'tribucket.json');
    if (existsSync(tjPath)) {
      try {
        const tj = JSON.parse(readFileSync(tjPath, 'utf-8'));
        console.log(`Repo:        ${tj.repo || '?'}`);
        console.log(`Description: ${tj.description || '?'}`);
        console.log(`Binary:      ${tj.binary || '?'}`);
        console.log(`License:     ${tj.license || '?'}`);
        console.log(`Homepage:    ${tj.homepage || '?'}`);
        console.log(`Install:     ${tj.install_type || 'binary'}`);
      } catch {}
    }
    console.log(`Installed:   ${info.path}`);
    console.log(`Version:     ${info.version || '?'}`);
    console.log(`Tracked at:  ${info.installed_at || '?'}`);
  });

// self-update
program
  .command('self-update')
  .description('Update tribucket CLI itself')
  .action(async () => {
    const { selfUpdate } = await import('./commands/self-update');
    await selfUpdate();
  });

// clean
program
  .command('clean')
  .description('Remove stale entries and dangling symlinks')
  .action(async () => {
    const { clean } = await import('./commands/clean');
    clean();
  });

// config
program
  .command('config')
  .description('Manage configuration')
  .argument('[subcommand]', 'list / get / set / unset')
  .argument('[key]', 'Setting key')
  .argument('[value]', 'Setting value')
  .action(async (subcommand, key, value) => {
    const { configCommand } = await import('./commands/config');
    configCommand(subcommand || 'list', key, value);
  });

// Cleanup on startup
cleanupOldTmp();

program.parse();
