import { existsSync, readdirSync, unlinkSync, rmSync, readlinkSync, lstatSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { binDir, backupDir } from '../config/paths';
import { findRepoKey, untrack } from './track';

export function uninstallPackage(name: string): boolean {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name) || name;
  const info = config.packages[repoKey];
  if (!info) {
    console.error(`Error: '${name}' is not tracked.`);
    return false;
  }

  const path = info.path;

  if (existsSync(path)) {
    rmSync(path, { recursive: true });
    console.log(`Deleted: ${path}`);
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
            console.log(`Removed symlink: ${link}`);
          }
        }
      } catch {}
    }
  }

  // Remove backups
  const bk = join(backupDir(), name);
  if (existsSync(bk)) {
    rmSync(bk, { recursive: true });
    console.log(`Removed backup: ${bk}`);
  }

  // Untrack
  untrack(name);
  return true;
}
