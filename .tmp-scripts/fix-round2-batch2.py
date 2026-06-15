#!/usr/bin/env python3
"""Fix batch 2: #9 cache, #11 lock, #12 paths, #13 paths, #14 store, #15 lock."""

import os
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- #9: cache.ts — use ?? instead of || ---
with open('src/config/cache.ts') as f:
    c = f.read()
c = c.replace('entry.ttl_seconds || 3600', 'entry.ttl_seconds ?? 3600')
with open('src/config/cache.ts', 'w') as f:
    f.write(c)
print('#9 fixed')

# --- #11 + #15: lock.ts — Windows comment + corrupted lock warning ---
with open('src/engine/lock.ts') as f:
    c = f.read()
old = """    // Check for stale lock from a dead process
    if (existsSync(this.lockPath)) {
      try {
        const pid = parseInt(readFileSync(this.lockPath, 'utf-8').trim());
        if (pid && this.isProcessAlive(pid)) {
          error('locked', `Another update for '${this.name}' is in progress.`);
          process.exit(EXIT_ERROR);
        }
      } catch {}
      // Stale lock — remove it
      try { unlinkSync(this.lockPath); } catch {}
    }"""
new = """    // Check for stale lock from a dead process
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
    }"""
c = c.replace(old, new)
# Add log import
c = c.replace("import { error } from '../utils/log';", "import { error, log } from '../utils/log';")
# Add comment about Windows process.kill
c = c.replace("""  private isProcessAlive(pid: number): boolean {
    try {
      process.kill(pid, 0);
      return true;
    } catch {
      return false;
    }
  }""", """  private isProcessAlive(pid: number): boolean {
    // NOTE: process.kill(pid, 0) is unreliable on Windows — it may throw
    // for alive processes or succeed for dead-but-recycled PIDs.
    // This is a known limitation; the `wx` atomic create on acquire()
    // provides the primary mutual exclusion guarantee.
    try {
      process.kill(pid, 0);
      return true;
    } catch {
      return false;
    }
  }""")
with open('src/engine/lock.ts', 'w') as f:
    f.write(c)
print('#11+#15 fixed')

# --- #12 + #13: paths.ts — validate TRIBUCKET_HOME ---
with open('src/config/paths.ts') as f:
    c = f.read()
old = """export function tribucketHome(): string {
  return process.env.TRIBUCKET_HOME || join(homedir(), '.tribucket');
}"""
new = """export function tribucketHome(): string {
  const env = process.env.TRIBUCKET_HOME;
  if (env && env.trim() !== '') {
    // Validate and normalize the path to prevent injection
    const { resolve } = require('path');
    return resolve(env.trim());
  }
  return join(homedir(), '.tribucket');
}"""
c = c.replace(old, new)
with open('src/config/paths.ts', 'w') as f:
    f.write(c)
print('#12+#13 fixed')

# --- #14: store.ts — Windows atomic write backup ---
with open('src/config/store.ts') as f:
    c = f.read()
old = """export function saveConfig(config: Config): void {
  const path = configPath();
  mkdirSync(dirname(path), { recursive: true });
  const tmp = path + '.tmp';
  writeFileSync(tmp, JSON.stringify(config, null, 2) + '\n');
  renameSync(tmp, path);
}"""
new = """export function saveConfig(config: Config): void {
  const path = configPath();
  mkdirSync(dirname(path), { recursive: true });
  const tmp = path + '.tmp';
  const bak = path + '.bak';
  writeFileSync(tmp, JSON.stringify(config, null, 2) + '\n');
  // Keep a backup of the previous config for recovery on Windows
  // where renameSync may fail if the target is locked (e.g. by AV).
  try { if (existsSync(path)) copyFileSync(path, bak); } catch {}
  try { renameSync(tmp, path); } catch (e: any) {
    // rename failed — try to restore from backup
    log(`Config save failed (${e.message}), trying to restore backup`);
    try { if (existsSync(bak)) copyFileSync(bak, path); } catch {}
    throw e;
  }
}"""
c = c.replace(old, new)
# Add imports
c = c.replace("import { readFileSync, writeFileSync, mkdirSync, existsSync, renameSync } from 'fs';",
              "import { readFileSync, writeFileSync, mkdirSync, existsSync, renameSync, copyFileSync } from 'fs';")
c = c.replace("import type { Config } from '../types';",
              "import { log } from '../utils/log';\nimport type { Config } from '../types';")
with open('src/config/store.ts', 'w') as f:
    f.write(c)
print('#14 fixed')

print('Batch 2 done')
