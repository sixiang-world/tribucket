import { readFileSync, writeFileSync, mkdirSync, existsSync, renameSync } from 'fs';
import { dirname } from 'path';
import type { Config } from '../types';
import { configPath } from './paths';

export function loadConfig(): Config {
  const path = configPath();
  if (!existsSync(path)) {
    return { settings: {}, packages: {} };
  }
  try {
    const data = JSON.parse(readFileSync(path, 'utf-8'));
    data.settings = data.settings || {};
    data.packages = data.packages || {};
    return data;
  } catch (e) {
    console.error(`Warning: config.json corrupted (${e}), using defaults`);
    return { settings: {}, packages: {} };
  }
}

export function saveConfig(config: Config): void {
  const path = configPath();
  mkdirSync(dirname(path), { recursive: true });
  const tmp = path + '.tmp';
  writeFileSync(tmp, JSON.stringify(config, null, 2) + '\n');
  renameSync(tmp, path);
}

export function loadJson<T = any>(path: string, defaultValue: T): T {
  if (!existsSync(path)) return defaultValue;
  try {
    return JSON.parse(readFileSync(path, 'utf-8'));
  } catch {
    return defaultValue;
  }
}

export function saveJson(path: string, data: any): void {
  mkdirSync(dirname(path) || '.', { recursive: true });
  const tmp = path + '.tmp';
  writeFileSync(tmp, JSON.stringify(data, null, 2) + '\n');
  renameSync(tmp, path);
}
