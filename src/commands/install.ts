import { existsSync, mkdirSync, chmodSync, writeFileSync, readFileSync, statSync, readdirSync, copyFileSync } from 'fs';
import { join, resolve } from 'path';
import { tmpdir } from 'os';
import { execFileSync } from 'child_process';
import type { PackageMeta } from '../types';
import { httpGetJson } from '../utils/http';
import { detectPlatform } from '../utils/platform';
import { log, error } from '../utils/log';
import { extractArchive } from '../utils/archive';
import { downloadFile } from '../engine/download';
import { resolveDownloadUrl } from '../engine/mirror';
import { loadConfig, saveConfig } from '../config/store';

const REPO_URL = 'https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages';

function sanitizePath(path: string): string {
  return resolve(path).replace(/[;&|`$()]/g, '');
}

export async function installPackage(
  name: string,
  options: { dir?: string; link?: boolean; force?: boolean; mirror?: string }
): Promise<boolean> {
  const config = loadConfig();
  if (config.packages[name] && !options.force) {
    const info = config.packages[name];
    if (existsSync(info.path)) {
      error('exists', `'${name}' is already installed at ${info.path}`);
      return false;
    }
  }

  let pkg: PackageMeta;
  try {
    pkg = await httpGetJson<PackageMeta>(`${REPO_URL}/${name}.json`);
  } catch {
    error('not-found', `Package '${name}' not found in tributable repo`);
    return false;
  }

  let targetDir = options.dir || process.cwd();
  targetDir = join(targetDir, name);

  // Path traversal protection
  const resolvedTarget = resolve(targetDir);
  const resolvedBase = resolve(options.dir || process.cwd());
  if (!resolvedTarget.startsWith(resolvedBase + '/') && resolvedTarget !== resolvedBase) {
    error('security', `Path traversal detected: ${name} resolves outside base directory`);
    return false;
  }

  // System directory protection
  const FORBIDDEN = ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];
  for (const forbidden of FORBIDDEN) {
    if (resolvedTarget === forbidden || resolvedTarget.startsWith(forbidden + '/')) {
      error('forbidden', `Refusing to install into system directory: ${resolvedTarget}`);
      return false;
    }
  }

  mkdirSync(targetDir, { recursive: true });

  const platform = detectPlatform();
  if (!platform) { error('platform', 'Unsupported platform'); return false; }

  const pattern = pkg.asset_pattern?.[platform];
  if (!pattern || pattern === 'NO_MATCH') { error('platform', `No asset available for ${platform}`); return false; }

  const version = pkg.version || '0.0.0';
  const repo = pkg.repo || '';

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

  const [url, provider] = await resolveDownloadUrl(repo, actualVersion, pattern, options.mirror as any);
  log(`Download URL (${provider}): ${url}`);

  const tmpDir = join(tmpdir(), `tributable-install-${Date.now()}`);
  mkdirSync(tmpDir, { recursive: true });

  try {
    const archivePath = await downloadFile(url, tmpDir);
    if (!archivePath) { error('network', 'Download failed'); return false; }

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
      // Copy directory contents safely
      const entries = readdirSync(extractDir);
      for (const entry of entries) {
        const srcPath = join(extractDir, entry);
        const destPath = join(targetDir, entry);
        const stat = statSync(srcPath);
        if (stat.isDirectory()) {
          execFileSync('cp', ['-r', srcPath, destPath], { stdio: 'pipe' });
        } else {
          copyFileSync(srcPath, destPath);
        }
      }
    } else {
      // Try to find binary by name first
      let found = '';
      const tryPaths = [
        join(extractDir, binary),
        join(extractDir, `${binary}*`),
      ];

      for (const pattern of tryPaths) {
        try {
          const result = execFileSync('find', [extractDir, '-name', pattern.replace('*', '*'), '-type', 'f'], {
            encoding: 'utf-8',
            stdio: ['pipe', 'pipe', 'pipe'],
          }).trim();
          if (result) {
            found = result.split('\n')[0];
            break;
          }
        } catch {}
      }

      // Fallback to any executable file
      if (!found) {
        try {
          const result = execFileSync('find', [extractDir, '-type', 'f', '-executable'], {
            encoding: 'utf-8',
            stdio: ['pipe', 'pipe', 'pipe'],
          }).trim();
          if (result) {
            found = result.split('\n')[0];
          }
        } catch {}
      }

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
      asset_pattern: pkg.asset_pattern || {}, install_type: installType, mirror: { enabled: true },
    };
    writeFileSync(join(targetDir, 'tributable.json'), JSON.stringify(tributableJson, null, 2) + '\n');

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

    config.packages[name] = { name, path: targetDir, version, installed_at: new Date().toISOString(), linked: false };
    saveConfig(config);

    console.log(`Installed: ${targetDir}`);
    return true;
  } finally {
    try { execFileSync('rm', ['-rf', tmpDir], { stdio: 'pipe' }); } catch {}
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
