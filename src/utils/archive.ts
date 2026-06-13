import { mkdirSync, readdirSync, statSync, lstatSync } from 'fs';
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
  } else {
    throw new Error(`Unsupported archive format: ${archivePath}`);
  }

  // Post-extraction zip-slip validation for all archive types
  validateExtraction(destDir, resolvedDest);
}

function validateExtraction(extractDir: string, destDir: string): void {
  try {
    validateDir(extractDir, destDir);
  } catch (e: any) {
    if (e.message.includes('path traversal')) {
      throw e;
    }
  }
}

function validateDir(currentDir: string, destDir: string): void {
  const entries = readdirSync(currentDir);
  for (const entry of entries) {
    const entryPath = resolve(join(currentDir, entry));
    if (!entryPath.startsWith(destDir) && entryPath !== destDir) {
      throw new Error(`Archive contains path traversal: ${entry}`);
    }
    try {
      const stat = lstatSync(entryPath);
      if (stat.isDirectory()) {
        validateDir(entryPath, destDir);
      }
    } catch {}
  }
}
