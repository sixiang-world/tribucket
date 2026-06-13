import type { Platform } from '../types';

export function detectPlatform(): Platform | null {
  const osMap: Record<string, string> = { linux: 'linux', darwin: 'darwin', win32: 'windows' };
  const archMap: Record<string, string> = { x64: 'amd64', arm64: 'arm64' };

  const os = osMap[process.platform];
  const arch = archMap[process.arch];
  if (!os || !arch) return null;
  return `${os}_${arch}` as Platform;
}
