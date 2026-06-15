import { describe, it, expect, afterAll, beforeAll } from 'bun:test';
import {
  mkdtempSync,
  rmSync,
  statSync,
  truncateSync,
  readFileSync,
  existsSync,
  copyFileSync,
  writeFileSync,
} from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { createHash } from 'crypto';

/**
 * End-to-end test for download resume (Range / HTTP 206).
 *
 * We spin up a *real* local HTTP server (Bun.serve) that fully implements
 * HTTP Range per RFC 7233, then exercise the production `downloadFile`
 * against it. This is a genuine resume, not a proxy signal:
 *
 *   - A broken append path (e.g. opening with 'w' instead of 'a') would
 *     lose the truncated prefix and produce a wrong final SHA256.
 *   - A missing Range header would make the server return the full body
 *     with HTTP 200; downloadFile would then rewrite the file and the
 *     final size would still match, BUT we additionally assert the
 *     server observed a Range request and replied 206.
 *   - A wrong resume offset would make the server return 416 or the
 *     reconstructed bytes wouldn't hash-equal the original.
 *
 * Using a local server is intentional and stronger than relying on a
 * third-party CDN: CDN Range support is inconsistent (e.g. raw.githubusercontent.com
 * advertises `Accept-Ranges: bytes` but ignores Range and returns 200),
 * which would make the test flaky and unable to prove the 206 path works.
 */

// A deterministic payload larger than typical chunking thresholds so that
// both the "first half on disk" and "remaining bytes streamed" cases
// exercise multi-write append behaviour.
const PAYLOAD = Buffer.from(
  Array.from({ length: 64 * 1024 }, (_, i) => i % 251),
);

let server: ReturnType<typeof Bun.serve> | null = null;
let baseUrl = '';
// Telemetry captured per request so the test can prove the 206 path ran.
let lastServedStatus = 0;
let lastRangeHeader: string | null = null;
let rangeRequests = 0;
let fullRequests = 0;

function sha256(buf: Buffer): string {
  return createHash('sha256').update(buf).digest('hex');
}

beforeAll(() => {
  server = Bun.serve({
    port: 0, // ephemeral
    fetch(req) {
      const url = new URL(req.url);
      if (url.pathname !== '/payload.bin') {
        return new Response('not found', { status: 404 });
      }
      const range = req.headers.get('range');
      if (range) {
        rangeRequests++;
        lastRangeHeader = range;
      } else {
        fullRequests++;
      }
      lastRangeHeader = range;

      // Respond to a "bytes=N-" open-ended range per RFC 7233.
      const m = /^bytes=(\d+)-$/.exec(range || '');
      if (range) {
        if (!m) {
          return new Response('bad range', { status: 400 });
        }
        const start = parseInt(m[1], 10);
        if (start >= PAYLOAD.length) {
          return new Response(null, {
            status: 416,
            headers: { 'Content-Range': `bytes */${PAYLOAD.length}` },
          });
        }
        const body = PAYLOAD.subarray(start);
        lastServedStatus = 206;
        return new Response(body, {
          status: 206,
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length': String(body.length),
            'Content-Range': `bytes ${start}-${PAYLOAD.length - 1}/${PAYLOAD.length}`,
            'Accept-Ranges': 'bytes',
          },
        });
      }
      lastServedStatus = 200;
      return new Response(PAYLOAD, {
        status: 200,
        headers: {
          'Content-Type': 'application/octet-stream',
          'Content-Length': String(PAYLOAD.length),
          'Accept-Ranges': 'bytes',
        },
      });
    },
  });
  // Bun.serve with port:0 assigns an ephemeral port.
  const addr = server.address as any;
  baseUrl = `http://localhost:${addr.port}`;
});

afterAll(() => {
  server?.stop(true);
  server = null;
});

async function downloadWithRetry(
  downloadFile: (url: string, dir: string) => Promise<string | null>,
  url: string,
  dir: string,
  retries = 3,
): Promise<string> {
  let lastErr: unknown;
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const out = await downloadFile(url, dir);
      if (out && existsSync(out)) return out;
      throw new Error('downloadFile returned null');
    } catch (e) {
      lastErr = e;
      await new Promise((r) => setTimeout(r, 200 * attempt));
    }
  }
  throw lastErr;
}

describe('download resume (Range / HTTP 206) [local server]', () => {
  it('resumes a truncated download: 206 + append produces identical SHA256', async () => {
    const { downloadFile } = await import('../engine/download');
    const workdir = mkdtempSync(join(tmpdir(), 'tb-resume-'));
    try {
      const url = `${baseUrl}/payload.bin`;
      const fullSha = sha256(PAYLOAD);
      const fullSize = PAYLOAD.length;

      // 1) Complete download — establishes the reference file on disk.
      const fullDir = mkdtempSync(join(workdir, 'full-'));
      const fullPath = await downloadWithRetry(downloadFile, url, fullDir);
      expect(statSync(fullPath).size).toBe(fullSize);
      expect(sha256OfFile(fullPath)).toBe(fullSha);
      expect(fullRequests).toBeGreaterThanOrEqual(1);

      // 2) Simulate an interrupted download: write the first half of the
      //    payload into the resume dir under the URL's basename. downloadFile
      //    derives the destination filename from the URL, so it must match.
      const resumeDir = mkdtempSync(join(workdir, 'resume-'));
      const resumePath = join(resumeDir, url.split('/').pop()!);
      const halfSize = Math.floor(fullSize / 2);
      writeFileSync(resumePath, PAYLOAD.subarray(0, halfSize));
      expect(statSync(resumePath).size).toBe(halfSize);

      // 3) Resume: downloadFile must send `Range: bytes=<halfSize>-`, the
      //    server must respond 206, and the remainder must be appended.
      rangeRequests = 0;
      const resumedOut = await downloadWithRetry(downloadFile, url, resumeDir);

      // The server actually received a Range request (i.e. downloadFile
      // emitted the header) — proves the resume code path ran.
      expect(rangeRequests).toBeGreaterThanOrEqual(1);
      expect(lastServedStatus).toBe(206);
      expect(lastRangeHeader).toBe(`bytes=${halfSize}-`);

      // Final size and SHA256 must match the complete payload. This fails
      // for any of: wrong open mode, wrong offset, double-counting, etc.
      expect(statSync(resumedOut).size).toBe(fullSize);
      expect(sha256OfFile(resumedOut)).toBe(fullSha);
    } finally {
      rmSync(workdir, { recursive: true, force: true });
    }
  }, 30_000);

  it('falls back to full download when server ignores Range (HTTP 200)', async () => {
    const { downloadFile } = await import('../engine/download');
    const workdir = mkdtempSync(join(tmpdir(), 'tb-noresume-'));
    try {
      const url = `${baseUrl}/payload.bin`;
      const resumeDir = mkdtempSync(join(workdir, 'resume-'));
      const resumePath = join(resumeDir, url.split('/').pop()!);

      // Seed a partial file. We'll point the request at a "no-range" server
      // by using a second server instance that always returns 200 + full body.
      writeFileSync(resumePath, PAYLOAD.subarray(0, 1000));

      const noRange = Bun.serve({
        port: 0,
        fetch(req) {
          // Intentionally ignore Range — emulate raw.githubusercontent.com.
          return new Response(PAYLOAD, {
            status: 200,
            headers: {
              'Content-Length': String(PAYLOAD.length),
              'Accept-Ranges': 'bytes',
            },
          });
        },
      });
      const noRangeUrl = `http://localhost:${(noRange.address as any).port}/payload.bin`;
      try {
        const out = await downloadWithRetry(downloadFile, noRangeUrl, resumeDir);
        // Must still converge to the correct full payload (rewritten, not appended).
        expect(statSync(out).size).toBe(PAYLOAD.length);
        expect(sha256OfFile(out)).toBe(sha256(PAYLOAD));
      } finally {
        noRange.stop(true);
      }
    } finally {
      rmSync(workdir, { recursive: true, force: true });
    }
  }, 30_000);
});

function sha256OfFile(path: string): string {
  return createHash('sha256').update(readFileSync(path)).digest('hex');
}
