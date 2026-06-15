import { readdirSync, statSync, accessSync, constants } from 'fs';
import { join } from 'path';

/**
 * Recursively find files matching a predicate.
 * Pure Node.js replacement for system `find` command.
 */
export function findFiles(
  dir: string,
  predicate: (name: string, fullPath: string) => boolean,
): string[] {
  const results: string[] = [];
  // Guard against symlink loops: track visited realpaths.
  const visited = new Set<string>();
  function walk(current: string): void {
    let entries: string[];
    try {
      const real = realpathSync(current);
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
  return results;
}

/**
 * Find the first executable file matching a name pattern in a directory.
 * Searches recursively; returns the first match or empty string.
 *
 * Matches Python v1 behavior:
 * 1. Direct match in root
 * 2. Recursive exact name match
 * 3. Recursive exact name + .exe (Windows)
 * 4. Recursive wildcard: any file containing the name
 * 5. Recursive wildcard: any file containing the name + .exe
 * 6. Fallback: any executable file
 */
export function findBinary(dir: string, name: string): string {
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
    const entry = f.split(/[/\\]/).pop() || '';
    // 2. Exact match
    if (entry === name) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\]/).pop() || '';
    // 3. name.exe suffix
    if (entry === `${name}.exe`) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\]/).pop() || '';
    // 4. Wildcard: name contained
    if (entry.includes(name)) return f;
  }
  for (const f of allFiles) {
    const entry = f.split(/[/\\]/).pop() || '';
    // 5. Wildcard + .exe
    if (entry.includes(name) && entry.endsWith('.exe')) return f;
  }
  for (const f of allFiles) {
    // 6. Any executable (Windows: any file containing name, Unix: X_OK)
    if (isWin && f.toLowerCase().includes(name.toLowerCase())) return f;
    try {
      accessSync(f, constants.X_OK);
      return f;
    } catch {}
  }
  return '';
}
