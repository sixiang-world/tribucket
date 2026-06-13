import { loadJson, saveJson } from '../config/store';
import { mirrorCachePath, mirrorConfigPath } from '../config/paths';
import { log } from '../utils/log';
import type { MirrorMode } from '../types';

const DEFAULT_PROVIDERS = [
  {
    name: 'hunluan',
    template: 'https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/v{version}/{asset}',
    test_url: 'https://gh.do.hunluan.space/',
  },
];

export function buildDirectUrl(repo: string, version: string, asset: string): string {
  return `https://github.com/${repo}/releases/download/v${version}/${asset}`;
}

export function buildMirrorUrl(template: string, repo: string, version: string, asset: string): string {
  return template.replace('{repo}', repo).replace('{version}', version).replace('{asset}', asset);
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

  // Probe all providers
  const results: Record<string, { ok: boolean; latency_ms: number }> = {};

  for (const p of providers) {
    const [ok, latency] = await testProvider(p);
    results[p.name] = { ok, latency_ms: latency };
    log(`Mirror probe: ${p.name} = ${ok ? 'OK' : 'FAIL'} (${latency}ms)`);
  }

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
  return p ? [p.name, p.template] : ['direct', null];
}

export async function resolveDownloadUrl(repo: string, version: string, asset: string, mirrorMode: MirrorMode = 'auto'): Promise<[string, string]> {
  const [providerName, template] = await selectProvider(mirrorMode);
  if (providerName === 'direct' || !template) {
    return [buildDirectUrl(repo, version, asset), 'direct'];
  }
  return [buildMirrorUrl(template, repo, version, asset), providerName];
}
