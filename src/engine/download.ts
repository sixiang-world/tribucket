import { join } from 'path';
import { log } from '../utils/log';

export async function downloadFile(url: string, destDir: string): Promise<string | null> {
  const filename = url.split('/').pop()?.split('?')[0] || 'download';
  const destPath = join(destDir, filename);

  log(`Downloading ${filename}...`);

  try {
    const response = await fetch(url, {
      headers: { 'User-Agent': 'Mozilla/5.0 (compatible; tributable/2.0)' },
    });

    if (!response.ok) {
      log(`Download failed: HTTP ${response.status}`);
      return null;
    }

    const data = new Uint8Array(await response.arrayBuffer());
    await Bun.write(destPath, data);

    const sizeMb = data.length / (1024 * 1024);
    log(`Download complete: ${sizeMb.toFixed(1)} MB`);
    return destPath;
  } catch (e: any) {
    log(`Download failed: ${e.message}`);
    return null;
  }
}
