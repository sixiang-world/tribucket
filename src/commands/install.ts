import { existsSync, mkdirSync, chmodSync, writeFileSync, readFileSync, statSync, readdirSync, copyFileSync, rmSync, cpSync, symlinkSync, realpathSync } from 'fs';
import { join, resolve, basename, sep } from 'path';
import { tmpdir } from 'os';
import type { PackageMeta } from '../types';
import { httpGetJson } from '../utils/http';
import { detectPlatform } from '../utils/platform';
import { log, error, sym } from '../utils/log';
import { extractArchive } from '../utils/archive';
import { downloadFile } from '../engine/download';
import { resolveDownloadUrl } from '../engine/mirror';
import { loadConfig, saveConfig } from '../config/store';
import { binDir } from '../config/paths';
import { computeSha256, findSha256FromRelease } from '../utils/sha256';
import { findRepoKey } from './track';
import { findBinary } from '../utils/find';

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
      error('exists', `'${name}' is already installed at ${info.path}`,
            `Use 'tribucket update ${name}' to update, or 'tribucket uninstall ${name}' first.`);
      return false;
    }
  }

  let pkg: PackageMeta;
  try {
    pkg = await httpGetJson<PackageMeta>(`${REPO_URL}/${name}.json`);
  } catch {
    error('not-found', `Package '${name}' not found in tribucket repo`);
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
    error('security', `Path traversal detected: ${name} resolves outside base directory`);
    return false;
  }

  // System directory protection
  const FORBIDDEN = ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];
  for (const forbidden of FORBIDDEN) {
    if (resolvedTarget === forbidden || resolvedTarget.startsWith(forbidden + sep)) {
      error('forbidden', `Refusing to install into system directory: ${resolvedTarget}`,
            `Use --dir to specify a user directory, e.g.: --dir ~/apps`);
      return false;
    }
  }

  // Self-directory protection
  const { tribucketHome } = await import('../config/paths');
  const homeDir = resolveReal(tribucketHome());
  if (resolvedTarget === homeDir || resolvedTarget.startsWith(homeDir + '/')) {
    error('forbidden', `Cannot install into tribucket home directory: ${resolvedTarget}`,
          `Use --dir to specify a different directory.`);
    return false;
  }

  // Non-empty directory check
  if (existsSync(targetDir)) {
    if (readdirSync(targetDir).length > 0 && !options.force) {
      error('exists', `Directory not empty: ${targetDir}`);
      console.log(`  ${sym('arrow')} Use --force to overwrite.`);
      return false;
    }
  }

  mkdirSync(targetDir, { recursive: true });

  const platform = detectPlatform();
  if (!platform) { error('platform', 'Unsupported platform'); return false; }

  const version = pkg.version || '0.0.0';
  const repo = pkg.repo || '';

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
    if (!pattern || pattern === 'NO_MATCH') { error('platform', `No asset available for ${platform}`); return false; }

    // If no version, fetch latest from GitHub
    let actualVersion = version;
    if (actualVersion === '0.0.0' && repo) {
      try {
        const token = process.env.GITHUB_TOKEN;
        const data = await httpGetJson<any>(
          `https://api.github.com/repos/${repo}/releases/latest`,
          { token }
        );
        actualVersion = data.tag_name?.replace(/^v/, '') || version;
        log(`Latest version: ${actualVersion}`);
      } catch {
        log(`Could not fetch latest version, using ${version}`);
      }
    }

    const resolved = await resolveDownloadUrl(repo, actualVersion, pattern, options.mirror as any);
    url = resolved[0];
    provider = resolved[1];
    log(`Download URL (${provider}): ${url}`);
  }

  const tmpDir = join(tmpdir(), `tribucket-install-${Date.now()}`);
  mkdirSync(tmpDir, { recursive: true });

  try {
    const archivePath = await downloadFile(url, tmpDir);
    if (!archivePath) { error('network', 'Download failed'); return false; }

    // SHA256 verification (best-effort) — searches release assets for checksum files
    if (repo) {
      try {
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
      extractArchive(archivePath, extractDir);
    } else {
      // Raw binary - copy directly using Node.js fs
      mkdirSync(extractDir, { recursive: true });
      copyFileSync(archivePath, join(extractDir, 'binary'));
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
        const dest = join(targetDir, binary);
        copyFileSync(found, dest);
        chmodSync(dest, 0o755);
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
    chmodSync(installShPath, 0o755);

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
      const binary = pkg.binary || name;
      const linkPath = join(bd, binary);
      const binaryPath = join(targetDir, binary);
      if (existsSync(linkPath)) {
        try { rmSync(linkPath, { force: true }); } catch {}
      }
      try {
        symlinkSync(binaryPath, linkPath);
        log(`Symlink: ${linkPath} ${sym('arrow')} ${binaryPath}`);
        linked = true;
      } catch (e) {
        error('symlink', `Failed to create symlink: ${linkPath} ${sym('arrow')} ${binaryPath}`);
      }
    }

    const repoKey = pkg.repo || name;
    config.packages[repoKey] = { name, path: targetDir, version, installed_at: new Date().toISOString(), linked };
    saveConfig(config);

    console.log(`Installed: ${targetDir}`);
    if (!linked && !options.link) {
      console.log(`Not in PATH. Options:`);
      console.log(`  1. Add to PATH:  export PATH="${targetDir}:$PATH"`);
      console.log(`  2. Reinstall with symlink:  tribucket install ${name} --link`);
    }
    return true;
  } finally {
    try { rmSync(tmpDir, { recursive: true, force: true }); } catch {}
  }
}

function generateInstallSh(name: string, repo: string, binary: string, version: string): string {
  return `#!/usr/bin/env bash
set -euo pipefail
# tribucket auto-generated install.sh — Package: ${name}
# Repo: ${repo}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BINARY="$SCRIPT_DIR/${binary}"
REPO="${repo}"
NAME="${name}"

# --- If tribucket CLI is available, delegate ---
if command -v tribucket &>/dev/null; then
    case "\${1:-check}" in
        check|status)  tribucket check "$NAME" ;;
        update|upgrade) tribucket update "$NAME" ;;
        install)       tribucket install "$NAME" --dir "$SCRIPT_DIR" --force ;;
        *)             echo "Usage: $0 [check|update|install]"; exit 1 ;;
    esac
    exit $?
fi

# --- Standalone fallback ---
echo "tribucket CLI not found. Running in standalone mode."
echo "Install tribucket for full features (backup, resume, mirror):"
echo "  curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.sh | bash"
echo ""

detect_version() {
    if [ -x "$BINARY" ]; then
        "$BINARY" --version 2>&1 | grep -oP 'v?\\d+\\.\\d+(?:\\.\\d+)?' | head -1
    fi
}

check_remote() {
    curl -sf "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null \\
        | grep -oP '"tag_name":\\s*"\\K[^"]+' | sed 's/^v//' || echo ""
}

LOCAL=$(detect_version)
REMOTE=$(check_remote)

echo "Package: $NAME"
echo "Local:   \${LOCAL:-not installed}"
echo "Remote:  \${REMOTE:-unknown}"

if [ -z "$LOCAL" ]; then
    echo "Binary not found. Install tribucket for automatic setup."
    exit 1
fi

if [ -z "$REMOTE" ]; then
    echo "Status:  ? unable to check remote"
    exit 0
fi

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Status:  ✓ up to date"
else
    echo "Status:  ⚠ update available ($LOCAL → $REMOTE)"
    echo "For backup-safe updates, install tribucket CLI."
fi
`;
}

function generateBat(name: string, binary: string): string {
  const winBinary = binary.endsWith('.exe') ? binary : `${binary}.exe`;
  return `@echo off
REM Auto-generated — Package: ${name}
SET SCRIPT_DIR=%~dp0
SET BINARY=%SCRIPT_DIR%${winBinary}
if not exist "%BINARY%" (
    echo Error: %BINARY% not found.
    echo Please install with: tribucket install ${name}
    exit /b 1
)
"%BINARY%" --version
echo.
echo To update, run: tribucket update ${name}
`;
}

function inferAssetFormat(assetPattern: Record<string, string>): Record<string, string> {
  const formats: Record<string, string> = {};
  for (const [platform, pattern] of Object.entries(assetPattern)) {
    if (pattern === 'NO_MATCH' || !pattern) continue;
    if (pattern.endsWith('.tar.gz')) formats[platform] = 'tar.gz';
    else if (pattern.endsWith('.tar.bz2')) formats[platform] = 'tar.bz2';
    else if (pattern.endsWith('.tar.xz')) formats[platform] = 'tar.xz';
    else if (pattern.endsWith('.zip')) formats[platform] = 'zip';
    else if (pattern.endsWith('.exe')) formats[platform] = 'exe';
    else formats[platform] = 'binary';
  }
  return formats;
}
