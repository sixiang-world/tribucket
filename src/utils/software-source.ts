/**
 * src/utils/software-source.ts — Fetch package data from tribucket.hunluan.space
 * first, then fall back to GitHub.
 *
 * This reduces reliance on GitHub API (rate-limited to 60 req/hr without a token)
 * by sourcing package definitions and version info from the EdgeOne-hosted website.
 */

import { httpGetJson } from './http';
import { versionFromTag } from '../engine/version';
import type { PackageMeta } from '../types';

const TRIBUCKET_SITE = 'https://tribucket.hunluan.space';
const GITHUB_RAW_PACKAGES = 'https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages';

/**
 * Fetch a package definition JSON.
 *
 * Priority:
 *  1. https://tribucket.hunluan.space/packages/<name>.json
 *  2. https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages/<name>.json
 *
 * Returns the PackageMeta, or null if both sources fail.
 */
export async function fetchPackageDef(name: string): Promise<PackageMeta | null> {
  // 1. Try tribucket.hunluan.space first
  try {
    return await httpGetJson<PackageMeta>(`${TRIBUCKET_SITE}/packages/${name}.json`);
  } catch {
    // 2. Fall back to GitHub raw
    try {
      return await httpGetJson<PackageMeta>(`${GITHUB_RAW_PACKAGES}/${name}.json`);
    } catch {
      return null;
    }
  }
}

/**
 * Fetch the latest remote version string for a package.
 *
 * Priority:
 *  1. https://tribucket.hunluan.space/bucket/<name>.json → version field
 *  2. https://api.github.com/repos/<repo>/releases/latest → tag_name
 *
 * Returns the version string (e.g. "1.2.3"), or null if both sources fail
 * or the repo is empty.
 */
export async function fetchRemoteVersion(name: string, repo: string): Promise<string | null> {
  if (!repo) return null;

  // 1. Try tribucket.hunluan.space bucket JSON first
  try {
    const data = await httpGetJson<{ version: string }>(`${TRIBUCKET_SITE}/bucket/${name}.json`);
    if (data?.version) return data.version;
  } catch {
    // Fall through to GitHub API
  }

  // 2. Fall back to GitHub API
  try {
    const token = process.env.GITHUB_TOKEN;
    const data = await httpGetJson<any>(
      `https://api.github.com/repos/${repo}/releases/latest`,
      { token },
    );
    return versionFromTag(data?.tag_name);
  } catch {
    return null;
  }
}
