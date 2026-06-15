import { join } from 'path';
import { existsSync, statSync } from 'fs';
import { log, status } from '../utils/log';
import { t } from '../utils/locale';

function getProxyUrl(url: string): string | null {
  const proto = url.startsWith('https') ? 'https' : 'http';
  const envKey = proto === 'https' ? 'HTTPS_PROXY' : 'HTTP_PROXY';
  return process.env[envKey] || process.env['ALL_PROXY'] || process.env['all_proxy'] || null;
}

export async function downloadFile(url: string, destDir: string): Promise<string | null> {
  const filename = url.split('/').pop()?.split('?')[0] || 'download';
  const destPath = join(destDir, filename);

  log(`Downloading ${filename}...`);
  status(t('downloading', { filename }));

  try {
    const headers: Record<string, string> = {
      'User-Agent': 'Mozilla/5.0 (compatible; tribucket/2.0)',
    };

    // Resume support: check existing file size
    let existingSize = 0;
    if (existsSync(destPath)) {
      existingSize = statSync(destPath).size;
    }

    if (existingSize > 0) {
      headers['Range'] = `bytes=${existingSize}-`;
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 120_000);

    const fetchOptions: RequestInit & { proxy?: string } = {
      headers,
      signal: controller.signal,
    };
    const proxyUrl = getProxyUrl(url);
    if (proxyUrl) {
      // NOTE: `proxy` on RequestInit is a Bun-only extension (not standard
      // fetch). See src/utils/http.ts for the same caveat.
      fetchOptions.proxy = proxyUrl;
      log(`Using proxy: ${proxyUrl}`);
    }

    const response = await fetch(url, fetchOptions);
    clearTimeout(timeout);

    if (!response.ok && response.status !== 206) {
      log(`Download failed: HTTP ${response.status}`);
      return null;
    }

    const statusCode = response.status;
    const contentLength = parseInt(response.headers.get('content-length') || '0', 10);

    let totalSize: number;
    let downloaded: number;
    let appendMode: boolean;

    if (statusCode === 206) {
      // Resume successful
      totalSize = contentLength + existingSize;
      downloaded = existingSize;
      appendMode = true;
      log(`Resuming from ${existingSize} bytes`);
    } else if (statusCode === 200 && existingSize > 0) {
      // Server doesn't support resume, restart
      totalSize = contentLength;
      downloaded = 0;
      appendMode = false;
      log("Server doesn't support resume, restarting download");
    } else {
      totalSize = contentLength;
      downloaded = 0;
      appendMode = false;
    }

    // Download with progress
    const reader = response.body?.getReader();
    if (!reader) {
      log('Download failed: No response body');
      return null;
    }

    const { openSync, writeSync, closeSync } = await import('fs');
    const fd = openSync(destPath, appendMode ? 'a' : 'w');

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        writeSync(fd, value);
        downloaded += value.length;

        // Progress display on TTY
        if (totalSize > 0 && process.stdout.isTTY) {
          const pct = Math.floor(downloaded * 100 / totalSize);
          const mb = (downloaded / (1024 * 1024)).toFixed(1);
          const totalMb = (totalSize / (1024 * 1024)).toFixed(1);
          process.stdout.write(`\r  ${String(pct).padStart(3)}% (${mb}/${totalMb} MB)  ${filename}`);
        }
      }
    } finally {
      closeSync(fd);
    }

    // Clear progress line
    if (process.stdout.isTTY && totalSize > 0) {
      process.stdout.write('\r' + ' '.repeat(50) + '\r');
    }

    const sizeMb = (downloaded / (1024 * 1024)).toFixed(1);
    log(`Download complete: ${sizeMb} MB`);
    status(t('download_complete', { size: sizeMb }));
    return destPath;
  } catch (e: any) {
    log(`Download failed: ${e.message}`);
    return null;
  }
}
