import { httpGet } from './http';

export function computeSha256(filepath: string): Promise<string> {
  const file = Bun.file(filepath);
  return Bun.CryptoHasher.hash('sha256', file).toString();
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
      const body = await httpGet(asset.browser_download_url, { timeout: 15000 });
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
