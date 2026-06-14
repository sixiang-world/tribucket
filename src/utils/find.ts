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
}
