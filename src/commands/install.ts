import { existsSync, mkdirSync, chmodSync, writeFileSync, readFileSync, statSync, readdirSync, copyFileSync, rmSync, cpSync, symlinkSync, realpathSync } from 'fs';
import { join, resolve, basename, sep } from 'path';
import { tmpdir } from 'os';
import type { PackageMeta } from '../types';
import { httpGetJson } from '../utils/http';
import { detectPlatform, binaryFileName } from '../utils/platform';
import { log, status, error, sym } from '../utils/log';
import { extractArchive } from '../utils/archive';
import { downloadFile } from '../engine/download';
import { resolveDownloadUrl } from '../engine/mirror';
import { loadConfig, saveConfig } from '../config/store';
import { binDir } from '../config/paths';
import { computeSha256, findSha256FromRelease } from '../utils/sha256';
import { findRepoKey } from './track';
import { findBinary } from '../utils/find';
import { versionFromTag } from '../engine/version';
import { t } from '../utils/locale';

const REPO_URL = 'https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages';

export async function installPackage(
  name: string,
  options: { dir?: string; link?: boolean; force?: boolean; mirror?: string }
): Promise<boolean> {
  const config = loadConfig();
  const existingKey = findRepoKey(config, name);
  if (existingKey && !options.force) {
    const info = config.packages[existingKey];
    if (info && existsSync(info.path)) {
      error('exists', t('error_already_installed', { name, path: info.path }),
            t('error_use_update', { name }));
      return false;
    }
  }

  let pkg: PackageMeta;
  try {
    status(t('resolving_package', { name }));
    pkg = await httpGetJson<PackageMeta>(`${REPO_URL}/${name}.json`);
  } catch {
    error('not-found', t('error_not_found', { name }));
    return false;
  }

  let targetDir = options.dir || process.cwd();
  targetDir = join(targetDir, name);

  // Path traversal protection — resolve symlinks (matching Python v1 realpath behavior)
  function resolveReal(p: string): string {
    try { return realpathSync(p); }
    catch {
      // If path doesn't exist yet, resolve parent chain
      const parent = resolve(p, '..');
      if (parent === p) return p; // root
      try { return join(realpathSync(parent), basename(p)); }
      catch { return resolve(p); }
    }
  }

  const resolvedTarget = resolveReal(targetDir);
  const resolvedBase = resolveReal(options.dir || process.cwd());
  if (!resolvedTarget.startsWith(resolvedBase + sep) && resolvedTarget !== resolvedBase) {
    error('security', t('error_path_traversal', { name }));
    return false;
  }

  // System directory protection (platform-specific paths)
  const FORBIDDEN = process.platform === 'win32'
    ? ['C:\\Windows', 'C:\\Program Files', 'C:\\Program Files (x86)', 'C:\\ProgramData']
    : ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];
  for (const forbidden of FORBIDDEN) {
    const normForbidden = resolve(forbidden);
    if (resolvedTarget === normForbidden || resolvedTarget.startsWith(normForbidden + sep)) {
      error('forbidden', t('error_forbidden_dir', { path: resolvedTarget }),
            t('error_use_user_dir'));
      return false;
    }
  }

  // Self-directory protection
  const { tribucketHome } = await import('../config/paths');
  const homeDir = resolveReal(tribucketHome());
  if (resolvedTarget === homeDir || resolvedTarget.startsWith(homeDir + sep)) {
    error('forbidden', t('error_cannot_install_home', { path: resolvedTarget }),
          t('error_use_different_dir'));
    return false;
  }

  // Non-empty directory check
  if (existsSync(targetDir)) {
    if (readdirSync(targetDir).length > 0 && !options.force) {
      error('exists', t('error_dir_not_empty', { path: targetDir }));
      console.log(`  ${sym('arrow')} ${t('error_use_force')}`);
      return false;
    }
  }

  mkdirSync(targetDir, { recursive: true });

  const platform = detectPlatform();
  if (!platform) { error('platform', t('error_unsupported_platform')); return false; }

  const version = pkg.version || '0.0.0';
  const repo = pkg.repo || '';

  // Fetch the latest release once, up front. We need:
  //  - the raw tag_name (NOT a v-stripped version) to build the download URL
  //  - the assets list to resolve glob/suffix asset patterns to real asset names
  //  - the release object again later for best-effort SHA256 verification
  // A single fetch serves all three uses.
  let releaseData: any | null = null;
  let tag = version;
  if (repo) {
    try {
      status(t('fetching_latest_release'));
      const token = process.env.GITHUB_TOKEN;
      releaseData = await httpGetJson<any>(
        `https://api.github.com/repos/${repo}/releases/latest`,
        { token }
      );
      tag = releaseData.tag_name || version;
      // If package definition has no version, derive it from the release tag
      // so the config stores a meaningful version instead of 0.0.0
      if (!pkg.version && tag !== version) {
        const extracted = versionFromTag(tag);
        if (extracted) version = extracted;
      }
      status(t('latest_release', { tag }));
      log(`Latest release: ${tag}`);
    } catch {
      log(t('could_not_fetch_release', { version }));
    }
  }

  // Determine download URL: download_url takes precedence over asset_pattern
  let url: string;
  let provider: string;
  const directUrl = pkg.download_url?.[platform];
  if (directUrl && directUrl !== 'NO_MATCH') {
    url = directUrl;
    provider = 'direct';
    log(`Download URL (download_url): ${url}`);
  } else {
    const pattern = pkg.asset_pattern?.[platform];
    if (!pattern || pattern === 'NO_MATCH') { error('platform', t('error_no_asset', { platform })); return false; }

    const resolved = await resolveDownloadUrl(repo, tag, pattern, options.mirror as any, releaseData);
    url = resolved[0];
    provider = resolved[1];
    status(provider === 'direct' ? t('using_direct_download') : t('using_mirror', { name: provider }));
    log(`Download URL (${provider}): ${url}`);
  }

  const tmpDir = join(tmpdir(), `tribucket-install-${Date.now()}`);
  mkdirSync(tmpDir, { recursive: true });

  try {
    const archivePath = await downloadFile(url, tmpDir);
    if (!archivePath) { error('network', t('download_failed')); return false; }

    // SHA256 verification (best-effort) — searches release assets for checksum files.
    // Reuses the releaseData fetched above.
    if (repo && releaseData) {
      try {
        status(t('verifying_checksum'));
        const archiveName = archivePath.split('/').pop() || '';
        const expectedHash = await findSha256FromRelease(releaseData, archiveName);
        if (expectedHash) {
          const actualHash = await computeSha256(archivePath);
          if (actualHash !== expectedHash) {
            error('integrity', t('error_sha256_mismatch', { filename: archiveName }),
                  t('error_integrity_expected', { expected: expectedHash, actual: actualHash }));
            // best-effort: continue even on mismatch (matching Python v1 behavior)
          } else {
            log('SHA256 verification OK');
          }
        } else {
          log('SHA256 verification skipped (no checksum in release)');
        }
      } catch {
        log('SHA256 verification skipped (could not fetch release info)');
      }
    }

    const extractDir = join(tmpDir, 'extracted');

    // Check if it's an archive or a raw binary
    const isArchive = archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz') ||
                      archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2') ||
                      archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz') ||
                      archivePath.endsWith('.zip');

    if (isArchive) {
      status(t('extracting_archive'));
      extractArchive(archivePath, extractDir);
    } else {
      // Raw binary — use the binary name directly (not hardcoded 'binary').
      // On Windows the executable must carry the .exe extension to be runnable.
      mkdirSync(extractDir, { recursive: true });
      const binName = binaryFileName(pkg.binary || name);
      copyFileSync(archivePath, join(extractDir, binName));
      try { chmodSync(join(extractDir, binName), 0o755); } catch { /* Windows: ignore */ }
    }

    const binary = pkg.binary || name;
    const installType = pkg.install_type || 'binary';

    if (installType === 'directory') {
      // Copy directory contents safely using native fs
      // Unwrap single top-level directory (matching Python v1 behavior)
      let copySource = extractDir;
      const entries = readdirSync(extractDir);
      if (entries.length === 1 && statSync(join(extractDir, entries[0])).isDirectory()) {
        copySource = join(extractDir, entries[0]);
      }

      const sourceEntries = readdirSync(copySource);
      for (const entry of sourceEntries) {
        const srcPath = join(copySource, entry);
        const destPath = join(targetDir, entry);
        const stat = statSync(srcPath);
        if (stat.isDirectory()) {
          if (existsSync(destPath)) rmSync(destPath, { recursive: true, force: true });
          cpSync(srcPath, destPath, { recursive: true });
        } else {
          copyFileSync(srcPath, destPath);
        }
      }
    } else {
      // Find binary using native walk
      const found = findBinary(extractDir, binary);
      if (found) {
        // On Windows the installed file must be <binary>.exe to be runnable.
        const dest = join(targetDir, binaryFileName(binary));
        copyFileSync(found, dest);
        try { chmodSync(dest, 0o755); } catch { /* Windows: ignore */ }
      }
    }

    const tributableJson = {
      name: pkg.name, version, repo: pkg.repo, description: pkg.description || '',
      binary: pkg.binary || name, homepage: pkg.homepage || '', license: pkg.license || 'Unknown',
      version_check: { cli_flags: ['--version'], parse_regex: 'v?(\\d+\\.\\d+(?:\\.\\d+)?)', output_stream: 'stdout', timeout: 5, fallback_version: version },
      asset_pattern: pkg.asset_pattern || {}, asset_format: inferAssetFormat(pkg.asset_pattern || {}),
      install_type: installType, mirror: { enabled: true },
    };
    writeFileSync(join(targetDir, 'tribucket.json'), JSON.stringify(tributableJson, null, 2) + '\n');

    // Generate install.sh
    const installSh = generateInstallSh(pkg.name, pkg.repo || '', pkg.binary || name, version);
    const installShPath = join(targetDir, 'install.sh');
    writeFileSync(installShPath, installSh);
    try { chmodSync(installShPath, 0o755); } catch { /* Windows: ignore */ }

    // Generate cmd/tribucket-update.bat
    const cmdDir = join(targetDir, 'cmd');
    mkdirSync(cmdDir, { recursive: true });
    const batContent = generateBat(pkg.name, pkg.binary || name);
    writeFileSync(join(cmdDir, 'tribucket-update.bat'), batContent);

    // Create symlink if requested
    let linked = false;
    if (options.link) {
      const bd = binDir();
      mkdirSync(bd, { recursive: true });
      const linkName = binaryFileName(pkg.binary || name);
      const linkPath = join(bd, linkName);
      const binaryPath = join(targetDir, linkName);
      if (existsSync(linkPath)) {
        try { rmSync(linkPath, { force: true }); } catch {}
      }
      try {
        symlinkSync(binaryPath, linkPath);
        log(`Symlink: ${linkPath} ${sym('arrow')} ${binaryPath}`);
        linked = true;
      } catch (e: any) {
        // Windows: creating symlinks requires admin or Developer Mode enabled.
        // Give a clear, actionable message instead of a generic failure.
        const isWin = process.platform === 'win32';
        const hint = isWin && (e?.code === 'EPERM' || e?.code === 'EACCES')
          ? t('error_windows_symlink_hint')
          : '';
        error('symlink', t('error_symlink_failed', { link: linkPath, arrow: sym('arrow'), target: binaryPath }) +
              (hint ? `\n  ${sym('arrow')} ${hint}` : ''));
      }
    }

    const repoKey = pkg.repo || name;
    config.packages[repoKey] = { name, path: targetDir, version, installed_at: new Date().toISOString(), linked };
    saveConfig(config);

    console.log(`${sym('ok')} ${t('ok_installed', { path: targetDir })}`);
    if (!linked && !options.link) {
      console.log(t('not_in_path'));
      console.log(t('add_to_path', { path: targetDir }));
      console.log(t('reinstall_with_symlink', { name }));
    }
    return true;
  } finally {
    try { rmSync(tmpDir, { recursive: true, force: true }); } catch {}
  }
}

function inferAssetFormat(patterns: Record<string, string>): string {
  for (const p of Object.values(patterns)) {
    if (p.endsWith('.tar.gz') || p.endsWith('.tgz')) return 'tar.gz';
    if (p.endsWith('.tar.bz2') || p.endsWith('.tbz2')) return 'tar.bz2';
    if (p.endsWith('.tar.xz') || p.endsWith('.txz')) return 'tar.xz';
    if (p.endsWith('.zip')) return 'zip';
  }
  return 'binary';
}

function generateInstallSh(name: string, repo: string, binary: string, version: string): string {
  return `#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
BINARY="${binary}"
BINARY_PATH="$SCRIPT_DIR/$BINARY"

if [[ ! -f "$BINARY_PATH" ]]; then
  echo "Error: Binary not found at $BINARY_PATH"
  exit 1
fi

chmod +x "$BINARY_PATH"
echo "Installed: $BINARY_PATH"
echo "Version: $version"
`;
}

function generateBat(name: string, binary: string): string {
  return `@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "BINARY=%SCRIPT_DIR%..\\${binary}.exe"
if exist "%BINARY%" (
  echo Running tribucket update for ${name}...
  tribucket update ${name}
) else (
  echo Error: Binary not found at %BINARY%
  exit /b 1
)
`;
}
