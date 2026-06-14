import { sym } from '../utils/log';
import { existsSync, mkdirSync, chmodSync, readFileSync, readdirSync, statSync, copyFileSync, rmSync, cpSync } from 'fs';
import { join, dirname } from 'path';
import { loadConfig, saveConfig } from '../config/store';
import { detectVersion } from '../engine/version';
import { resolveDownloadUrl } from '../engine/mirror';
import { downloadFile } from '../engine/download';
import { extractArchive } from '../utils/archive';
import { log, error } from '../utils/log';
import { backupDir } from '../config/paths';
import { PackageLock } from '../engine/lock';
import { detectPlatform, resolveBinaryPath } from '../utils/platform';
import { httpGetJson } from '../utils/http';
import { getCachedRemoteVersion, saveRemoteVersionCache } from '../config/cache';
import { findRepoKey } from './track';
import { findBinary } from '../utils/find';
import type { PackageMeta } from '../types';

// SIGINT handler for graceful interrupt
let sigintHandler: NodeJS.SignalsHandler | null = null;

function handleSigint() {
  console.log('\nInterrupted. Partial download saved. Run the same command again to resume.');
  process.exit(130);
}

export async function updatePackage(name: string, options: { force?: boolean; mirror?: string; backup?: boolean }): Promise<boolean> {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name);
  const info = repoKey ? config.packages[repoKey] : config.packages[name];
  if (!info) { error('not-found', `Package '${name}' is not tracked.`); return false; }

  const path = info.path;
  if (!existsSync(path)) {
    error('stale', `Package path does not exist: ${path}`);
    console.error(`  ${sym('arrow')} Run 'tribucket untrack ${name}' to remove stale entry.`);
    return false;
  }

  const tjPath = join(path, 'tribucket.json');
  if (!existsSync(tjPath)) { error('config', `tribucket.json not found in ${path}`); return false; }
  const tj: PackageMeta = JSON.parse(readFileSync(tjPath, 'utf-8'));

  const repo = tj.repo || '';
  const binary = tj.binary || name;
  const installType = tj.install_type || 'binary';

  const [localVer] = detectVersion(
    installType === 'directory' ? path : resolveBinaryPath(path, binary),
    tj, info
  );
  log(`Local version: ${localVer}`);

  const token = process.env.GITHUB_TOKEN;
  let remoteVer: string | null = null;
  // Keep the full release object + raw tag for URL building / asset resolution.
  let releaseData: any | null = null;
  let remoteTag: string | null = null;

  // Try cache first (unless force)
  if (!options.force) {
    const cached = getCachedRemoteVersion(repo);
    if (cached) remoteVer = cached;
  }

  // Fetch from API if not cached
  if (!remoteVer) {
    try {
      const data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
      releaseData = data;
      remoteTag = data.tag_name || null;
      remoteVer = remoteTag?.replace(/^v/, '') || null;
      if (remoteVer) saveRemoteVersionCache(repo, remoteVer);
    } catch { error('network', `Cannot check remote version for ${repo}`); return false; }
  }

  if (!remoteVer) { error('network', `Cannot check remote version for ${repo}`); return false; }
  log(`Remote version: ${remoteVer}`);

  if (localVer === remoteVer && !options.force) {
    console.log(`${name}: ${localVer} — already up to date`);
    return true;
  }

  // If we used a cached version, we still need the release object + raw tag
  // for URL building and asset (glob/suffix) resolution. Fetch it now.
  if (!releaseData || !remoteTag) {
    try {
      releaseData = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
      remoteTag = releaseData.tag_name || remoteTag;
    } catch { error('network', `Cannot fetch release info for ${repo}`); return false; }
  }
  if (!remoteTag) { error('network', `Cannot determine release tag for ${repo}`); return false; }

  const platform = detectPlatform();
  if (!platform) { error('platform', 'Unsupported platform'); return false; }

  const pattern = tj.asset_pattern?.[platform];
  if (!pattern || pattern === 'NO_MATCH') { error('platform', `No asset available for ${platform}`); return false; }

  const [url, provider] = await resolveDownloadUrl(repo, remoteTag, pattern, options.mirror as any, releaseData);
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

      // SHA256 verification (best-effort). Reuses the releaseData fetched above.
      if (repo && releaseData) {
        try {
          const { findSha256FromRelease, computeSha256 } = await import('../utils/sha256');
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
      if (options.backup !== false) {
        backupPath = join(backupDir(), name, localVer);
        if (existsSync(backupPath)) rmSync(backupPath, { recursive: true, force: true });
        mkdirSync(dirname(backupPath), { recursive: true });
        cpSync(path, backupPath, { recursive: true });
        log(`Backed up to ${backupPath}`);
      }

      const extractDir = join(tmpDir, 'extracted');

      // Check if it's an archive or a raw binary
      const isArchive = archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz') ||
                        archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2') ||
                        archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz') ||
                        archivePath.endsWith('.zip');

      if (isArchive) {
        extractArchive(archivePath, extractDir);
      } else {
        // Raw binary — copy using the package's real binary name (NOT a
        // hardcoded "binary"). On Unix we also chmod +x so that findBinary's
        // executable-bit fallback can locate it. (Mirrors install.ts behavior.)
        mkdirSync(extractDir, { recursive: true });
        const rawBinName = tj.binary || name;
        const rawBinPath = join(extractDir, rawBinName);
        copyFileSync(archivePath, rawBinPath);
        try { chmodSync(rawBinPath, 0o755); } catch { /* Windows: ignore */ }
      }

      try {
        if (installType === 'directory') {
          // Remove stale files first (except metadata files), then copy new ones
          const keepFiles = new Set(['tribucket.json', 'install.sh', 'cmd']);
          const existingEntries = readdirSync(path);
          for (const entry of existingEntries) {
            if (keepFiles.has(entry)) continue;
            const entryPath = join(path, entry);
            const stat = statSync(entryPath);
            if (stat.isDirectory()) {
              rmSync(entryPath, { recursive: true, force: true });
            } else {
              rmSync(entryPath, { force: true });
            }
          }

          // Copy new files from extracted archive
          // Unwrap single top-level directory (matching Python v1 behavior)
          let copySource = extractDir;
          const entries = readdirSync(extractDir);
          if (entries.length === 1 && statSync(join(extractDir, entries[0])).isDirectory()) {
            copySource = join(extractDir, entries[0]);
          }

          const excludeFiles = ['tribucket.json', 'install.sh', 'cmd'];
          const sourceEntries = readdirSync(copySource);
          for (const entry of sourceEntries) {
            if (excludeFiles.includes(entry)) continue;
            const srcPath = join(copySource, entry);
            const destPath = join(path, entry);
            const stat = statSync(srcPath);
            if (stat.isDirectory()) {
              if (existsSync(destPath)) rmSync(destPath, { recursive: true, force: true });
              cpSync(srcPath, destPath, { recursive: true });
            } else {
              copyFileSync(srcPath, destPath);
            }
          }
        } else {
          // Binary type - find the binary using native walk
          const found = findBinary(extractDir, binary);
          if (!found) {
            throw new Error('No installable files found in archive');
          }
          const dest = join(path, binary);
          copyFileSync(found, dest);
          try { chmodSync(dest, 0o755); } catch { /* Windows: ignore */ }
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
            cpSync(backupPath, path, { recursive: true });
            log('Restore successful');
          } catch (restoreError) {
            error('restore', `Restore also failed: ${restoreError}`);
          }
        }
        throw updateError;
      }

      // Verify version after update
      const [newVer] = detectVersion(
        installType === 'directory' ? path : resolveBinaryPath(path, binary),
        tj, info
      );
      if (newVer !== remoteVer && newVer !== 'unknown') {
        log(`Version mismatch: expected ${remoteVer}, got ${newVer}`);
        // Don't fail, just warn — binary might report version differently
      }

      config.packages[repoKey || name].version = remoteVer;
      saveConfig(config);

      if (options.backup !== false && backupPath && existsSync(backupPath)) {
        rmSync(backupPath, { recursive: true, force: true });
      }

      console.log(`${name}: ${localVer} ${sym('arrow')} ${remoteVer} ${sym('ok')}`);
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
