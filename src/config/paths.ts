import { homedir } from 'os';
import { join } from 'path';

export function tributableHome(): string {
  return process.env.TRIBUTABLE_HOME || join(homedir(), '.tributable');
}

export function configPath(): string {
  return join(tributableHome(), 'config.json');
}

export function cacheDir(): string {
  return join(tributableHome(), 'cache');
}

export function backupDir(): string {
  return join(tributableHome(), 'backup');
}

export function lockDir(): string {
  return join(tributableHome(), 'locks');
}

export function binDir(): string {
  return join(tributableHome(), 'bin');
}

export function versionsCachePath(): string {
  return join(cacheDir(), 'versions.json');
}

export function mirrorCachePath(): string {
  return join(cacheDir(), 'mirror_status.json');
}

export function mirrorConfigPath(): string {
  return join(tributableHome(), 'mirror.json');
}
