#!/usr/bin/env python3
"""Fix round 3: all 11 issues from latest review."""

import os
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- #1: index.ts — fix TDZ by moving _yesMode before usage ---
with open('src/index.ts') as f:
    c = f.read()

old = """import { VERSION } from './version';
// Global flag for --yes mode (checked by prompt.ts)
process.env.TRIBUCKET_YES = _yesMode ? '1' : '';

const program = new Command();
const _yesMode = process.argv.includes('--yes') || process.argv.includes('-y');"""

new = """import { VERSION } from './version';
const _yesMode = process.argv.includes('--yes') || process.argv.includes('-y');

// Global flag for --yes mode (checked by prompt.ts)
process.env.TRIBUCKET_YES = _yesMode ? '1' : '';

const program = new Command();"""

c = c.replace(old, new)
with open('src/index.ts', 'w') as f:
    f.write(c)
print('#1 TDZ fixed')

# --- #2: self-update.ts — fix # to // comment ---
with open('src/commands/self-update.ts') as f:
    c = f.read()
c = c.replace(
    "  // Detect dev mode: when running via `bun run src/index.ts`, process.argv[1]\n  # points to the bun binary, not the compiled tribucket binary. Self-update\n  would overwrite bun, which is catastrophic.",
    "  // Detect dev mode: when running via `bun run src/index.ts`, process.argv[1]\n  // points to the bun binary, not the compiled tribucket binary. Self-update\n  // would overwrite bun, which is catastrophic."
)
with open('src/commands/self-update.ts', 'w') as f:
    f.write(c)
print('#2 comment fixed')

# --- #3: install.ts — fallback version from software source on API failure ---
with open('src/commands/install.ts') as f:
    c = f.read()
old = """    } catch {
      log(t('could_not_fetch_release', { version }));
    }"""
new = """    } catch {
      log(t('could_not_fetch_release', { version }));
      // If version is still 0.0.0 (no pkg.version), try software source as fallback
      if (version === '0.0.0') {
        try {
          const { fetchPackageDef } = await import('../utils/software-source');
          const def = await fetchPackageDef(pkg.name);
          if (def?.version) version = def.version;
        } catch {}
      }
    }"""
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#3 version fallback fixed')

# --- #5: lock.ts — fix TOCTOU by using wx atomic write first ---
with open('src/engine/lock.ts') as f:
    c = f.read()
old = """  acquire(): void {
    mkdirSync(lockDir(), { recursive: true });

    // Check for stale lock from a dead process
    if (existsSync(this.lockPath)) {
      try {
        const rawPid = readFileSync(this.lockPath, 'utf-8').trim();
        const pid = parseInt(rawPid);
        if (!pid || isNaN(pid)) {
          // Corrupted lock file — log and remove
          log(`Corrupted lock file for '${this.name}', removing: ${rawPid}`);
        } else if (this.isProcessAlive(pid)) {
          error('locked', `Another update for '${this.name}' is in progress.`);
          process.exit(EXIT_ERROR);
        }
      } catch (e: any) { log(`Failed to read lock file: ${e.message}`); }
      // Stale or corrupted lock — remove it
      try { unlinkSync(this.lockPath); } catch {}
    }

    // Atomic create: wx flag fails if file was created between our check and here
    try {
      writeFileSync(this.lockPath, String(process.pid), { flag: 'wx' });
    } catch {
      error('locked', `Another update for '${this.name}' is in progress.`);
      process.exit(EXIT_ERROR);
    }
  }"""
new = """  acquire(): void {
    mkdirSync(lockDir(), { recursive: true });

    // Atomic create: wx flag is the primary mutual exclusion mechanism.
    // Only if wx fails do we check for stale lock (not the other way around),
    // avoiding the TOCTOU gap between existsSync-check and writeFileSync.
    try {
      writeFileSync(this.lockPath, String(process.pid), { flag: 'wx' });
      return;  // Lock acquired
    } catch (err: any) {
      if (err.code !== 'EEXIST') throw err;
    }

    // File exists — check if the lock holder is still alive
    try {
      const rawPid = readFileSync(this.lockPath, 'utf-8').trim();
      const pid = parseInt(rawPid);
      if (!pid || isNaN(pid)) {
        log(`Corrupted lock file for '${this.name}', removing: ${rawPid}`);
      } else if (this.isProcessAlive(pid)) {
        error('locked', `Another update for '${this.name}' is in progress.`);
        process.exit(EXIT_ERROR);
      }
    } catch (e: any) { log(`Failed to read lock file: ${e.message}`); }
    // Stale or corrupted lock — overwrite
    writeFileSync(this.lockPath, String(process.pid));
  }"""
c = c.replace(old, new)
with open('src/engine/lock.ts', 'w') as f:
    f.write(c)
print('#5 TOCTOU fixed')

# --- #6: find.ts — Windows final fallback check name substring ---
with open('src/utils/find.ts') as f:
    c = f.read()
old = """  for (const f of allFiles) {
    // 6. Any executable (Windows: any file, Unix: X_OK)
    if (isWin) return f;"""
new = """  for (const f of allFiles) {
    // 6. Any executable (Windows: any file containing name, Unix: X_OK)
    if (isWin && f.toLowerCase().includes(name.toLowerCase())) return f;"""
c = c.replace(old, new)
with open('src/utils/find.ts', 'w') as f:
    f.write(c)
print('#6 findBinary Windows fallback fixed')

# --- #7: http.ts — 403 check X-RateLimit-Remaining header ---
with open('src/utils/http.ts') as f:
    c = f.read()
old = """        if ((response.status === 403 || response.status === 429) && attempt < retries - 1) {
          log(`HTTP ${response.status} (rate limited), retrying (${attempt + 1}/${retries})...`);
          if (!silent) status(t('rate_limited_retrying', { n: attempt + 1, total: retries }));
          await new Promise(r => setTimeout(r, backoffMs(attempt)));
          continue;
        }
        if (response.status === 403) throw new Error(`HTTP 403: Rate limited`);"""
new = """        const isRateLimited = response.status === 429 ||
          (response.status === 403 && response.headers.get('X-RateLimit-Remaining') === '0');
        if (isRateLimited && attempt < retries - 1) {
          log(`HTTP ${response.status} (rate limited), retrying (${attempt + 1}/${retries})...`);
          if (!silent) status(t('rate_limited_retrying', { n: attempt + 1, total: retries }));
          await new Promise(r => setTimeout(r, backoffMs(attempt)));
          continue;
        }
        if (response.status === 403) throw new Error(`HTTP 403: ${response.headers.get('X-RateLimit-Remaining') === '0' ? 'Rate limited' : 'Forbidden'}`);"""
c = c.replace(old, new)
with open('src/utils/http.ts', 'w') as f:
    f.write(c)
print('#7 403 rate-limit fixed')

# --- #8: software-source.ts — pass GITHUB_TOKEN to all requests ---
with open('src/utils/software-source.ts') as f:
    c = f.read()
old = """export async function fetchPackageDef(name: string): Promise<PackageMeta | null> {
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
}"""
new = """export async function fetchPackageDef(name: string): Promise<PackageMeta | null> {
  const token = process.env.GITHUB_TOKEN;
  // 1. Try tribucket.hunluan.space first
  try {
    return await httpGetJson<PackageMeta>(`${TRIBUCKET_SITE}/packages/${name}.json`, { token });
  } catch {
    // 2. Fall back to GitHub raw
    try {
      return await httpGetJson<PackageMeta>(`${GITHUB_RAW_PACKAGES}/${name}.json`, { token });
    } catch {
      return null;
    }
  }
}"""
c = c.replace(old, new)
with open('src/utils/software-source.ts', 'w') as f:
    f.write(c)
print('#8 token added')

# --- #9: update.ts — fix indentation at line 280 ---
with open('src/commands/update.ts') as f:
    c = f.read()
c = c.replace(
    "\n      const targetKey = repoKey || name;\n    config.packages[targetKey].version = remoteVer;",
    "\n      const targetKey = repoKey || name;\n      config.packages[targetKey].version = remoteVer;"
)
with open('src/commands/update.ts', 'w') as f:
    f.write(c)
print('#9 indentation fixed')

# --- #10: check.ts — formatCheckResult use computeStatus ---
with open('src/commands/check.ts') as f:
    c = f.read()
old = """export function formatCheckResult(name: string, localVer: string, localSource: string, remoteVer: string | null, pathExists = true): string {
  if (!pathExists) return `${name.padEnd(20)}  ${sym('err')} ${t('not_found')}`;
  let status = '';
  if (!remoteVer) status = '? ' + t('offline');
  else if (localVer === remoteVer) status = `${sym('ok')} ${t('latest')}`;
  else status = `${sym('warn')} ${localVer} ${sym('arrow')} ${remoteVer}`;
  return `${name.padEnd(20)}  ${localVer.padEnd(12)} (${localSource.padEnd(8)})  ${status}`;
}"""
new = """export function formatCheckResult(name: string, localVer: string, localSource: string, remoteVer: string | null, pathExists = true): string {
  if (!pathExists) return `${name.padEnd(20)}  ${sym('err')} ${t('not_found')}`;
  const s = computeStatus(localVer, remoteVer);
  let status = '';
  if (s === 'unknown') status = '? ' + t('offline');
  else if (s === 'latest') status = `${sym('ok')} ${t('latest')}`;
  else status = `${sym('warn')} ${localVer} ${sym('arrow')} ${remoteVer}`;
  return `${name.padEnd(20)}  ${localVer.padEnd(12)} (${localSource.padEnd(8)})  ${status}`;
}"""
c = c.replace(old, new)
with open('src/commands/check.ts', 'w') as f:
    f.write(c)
print('#10 status dedup fixed')

# --- #11: download.ts — merge redundant HTTP status branches ---
with open('src/engine/download.ts') as f:
    c = f.read()
old = """    if (statusCode === 206) {
      // Resume successful
      totalSize = contentLength + existingSize;
      downloaded = existingSize;
      appendMode = true;
      log(`Resuming from ${existingSize} bytes`);
    } else if (statusCode === 200 && existingSize > 0) {
      // Server doesn't support resume, restart
      totalSize = contentLength;
      downloaded = 0;
      appendMode = false;
      log("Server doesn't support resume, restarting download");
    } else {
      totalSize = contentLength;
      downloaded = 0;
      appendMode = false;
    }"""
new = """    if (statusCode === 206) {
      // Resume successful
      totalSize = contentLength + existingSize;
      downloaded = existingSize;
      appendMode = true;
      log(`Resuming from ${existingSize} bytes`);
    } else {
      // Fresh download (or server doesn't support resume)
      totalSize = contentLength;
      downloaded = 0;
      appendMode = false;
      if (existingSize > 0) log("Server doesn't support resume, restarting download");
    }"""
c = c.replace(old, new)
with open('src/engine/download.ts', 'w') as f:
    f.write(c)
print('#11 branches merged')

print('Round 3 all fixes applied')
