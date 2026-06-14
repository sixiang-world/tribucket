import { sym, log } from '../utils/log';
import { existsSync, readFileSync, readdirSync, statSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { detectVersion } from '../engine/version';
import { httpGetJson } from '../utils/http';
import { getCachedRemoteVersion, saveRemoteVersionCache } from '../config/cache';
import { findBinary } from '../utils/find';
import type { CheckResult, PackageMeta } from '../types';

export async function checkPackage(nameOrPath: string, options: { refresh?: boolean; localOnly?: boolean }): Promise<CheckResult> {
  if (nameOrPath.includes('/') || nameOrPath.includes('\\') || nameOrPath.startsWith('.')) {
    return checkPath(nameOrPath);
  }

  const config = loadConfig();
  const info = config.packages[nameOrPath];
  if (info) return checkTracked(nameOrPath, info, options);

  for (const [_, pkgInfo] of Object.entries(config.packages)) {
    if (pkgInfo.name === nameOrPath) return checkTracked(nameOrPath, pkgInfo, options);
  }

  return { name: nameOrPath, error: `Package '${nameOrPath}' not found` };
}

async function checkTracked(name: string, info: any, options: { refresh?: boolean; localOnly?: boolean }): Promise<CheckResult> {
  const path = info.path;
  const pathExists = existsSync(path);

  if (!pathExists) {
    return { name, path, path_exists: false, local: 'not found', local_source: 'none', remote: null, status: 'error' };
  }

  const tjPath = join(path, 'tribucket.json');
  let tj: PackageMeta | null = null;
  if (existsSync(tjPath)) {
    try { tj = JSON.parse(readFileSync(tjPath, 'utf-8')); } catch {}
  }

  if (!tj) {
    const binary = info.name || name;
    const binaryPath = join(path, binary);
    const [localVer, source] = detectVersion(existsSync(binaryPath) ? binaryPath : path, { version_check: { cli_flags: ['--version'], parse_regex: 'v?(\\d+\\.\\d+(?:\\.\\d+)?)', output_stream: 'stdout', timeout: 5 } } as any);

    let remoteVer: string | null = null;
    if (!options.localOnly && info.repo) {
      if (!options.refresh) {
        const cached = getCachedRemoteVersion(info.repo);
        if (cached) remoteVer = cached;
      }
      if (!remoteVer) {
        try {
          const token = process.env.GITHUB_TOKEN;
          const data = await httpGetJson<any>(`https://api.github.com/repos/${info.repo}/releases/latest`, { token });
          remoteVer = data.tag_name?.replace(/^v/, '') || null;
          if (remoteVer) saveRemoteVersionCache(info.repo, remoteVer);
        } catch (e: any) { log(`Failed to fetch remote version for ${info.repo}: ${e.message}`); }
      }
    }

    return { name, path, path_exists: true, local: localVer, local_source: source as any, remote: remoteVer, status: computeStatus(localVer, remoteVer) };
  }

  return checkWithTributableJson(name, path, tj, info, options);
}

async function checkWithTributableJson(name: string, path: string, tj: PackageMeta, info: any, options: { refresh?: boolean; localOnly?: boolean }): Promise<CheckResult> {
  const binary = tj.binary || name;
  const installType = tj.install_type || 'binary';
  let binaryPath = join(path, binary);
  if (installType === 'directory' && !existsSync(binaryPath)) {
    const found = findBinary(path, binary);
    if (found) binaryPath = found;
  }

  const [localVer, source] = detectVersion(binaryPath, tj, info);

  let remoteVer: string | null = null;
  if (!options.localOnly) {
    const token = process.env.GITHUB_TOKEN;
    const repo = tj.repo || '';
    if (repo) {
      if (!options.refresh) {
        const cached = getCachedRemoteVersion(repo);
        if (cached) { remoteVer = cached; }
      }
      if (!remoteVer) {
        try {
          const includePrerelease = tj.version_check?.include_prerelease || false;
          let data: any;
          if (includePrerelease) {
            const releases = await httpGetJson<any[]>(`https://api.github.com/repos/${repo}/releases`, { token });
            data = Array.isArray(releases) && releases.length > 0 ? releases[0] : null;
          } else {
            data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
          }
          remoteVer = data?.tag_name?.replace(/^v/, '') || null;
          if (remoteVer) saveRemoteVersionCache(repo, remoteVer);
        } catch (e: any) { log(`Failed to fetch remote version for ${repo}: ${e.message}`); }
      }
    } else if (tj.download_url) {
      // download_url packages: try HEAD request to check reachability
      const { detectPlatform } = await import('../utils/platform');
      const plat = detectPlatform();
      let url = tj.download_url[plat || ''];
      if (!url || url === 'NO_MATCH') {
        // Fallback: try any platform URL
        for (const v of Object.values(tj.download_url)) {
          if (v && v !== 'NO_MATCH') { url = v; break; }
        }
      }
      if (url && url !== 'NO_MATCH') {
        try {
          const { httpGet } = await import('../utils/http');
          await httpGet(url, { timeout: 5000, method: 'HEAD' });
          // If HEAD succeeds, URL is reachable but we don't know the version
          remoteVer = localVer;
        } catch { log(`Cannot reach download URL for ${name}`); }
      }
    }
  }

  return { name, path, path_exists: true, local: localVer, local_source: source as any, remote: remoteVer, status: computeStatus(localVer, remoteVer) };
}

function checkPath(path: string): CheckResult {
  if (!existsSync(path)) {
    return { name: path.split(/[/\\]/).pop() || path, path, error: 'Path not found' };
  }

  const tj = { version_check: { cli_flags: ['--version', '-v', '-V'], parse_regex: 'v?(\\d+\\.\\d+(?:\\.\\d+)?)', output_stream: 'stdout' as const, timeout: 5 } };
  const [ver, source] = detectVersion(path, tj as any);
  return { name: path.split(/[/\\]/).pop() || path, path, path_exists: true, local: ver, local_source: source as any, remote: null, status: 'unknown' };
}

function computeStatus(localVer: string, remoteVer: string | null): 'latest' | 'outdated' | 'unknown' {
  if (!remoteVer) return 'unknown';
  if (localVer === remoteVer) return 'latest';
  return 'outdated';
}

export function formatCheckResult(name: string, localVer: string, localSource: string, remoteVer: string | null, pathExists = true): string {
  if (!pathExists) return `${name.padEnd(20)}  ${sym('err')} not found`;
  let status = '';
  if (!remoteVer) status = '? offline';
  else if (localVer === remoteVer) status = `${sym('ok')} latest`;
  else status = `${sym('warn')} ${localVer} ${sym('arrow')} ${remoteVer}`;
  return `${name.padEnd(20)}  ${localVer.padEnd(12)} (${localSource.padEnd(8)})  ${status}`;
}
