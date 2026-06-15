#!/usr/bin/env python3
"""Fix batch 1: #1 sha256, #2 find symlink loop, #3 findBinary single-pass, #6 empty archive, #7 C: drive, #8 resolveReal."""

import os, re
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- #1: sha256.ts — Node.js crypto fallback ---
with open('src/utils/sha256.ts') as f:
    c = f.read()
old = """import { httpGet } from './http';

import { openSync, readSync, closeSync, statSync } from 'fs';

export async function computeSha256(filepath: string): Promise<string> {
  // Read file in chunks using fs.readSync (works in compiled binaries,
  // unlike Bun.CryptoHasher.hash with Bun.file which fails with "File blob cannot be used here")
  const hasher = new Bun.CryptoHasher('sha256');
  const fd = openSync(filepath, 'r');
  const buf = Buffer.alloc(64 * 1024);
  let bytesRead: number;
  try {
    while ((bytesRead = readSync(fd, buf, 0, buf.length, null)) > 0) {
      hasher.update(buf.subarray(0, bytesRead));
    }
  } finally {
    closeSync(fd);
  }
  return hasher.digest('hex');
}"""
new = """import { httpGet } from './http';

import { openSync, readSync, closeSync, statSync } from 'fs';
import { createHash } from 'crypto';

export async function computeSha256(filepath: string): Promise<string> {
  // Read file in chunks using fs.readSync (works in compiled binaries,
  // unlike Bun.CryptoHasher.hash with Bun.file which fails with "File blob cannot be used here")
  // Support both Bun and Node.js runtimes.
  const fd = openSync(filepath, 'r');
  const buf = Buffer.alloc(64 * 1024);
  let bytesRead: number;
  const useBun = typeof Bun !== 'undefined' && typeof Bun.CryptoHasher !== 'undefined';
  const hasher = useBun ? new Bun.CryptoHasher('sha256') : createHash('sha256');
  try {
    while ((bytesRead = readSync(fd, buf, 0, buf.length, null)) > 0) {
      const chunk = buf.subarray(0, bytesRead);
      if (useBun) {
        hasher.update(chunk);
      } else {
        hasher.update(chunk);
      }
    }
  } finally {
    closeSync(fd);
  }
  return useBun ? hasher.digest('hex') : hasher.digest('hex');
}"""
c = c.replace(old, new)
with open('src/utils/sha256.ts', 'w') as f:
    f.write(c)
print('#1 fixed')

# --- #2: find.ts — symlink loop guard ---
with open('src/utils/find.ts') as f:
    c = f.read()
old = """  const results: string[] = [];
  function walk(current: string): void {
    let entries: string[];
    try {
      entries = readdirSync(current);
    } catch {
      return;
    }
    for (const entry of entries) {
      const fullPath = join(current, entry);
      try {
        const s = statSync(fullPath);
        if (s.isDirectory()) {
          walk(fullPath);
        } else if (s.isFile() && predicate(entry, fullPath)) {
          results.push(fullPath);
        }
      } catch {
        // skip entries we can't stat
      }
    }
  }
  walk(dir);
  return results;"""
new = """  const results: string[] = [];
  // Guard against symlink loops: track visited realpaths.
  const visited = new Set<string>();
  function walk(current: string): void {
    let entries: string[];
    try {
      const real = require('fs').realpathSync(current);
      if (visited.has(real)) return; // symlink loop detected
      visited.add(real);
    } catch {}
    try {
      entries = readdirSync(current);
    } catch {
      return;
    }
    for (const entry of entries) {
      const fullPath = join(current, entry);
      try {
        const s = statSync(fullPath);
        if (s.isDirectory()) {
          walk(fullPath);
        } else if (s.isFile() && predicate(entry, fullPath)) {
          results.push(fullPath);
        }
      } catch {
        // skip entries we can't stat
      }
    }
  }
  walk(dir);
  return results;"""
c = c.replace(old, new)
with open('src/utils/find.ts', 'w') as f:
    f.write(c)
print('#2 fixed')

# --- #3: find.ts — findBinary single-pass optimization ---
old = """export function findBinary(dir: string, name: string): string {
  // 1. Direct match first
  const direct = join(dir, name);
  try {
    if (statSync(direct).isFile()) return direct;
  } catch { /* not found */ }

  // 2. Recursive search by exact name
  const matches = findFiles(dir, (entry) => entry === name);
  if (matches.length > 0) return matches[0];

  // 3. Search by name suffix (e.g. name.exe on Windows)
  const suffix = `${name}.exe`;
  const suffixMatches = findFiles(dir, (entry) => entry === suffix);
  if (suffixMatches.length > 0) return suffixMatches[0];

  // 4. Recursive wildcard: any file containing the name (matching Python's **/*{name}*)
  const wildcardMatches = findFiles(dir, (entry) => entry.includes(name));
  if (wildcardMatches.length > 0) return wildcardMatches[0];

  // 5. Recursive wildcard: any file containing the name + .exe
  const wildcardExe = findFiles(dir, (entry) => entry.includes(name) && entry.endsWith('.exe'));
  if (wildcardExe.length > 0) return wildcardExe[0];

  // 6. Fallback: any executable file
  const isWin = process.platform === 'win32';
  const executables = findFiles(dir, (_entry, fullPath) => {
    if (isWin) return true; // Windows doesn't have Unix-style executable bits
    try {
      accessSync(fullPath, constants.X_OK);
      return true;
    } catch {
      return false;
    }
  });
  return executables.length > 0 ? executables[0] : '';
}"""
new = """export function findBinary(dir: string, name: string): string {
  // 1. Direct match first
  const direct = join(dir, name);
  try {
    if (statSync(direct).isFile()) return direct;
  } catch { /* not found */ }

  // Single-pass traversal: collect all files, then match against patterns.
  // This avoids walking the entire directory tree up to 6 times.
  const allFiles = findFiles(dir, () => true);
  const isWin = process.platform === 'win32';

  // Priority-ordered matching (2→6 from original logic, single pass)
  for (const f of allFiles) {
    const entry = f.split(/[/\\\\]/).pop() || '';
    // 2. Exact match
    if (entry === name) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\\\]/).pop() || '';
    // 3. name.exe suffix
    if (entry === `${name}.exe`) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\\\]/).pop() || '';
    // 4. Wildcard: name contained
    if (entry.includes(name)) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\\\]/).pop() || '';
    // 5. Wildcard + .exe
    if (entry.includes(name) && entry.endsWith('.exe')) return f;
  }
  for (const f of allFiles) {
    // 6. Any executable (Windows: any file, Unix: X_OK)
    if (isWin) return f;
    try {
      accessSync(f, constants.X_OK);
      return f;
    } catch {}
  }
  return '';
}"""
c = c.replace(old, new)
with open('src/utils/find.ts', 'w') as f:
    f.write(c)
print('#3 fixed')

# --- #6: install.ts — empty archive guard ---
with open('src/commands/install.ts') as f:
    c = f.read()
old = "    // If single top-level directory, unwrap it"
new = """    // Empty archive guard
    if (entries.length === 0) {
      throw new Error('Archive is empty');
    }
    // If single top-level directory, unwrap it"""
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#6 fixed')

# --- #7: install.ts — dynamic Windows system root ---
old = """  // System directory protection (platform-specific paths)
  const FORBIDDEN = process.platform === 'win32'
    ? ['C:\\\\Windows', 'C:\\\\Program Files', 'C:\\\\Program Files (x86)', 'C:\\\\ProgramData']
    : ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];"""
new = """  // System directory protection (platform-specific paths)
  const winRoot = process.env.SystemRoot || process.env.windir || 'C:\\\\Windows';
  const winDrive = winRoot.slice(0, 2); // e.g. "C:"
  const FORBIDDEN = process.platform === 'win32'
    ? [winRoot, `${winDrive}\\\\Program Files`, `${winDrive}\\\\Program Files (x86)`, `${winDrive}\\\\ProgramData`]
    : ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];"""
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#7 fixed')

# --- #8: install.ts — resolveReal symlink-aware fallback ---
old = """  // Path traversal protection — resolve symlinks (matching Python v1 realpath behavior)
  function resolveReal(p: string): string {
    try { return realpathSync(p); }
    catch {
      // If path doesn't exist yet, resolve parent chain
      const parent = resolve(p, '..');
      if (parent === p) return p; // root
      try { return join(realpathSync(parent), basename(p)); }
      catch { return resolve(p); }
    }
  }"""
new = """  // Path traversal protection — resolve symlinks (matching Python v1 realpath behavior)
  function resolveReal(p: string): string {
    try { return realpathSync(p); }
    catch {
      // If path doesn't exist yet, resolve parent chain
      const parent = resolve(p, '..');
      if (parent === p) return p; // root
      try { return join(realpathSync(parent), basename(p)); }
      catch {
        // Last resort: resolve the path and check against resolved base
        // to ensure the fallback itself doesn't allow traversal.
        const resolved = resolve(p);
        const resolvedBase = resolve(options.dir || process.cwd());
        if (!resolved.startsWith(resolvedBase + require('path').sep) && resolved !== resolvedBase) {
          throw new Error('Path traversal detected');
        }
        return resolved;
      }
    }
  }"""
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#8 fixed')

print('Batch 1 done')
