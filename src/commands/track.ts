import { existsSync, readFileSync } from 'fs';
import { join, resolve } from 'path';
import { loadConfig, saveConfig } from '../config/store';
import { sym } from '../utils/log';
import { t } from '../utils/locale';

function detectRepo(path: string): string | null {
  try {
    const tjPath = join(path, 'tribucket.json');
    if (existsSync(tjPath)) {
      const tj = JSON.parse(readFileSync(tjPath, 'utf-8'));
      if (tj.repo) return tj.repo;
    }
  } catch {}
  return null;
}

export function track(name: string, path?: string): boolean {
  const config = loadConfig();
  const targetPath = resolve(path || process.cwd());

  if (!existsSync(targetPath)) { console.error(`Error: [${name}] ${t('path_does_not_exist', { path: targetPath })}`); return false; }

  // Use owner/repo as key if available, otherwise just name
  const repo = detectRepo(targetPath);
  const repoKey = repo || name;

  if (config.packages[repoKey] && existsSync(config.packages[repoKey].path)) {
    console.error(`Error: ${t('error_already_installed', { name, path: config.packages[repoKey].path })}`);
    console.error(`  ${sym('arrow')} ${t('error_use_update', { name })}`);
    return false;
  }

  config.packages[repoKey] = { name, path: targetPath, version: 'unknown', installed_at: new Date().toISOString(), linked: false };
  saveConfig(config);
  console.log(t('tracked', { name, path: targetPath }));
  return true;
}

export function untrack(name: string): boolean {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name);
  if (!repoKey) { console.error(`Error: ${t('error_not_tracked_generic', { name })}`); return false; }
  delete config.packages[repoKey];
  saveConfig(config);
  console.log(t('untracked', { name }));
  return true;
}

export function updatePackageVersion(name: string, version: string): boolean {
  const config = loadConfig();
  const repoKey = findRepoKey(config, name);
  if (repoKey && config.packages[repoKey]) {
    config.packages[repoKey].version = version;
    saveConfig(config);
    return true;
  }
  return false;
}

export function removeStaleEntries(): string[] {
  const config = loadConfig();
  const removed: string[] = [];
  for (const [key, info] of Object.entries(config.packages)) {
    if (!existsSync(info.path)) {
      delete config.packages[key];
      removed.push(info.name || key);
    }
  }
  if (removed.length > 0) saveConfig(config);
  return removed;
}

export function findRepoKey(config: any, name: string): string | null {
  for (const [key, info] of Object.entries(config.packages)) {
    if ((info as any).name === name) return key;
  }
  if (config.packages[name]) return name;
  return null;
}
