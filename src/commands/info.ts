/**
 * src/commands/info.ts — Show detailed information about a tracked package.
 *
 * Reads config + tribucket.json from the install directory and displays
 * all known metadata. Supports --json output and runtime version detection.
 */

import { existsSync, readFileSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { findRepoKey } from './track';
import { detectVersion } from '../engine/version';
import { sym } from '../utils/log';
import { t } from '../utils/locale';

interface InfoOpts {
  json?: boolean;
}

interface InfoData {
  name: string;
  repo?: string;
  description?: string;
  binary?: string;
  license?: string;
  homepage?: string;
  installType?: string;
  path: string;
  version?: string;
  versionSource?: string;
  trackedAt?: string;
  stale: boolean;
}

export async function showInfo(name: string, opts: InfoOpts): Promise<boolean> {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name) || name;
  const info = config.packages[repoKey];

  if (!info) {
    console.error(`Error: ${t('error_not_tracked', { name })}`);
    return false;
  }

  const installPath = info.path;
  const stale = !existsSync(installPath);

  // Read tribucket.json for package metadata
  const tjPath = join(installPath, 'tribucket.json');
  let tj: Record<string, any> = {};
  if (!stale && existsSync(tjPath)) {
    try {
      tj = JSON.parse(readFileSync(tjPath, 'utf-8'));
    } catch { /* ignore corrupt json */ }
  }

  // Run version detection if the binary exists
  let detectedVersion = info.version;
  let versionSource: string | undefined;
  if (!stale && tj.version_check) {
    const binary = tj.binary;
    if (binary) {
      const { resolveBinaryPath } = await import('../utils/platform');
      const binaryPath = resolveBinaryPath(installPath, binary);
      if (existsSync(binaryPath)) {
        const [ver, src] = detectVersion(binaryPath, tj);
        if (ver && ver !== 'unknown') {
          detectedVersion = ver;
          versionSource = src;
        }
      }
    }
  }

  const data: InfoData = {
    name,
    repo: tj.repo,
    description: tj.description,
    binary: tj.binary,
    license: tj.license,
    homepage: tj.homepage,
    installType: tj.install_type,
    path: installPath,
    version: detectedVersion || info.version || '?',
    versionSource,
    trackedAt: info.installed_at,
    stale,
  };

  if (opts.json) {
    console.log(JSON.stringify(data, null, 2));
    return true;
  }

  // Human-readable table
  const label = (l: string) => `${l.padEnd(16)}`;
  const val = (v: string) => v || '?';

  console.log(`${label(t('info_name'))}${data.name}${data.stale ? `  ${sym('warn')} ${t('info_stale')}` : ''}`);
  if (data.repo)          console.log(`${label(t('info_repo'))}${val(data.repo)}`);
  if (data.description)   console.log(`${label(t('info_description'))}${val(data.description)}`);
  if (data.binary)        console.log(`${label(t('info_binary'))}${val(data.binary)}`);
  if (data.license)       console.log(`${label(t('info_license'))}${val(data.license)}`);
  if (data.homepage)      console.log(`${label(t('info_homepage'))}${val(data.homepage)}`);
  if (data.installType)   console.log(`${label(t('info_install_type'))}${val(data.installType)}`);
  console.log(`${label(t('info_installed_path'))}${data.path}`);
  console.log(`${label(t('info_version'))}${data.version}${versionSource ? ` (${versionSource})` : ''}`);
  if (data.trackedAt)     console.log(`${label(t('info_tracked_at'))}${data.trackedAt}`);

  return true;
}
