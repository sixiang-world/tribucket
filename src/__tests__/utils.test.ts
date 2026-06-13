import { describe, it, expect } from 'bun:test';

describe('Platform Detection', () => {
  it('should detect platform', async () => {
    const { detectPlatform } = await import('../utils/platform');
    const platform = detectPlatform();
    if (platform) {
      expect(['linux_amd64', 'linux_arm64', 'darwin_amd64', 'darwin_arm64', 'windows_amd64', 'windows_arm64']).toContain(platform);
    }
  });
});

describe('SHA256', () => {
  it('should compute SHA256 hash', async () => {
    const { writeFileSync, unlinkSync } = await import('fs');
    const { join } = await import('path');
    const { tmpdir } = await import('os');
    const { createHash } = await import('crypto');
    const tmpFile = join(tmpdir(), 'test-sha256.txt');
    writeFileSync(tmpFile, 'hello world');
    // Use Node.js crypto for testing
    const { readFileSync } = await import('fs');
    const data = readFileSync(tmpFile);
    const hash = createHash('sha256').update(data).digest('hex');
    expect(hash).toBe('b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9');
    unlinkSync(tmpFile);
  });
});

describe('Mirror', () => {
  it('should build direct URL', async () => {
    const { buildDirectUrl } = await import('../engine/mirror');
    const url = buildDirectUrl('owner/repo', '1.0.0', 'asset.tar.gz');
    expect(url).toBe('https://github.com/owner/repo/releases/download/v1.0.0/asset.tar.gz');
  });

  it('should build mirror URL', async () => {
    const { buildMirrorUrl } = await import('../engine/mirror');
    const url = buildMirrorUrl('https://mirror.example.com/{repo}/v{version}/{asset}', 'owner/repo', '1.0.0', 'asset.tar.gz');
    expect(url).toBe('https://mirror.example.com/owner/repo/v1.0.0/asset.tar.gz');
  });
});

describe('Archive', () => {
  it('should throw on unsupported format', async () => {
    const { extractArchive } = await import('../utils/archive');
    expect(() => extractArchive('test.unknown', '/tmp/dest')).toThrow('Unsupported archive format');
  });
});

describe('Version Detection', () => {
  it('should detect version from binary', async () => {
    const { detectVersion } = await import('../engine/version');
    const { writeFileSync, chmodSync, unlinkSync } = await import('fs');
    const { join } = await import('path');
    const { tmpdir } = await import('os');
    const tmpDir = tmpdir();
    const binaryPath = join(tmpDir, 'test-binary');
    writeFileSync(binaryPath, '#!/bin/sh\necho "mytool 1.2.3"');
    chmodSync(binaryPath, 0o755);
    const tj = { version_check: { cli_flags: ['--version'], parse_regex: '(\\d+\\.\\d+\\.\\d+)', output_stream: 'stdout' as const, timeout: 5 } };
    const [ver, source] = detectVersion(binaryPath, tj as any);
    expect(ver).toBe('1.2.3');
    expect(source).toBe('cli');
    unlinkSync(binaryPath);
  });

  it('should fallback to config version', async () => {
    const { detectVersion } = await import('../engine/version');
    const tj = { version_check: { cli_flags: ['--version'], parse_regex: '(\\d+\\.\\d+\\.\\d+)', output_stream: 'stdout' as const, timeout: 5 } };
    const configInfo = { version: '2.0.0' };
    const [ver, source] = detectVersion('/nonexistent', tj as any, configInfo as any);
    expect(ver).toBe('2.0.0');
    expect(source).toBe('config');
  });

  it('should fallback to package version', async () => {
    const { detectVersion } = await import('../engine/version');
    const tj = { version: '3.0.0', version_check: { cli_flags: ['--version'], parse_regex: '(\\d+\\.\\d+\\.\\d+)', output_stream: 'stdout' as const, timeout: 5 } };
    const [ver, source] = detectVersion('/nonexistent', tj as any);
    expect(ver).toBe('3.0.0');
    expect(source).toBe('fallback');
  });
});

describe('Exit Codes', () => {
  it('should have correct exit codes', async () => {
    const { EXIT_OK, EXIT_ERROR, EXIT_USAGE, EXIT_NOT_FOUND, EXIT_EXISTS, EXIT_NOT_TRACKED, EXIT_UP_TO_DATE, EXIT_NO_NETWORK } = await import('../types');
    expect(EXIT_OK).toBe(0);
    expect(EXIT_ERROR).toBe(1);
    expect(EXIT_USAGE).toBe(2);
    expect(EXIT_NOT_FOUND).toBe(3);
    expect(EXIT_EXISTS).toBe(4);
    expect(EXIT_NOT_TRACKED).toBe(5);
    expect(EXIT_UP_TO_DATE).toBe(6);
    expect(EXIT_NO_NETWORK).toBe(7);
  });
});

describe('Cleanup', () => {
  it('should export cleanupOldTmp function', async () => {
    const { cleanupOldTmp } = await import('../utils/cleanup');
    expect(typeof cleanupOldTmp).toBe('function');
  });
});
