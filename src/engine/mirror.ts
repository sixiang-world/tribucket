import { loadJson, saveJson } from '../config/store';
import { mirrorCachePath, mirrorConfigPath } from '../config/paths';
import { log, status } from '../utils/log';
import type { MirrorMode } from '../types';

const DEFAULT_PROVIDERS = [
  {
    name: 'hunluan',
    // {tag} is the raw release tag_name (e.g. "v1.2.3", "jq-1.8.1", "15.1.0").
    // We must NOT inject a "v" prefix — release tags are project-specific.
    template: 'https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/{tag}/{asset}',
    test_url: 'https://gh.do.hunluan.space/',
  },
];

/**
 * Build a direct GitHub download URL.
 * `tag` is the raw release tag_name (with whatever prefix the project uses).
 */
export function buildDirectUrl(repo: string, tag: string, asset: string): string {
  return `https://github.com/${repo}/releases/download/${tag}/${asset}`;
}

/**
 * Build a mirror download URL from a provider template.
 * Templates may use {tag} (raw tag_name, preferred) or {version} (legacy,
 * tag with a single leading "v" stripped — kept for backward compat with
 * user mirror.json configs that still reference {version}).
 */
export function buildMirrorUrl(template: string, repo: string, tag: string, asset: string): string {
  const version = tag.replace(/^v/, '');
  return template
    .replace('{repo}', repo)
    .replace('{tag}', tag)
    .replace('{version}', version)
    .replace('{asset}', asset);
}

/**
 * Convert an asset glob pattern (e.g. "fzf-*-windows_amd64.zip") into a RegExp.
 * Only `*` is treated as a wildcard (matches any characters). All other regex
 * metacharacters in the pattern are escaped so they match literally.
 */
function globToRegExp(pattern: string): RegExp {
  const parts = pattern.split('*');
  const escaped = parts.map((p) => p.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
  return new RegExp('^' + escaped.join('.*') + '$');
}

/**
 * Resolve an asset_pattern to the actual asset name from a GitHub release.
 *
 * Strategy:
 *  1. Literal exact match: pattern equals an asset name → use it directly.
 *  2. Glob match: pattern contains `*` → find the first asset matching the glob.
 *  3. Suffix match: pattern is a pure suffix (no `/`, no `*`) → find assets
 *     whose name ends with the pattern. Handles the common case where package
 *     definitions list only the platform/arch tail (e.g. "x86_64-pc-windows-msvc.zip")
 *     while the real asset is "bat-v0.26.1-x86_64-pc-windows-msvc.zip".
 *
 * Returns the resolved asset name, or the raw pattern if no release data / no
 * match is available (the caller will then likely 404, but we never invent a
 * fake name).
 */
export function resolveAssetName(releaseData: any | null, pattern: string): string {
  if (!releaseData || pattern === 'NO_MATCH') return pattern;

  const assets: string[] = (releaseData.assets || [])
    .map((a: any) => a.name)
    .filter((n: any): n is string => typeof n === 'string' && n.length > 0);

  if (assets.length === 0) return pattern;

  // 1. Literal exact match.
  if (assets.includes(pattern)) return pattern;

  // 2. Glob match (pattern contains *).
  if (pattern.includes('*')) {
    const re = globToRegExp(pattern);
    const match = assets.find((a) => re.test(a));
    if (match) return match;
  }

  // 3. Suffix match — pattern is a pure suffix with no path separators.
  if (!pattern.includes('/')) {
    const candidates = assets.filter((a) => a.endsWith(pattern));
    if (candidates.length > 0) {
      // Prefer the candidate whose prefix ends in a separator, to avoid
      // e.g. "amd64" matching inside "arm64...amd64".
      const preferred = candidates.find((a) => {
        const prefix = a.slice(0, a.length - pattern.length);
        return prefix === '' || /[-_.]$/.test(prefix);
      });
      return preferred || candidates[0];
    }
  }

  return pattern;
}

async function testProvider(provider: { test_url: string }, timeout = 3000): Promise<[boolean, number]> {
  const start = Date.now();
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);
    const response = await fetch(provider.test_url, { method: 'HEAD', signal: controller.signal });
    clearTimeout(timeoutId);
    return [response.status < 400, Date.now() - start];
  } catch {
    return [false, Date.now() - start];
  }
}

export async function selectProvider(mirrorMode: MirrorMode = 'auto'): Promise<[string, string | null]> {
  if (mirrorMode === 'direct') return ['direct', null];

  const userConfig = loadJson<any>(mirrorConfigPath(), {});
  const force = userConfig.force;

  if (force === 'direct') return ['direct', null];
  if (force && force !== 'direct') {
    const providers = userConfig.providers || DEFAULT_PROVIDERS;
    const p = providers.find((x: any) => x.name === force);
    if (p) return [p.name, p.template];
  }

  const providers = userConfig.providers || DEFAULT_PROVIDERS;

  // cn mode: force mirror, skip direct, fallback to first provider
  if (mirrorMode === 'cn') {
    for (const p of providers) {
      const [ok] = await testProvider(p);
      if (ok) return [p.name, p.template];
    }
    return providers.length > 0 ? [providers[0].name, providers[0].template] : ['direct', null];
  }

  // auto mode: check cache, then probe
  const cache = loadJson<any>(mirrorCachePath(), null);
  if (cache?.selected) {
    const checkedAt = new Date(cache.checked_at);
    if (Date.now() - checkedAt.getTime() < (cache.ttl_seconds || 3600) * 1000) {
      if (cache.selected === 'direct') return ['direct', null];
      const p = providers.find((x: any) => x.name === cache.selected);
      if (p) return [p.name, p.template];
    }
  }

  // Probe all providers + direct
  status('Testing mirrors...');
  const results: Record<string, { ok: boolean; latency_ms: number }> = {};

  for (const p of providers) {
    const [ok, latency] = await testProvider(p);
    results[p.name] = { ok, latency_ms: latency };
    log(`Mirror probe: ${p.name} = ${ok ? 'OK' : 'FAIL'} (${latency}ms)`);
  }

  const [directOk, directLatency] = await testDirect();
  results['direct'] = { ok: directOk, latency_ms: directLatency };
  log(`Mirror probe: direct = ${directOk ? 'OK' : 'FAIL'} (${directLatency}ms)`);

  // Select fastest
  let bestName = 'direct';
  let bestLatency = Infinity;
  for (const [name, result] of Object.entries(results)) {
    if (result.ok && result.latency_ms < bestLatency) {
      bestName = name;
      bestLatency = result.latency_ms;
    }
  }

  saveJson(mirrorCachePath(), {
    checked_at: new Date().toISOString(),
    ttl_seconds: 3600,
    providers: results,
    selected: bestName,
  });

  if (bestName === 'direct') return ['direct', null];
  const p = providers.find((x: any) => x.name === bestName);
  status(`Mirror selected: ${bestName} (${bestLatency}ms)`);
  return p ? [p.name, p.template] : ['direct', null];
}

async function testDirect(timeout = 3000): Promise<[boolean, number]> {
  const start = Date.now();
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);
    const response = await fetch('https://github.com', { method: 'HEAD', signal: controller.signal });
    clearTimeout(timeoutId);
    return [response.status < 400, Date.now() - start];
  } catch {
    return [false, Date.now() - start];
  }
}

/**
 * Resolve the final download URL for an asset.
 *
 * @param repo         owner/repo
 * @param tag          raw release tag_name (e.g. "v1.2.3", "jq-1.8.1", "15.1.0")
 * @param pattern      asset_pattern value for the current platform (literal, glob, or suffix)
 * @param mirrorMode   auto / cn / direct
 * @param releaseData  GitHub release object (used to resolve glob/suffix patterns to real asset names)
 */
export async function resolveDownloadUrl(
  repo: string,
  tag: string,
  pattern: string,
  mirrorMode: MirrorMode = 'auto',
  releaseData: any | null = null,
): Promise<[string, string]> {
  const asset = resolveAssetName(releaseData, pattern);
  const [providerName, template] = await selectProvider(mirrorMode);
  if (providerName === 'direct' || !template) {
    return [buildDirectUrl(repo, tag, asset), 'direct'];
  }
  return [buildMirrorUrl(template, repo, tag, asset), providerName];
}
