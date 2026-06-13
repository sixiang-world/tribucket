import { existsSync, accessSync, constants } from 'fs';
import { execSync } from 'child_process';
import type { PackageMeta, TrackedPackage } from '../types';
import { log } from '../utils/log';

export function detectVersion(
  binaryPath: string,
  tributableJson: PackageMeta,
  configInfo?: TrackedPackage
): [string, string] {
  const vc = tributableJson.version_check || {};
  const cliFlags = vc.cli_flags || ['--version'];
  const parseRegex = vc.parse_regex || 'v?(\\d+\\.\\d+(?:\\.\\d+)?)';
  const timeout = vc.timeout || 5;

  // 1. Try CLI
  if (existsSync(binaryPath)) {
    try {
      accessSync(binaryPath, constants.X_OK);
      for (const flag of cliFlags) {
        const ver = runVersionCommand(binaryPath, flag, parseRegex, vc.output_stream || 'stdout', timeout);
        if (ver) return [ver, 'cli'];
      }
    } catch {}
  }

  // 2. Try config.json version
  if (configInfo?.version && configInfo.version !== 'unknown') {
    return [configInfo.version, 'config'];
  }

  // 3. Fallback
  const fallback = tributableJson.version || vc.fallback_version || 'unknown';
  return [fallback, 'fallback'];
}

function runVersionCommand(
  binaryPath: string,
  flag: string,
  parseRegex: string,
  outputStream: string,
  timeout: number
): string | null {
  try {
    const result = execSync(`"${binaryPath}" ${flag}`, {
      timeout: timeout * 1000,
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    const text = outputStream === 'stderr' ? '' : result;
    const match = text.match(new RegExp(parseRegex));
    if (match) return match[1] || match[0];
  } catch {}
  return null;
}
