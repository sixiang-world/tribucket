import { describe, it, expect, beforeEach, afterEach } from 'bun:test';
import { mkdtempSync, rmSync, existsSync, readFileSync, writeFileSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';

describe('Config Store', () => {
  let tmpDir: string;
  let origHome: string | undefined;

  beforeEach(() => {
    tmpDir = mkdtempSync(join(tmpdir(), 'tribucket-test-'));
    origHome = process.env.TRIBUCKET_HOME;
    process.env.TRIBUCKET_HOME = tmpDir;
  });

  afterEach(() => {
    if (origHome !== undefined) {
      process.env.TRIBUCKET_HOME = origHome;
    } else {
      delete process.env.TRIBUCKET_HOME;
    }
    rmSync(tmpDir, { recursive: true, force: true });
  });

  it('should return default config when no file exists', async () => {
    const { loadConfig } = await import('../config/store');
    const config = loadConfig();
    expect(config).toEqual({ settings: {}, packages: {} });
  });

  it('should save and load config', async () => {
    const { loadConfig, saveConfig } = await import('../config/store');
    const cfg = { settings: { key: 'value' }, packages: { a: { name: 'a', path: '/tmp/a', version: '1.0.0', installed_at: '2024-01-01', linked: false } } };
    saveConfig(cfg);
    const loaded = loadConfig();
    expect(loaded.settings.key).toBe('value');
    expect(loaded.packages.a.name).toBe('a');
  });

  it('should handle corrupt config gracefully', async () => {
    const { loadConfig } = await import('../config/store');
    const configPath = join(tmpDir, 'config.json');
    writeFileSync(configPath, 'not json{{{');
    const config = loadConfig();
    expect(config).toEqual({ settings: {}, packages: {} });
  });

  it('should load missing JSON with default', async () => {
    const { loadJson } = await import('../config/store');
    const result = loadJson(join(tmpDir, 'missing.json'), { x: 1 });
    expect(result).toEqual({ x: 1 });
  });

  it('should save and load generic JSON', async () => {
    const { loadJson, saveJson } = await import('../config/store');
    const path = join(tmpDir, 'test.json');
    saveJson(path, { b: 2 });
    const result = loadJson(path);
    expect(result).toEqual({ b: 2 });
  });
});

describe('Config Paths', () => {
  it('should return tribucket home from env', async () => {
    const origHome = process.env.TRIBUCKET_HOME;
    process.env.TRIBUCKET_HOME = '/tmp/test-tribucket';
    const { tribucketHome } = await import('../config/paths');
    expect(tribucketHome()).toBe('/tmp/test-tribucket');
    if (origHome !== undefined) {
      process.env.TRIBUCKET_HOME = origHome;
    } else {
      delete process.env.TRIBUCKET_HOME;
    }
  });
});
