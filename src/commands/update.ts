import { existsSync, mkdirSync, chmodSync, readFileSync } from 'fs';
import { join } from 'path';
import { execSync } from 'child_process';
import { loadConfig, saveConfig } from '../config/store';
import { detectVersion } from '../engine/version';
import { resolveDownloadUrl } from '../engine/mirror';
import { downloadFile } from '../engine/download';
import { extractArchive } from '../utils/archive';
import { log, error } from '../utils/log';
import { backupDir } from '../config/paths';
import { PackageLock } from '../engine/lock';
import { detectPlatform } from '../utils/platform';
import { httpGetJson } from '../utils/http';
import type { PackageMeta } from '../types';

export async function updatePackage(name: string, options: { force?: boolean; mirror?: string; noBackup?: boolean }): Promise<boolean> {
  const config = loadConfig();
  const info = config.packages[name];
  if (!info) { error('not-found', `Package '${name}' is not tracked.`); return false; }

  const path = info.path;
  if (!existsSync(path)) { error('stale', `Package path does not exist: ${path}`); return false; }

  const tjPath = join(path, 'tributable.json');
  if (!existsSync(tjPath)) { error('config', `tributable.json not found in ${path}`); return false; }
  const tj: PackageMeta = JSON.parse(readFileSync(tjPath, 'utf-8'));

  const repo = tj.repo || '';
  const binary = tj.binary || name;
  const installType = tj.install_type || 'binary';

  const [localVer] = detectVersion(join(path, binary), tj, info);
  log(`Local version: ${localVer}`);

  const token = process.env.GITHUB_TOKEN;
  let remoteVer: string | null = null;
  try {
    const data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
    remoteVer = data.tag_name?.replace(/^v/, '') || null;
  } catch { error('network', `Cannot check remote version for ${repo}`); return false; }

  if (!remoteVer) { error('network', `Cannot check remote version for ${repo}`); return false; }
  log(`Remote version: ${remoteVer}`);

  if (localVer === remoteVer && !options.force) {
    console.log(`${name}: ${localVer} — already up to date`);
    return true;
  }

  const platform = detectPlatform();
  if (!platform) { error('platform', 'Unsupported platform'); return false; }

  const pattern = tj.asset_pattern?.[platform];
  if (!pattern || pattern === 'NO_MATCH') { error('platform', `No asset available for ${platform}`); return false; }

  const [url, provider] = await resolveDownloadUrl(repo, remoteVer, pattern, options.mirror as any);
  log(`Download URL (${provider}): ${url}`);

  const lock = new PackageLock(name);
  lock.acquire();

  try {
    const tmpDir = join(Bun.TEMP_DIR, `tributable-${Date.now()}`);
    mkdirSync(tmpDir, { recursive: true });

    try {
      const archivePath = await downloadFile(url, tmpDir);
      if (!archivePath) { error('network', 'Download failed'); return false; }

      if (!options.noBackup) {
        const bkPath = join(backupDir(), name, localVer);
        mkdirSync(bkPath, { recursive: true });
        execSync(`cp -r "${path}"/* "${bkPath}"/`, { stdio: 'pipe' });
        log(`Backed up to ${bkPath}`);
      }

      const extractDir = join(tmpDir, 'extracted');
      extractArchive(archivePath, extractDir);

      if (installType === 'directory') {
        execSync(`rsync -a --exclude='tributable.json' --exclude='install.sh' --exclude='cmd' "${extractDir}"/ "${path}"/`, { stdio: 'pipe' });
      } else {
        const found = execSync(`find "${extractDir}" -name "${binary}" -type f | head -1`, { encoding: 'utf-8' }).trim();
        if (found) {
          const dest = join(path, binary);
          execSync(`cp "${found}" "${dest}"`, { stdio: 'pipe' });
          chmodSync(dest, 0o755);
        }
      }

      config.packages[name].version = remoteVer;
      saveConfig(config);

      if (!options.noBackup) {
        const bkPath = join(backupDir(), name, localVer);
        if (existsSync(bkPath)) execSync(`rm -rf "${bkPath}"`, { stdio: 'pipe' });
      }

      console.log(`${name}: ${localVer} → ${remoteVer} ✓`);
      return true;
    } finally {
      try { execSync(`rm -rf "${tmpDir}"`, { stdio: 'pipe' }); } catch {}
    }
  } finally {
    lock.release();
  }
}
