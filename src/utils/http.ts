import { log, status } from './log';
import { t } from './locale';

function getProxyUrl(url: string): string | null {
  const proto = url.startsWith('https') ? 'https' : 'http';
  const envKey = proto === 'https' ? 'HTTPS_PROXY' : 'HTTP_PROXY';
  return process.env[envKey] || process.env['ALL_PROXY'] || null;
}

export async function httpGet(url: string, options?: { token?: string; retries?: number; timeout?: number; method?: string }): Promise<Uint8Array> {
  // Default to 5 retries with jittered exponential backoff — GitHub metadata
  // (api.github.com, raw.githubusercontent.com) is frequently flaky on
  // restricted networks (e.g. China), where 3 retries were not enough in
  // practice and caused spurious "Package not found" / install failures.
  const { token, retries = 5, timeout = 30000, method = 'GET' } = options || {};
  const headers: Record<string, string> = {
    'User-Agent': 'Mozilla/5.0 (compatible; tribucket/2.0)',
  };
  if (url.includes('github.com')) {
    headers['Accept'] = 'application/vnd.github.v3+json';
  }
  if (token) {
    headers['Authorization'] = `token ${token}`;
  }

  // Exponential backoff with full jitter to avoid thundering-herd retries.
  const backoffMs = (attempt: number) => Math.floor(Math.random() * (2 ** attempt * 1000)) + 250;

  const proxyUrl = getProxyUrl(url);

  let lastError: Error | null = null;
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), timeout);

      const fetchOptions: RequestInit = {
        method,
        headers,
        signal: controller.signal,
      };

      // Proxy support via environment variables.
      // NOTE: `proxy` on RequestInit is a Bun-only extension (not part of the
      // standard fetch Web API). If this code is ever ported to Node.js, swap
      // this for an undici ProxyAgent / https-proxy-agent instead.
      if (proxyUrl) {
        log(`Using proxy: ${proxyUrl}`);
        (fetchOptions as any).proxy = proxyUrl;
      }

      const response = await fetch(url, fetchOptions);
      clearTimeout(timeoutId);

      if (!response.ok) {
        // Retry on rate-limiting too: a transient 403/429 may clear after a
        // short backoff, and failing fast makes installs unusable on
        // rate-limited networks without a token.
        if ((response.status === 403 || response.status === 429) && attempt < retries - 1) {
          log(`HTTP ${response.status} (rate limited), retrying (${attempt + 1}/${retries})...`);
          status(t('rate_limited_retrying', { n: attempt + 1, total: retries }));
          await new Promise(r => setTimeout(r, backoffMs(attempt)));
          continue;
        }
        if (response.status === 403) throw new Error(`HTTP 403: Rate limited`);
        if (response.status >= 500 && attempt < retries - 1) {
          log(`HTTP ${response.status}, retrying (${attempt + 1}/${retries})...`);
          status(t('server_error_retrying', { n: attempt + 1, total: retries }));
          await new Promise(r => setTimeout(r, backoffMs(attempt)));
          continue;
        }
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return new Uint8Array(await response.arrayBuffer());
    } catch (e: any) {
      lastError = e;
      if (attempt < retries - 1) {
        // Extract a short error code for the status line (e.g. ECONNREFUSED, ETIMEDOUT)
        const code = e?.cause?.code || e?.code || e?.name || 'unknown';
        log(`Network error: ${e.message}${e.cause ? ` (cause: ${e.cause})` : ''}, retrying (${attempt + 1}/${retries})...`);
        status(t('network_error_retrying', { code, n: attempt + 1, total: retries }));
        await new Promise(r => setTimeout(r, backoffMs(attempt)));
        continue;
      }
      throw e;
    }
  }
  throw lastError!;
}

export async function httpGetJson<T = any>(url: string, options?: { token?: string; retries?: number; timeout?: number }): Promise<T> {
  const body = await httpGet(url, options);
  return JSON.parse(new TextDecoder().decode(body));
}
