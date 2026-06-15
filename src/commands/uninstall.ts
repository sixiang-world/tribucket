import { existsSync, readdirSync, unlinkSync, rmSync, readlinkSync, lstatSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { binDir, backupDir } from '../config/paths';
import { findRepoKey, untrack } from './track';
import { sym } from '../utils/log';
import { t } from '../utils/locale';

export function uninstallPackage(name: string): boolean {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name) || name;
  const info = config.packages[repoKey];
  if (!info) {
    console.error(`Error: ${t('error_not_tracked_generic', { name })}`);
    return false;
  }

  const path = info.path;

  if (existsSync(path)) {
    rmSync(path, { recursive: true });
    console.log(t('deleted', { path }));
  }

  // Remove symlinks pointing to the package path
  const bd = binDir();
  if (existsSync(bd)) {
    for (const f of readdirSync(bd)) {
      const link = join(bd, f);
      try {
        if (lstatSync(link).isSymbolicLink()) {
          const target = readlinkSync(link);
          if (target.startsWith(path)) {
            unlinkSync(link);
            console.log(t('removed_symlink', { path: link }));
          }
        }
      } catch {}
    }
  }

  // Remove backups
  const bk = join(backupDir(), name);
  if (existsSync(bk)) {
    rmSync(bk, { recursive: true });
    console.log(t('removed_backup', { path: bk }));
  }

  // Untrack
  if (!untrack(name)) {
    console.error(t('untrack_failed', { name }));
    return false;
  }
  return true;
}
