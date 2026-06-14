import { readdirSync, statSync } from 'fs';
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
 */
export function findBinary(dir: string, name: string): string {
  // Direct match first
  const direct = join(dir, name);
  try {
    if (statSync(direct).isFile()) return direct;
  } catch { /* not found */ }

  // Recursive search by exact name
  const matches = findFiles(dir, (entry) => entry === name);
  if (matches.length > 0) return matches[0];

  // Search by name suffix (e.g. name.exe on Windows)
  const suffix = `${name}.exe`;
  const suffixMatches = findFiles(dir, (entry) => entry === suffix);
  if (suffixMatches.length > 0) return suffixMatches[0];

  // Fallback: any executable file
  const executables = findFiles(dir, (_entry, fullPath) => {
    try {
      const { accessSync, constants } = require('fs');
      accessSync(fullPath, constants.X_OK);
      return true;
    } catch {
      return false;
    }
  });
  return executables.length > 0 ? executables[0] : '';
}
