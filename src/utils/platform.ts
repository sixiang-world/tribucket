import { existsSync } from 'fs';
import { join } from 'path';
import type { Platform } from '../types';

export function detectPlatform(): Platform | null {
  const osMap: Record<string, string> = { linux: 'linux', darwin: 'darwin', win32: 'windows' };
  const archMap: Record<string, string> = { x64: 'amd64', arm64: 'arm64' };

  const os = osMap[process.platform];
  const arch = archMap[process.arch];
  if (!os || !arch) return null;
  return `${os}_${arch}` as Platform;
}

/**
 * Build the on-disk path to a package binary inside its install directory.
 *
 * On Windows, release binaries ship as `<binary>.exe`. The package's `binary`
 * field is the bare name (e.g. "rg"), so we must append `.exe` when probing
 * the filesystem — existsSync/spawnSync do NOT try PATHEXT for us.
 *
 * If the bare path already exists (some Windows packages store the binary
 * without an extension, or the name already includes .exe), it is returned
 * unchanged.
 */
export function resolveBinaryPath(installDir: string, binary: string): string {
  const isWindows = process.platform === 'win32';
  const bare = join(installDir, binary);
  if (!isWindows) return bare;
  // Already has an extension, or the bare file exists — use as-is.
  if (existsSync(bare)) return bare;
  const withExe = join(installDir, binary.endsWith('.exe') ? binary : `${binary}.exe`);
  return withExe;
}
