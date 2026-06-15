#!/usr/bin/env bun
import { Command } from 'commander';
import { cleanupOldTmp } from './utils/cleanup';
import { setNoColor, sym } from './utils/log';
import { detectPlatform } from './utils/platform';

import { VERSION } from './version';

const program = new Command();
program
  .name('tribucket')
  .description('Lightweight portable package manager')
  .option('--json', 'JSON output (with --version)')
  .option('--no-color', 'Disable colored output')
  .option('--proxy <url>', 'Proxy URL for all HTTP requests (e.g. http://127.0.0.1:7897)');

// Handle --version and --proxy before commander processes args,
// so they work even if no subcommand is given.
const args = process.argv.slice(2);

// Check for --no-color before commander processes args
if (args.includes("--no-color") || !process.stdout.isTTY || process.env.NO_COLOR !== undefined) {
  setNoColor(true);
}

// Bootstrap --proxy: set env vars early so all modules pick them up
const proxyIdx = args.indexOf('--proxy');
if (proxyIdx !== -1 && proxyIdx + 1 < args.length) {
  const proxyUrl = args[proxyIdx + 1];
  process.env.ALL_PROXY = proxyUrl;
}

if (args.includes('--version') || args.includes('-V')) {
  const jsonOutput = args.includes('--json');
  if (jsonOutput) {
    console.log(JSON.stringify({
      version: VERSION,
      runtime: `${process.version}`,
      platform: detectPlatform(),
    }));
  } else {
    console.log(`tribucket ${VERSION}`);
  }
  process.exit(0);
}

program.version(VERSION);

// preAction hook: forward --proxy to env for all commands
program.hook('preAction', (thisCommand) => {
  const opts = thisCommand.optsWithGlobals();
  if (opts.proxy) {
    process.env.ALL_PROXY = opts.proxy;
  }
});

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
  .option('--force', 'Skip confirmation prompt')
  .action(async (name, opts) => {
    const { uninstallPackage } = await import('./commands/uninstall');
    if (!await uninstallPackage(name, opts)) process.exit(5);
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
    // Merge global opts so --json (also defined at program level) is visible.
    // Arrow function => use module-scoped `program`, not `this`.
    const merged = { ...opts, ...program.optsWithGlobals() };
    await listPackages(merged);
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
      // Use each package's human-readable .name (NOT the repo-key, which can
      // contain "/" and would be misread as a filesystem path by checkPackage).
      names = Object.values(config.packages).map((p: any) => p.name).filter((n: any): n is string => !!n);
    }
    if (names.length === 0) { console.error('Specify package names or use --all'); process.exit(2); }

    // Concurrent check (work queue, matching Python's ThreadPoolExecutor)
    const { concurrentMap } = await import('./utils/concurrent');
    const { status } = await import('./utils/log');
    const { t } = await import('./utils/locale');
    const checkStart = Date.now();
    const results = await concurrentMap(names, (n: string) => checkPackage(n, opts), 4,
      (done, total) => { status(t('checking_packages', { done, total })); },
    );

    // Clear the status line
    if (process.stdout.isTTY) {
      process.stdout.write('\r' + ' '.repeat(60) + '\r');
    }

    // NOTE: read --json via optsWithGlobals(). The program also defines a
    // global --json (index.ts top), and in Commander v15 a command-level
    // option with the same name as a program-level one does NOT appear in the
    // command's local opts() — it only surfaces through optsWithGlobals().
    // We use program (module-scoped) rather than `this` because these actions
    // are arrow functions, which do not bind their own `this` to the command.
    const wantJson = program.optsWithGlobals().json === true || opts.json === true;
    if (wantJson) {
      const output: Record<string, any> = {};
      for (const r of results) output[r.name || '?'] = { local: r.local, remote: r.remote, status: r.status, source: r.local_source };
      console.log(JSON.stringify(output, null, 2));
      return;
    }

    for (const r of results) {
      if (r.error) console.log(`${r.name?.padEnd(20)}  ${sym('err')} ${r.error}`);
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
      // Use each package's human-readable .name (NOT the repo-key, which can
      // contain "/" and would be misread as a filesystem path downstream).
      const names = Object.values(config.packages).map((p: any) => p.name).filter((n: any): n is string => !!n);
      if (names.length === 0) { console.log('No packages tracked.'); return; }

      if (opts.dryRun) {
        const { checkPackage } = await import('./commands/check');
        const wouldUpdate: Array<{n: string; local: string; remote: string}> = [];
        for (const n of names) {
          const r = await checkPackage(n, { localOnly: false });
          if (r.remote && r.local !== r.remote) {
            wouldUpdate.push({ n, local: r.local!, remote: r.remote });
          } else if (r.remote) {
            console.log(`${n.padEnd(20)}  ${r.local} — already up to date`);
          }
        }
        if (wouldUpdate.length > 0) {
          console.log(`\n${sym('warn')} ${wouldUpdate.length} package(s) would be updated:`);
          for (const { n, local, remote } of wouldUpdate) {
            console.log(`  ${n}: ${local} ${sym('arrow')} ${remote}`);
          }
        } else {
          console.log(`\n${sym('ok')} All packages up to date.`);
        }
        return;
      }

      // Confirm before bulk update (unless non-interactive)
      const { confirm } = await import('./utils/prompt');
      const ok = await confirm(t('confirm_update_all', { count: names.length }));
      if (!ok) { console.log(`  ${sym('arrow')} ${t('skipped_confirmation')}`); return; }

      // Concurrent update (work queue, matching Python's ThreadPoolExecutor)
      const { concurrentMap } = await import('./utils/concurrent');
      const { status } = await import('./utils/log');
      let success = 0, failed = 0;
      const updateOne = async (n: string) => {
        const { updatePackage } = await import('./commands/update');
        try {
          if (await updatePackage(n, opts)) success++;
          else { failed++; console.error(`[error] ${n}: update failed`); }
        } catch (e) { failed++; console.error(`[error] ${n}: ${e}`); }
      };
      await concurrentMap(names, updateOne, 4,
        (done, total) => { status(t('updating_packages', { done, total })); },
      );

      console.log(`\n${t('update_summary', { ok: success, failed })}`);
      process.exit(failed > 0 ? 1 : 0);
      return;
    }

    if (!name) { console.error('Specify a package name or use --all'); process.exit(2); }

    if (opts.dryRun) {
      const { checkPackage } = await import('./commands/check');
      const r = await checkPackage(name, { localOnly: false });
      if (r.error) { console.error(`Error: ${r.error}`); process.exit(3); }
      if (r.remote && r.local !== r.remote) console.log(`${name}: ${r.local} ${sym('arrow')} ${r.remote} (would update)`);
      else console.log(`${name}: ${r.local} — already up to date`);
      process.exit(0);
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
  .option('--json', 'JSON output')
  .action(async (name, opts) => {
    const { showInfo } = await import('./commands/info');
    if (!await showInfo(name, opts)) process.exit(3);
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

// Cleanup old temp files in the background (don't block command startup)
setImmediate(() => { cleanupOldTmp(); });

// Catch SIGINT globally (matching Python's KeyboardInterrupt handler)
process.on('SIGINT', () => {
  import('./utils/locale').then(({ t }) => {
    console.error(`\n${t('interrupted_sigint')}`);
    process.exit(130);
  }).catch(() => {
    console.error('\nInterrupted.');
    process.exit(130);
  });
});

// Handle uncaught rejections gracefully
process.on('unhandledRejection', (reason) => {
  if (process.env.TRIBUCKET_VERBOSE === '1') {
    console.error('Unhandled rejection:', reason);
  }
  process.exit(1);
});

program.parse();
