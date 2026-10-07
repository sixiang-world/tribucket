import { existsSync, accessSync, constants } from 'fs';
import { spawnSync } from 'child_process';
import type { PackageMeta, TrackedPackage } from '../types';
import { log, VERBOSE } from '../utils/log';

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

  // 1. Try CLI. We probe each flag a few times because freshly-installed
  // binaries can transiently fail to execute (file-system/cache settling on
  // Windows, AV scanners holding the file, slow first run, etc.). A single
  // failure should NOT cause us to fall back to a hardcoded version.
  if (existsSync(binaryPath)) {
    // accessSync(X_OK) is unreliable on Windows (it often denies .exe files
    // that are in fact runnable). Only treat it as authoritative on POSIX,
    // where the executable bit is meaningful; on Windows just attempt spawn.
    const isWindows = process.platform === 'win32';
    let probeable = true;
    if (!isWindows) {
      try { accessSync(binaryPath, constants.X_OK); }
      catch { probeable = false; }
    }
    if (probeable) {
      for (const flag of cliFlags) {
        const ver = runVersionCommandWithRetry(
          binaryPath, flag, parseRegex, vc.output_stream || 'stdout', timeout, 3,
        );
        if (ver) return [ver, 'cli'];
      }
    }
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

/**
 * Run a version command with bounded retries. Freshly-installed binaries can
 * transiently fail to execute (Windows file-handle settling, AV interference,
 * slow first run). We retry up to `retries` times with a short backoff before
 * giving up and letting the caller fall through to config/fallback.
 */
function runVersionCommandWithRetry(
  binaryPath: string,
  flag: string,
  parseRegex: string,
  outputStream: string,
  timeout: number,
  retries: number,
): string | null {
  let lastErr: any = null;
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      const result = spawnSync(binaryPath, [flag], {
        timeout: timeout * 1000,
        stdio: ['pipe', 'pipe', 'pipe'],
      });
      if (result.error) {
        // EAGAIN / EBUSY / ETXTBSY etc. are transient — retry. Other errors
        // (ENOENT) are not, but retrying is cheap and harmless.
        lastErr = result.error;
      } else {
        let text: string;
        if (outputStream === 'stderr') {
          text = result.stderr ? result.stderr.toString() : '';
        } else if (outputStream === 'both') {
          text = (result.stdout ? result.stdout.toString() : '') + (result.stderr ? result.stderr.toString() : '');
        } else {
          text = result.stdout ? result.stdout.toString() : '';
        }
        const match = text.match(new RegExp(parseRegex));
        if (match && (match[1] || match[0])) return match[1] || match[0];
        // Non-empty output that didn't match the regex is a real failure —
        // don't retry, the binary simply reports an unparseable version.
        if (text.trim().length > 0) return null;
        lastErr = new Error('empty version output');
      }
    } catch (e: any) {
      lastErr = e;
    }
    // Brief backoff before retrying (50ms, 150ms).
    if (attempt < retries - 1) {
      const ms = 50 * (attempt + 1);
      const end = Date.now() + ms;
      while (Date.now() < end) { /* busy-wait; spawnSync is sync already */ }
    }
  }
  if (VERBOSE && lastErr) {
    console.error(`[debug] version probe failed after ${retries} attempts: ${lastErr.message || lastErr}`);
  }
  return null;
}
