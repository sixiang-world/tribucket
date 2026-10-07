import { httpGet } from './http';

import { openSync, readSync, closeSync } from 'fs';
import { createHash } from 'crypto';

export async function computeSha256(filepath: string): Promise<string> {
  // Read file in chunks using fs.readSync (works in compiled binaries,
  // unlike Bun.CryptoHasher.hash with Bun.file which fails with "File blob cannot be used here")
  // Support both Bun and Node.js runtimes.
  const fd = openSync(filepath, 'r');
  const buf = Buffer.alloc(64 * 1024);
  let bytesRead: number;
  const useBun = typeof Bun !== 'undefined' && typeof Bun.CryptoHasher !== 'undefined';
  const hasher: { update(data: Buffer): void; digest(encoding: 'hex'): string } =
    useBun ? new Bun.CryptoHasher('sha256') : createHash('sha256');
  try {
    while ((bytesRead = readSync(fd, buf, 0, buf.length, null)) > 0) {
      hasher.update(buf.subarray(0, bytesRead));
    }
  } finally {
    closeSync(fd);
  }
  return hasher.digest('hex');
}

const CHECKSUM_PATTERNS = ['sha256sums', 'sha256', 'checksums.txt', '.sha256'];

export async function findSha256FromRelease(
  releaseData: any,
  targetFilename: string
): Promise<string | null> {
  const assets = releaseData?.assets || [];
  for (const asset of assets) {
    const nameLower = (asset.name || '').toLowerCase();
    if (!CHECKSUM_PATTERNS.some(p => nameLower.includes(p))) continue;
    try {
      const body = await httpGet(asset.browser_download_url, { timeout: 15000, retries: 1, silent: true });
      const content = new TextDecoder().decode(body);
      for (const line of content.trim().split('\n')) {
        const parts = line.trim().split(/\s+/);
        if (parts.length >= 2 && parts[parts.length - 1].includes(targetFilename)) {
          return parts[0].toLowerCase();
        }
      }
    } catch {
      continue;
    }
  }
  return null;
}
