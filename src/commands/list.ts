import { existsSync, readdirSync, lstatSync, readFileSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { binDir } from '../config/paths';
import { detectVersion } from '../engine/version';
import { httpGetJson } from '../utils/http';
import type { PackageMeta } from '../types';

export async function listPackages(options: { json?: boolean; sort?: string; check?: boolean }): Promise<void> {
  const config = loadConfig();
  const packages = Object.entries(config.packages || {});

  if (packages.length === 0) { console.log('No packages tracked.'); return; }

  // If --check, run version detection for all packages
  if (options.check) {
    const results: Array<{name: string; info: any; localVer: string; remoteVer: string | null}> = [];

    for (const [_, info] of packages) {
      const path = info.path;
      const exists = existsSync(path);
      let localVer = info.version || '?';
      let remoteVer: string | null = null;

      if (exists) {
        // Try to detect version from binary
        const tjPath = join(path, 'tributable.json');
        let tj: PackageMeta | null = null;
        if (existsSync(tjPath)) {
          try { tj = JSON.parse(readFileSync(tjPath, 'utf-8')); } catch {}
        }

        const binary = tj?.binary || info.name;
        const binaryPath = join(path, binary);
        if (existsSync(binaryPath) || tj) {
          const [ver] = detectVersion(binaryPath, tj || { version_check: { cli_flags: ['--version'], parse_regex: 'v?(\\d+\\.\\d+(?:\\.\\d+)?)', output_stream: 'stdout', timeout: 5 } }, info);
          localVer = ver;
        }

        // Try to get remote version
        const repo = tj?.repo || info.repo;
        if (repo) {
          try {
            const token = process.env.GITHUB_TOKEN;
            const data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
            remoteVer = data.tag_name?.replace(/^v/, '') || null;
          } catch {}
        }
      }

      results.push({ name: info.name, info, localVer, remoteVer });
    }

    if (options.json) {
      const output: Record<string, any> = {};
      for (const r of results) {
        output[r.name] = {
          version: r.localVer,
          remote: r.remoteVer,
          status: r.remoteVer ? (r.localVer === r.remoteVer ? 'latest' : 'outdated') : 'unknown',
          path: r.info.path,
        };
      }
      console.log(JSON.stringify(output, null, 2));
      return;
    }

    console.log(`${'Name'.padEnd(20)}  ${'Version'.padEnd(12)}  ${'Remote'.padEnd(12)}  ${'Status'.padEnd(10)}  ${'Path'}`);
    console.log('-'.repeat(100));

    for (const r of results) {
      const exists = existsSync(r.info.path);
      let status = '';
      if (!exists) status = '✗ not found';
      else if (!r.remoteVer) status = '? offline';
      else if (r.localVer === r.remoteVer) status = '✓ latest';
      else status = `⚠ outdated`;

      console.log(`${r.name.padEnd(20)}  ${r.localVer.padEnd(12)}  ${(r.remoteVer || '?').padEnd(12)}  ${status.padEnd(10)}  ${r.info.path}`);
    }
    return;
  }

  if (options.json) {
    const result: Record<string, any> = {};
    for (const [_, info] of packages) result[info.name] = info;
    console.log(JSON.stringify({ packages: result }, null, 2));
    return;
  }

  if (options.sort === 'status') {
    packages.sort((a, b) => {
      const aE = existsSync(a[1].path), bE = existsSync(b[1].path);
      return (aE === bE ? 0 : aE ? 1 : -1) || a[0].localeCompare(b[0]);
    });
  } else {
    packages.sort((a, b) => a[0].localeCompare(b[0]));
  }

  console.log(`${'Name'.padEnd(20)}  ${'Version'.padEnd(12)}  ${'Path'.padEnd(40)}  Status`);
  console.log('-'.repeat(90));

  for (const [_, info] of packages) {
    const exists = existsSync(info.path);
    console.log(`${info.name.padEnd(20)}  ${(info.version || '?').padEnd(12)}  ${info.path.padEnd(40)}  ${exists ? '✓ latest' : '✗ not found'}`);
  }

  const bd = binDir();
  if (existsSync(bd)) {
    const dangling: string[] = [];
    for (const f of readdirSync(bd)) {
      const linkPath = join(bd, f);
      try {
        if (lstatSync(linkPath).isSymbolicLink()) {
          const target = require('fs').readlinkSync(linkPath);
          if (!existsSync(linkPath)) dangling.push(`${linkPath} → ${target}`);
        }
      } catch {}
    }
    if (dangling.length > 0) {
      console.log(`\n⚠ Found ${dangling.length} dangling symlink(s):`);
      for (const p of dangling) console.log(`  ${p}`);
    }
  }

  const stale = packages.filter(([_, info]) => !existsSync(info.path)).map(([_, info]) => info.name);
  if (stale.length > 0) {
    console.log(`\n⚠ Found ${stale.length} stale entry(ies): ${stale.join(', ')}`);
    console.log(`  → Run 'tribucket clean' to remove them.`);
  }
}
