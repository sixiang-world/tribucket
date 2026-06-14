import { describe, it, expect } from 'bun:test';

describe('Platform Detection', () => {
  it('should detect platform', async () => {
    const { detectPlatform } = await import('../utils/platform');
    const platform = detectPlatform();
    if (platform) {
      expect(['linux_amd64', 'linux_arm64', 'darwin_amd64', 'darwin_arm64', 'windows_amd64', 'windows_arm64']).toContain(platform);
    }
  });

  it('resolveBinaryPath appends .exe on Windows when bare missing', async () => {
    const { resolveBinaryPath } = await import('../utils/platform');
    const { mkdirSync, writeFileSync, rmSync } = await import('fs');
    const { join } = await import('path');
    const { tmpdir } = await import('os');
    const dir = join(tmpdir(), `tb-binpath-test-${Date.now()}`);
    mkdirSync(dir, { recursive: true });
    try {
      const isWin = process.platform === 'win32';
      // Simulate the Windows case: only "rg.exe" exists, binary field is "rg".
      const onDisk = isWin ? 'rg.exe' : 'rg';
      writeFileSync(join(dir, onDisk), isWin ? '' : '#!/bin/sh\n');
      const p = resolveBinaryPath(dir, 'rg');
      // The resolved path must point at the file that actually exists.
      expect(p.endsWith(isWin ? 'rg.exe' : 'rg')).toBe(true);
      // On non-Windows the path is the bare name; on Windows it's the .exe.
      if (isWin) expect(p.endsWith('rg.exe')).toBe(true);
      else expect(p.endsWith('/rg') || p.endsWith('\\rg')).toBe(true);
    } finally {
      rmSync(dir, { recursive: true, force: true });
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
  it('should build direct URL using the raw tag (no forced v-prefix)', async () => {
    const { buildDirectUrl } = await import('../engine/mirror');
    // v-prefixed tag: must be used verbatim
    expect(buildDirectUrl('owner/repo', 'v1.0.0', 'asset.tar.gz'))
      .toBe('https://github.com/owner/repo/releases/download/v1.0.0/asset.tar.gz');
    // non-v tag (e.g. jq): must NOT get a v injected
    expect(buildDirectUrl('jqlang/jq', 'jq-1.8.1', 'jq-linux64'))
      .toBe('https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64');
  });

  it('should build mirror URL supporting {tag} and legacy {version}', async () => {
    const { buildMirrorUrl } = await import('../engine/mirror');
    // {tag} preferred — used verbatim
    expect(buildMirrorUrl('https://m/{repo}/releases/download/{tag}/{asset}', 'owner/repo', 'v1.0.0', 'a.zip'))
      .toBe('https://m/owner/repo/releases/download/v1.0.0/a.zip');
    // legacy {version} — strips a single leading v for backward compat
    expect(buildMirrorUrl('https://m/{repo}/v{version}/{asset}', 'owner/repo', 'v1.0.0', 'a.zip'))
      .toBe('https://m/owner/repo/v1.0.0/a.zip');
  });

  it('should resolve glob/suffix asset patterns against release assets', async () => {
    const { resolveAssetName } = await import('../engine/mirror');
    const release = {
      assets: [
        { name: 'bat-v0.26.1-x86_64-pc-windows-msvc.zip' },
        { name: 'bat-v0.26.1-x86_64-unknown-linux-gnu.tar.gz' },
        { name: 'fzf-0.73.1-windows_amd64.zip' },
        { name: 'jq-linux64' },
      ],
    };
    // 1. literal exact match
    expect(resolveAssetName(release, 'jq-linux64')).toBe('jq-linux64');
    // 2. glob match
    expect(resolveAssetName(release, 'fzf-*-windows_amd64.zip'))
      .toBe('fzf-0.73.1-windows_amd64.zip');
    // 3. suffix match
    expect(resolveAssetName(release, 'x86_64-pc-windows-msvc.zip'))
      .toBe('bat-v0.26.1-x86_64-pc-windows-msvc.zip');
    // no release data → pattern returned as-is
    expect(resolveAssetName(null, 'whatever')).toBe('whatever');
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
    const isWin = process.platform === 'win32';

    const tmpDir = tmpdir();
    const baseName = 'test-binary';
    const binaryPath = join(tmpDir, isWin ? baseName + '.bat' : baseName);

    // Write a script that runs on the current platform and prints a version line.
    const content = isWin
      ? '@echo off\recho mytool 1.2.3'
      : '#!/bin/sh\necho "mytool 1.2.3"';
    writeFileSync(binaryPath, content);
    if (!isWin) chmodSync(binaryPath, 0o755);

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
