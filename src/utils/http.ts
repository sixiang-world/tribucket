import { log } from './log';

function getProxyUrl(url: string): string | null {
  const proto = url.startsWith('https') ? 'https' : 'http';
  const envKey = proto === 'https' ? 'HTTPS_PROXY' : 'HTTP_PROXY';
  return process.env[envKey] || process.env['ALL_PROXY'] || null;
}

export async function httpGet(url: string, options?: { token?: string; retries?: number; timeout?: number }): Promise<Uint8Array> {
  const { token, retries = 3, timeout = 30000 } = options || {};
  const headers: Record<string, string> = {
    'User-Agent': 'Mozilla/5.0 (compatible; tributable/2.0)',
  };
  if (url.includes('github.com')) {
    headers['Accept'] = 'application/vnd.github.v3+json';
  }
  if (token) {
    headers['Authorization'] = `token ${token}`;
  }

  const proxyUrl = getProxyUrl(url);

  let lastError: Error | null = null;
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), timeout);

      const fetchOptions: RequestInit = {
        headers,
        signal: controller.signal,
      };

      // Proxy support via environment variables
      if (proxyUrl) {
        log(`Using proxy: ${proxyUrl}`);
        // Bun supports proxy via dispatcher, but for simplicity we use undici
        // Fallback: if proxy is needed, try direct connection
        try {
          const { ProxyAgent } = await import('undici');
          fetchOptions.dispatcher = new ProxyAgent(proxyUrl);
        } catch {
          // undici not available, try direct connection
          log('Proxy library not available, trying direct connection');
        }
      }

      const response = await fetch(url, fetchOptions);
      clearTimeout(timeoutId);

      if (!response.ok) {
        if (response.status === 403) throw new Error(`HTTP 403: Rate limited`);
        if (response.status >= 500 && attempt < retries - 1) {
          log(`HTTP ${response.status}, retrying (${attempt + 1}/${retries})...`);
          await new Promise(r => setTimeout(r, 2 ** attempt * 1000));
          continue;
        }
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return new Uint8Array(await response.arrayBuffer());
    } catch (e: any) {
      lastError = e;
      if (attempt < retries - 1) {
        log(`Network error, retrying (${attempt + 1}/${retries})...`);
        await new Promise(r => setTimeout(r, 2 ** attempt * 1000));
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
