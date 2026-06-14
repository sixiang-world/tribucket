import { mkdirSync, readdirSync, lstatSync } from 'fs';
import { join, resolve } from 'path';
import { execFileSync } from 'child_process';

const isWindows = process.platform === 'win32';

function sh(cmd: string, args: string[]): void {
  // shell:false on both platforms. execFileSync resolves cmd via PATHEXT
  // and PATH correctly when given the base name 'tar' / 'unzip'.
  execFileSync(cmd, args, { stdio: 'pipe', shell: false });
}

/**
 * Cross-platform archive extraction.
 *
 * Strategy:
 *  - .zip on Windows: use `tar -xf` (Windows 10 1803+ ships libarchive's
 *    bsdtar, which handles zip natively). Fallback to PowerShell
 *    Expand-Archive for older Windows without tar.
 *  - .zip on Unix: use `unzip` (ubiquitous), fallback to `tar -xf`.
 *  - .tar.*: use `tar` on both platforms. GNU tar (Linux/macOS) supports
 *    --no-absolute-names; Windows bsdtar does not, so we omit it there and
 *    rely on the post-extraction zip-slip validator instead.
 */
export function extractArchive(archivePath: string, destDir: string): void {
  mkdirSync(destDir, { recursive: true });
  const resolvedDest = resolve(destDir);
  const lower = archivePath.toLowerCase();
  const isZip = lower.endsWith('.zip');

  const errors: Error[] = [];

  if (isZip) {
    if (isWindows) {
      // Windows 10 1803+ ships tar (libarchive bsdtar) which handles zip.
      try {
        sh('tar', ['-xf', archivePath, '-C', destDir]);
      } catch (e1) {
        errors.push(e1 as Error);
        // Fallback: PowerShell Expand-Archive (available on all Win10+).
        const psCmd =
          "Expand-Archive -LiteralPath '" + archivePath +
          "' -DestinationPath '" + destDir + "' -Force";
        try {
          execFileSync(
            'powershell.exe',
            ['-NoProfile', '-Command', psCmd],
            { stdio: 'pipe', shell: false },
          );
        } catch (e2) {
          errors.push(e2 as Error);
          throw new Error(
            'Failed to extract zip on Windows.\n' +
            '  tar: ' + errors[0].message + '\n' +
            '  powershell: ' + errors[1].message + '\n' +
            'Install tar (built into Windows 10 1803+) or PowerShell.',
          );
        }
      }
    } else {
      // Unix: prefer unzip, fallback to bsdtar/GNU tar.
      try {
        sh('unzip', ['-o', archivePath, '-d', destDir]);
      } catch (e1) {
        errors.push(e1 as Error);
        try {
          sh('tar', ['-xf', archivePath, '-C', destDir]);
        } catch (e2) {
          errors.push(e2 as Error);
          throw new Error(
            'Failed to extract zip.\n' +
            '  unzip: ' + errors[0].message + '\n' +
            '  tar: ' + errors[1].message + '\n' +
            "Install 'unzip' or 'tar'.",
          );
        }
      }
    }
  } else {
    // tar variants — same flags work for both GNU tar and Windows bsdtar.
    let flag: string;
    if (lower.endsWith('.tar.gz') || lower.endsWith('.tgz')) flag = '-xzf';
    else if (lower.endsWith('.tar.bz2') || lower.endsWith('.tbz2')) flag = '-xjf';
    else if (lower.endsWith('.tar.xz') || lower.endsWith('.txz')) flag = '-xJf';
    else throw new Error('Unsupported archive format: ' + archivePath);

    // NOTE: We deliberately do NOT pass --no-absolute-names to tar.
    // That flag is NOT supported by GNU tar (including Ubuntu 24.04's
    // GNU tar 1.35) despite a widespread misconception — it only exists in
    // libarchive's bsdtar. Passing it makes tar crash on Linux.
    // Instead we rely on the post-extraction zip-slip validator below
    // (validateExtraction) to reject any path-escaping entries.
    const args = [flag, archivePath, '-C', destDir];

    try {
      sh('tar', args);
    } catch (e) {
      throw new Error(
        'Failed to extract tar archive: ' + (e as Error).message + '\n' +
        "Ensure 'tar' is installed and on PATH.",
      );
    }
  }

  // Post-extraction zip-slip validation for all archive types.
  // This is our security backstop on platforms where the extractor
  // cannot reject absolute paths by itself (e.g. Windows bsdtar).
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
      throw new Error('Archive contains path traversal: ' + entry);
    }
    try {
      const stat = lstatSync(entryPath);
      if (stat.isDirectory()) {
        validateDir(entryPath, destDir);
      }
    } catch {}
  }
}
