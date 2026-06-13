import { mkdirSync, readdirSync, statSync } from 'fs';
import { join, resolve } from 'path';
import { execFileSync } from 'child_process';

export function extractArchive(archivePath: string, destDir: string): void {
  mkdirSync(destDir, { recursive: true });
  const resolvedDest = resolve(destDir);

  if (archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz')) {
    execFileSync('tar', ['-xzf', archivePath, '-C', destDir, '--no-absolute-names'], { stdio: 'pipe' });
  } else if (archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2')) {
    execFileSync('tar', ['-xjf', archivePath, '-C', destDir, '--no-absolute-names'], { stdio: 'pipe' });
  } else if (archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz')) {
    execFileSync('tar', ['-xJf', archivePath, '-C', destDir, '--no-absolute-names'], { stdio: 'pipe' });
  } else if (archivePath.endsWith('.zip')) {
    execFileSync('unzip', ['-o', archivePath, '-d', destDir], { stdio: 'pipe' });
    // Post-extraction zip-slip validation
    validateExtraction(destDir, resolvedDest);
  } else {
    throw new Error(`Unsupported archive format: ${archivePath}`);
  }
}

function validateExtraction(extractDir: string, destDir: string): void {
  try {
    const entries = readdirSync(extractDir);
    for (const entry of entries) {
      const entryPath = resolve(join(extractDir, entry));
      if (!entryPath.startsWith(destDir) && entryPath !== destDir) {
        throw new Error(`Archive contains path traversal: ${entry}`);
      }
    }
  } catch (e: any) {
    if (e.message.includes('path traversal')) {
      throw e;
    }
    // Ignore errors from reading directory
  }
}
