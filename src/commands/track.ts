import { existsSync } from 'fs';
import { loadConfig, saveConfig } from '../config/store';

export function track(name: string, path?: string): boolean {
  const config = loadConfig();
  const targetPath = path || process.cwd();

  if (!existsSync(targetPath)) { console.error(`Error: path does not exist: ${targetPath}`); return false; }
  if (config.packages[name] && existsSync(config.packages[name].path)) {
    console.error(`Error: '${name}' is already tracked at ${config.packages[name].path}`); return false;
  }

  config.packages[name] = { name, path: targetPath, version: 'unknown', installed_at: new Date().toISOString(), linked: false };
  saveConfig(config);
  console.log(`Tracked: ${name} at ${targetPath}`);
  return true;
}

export function untrack(name: string): boolean {
  const config = loadConfig();
  if (!config.packages[name]) { console.error(`Error: '${name}' is not tracked.`); return false; }
  delete config.packages[name];
  saveConfig(config);
  console.log(`Untracked: ${name}`);
  return true;
}
