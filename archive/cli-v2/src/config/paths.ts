import { homedir } from 'os';
import { join } from 'path';

export function tribucketHome(): string {
  const env = process.env.TRIBUCKET_HOME;
  if (env && env.trim() !== '') {
    return env.trim();
  }
  return join(homedir(), '.tribucket');
}

export function configPath(): string {
  return join(tribucketHome(), 'config.json');
}

export function cacheDir(): string {
  return join(tribucketHome(), 'cache');
}

export function backupDir(): string {
  return join(tribucketHome(), 'backup');
}

export function lockDir(): string {
  return join(tribucketHome(), 'locks');
}

export function binDir(): string {
  return join(tribucketHome(), 'bin');
}

export function versionsCachePath(): string {
  return join(cacheDir(), 'versions.json');
}

export function mirrorCachePath(): string {
  return join(cacheDir(), 'mirror_status.json');
}

export function mirrorConfigPath(): string {
  return join(tribucketHome(), 'mirror.json');
}
