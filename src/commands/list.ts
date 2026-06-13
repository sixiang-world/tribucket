import { existsSync, readdirSync, lstatSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { binDir } from '../config/paths';

export function listPackages(options: { json?: boolean; sort?: string }): void {
  const config = loadConfig();
  const packages = Object.entries(config.packages || {});

  if (packages.length === 0) { console.log('No packages tracked.'); return; }

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
      try { if (lstatSync(linkPath).isSymbolicLink() && !existsSync(linkPath)) dangling.push(linkPath); } catch {}
    }
    if (dangling.length > 0) {
      console.log(`\n⚠ Found ${dangling.length} dangling symlink(s):`);
      for (const p of dangling) console.log(`  ${p}`);
    }
  }

  const stale = packages.filter(([_, info]) => !existsSync(info.path)).map(([_, info]) => info.name);
  if (stale.length > 0) {
    console.log(`\n⚠ Found ${stale.length} stale entry(ies): ${stale.join(', ')}`);
    console.log(`  → Run 'tributable clean' to remove them.`);
  }
}
