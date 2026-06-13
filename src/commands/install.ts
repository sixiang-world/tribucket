import { existsSync, mkdirSync, chmodSync, writeFileSync, readFileSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import { execSync } from 'child_process';
import type { PackageMeta } from '../types';
import { httpGetJson } from '../utils/http';
import { detectPlatform } from '../utils/platform';
import { log, error } from '../utils/log';
import { extractArchive } from '../utils/archive';
import { downloadFile } from '../engine/download';
import { resolveDownloadUrl } from '../engine/mirror';
import { loadConfig, saveConfig } from '../config/store';

const REPO_URL = 'https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages';

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
      // Raw binary - copy directly
      mkdirSync(extractDir, { recursive: true });
      execSync(`cp "${archivePath}" "${extractDir}/"`, { stdio: 'pipe' });
    }

    const binary = pkg.binary || name;
    const installType = pkg.install_type || 'binary';

    if (installType === 'directory') {
      execSync(`cp -r "${extractDir}"/* "${targetDir}"/`, { stdio: 'pipe' });
    } else {
      // Try to find binary by name first, then by pattern
      let found = execSync(`find "${extractDir}" -name "${binary}" -type f | head -1`, { encoding: 'utf-8' }).trim();
      if (!found) {
        // Try to find any file that matches the binary name pattern
        found = execSync(`find "${extractDir}" -name "${binary}*" -type f | head -1`, { encoding: 'utf-8' }).trim();
      }
      if (!found) {
        // Try to find any executable file
        found = execSync(`find "${extractDir}" -type f -executable | head -1`, { encoding: 'utf-8' }).trim();
      }
      if (found) {
        const dest = join(targetDir, binary);
        execSync(`cp "${found}" "${dest}"`, { stdio: 'pipe' });
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

    config.packages[name] = { name, path: targetDir, version, installed_at: new Date().toISOString(), linked: false };
    saveConfig(config);

    console.log(`Installed: ${targetDir}`);
    return true;
  } finally {
    try { execSync(`rm -rf "${tmpDir}"`, { stdio: 'pipe' }); } catch {}
  }
}
