import { sym } from '../utils/log';
import { existsSync, readdirSync, unlinkSync, lstatSync, readlinkSync } from 'fs';
import { join } from 'path';
import { loadConfig, saveConfig } from '../config/store';
import { binDir } from '../config/paths';
import { t } from '../utils/locale';

export function clean(): void {
  const config = loadConfig();
  const removed: string[] = [];

  for (const [key, info] of Object.entries(config.packages)) {
    if (!existsSync(info.path)) { delete config.packages[key]; removed.push(info.name || key); }
  }

  if (removed.length > 0) {
    saveConfig(config);
    console.log(t('removed_stale_entries', { count: removed.length }) + ':');
    for (const name of removed) console.log(`  ${sym('ok')} ${name}`);
  } else {
    console.log(t('no_stale_entries'));
  }

  const bd = binDir();
  if (existsSync(bd)) {
    const dangling: string[] = [];
    for (const f of readdirSync(bd)) {
      const linkPath = join(bd, f);
      try { if (lstatSync(linkPath).isSymbolicLink() && !existsSync(linkPath)) dangling.push(linkPath); } catch {}
    }
    if (dangling.length > 0) {
      console.log(`\n${t('removing_dangling_symlinks', { count: dangling.length })}:`);
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
      console.log(t('nothing_to_clean'));
    }
  }
}
