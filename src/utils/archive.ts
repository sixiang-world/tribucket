import { mkdirSync } from 'fs';
import { execSync } from 'child_process';

export function extractArchive(archivePath: string, destDir: string): void {
  mkdirSync(destDir, { recursive: true });

  if (archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz')) {
    execSync(`tar -xzf "${archivePath}" -C "${destDir}"`, { stdio: 'pipe' });
  } else if (archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2')) {
    execSync(`tar -xjf "${archivePath}" -C "${destDir}"`, { stdio: 'pipe' });
  } else if (archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz')) {
    execSync(`tar -xJf "${archivePath}" -C "${destDir}"`, { stdio: 'pipe' });
  } else if (archivePath.endsWith('.zip')) {
    execSync(`unzip -o "${archivePath}" -d "${destDir}"`, { stdio: 'pipe' });
  } else {
    throw new Error(`Unsupported archive format: ${archivePath}`);
  }
}
