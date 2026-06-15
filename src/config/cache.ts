import { versionsCachePath, mirrorCachePath } from './paths';
import { loadJson, saveJson } from './store';
import { versionFromTag } from '../engine/version';

interface VersionCacheEntry {
  remote_version: string;
  checked_at: string;
  ttl_seconds: number;
}

interface MirrorCacheEntry {
  checked_at: string;
  ttl_seconds: number;
  providers: Record<string, { ok: boolean; latency_ms: number }>;
  selected: string;
}

export function getCachedRemoteVersion(repo: string): string | null {
  const cache = loadJson<Record<string, VersionCacheEntry>>(versionsCachePath(), {});
  const entry = cache[repo];
  if (!entry) return null;
  const checkedAt = new Date(entry.checked_at);
  const ttl = entry.ttl_seconds ?? 3600;
  if (Date.now() - checkedAt.getTime() < ttl * 1000) {
    // Normalize on read so cached values written by older (pre-fix) versions
    // that stored raw tag names (e.g. "jq-1.8.1") self-heal into a comparable
    // version core ("1.8.1") instead of poisoning version comparisons.
    return versionFromTag(entry.remote_version) ?? entry.remote_version;
  }
  return null;
}

export function saveRemoteVersionCache(repo: string, version: string): void {
  const cache = loadJson<Record<string, VersionCacheEntry>>(versionsCachePath(), {});
  cache[repo] = {
    remote_version: version,
    checked_at: new Date().toISOString(),
    ttl_seconds: 3600,
  };
  saveJson(versionsCachePath(), cache);
}

export function getMirrorCache(): MirrorCacheEntry | null {
  return loadJson<MirrorCacheEntry | null>(mirrorCachePath(), null);
}

export function saveMirrorCache(selected: string, providers: Record<string, { ok: boolean; latency_ms: number }>): void {
  const cache: MirrorCacheEntry = {
    checked_at: new Date().toISOString(),
    ttl_seconds: 3600,
    providers,
    selected,
  };
  saveJson(mirrorCachePath(), cache);
}
