import { existsSync, mkdirSync, chmodSync, readFileSync, readdirSync, statSync, copyFileSync, rmSync } from 'fs';
import { join, resolve } from 'path';
import { execFileSync } from 'child_process';
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
import { getCachedRemoteVersion, saveRemoteVersionCache } from '../config/cache';
import type { PackageMeta } from '../types';

// SIGINT handler for graceful interrupt
let sigintHandler: NodeJS.SignalsHandler | null = null;

function handleSigint() {
  console.log('\nInterrupted. Partial download saved. Run the same command again to resume.');
  process.exit(130);
}

export async function updatePackage(name: string, options: { force?: boolean; mirror?: string; noBackup?: boolean }): Promise<boolean> {
  const config = loadConfig();
  const info = config.packages[name];
  if (!info) { error('not-found', `Package '${name}' is not tracked.`); return false; }

  const path = info.path;
  if (!existsSync(path)) { error('stale', `Package path does not exist: ${path}`); return false; }

  const tjPath = join(path, 'tribucket.json');
  if (!existsSync(tjPath)) { error('config', `tribucket.json not found in ${path}`); return false; }
  const tj: PackageMeta = JSON.parse(readFileSync(tjPath, 'utf-8'));

  const repo = tj.repo || '';
  const binary = tj.binary || name;
  const installType = tj.install_type || 'binary';

  const [localVer] = detectVersion(join(path, binary), tj, info);
  log(`Local version: ${localVer}`);

  const token = process.env.GITHUB_TOKEN;
  let remoteVer: string | null = null;

  // Try cache first (unless force)
  if (!options.force) {
    const cached = getCachedRemoteVersion(repo);
    if (cached) remoteVer = cached;
  }

  // Fetch from API if not cached
  if (!remoteVer) {
    try {
      const data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
      remoteVer = data.tag_name?.replace(/^v/, '') || null;
      if (remoteVer) saveRemoteVersionCache(repo, remoteVer);
    } catch { error('network', `Cannot check remote version for ${repo}`); return false; }
  }

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

  // Install SIGINT handler
  sigintHandler = handleSigint;
  process.on('SIGINT', sigintHandler);

  const lock = new PackageLock(name);
  lock.acquire();

  try {
    const { tmpdir } = await import('os');
    const tmpDir = join(tmpdir(), `tribucket-update-${Date.now()}`);
    mkdirSync(tmpDir, { recursive: true });

    try {
      const archivePath = await downloadFile(url, tmpDir);
      if (!archivePath) { error('network', 'Download failed'); return false; }

      // SHA256 verification (best-effort)
      if (repo) {
        try {
          const { findSha256FromRelease, computeSha256 } = await import('../utils/sha256');
          const token = process.env.GITHUB_TOKEN;
          const releaseData = await httpGetJson<any>(
            `https://api.github.com/repos/${repo}/releases/latest`,
            { token }
          );
          const archiveName = archivePath.split('/').pop() || '';
          const expectedHash = await findSha256FromRelease(releaseData, archiveName);
          if (expectedHash) {
            const actualHash = await computeSha256(archivePath);
            if (actualHash !== expectedHash) {
              error('integrity', `SHA256 mismatch for ${archiveName}`,
                    `Expected: ${expectedHash}\nGot: ${actualHash}`);
              return false;
            }
            log('SHA256 verification OK');
          } else {
            log('SHA256 verification skipped (no checksum in release)');
          }
        } catch {
          log('SHA256 verification skipped (could not fetch release info)');
        }
      }

      let backupPath: string | null = null;
      if (!options.noBackup) {
        backupPath = join(backupDir(), name, localVer);
        mkdirSync(backupPath, { recursive: true });
        // Copy directory safely
        const entries = readdirSync(path);
        for (const entry of entries) {
          const srcPath = join(path, entry);
          const destPath = join(backupPath, entry);
          const stat = statSync(srcPath);
          if (stat.isDirectory()) {
            execFileSync('cp', ['-r', srcPath, destPath], { stdio: 'pipe' });
          } else {
            copyFileSync(srcPath, destPath);
          }
        }
        log(`Backed up to ${backupPath}`);
      }

      const extractDir = join(tmpDir, 'extracted');
      extractArchive(archivePath, extractDir);

      try {
        if (installType === 'directory') {
          // Copy directory contents safely, excluding certain files
          const excludeFiles = ['tribucket.json', 'install.sh', 'cmd'];
          const entries = readdirSync(extractDir);
          for (const entry of entries) {
            if (excludeFiles.includes(entry)) continue;
            const srcPath = join(extractDir, entry);
            const destPath = join(path, entry);
            const stat = statSync(srcPath);
            if (stat.isDirectory()) {
              execFileSync('rsync', ['-a', `${srcPath}/`, `${destPath}/`], { stdio: 'pipe' });
            } else {
              copyFileSync(srcPath, destPath);
            }
          }
        } else {
          const found = execFileSync('find', [extractDir, '-name', binary, '-type', 'f'], {
            encoding: 'utf-8',
            stdio: ['pipe', 'pipe', 'pipe'],
          }).trim();
          if (found) {
            const firstFile = found.split('\n')[0];
            const dest = join(path, binary);
            copyFileSync(firstFile, dest);
            chmodSync(dest, 0o755);
          }
        }
      } catch (updateError) {
        // Restore from backup on failure
        if (backupPath && existsSync(backupPath)) {
          log('Update failed, restoring from backup...');
          try {
            // Remove current files
            const currentEntries = readdirSync(path);
            for (const entry of currentEntries) {
              const entryPath = join(path, entry);
              const stat = statSync(entryPath);
              if (stat.isDirectory()) {
                rmSync(entryPath, { recursive: true, force: true });
              } else {
                rmSync(entryPath, { force: true });
              }
            }
            // Restore from backup
            const backupEntries = readdirSync(backupPath);
            for (const entry of backupEntries) {
              const srcPath = join(backupPath, entry);
              const destPath = join(path, entry);
              const stat = statSync(srcPath);
              if (stat.isDirectory()) {
                execFileSync('cp', ['-r', srcPath, destPath], { stdio: 'pipe' });
              } else {
                copyFileSync(srcPath, destPath);
              }
            }
            log('Restore successful');
          } catch (restoreError) {
            error('restore', `Restore also failed: ${restoreError}`);
          }
        }
        throw updateError;
      }

      config.packages[name].version = remoteVer;
      saveConfig(config);

      if (!options.noBackup && backupPath && existsSync(backupPath)) {
        rmSync(backupPath, { recursive: true, force: true });
      }

      console.log(`${name}: ${localVer} → ${remoteVer} ✓`);
      return true;
    } finally {
      try { rmSync(tmpDir, { recursive: true, force: true }); } catch {}
    }
  } finally {
    lock.release();
    // Remove SIGINT handler
    if (sigintHandler) {
      process.removeListener('SIGINT', sigintHandler);
      sigintHandler = null;
    }
  }
}
