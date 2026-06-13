import { existsSync, readFileSync } from 'fs';
import { join } from 'path';
import { loadConfig, saveConfig } from '../config/store';

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
  const targetPath = path || process.cwd();

  if (!existsSync(targetPath)) { console.error(`Error: path does not exist: ${targetPath}`); return false; }

  // Use owner/repo as key if available, otherwise just name
  const repo = detectRepo(targetPath);
  const repoKey = repo || name;

  if (config.packages[repoKey] && existsSync(config.packages[repoKey].path)) {
    console.error(`Error: '${name}' is already tracked at ${config.packages[repoKey].path}`); return false;
  }

  config.packages[repoKey] = { name, path: targetPath, version: 'unknown', installed_at: new Date().toISOString(), linked: false };
  saveConfig(config);
  console.log(`Tracked: ${name} at ${targetPath}`);
  return true;
}

export function untrack(name: string): boolean {
  const config = loadConfig();
  // Find by name in packages
  let repoKey: string | null = null;
  for (const [key, info] of Object.entries(config.packages)) {
    if ((info as any).name === name) { repoKey = key; break; }
  }
  if (!repoKey && config.packages[name]) repoKey = name;
  if (!repoKey) { console.error(`Error: '${name}' is not tracked.`); return false; }
  delete config.packages[repoKey];
  saveConfig(config);
  console.log(`Untracked: ${name}`);
  return true;
}
