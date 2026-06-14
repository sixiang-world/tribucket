import { sym } from '../utils/log';
import { existsSync, readdirSync, unlinkSync, lstatSync, readlinkSync } from 'fs';
import { join } from 'path';
import { loadConfig, saveConfig } from '../config/store';
import { binDir } from '../config/paths';

export function clean(): void {
  const config = loadConfig();
  const removed: string[] = [];

  for (const [key, info] of Object.entries(config.packages)) {
    if (!existsSync(info.path)) { delete config.packages[key]; removed.push(info.name || key); }
  }

  if (removed.length > 0) {
    saveConfig(config);
    console.log(`Removed ${removed.length} stale entry(ies):`);
    for (const name of removed) console.log(`  ${sym('ok')} ${name}`);
  } else {
    console.log('No stale entries found.');
  }

  const bd = binDir();
  if (existsSync(bd)) {
    const dangling: string[] = [];
    for (const f of readdirSync(bd)) {
      const linkPath = join(bd, f);
      try { if (lstatSync(linkPath).isSymbolicLink() && !existsSync(linkPath)) dangling.push(linkPath); } catch {}
    }
    if (dangling.length > 0) {
      console.log(`\nRemoving ${dangling.length} dangling symlink(s):`);
      for (const linkPath of dangling) {
        try {
          const target = readlinkSync(linkPath);
          unlinkSync(linkPath);
          console.log(`  ${sym('ok')} ${linkPath} ${sym('arrow')} ${target}`);
        } catch {
          unlinkSync(linkPath);
          console.log(`  ${sym('ok')} ${linkPath}`);
        }
      }
    } else if (removed.length === 0) {
      console.log('Nothing to clean.');
    }
  }
}
