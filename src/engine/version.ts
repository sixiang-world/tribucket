import { existsSync, accessSync, constants } from 'fs';
import { spawnSync } from 'child_process';
import type { PackageMeta, TrackedPackage } from '../types';
import { log } from '../utils/log';

// Matches a semantic version core (major.minor[.patch][...suffix]) anywhere in
// a string. Used to normalize release tags like "jq-1.8.1", "shellcheck-v0.11.0",
// "v15.1.0", or "1.2.3" into a comparable "1.8.1" / "0.11.0" / "15.1.0".
const VERSION_CORE_RE = /(\d+\.\d+(?:\.\d+)?)/;

/**
 * Extract a comparable version string from a release tag_name.
 * Falls back to the raw tag (with a single leading "v" stripped) when no
 * version core can be found, so behavior is never worse than before.
 *
 * Examples:
 *   "v1.2.3"          -> "1.2.3"
 *   "jq-1.8.1"        -> "1.8.1"
 *   "shellcheck-v0.11.0" -> "0.11.0"
 *   "15.1.0"          -> "15.1.0"
 *   "release-2024-01" -> "2024-1" (best effort)
 */
export function versionFromTag(tag: string | null | undefined): string | null {
  if (!tag) return null;
  const m = tag.match(VERSION_CORE_RE);
  if (m && m[1]) return m[1];
  const stripped = tag.replace(/^v/, '');
  return stripped || null;
}

export function detectVersion(
  binaryPath: string,
  tributableJson: PackageMeta,
  configInfo?: TrackedPackage
): [string, string] {
  const vc = tributableJson.version_check || {};
  const cliFlags = vc.cli_flags || ['--version'];
  const parseRegex = vc.parse_regex || 'v?(\\d+\\.\\d+(?:\\.\\d+)?)';
  const timeout = vc.timeout || 5;

  // 1. Try CLI
  if (existsSync(binaryPath)) {
    try {
      accessSync(binaryPath, constants.X_OK);
      for (const flag of cliFlags) {
        const ver = runVersionCommand(binaryPath, flag, parseRegex, vc.output_stream || 'stdout', timeout);
        if (ver) return [ver, 'cli'];
      }
    } catch {}
  }

  // 2. Try config.json version
  if (configInfo?.version && configInfo.version !== 'unknown') {
    return [configInfo.version, 'config'];
  }

  // 3. Fallback
  const fallback = tributableJson.version || vc.fallback_version || 'unknown';
  return [fallback, 'fallback'];
}

function runVersionCommand(
  binaryPath: string,
  flag: string,
  parseRegex: string,
  outputStream: string,
  timeout: number
): string | null {
  try {
    const result = spawnSync(binaryPath, [flag], {
      timeout: timeout * 1000,
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    if (result.error) return null;
    let text: string;
    if (outputStream === 'stderr') {
      text = result.stderr ? result.stderr.toString() : '';
    } else if (outputStream === 'both') {
      text = (result.stdout ? result.stdout.toString() : '') + (result.stderr ? result.stderr.toString() : '');
    } else {
      text = result.stdout ? result.stdout.toString() : '';
    }
    const match = text.match(new RegExp(parseRegex));
    if (match) return match[1] || match[0];
  } catch {}
  return null;
}
