export interface PackageMeta {
  name: string;
  repo: string;
  description: string;
  binary: string;
  license: string;
  homepage: string;
  asset_pattern: Record<string, string>;
  asset_format?: Record<string, string>;
  install_type?: 'binary' | 'directory';
  download_url?: Record<string, string>;
  version?: string;
  version_check?: {
    cli_flags?: string[];
    parse_regex?: string;
    output_stream?: 'stdout' | 'stderr' | 'both';
    timeout?: number;
    fallback_version?: string;
    include_prerelease?: boolean;
  };
  mirror?: { enabled: boolean };
}

export interface TrackedPackage {
  name: string;
  path: string;
  version: string;
  installed_at: string;
  linked: boolean;
}

export interface Config {
  settings: Record<string, any>;
  packages: Record<string, TrackedPackage>;
}

export interface CheckResult {
  name: string;
  path?: string;
  path_exists?: boolean;
  local?: string;
  local_source?: 'cli' | 'config' | 'fallback' | 'none';
  remote?: string | null;
  status?: 'latest' | 'outdated' | 'unknown' | 'error';
  error?: string;
}

export type Platform = 'linux_amd64' | 'linux_arm64' | 'darwin_amd64' | 'darwin_arm64' | 'windows_amd64' | 'windows_arm64';

export type MirrorMode = 'auto' | 'cn' | 'direct';

export const EXIT_OK = 0;
export const EXIT_ERROR = 1;
export const EXIT_USAGE = 2;
export const EXIT_NOT_FOUND = 3;
export const EXIT_EXISTS = 4;
export const EXIT_NOT_TRACKED = 5;
export const EXIT_UP_TO_DATE = 6;
export const EXIT_NO_NETWORK = 7;
