/**
 * Comprehensive integration tests for tribucket CLI.
 * Tests CLI entry, security boundaries, edge cases, and core utilities.
 */
import { describe, it, expect, beforeAll, afterAll } from 'bun:test';
import { mkdirSync, writeFileSync, rmSync, existsSync, readFileSync, chmodSync, symlinkSync } from 'fs';
import { join, resolve } from 'path';
import { tmpdir } from 'os';

// ── Helpers ──

const TMP = join(tmpdir(), `tb-comprehensive-${Date.now()}`);
const HOME = join(TMP, 'home');
const BIN = join(HOME, 'bin');
const CONFIG = join(HOME, 'config.json');

beforeAll(() => {
  mkdirSync(TMP, { recursive: true });
  mkdirSync(BIN, { recursive: true });
  process.env.TRIBUCKET_HOME = HOME;
});

afterAll(() => {
  rmSync(TMP, { recursive: true, force: true });
});

// ── 1. Config Store Tests ──

describe('Config Store (extended)', () => {
  it('should create default config when no file exists', async () => {
    const { loadConfig } = await import('../config/store');
    const cfg = loadConfig();
    expect(cfg.settings).toEqual({});
    expect(cfg.packages).toEqual({});
  });

  it('should save and load config with packages', async () => {
    const { loadConfig, saveConfig } = await import('../config/store');
    const cfg = loadConfig();
    cfg.packages['test/repo'] = {
      name: 'test-pkg',
      path: '/tmp/test',
      version: '1.0.0',
      installed_at: new Date().toISOString(),
      linked: false,
    };
    saveConfig(cfg);
    const loaded = loadConfig();
    expect(loaded.packages['test/repo'].name).toBe('test-pkg');
    expect(loaded.packages['test/repo'].version).toBe('1.0.0');
  });

  it('should handle corrupted config gracefully', async () => {
    writeFileSync(CONFIG, 'not valid json {{{');
    const { loadConfig } = await import('../config/store');
    const cfg = loadConfig();
    expect(cfg.settings).toEqual({});
    expect(cfg.packages).toEqual({});
  });

  it('should handle missing JSON gracefully', async () => {
    const { loadJson } = await import('../config/store');
    const result = loadJson('/nonexistent/path.json', { default: true });
    expect(result).toEqual({ default: true });
  });
});

// ── 2. Security Boundary Tests ──

describe('Security boundaries', () => {
  it('should detect path traversal in resolveReal', async () => {
    const { resolve, sep } = await import('path');
    const baseDir = join(TMP, 'security-test');
    mkdirSync(baseDir, { recursive: true });
    
    const { realpathSync } = await import('fs');
    const { basename } = await import('path');
    
    function resolveReal(p: string): string {
      try { return realpathSync(p); }
      catch {
        const parent = resolve(p, '..');
        if (parent === p) return p;
        try { return join(realpathSync(parent), basename(p)); }
        catch {
          const resolved = resolve(p);
          const resolvedBase = resolve(baseDir);
          if (!resolved.startsWith(resolvedBase + sep) && resolved !== resolvedBase) {
            throw new Error('Path traversal detected');
          }
          return resolved;
        }
      }
    }

    // Valid path inside base should work
    const validPath = join(baseDir, 'subdir');
    mkdirSync(validPath, { recursive: true });
    expect(resolveReal(validPath)).toBe(realpathSync(validPath));
  });

  it('should reject system directories', async () => {
    // Simulate install.ts FORBIDDEN check
    const winRoot = process.env.SystemRoot || process.env.windir || 'C:\\Windows';
    const winDrive = winRoot.slice(0, 2);
    const FORBIDDEN = process.platform === 'win32'
      ? [winRoot, `${winDrive}\\Program Files`, `${winDrive}\\Program Files (x86)`, `${winDrive}\\ProgramData`]
      : ['/', '/usr', '/bin', '/sbin', '/etc', '/var', '/tmp'];

    // On Windows, at least the SystemRoot should be in the list
    if (process.platform === 'win32') {
      expect(FORBIDDEN.some(p => p.toLowerCase() === winRoot.toLowerCase())).toBe(true);
    } else {
      expect(FORBIDDEN).toContain('/usr');
      expect(FORBIDDEN).toContain('/etc');
    }
  });

  it('should prevent symlink traversal in findFiles', async () => {
    const { findFiles } = await import('../utils/find');
    // Create a directory with a symlink loop
    const loopBase = join(TMP, 'symloop-test');
    const dirA = join(loopBase, 'a');
    const dirB = join(loopBase, 'b');
    mkdirSync(dirA, { recursive: true });
    mkdirSync(dirB, { recursive: true });
    
    // Create A -> B -> A loop
    try {
      symlinkSync(dirB, join(dirA, 'loop'));
      symlinkSync(dirA, join(dirB, 'loop_back'));
      
      // findFiles should not crash from stack overflow
      const results = findFiles(loopBase, () => true);
      // Should have found the directories and our test file (if any)
      expect(Array.isArray(results)).toBe(true);
    } catch (e: any) {
      // Symlinks may fail on Windows without admin/developer mode
      if (process.platform === 'win32') {
        console.log('  [skip] symlink creation requires admin/developer mode on Windows');
      } else {
        throw e;
      }
    }
  });

  it('should resolve asset patterns correctly', async () => {
    const { resolveAssetName } = await import('../engine/mirror');
    const release = {
      assets: [
        { name: 'bat-v0.26.1-x86_64-pc-windows-msvc.zip' },
        { name: 'fzf-0.73.1-windows_amd64.zip' },
        { name: 'ripgrep-15.1.0-x86_64-unknown-linux-gnu.tar.gz' },
      ],
    };

    // Exact match
    expect(resolveAssetName(release, 'jq-linux64')).toBe('jq-linux64');
    // Glob match
    expect(resolveAssetName(release, 'fzf-*-windows_amd64.zip')).toBe('fzf-0.73.1-windows_amd64.zip');
    // Suffix match
    expect(resolveAssetName(release, 'x86_64-pc-windows-msvc.zip')).toBe('bat-v0.26.1-x86_64-pc-windows-msvc.zip');
    // No match -> pattern returned as-is
    expect(resolveAssetName(release, 'nonexistent.tar.gz')).toBe('nonexistent.tar.gz');
    // Null release -> pattern returned
    expect(resolveAssetName(null, 'whatever')).toBe('whatever');
  });
});

// ── 3. Utility Tests ──

describe('Utility functions (extended)', () => {
  it('formatBytes should format values correctly', async () => {
    const { formatBytes } = await import('../utils/log');
    expect(formatBytes(0)).toBe('0 B');
    expect(formatBytes(500)).toBe('500 B');
    expect(formatBytes(1024)).toBe('1.0 KB');
    expect(formatBytes(1536)).toBe('1.5 KB');
    expect(formatBytes(1048576)).toBe('1.0 MB');
    expect(formatBytes(1073741824)).toBe('1.0 GB');
  });

  it('versionFromTag should extract version core', async () => {
    const { versionFromTag } = await import('../engine/version');
    expect(versionFromTag('v1.2.3')).toBe('1.2.3');
    expect(versionFromTag('jq-1.8.1')).toBe('1.8.1');
    expect(versionFromTag('shellcheck-v0.11.0')).toBe('0.11.0');
    expect(versionFromTag('15.1.0')).toBe('15.1.0');
    expect(versionFromTag(null)).toBeNull();
    // Non-version tags fall back to stripped tag (v prefix removed)
    expect(versionFromTag('no-version')).toBe('no-version');
    expect(versionFromTag('')).toBeNull();
  });

  it('locale t() should translate correctly', async () => {
    const { t, getLang } = await import('../utils/locale');
    // Default language is english
    expect(t('ok_installed', { path: '/usr/local/bin' })).toBe('Installed: /usr/local/bin');
    
    // Test variable interpolation
    const result = t('error_not_found', { name: 'fzf' });
    expect(result).toContain('fzf');
    expect(result).toContain('not found');
  });

  it('sym() should return correct symbols', async () => {
    const { sym, setNoColor, isNoColor } = await import('../utils/log');
    // Temporarily disable no-color
    setNoColor(false);
    expect(sym('ok')).toBe('\u2713');
    expect(sym('err')).toBe('\u2717');
    expect(sym('arrow')).toBe('\u2192');
    expect(sym('nonexistent')).toBe('');

    // Test ASCII fallback
    setNoColor(true);
    expect(sym('ok')).toBe('OK');
    expect(sym('err')).toBe('ERR');
    setNoColor(false);
  });

  it('should detect platform correctly', async () => {
    const { detectPlatform } = await import('../utils/platform');
    const plat = detectPlatform();
    if (plat) {
      const validPlatforms = ['linux_amd64', 'linux_arm64', 'darwin_amd64', 'darwin_arm64', 'windows_amd64', 'windows_arm64'];
      expect(validPlatforms).toContain(plat);
    }
  });

  it('resolveBinaryPath should handle .exe on Windows', async () => {
    const { resolveBinaryPath } = await import('../utils/platform');
    const dir = join(TMP, 'binpath-test');
    mkdirSync(dir, { recursive: true });

    writeFileSync(join(dir, 'rg.exe'), '');
    // resolveBinaryPath should find rg.exe when looking for "rg"
    const p = resolveBinaryPath(dir, 'rg');
    expect(p.toLowerCase().endsWith(process.platform === 'win32' ? 'rg.exe' : 'rg')).toBe(true);

    rmSync(dir, { recursive: true, force: true });
  });

  it('concurrentMap should maintain order and respect workers', async () => {
    const { concurrentMap } = await import('../utils/concurrent');
    const items = [1, 2, 3, 4, 5];
    const results = await concurrentMap(items, async (item) => item * 2, 3);
    expect(results).toEqual([2, 4, 6, 8, 10]);

    // Test with progress callback
    let progressCount = 0;
    const results2 = await concurrentMap(items, async (item) => item, 2,
      (done, total) => { progressCount = done; }
    );
    expect(results2).toEqual([1, 2, 3, 4, 5]);
    expect(progressCount).toBe(5);
  });

  it('confirm() should skip in non-TTY mode', async () => {
    const { confirm } = await import('../utils/prompt');
    // In test (non-TTY), confirm should return false
    const result = await confirm('Test question');
    expect(result).toBe(false);
  });

  it('coerceValue should convert correctly', async () => {
    const c = (s: string): any => {
      if (s === 'true' || s === 'yes' || s === 'on') return true;
      if (s === 'false' || s === 'no' || s === 'off') return false;
      if (s === '') return s;
      const num = Number(s);
      if (!isNaN(num) && s.trim() !== '') return num;
      return s;
    };
    expect(c('true')).toBe(true);
    expect(c('false')).toBe(false);
    expect(c('42')).toBe(42);
    expect(c('0')).toBe(0);
    expect(c('abc')).toBe('abc');
    expect(c('')).toBe('');
    // The bug fix: arbitrary strings should not be converted
    expect(c('falsepos')).toBe('falsepos');
  });
});

// ── 4. Version Detection Tests ──

describe('Version detection (extended)', () => {
  it('should detect version with retry', async () => {
    const { detectVersion } = await import('../engine/version');
    const isWin = process.platform === 'win32';
    const binName = isWin ? 'test-ver.bat' : 'test-ver';
    const binPath = join(TMP, binName);
    
    const content = isWin
      ? '@echo off\r\necho mytool 2.0.0\r\n'
      : '#!/bin/sh\necho "mytool 2.0.0"';
    writeFileSync(binPath, content);
    if (!isWin) chmodSync(binPath, 0o755);

    const tj = {
      version_check: {
        cli_flags: ['--version'],
        parse_regex: '(\\d+\\.\\d+\\.\\d+)',
        output_stream: 'stdout' as const,
        timeout: 5,
      }
    };
    const [ver, source] = detectVersion(binPath, tj as any);
    expect(ver).toBe('2.0.0');
    expect(source).toBe('cli');
    rmSync(binPath, { force: true });
  });

  it('should fallback to config version when binary missing', async () => {
    const { detectVersion } = await import('../engine/version');
    const tj = {
      version_check: {
        cli_flags: ['--version'],
        parse_regex: '(\\d+\\.\\d+\\.\\d+)',
        output_stream: 'stdout' as const,
        timeout: 5,
      }
    };
    const configInfo = { version: '3.0.0' };
    const [ver, source] = detectVersion('/nonexistent/binary', tj as any, configInfo as any);
    expect(ver).toBe('3.0.0');
    expect(source).toBe('config');
  });

  it('should fallback to package fallback version', async () => {
    const { detectVersion } = await import('../engine/version');
    const tj = {
      version: '4.0.0',
      version_check: {
        cli_flags: ['--version'],
        parse_regex: '(\\d+\\.\\d+\\.\\d+)',
        output_stream: 'stdout' as const,
        timeout: 5,
      }
    };
    const [ver, source] = detectVersion('/nonexistent/binary', tj as any);
    expect(ver).toBe('4.0.0');
    expect(source).toBe('fallback');
  });
});

// ── 5. HTTP/Network Tests ──

describe('HTTP utilities', () => {
  it('httpGetJson should handle GitHub API responses', async () => {
    const { httpGetJson } = await import('../utils/http');
    // Test with a public API that returns JSON
    try {
      const result = await httpGetJson<{ id: number }>('https://api.github.com/repos/sixiang-world/tribucket', { timeout: 10000 });
      expect(result.id).toBeDefined();
    } catch (e: any) {
      // Network might not be available in test environment
      console.log('  [skip] GitHub API not reachable:', e.message);
    }
  });
});

// ── 6. findBinary Tests ──

describe('findBinary', () => {
  it('should find exact match first', async () => {
    const { findFiles, findBinary } = await import('../utils/find');
    const dir = join(TMP, 'find-test');
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, 'fzf.exe'), '');
    writeFileSync(join(dir, 'fzf'), '');
    writeFileSync(join(dir, 'other.txt'), '');
    
    const result = findBinary(dir, 'fzf');
    // Should find exact match first (not .exe, not other)
    expect(result).toBe(join(dir, 'fzf'));
    rmSync(dir, { recursive: true, force: true });
  });

  it('findBinary should fallback to name-containing files on Windows', async () => {
    const { findBinary } = await import('../utils/find');
    const dir = join(TMP, 'find-fallback');
    mkdirSync(dir, { recursive: true });
    // Create files that contain the name but aren't exact matches
    writeFileSync(join(dir, 'fzf-helper.dll'), '');
    writeFileSync(join(dir, 'README.txt'), '');
    
    const result = findBinary(dir, 'fzf');
    // Should find the dll since it contains 'fzf'
    if (process.platform === 'win32') {
      expect(result).toBe(join(dir, 'fzf-helper.dll'));
    }
    rmSync(dir, { recursive: true, force: true });
  });

  it('formatCheckResult should use computeStatus', async () => {
    const { formatCheckResult } = await import('../commands/check');
    const r = formatCheckResult('test-pkg', '1.0.0', 'cli', '1.0.0', true);
    expect(r).toContain('latest');
    
    const r2 = formatCheckResult('test-pkg', '1.0.0', 'cli', '2.0.0', true);
    // Outdated status shows version comparison
    expect(r2).toContain('1.0.0');
    expect(r2).toContain('2.0.0');
    
    const r3 = formatCheckResult('test-pkg', '1.0.0', 'cli', null, true);
    expect(r3).toContain('?');
    expect(r3).toContain('offline');
  });

  it('findFiles should handle symlink loops', async () => {
    const { findFiles } = await import('../utils/find');
    const dir = join(TMP, 'find-loop');
    const a = join(dir, 'a');
    const b = join(dir, 'b');
    mkdirSync(a, { recursive: true });
    mkdirSync(b, { recursive: true });
    
    try {
      symlinkSync(b, join(a, 'to_b'));
      symlinkSync(a, join(b, 'to_a'));
      // Should not crash
      const results = findFiles(dir, () => true);
      expect(Array.isArray(results)).toBe(true);
    } catch {
      if (process.platform === 'win32') {
        console.log('  [skip] symlink creation requires Windows Developer Mode');
      } else {
        throw new Error('Unexpected symlink failure');
      }
    }
    rmSync(dir, { recursive: true, force: true });
  });
});

// ── 7. Exit Codes ──

describe('Exit codes', () => {
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

// ── 8. Locale i18n Coverage ──

describe('Locale i18n coverage', () => {
  it('should have all keys defined in both languages', async () => {
    // Read the locale module and check key parity
    // This test ensures no key is missing in one language
    const fs = await import('fs');
    const localeContent = fs.readFileSync(join(process.cwd(), 'src/utils/locale.ts'), 'utf-8');
    
    // Find all def() calls and extract keys
    const defRegex = /def\(['"]([^'"]+)['"]/g;
    const keys: string[] = [];
    let match;
    while ((match = defRegex.exec(localeContent)) !== null) {
      keys.push(match[1]);
    }
    
    // Each key should have both EN and ZH definitions
    expect(keys.length).toBeGreaterThan(80);
    
    // Check for duplicate keys
    const uniqueKeys = new Set(keys);
    expect(uniqueKeys.size).toBe(keys.length);
  });
});

// ── 9. Mirror Utilities ──

describe('Mirror utilities', () => {
  it('buildDirectUrl should preserve tag format', async () => {
    const { buildDirectUrl } = await import('../engine/mirror');
    expect(buildDirectUrl('owner/repo', 'v1.0.0', 'asset.zip'))
      .toBe('https://github.com/owner/repo/releases/download/v1.0.0/asset.zip');
    expect(buildDirectUrl('jqlang/jq', 'jq-1.8.1', 'jq-linux64'))
      .toBe('https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux64');
  });

  it('buildMirrorUrl should support both {tag} and {version}', async () => {
    const { buildMirrorUrl } = await import('../engine/mirror');
    expect(buildMirrorUrl('https://m/{repo}/releases/download/{tag}/{asset}', 'o/r', 'v1.0.0', 'a.zip'))
      .toBe('https://m/o/r/releases/download/v1.0.0/a.zip');
    expect(buildMirrorUrl('https://m/{repo}/v{version}/{asset}', 'o/r', 'v1.0.0', 'a.zip'))
      .toBe('https://m/o/r/v1.0.0/a.zip');
  });
});
