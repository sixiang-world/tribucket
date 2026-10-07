import { sym } from '../utils/log';
import { existsSync, readdirSync, lstatSync, readFileSync, readlinkSync } from 'fs';
import { join } from 'path';
import { loadConfig } from '../config/store';
import { binDir } from '../config/paths';
import { detectVersion, versionFromTag } from '../engine/version';
import { httpGetJson } from '../utils/http';
import { resolveBinaryPath } from '../utils/platform';
import { t } from '../utils/locale';
import type { PackageMeta } from '../types';

export async function listPackages(options: { json?: boolean; sort?: string; check?: boolean }): Promise<void> {
  const config = loadConfig();
  const packages = Object.entries(config.packages || {});

  if (packages.length === 0) { console.log(t('no_packages_tracked')); return; }

  // If --check, run version detection for all packages
  if (options.check) {
    const checkOne = async ([, info]: [string, any]): Promise<{name: string; info: any; localVer: string; remoteVer: string | null}> => {
      const path = info.path;
      const exists = existsSync(path);
      let localVer = info.version || '?';
      let remoteVer: string | null = null;

      if (exists) {
        const tjPath = join(path, 'tribucket.json');
        let tj: PackageMeta | null = null;
        if (existsSync(tjPath)) {
          try { tj = JSON.parse(readFileSync(tjPath, 'utf-8')); } catch {}
        }

        const binary = tj?.binary || info.name;
        const binaryPath = resolveBinaryPath(path, binary);
        if (existsSync(binaryPath) || tj) {
          const [ver] = detectVersion(binaryPath, tj || { version_check: { cli_flags: ['--version'], parse_regex: 'v?(\\d+\\.\\d+(?:\\.\\d+)?)', output_stream: 'stdout', timeout: 5 } }, info);
          localVer = ver;
        }

        const repo = tj?.repo || info.repo;
        if (repo) {
          try {
            const token = process.env.GITHUB_TOKEN;
            const data = await httpGetJson<any>(`https://api.github.com/repos/${repo}/releases/latest`, { token });
            remoteVer = versionFromTag(data.tag_name);
          } catch {}
        }
      }

      return { name: info.name, info, localVer, remoteVer };
    };
    const { concurrentMap } = await import('../utils/concurrent');
    const results = await concurrentMap(packages, (pkg) => checkOne(pkg));

    if (options.json) {
      const output: Record<string, any> = {};
      for (const r of results) {
        output[r.name] = {
          version: r.localVer,
          remote: r.remoteVer,
          status: r.remoteVer ? (r.localVer === r.remoteVer ? 'latest' : 'outdated') : 'unknown',
          path: r.info.path,
        };
      }
      console.log(JSON.stringify(output, null, 2));
      return;
    }

    console.log(`${t('name').padEnd(20)}  ${t('version').padEnd(12)}  ${t('remote').padEnd(12)}  ${t('status_latest').padEnd(10)}  ${t('path')}`);
    console.log('-'.repeat(100));

    for (const r of results) {
      const exists = existsSync(r.info.path);
      let status = '';
      if (!exists) status = `${sym('err')} ${t('not_found')}`;
      else if (!r.remoteVer) status = '? ' + t('offline');
      else if (r.localVer === r.remoteVer) status = `${sym('ok')} ${t('latest')}`;
      else status = `${sym('warn')} ${t('outdated')}`;

      console.log(`${r.name.padEnd(20)}  ${r.localVer.padEnd(12)}  ${(r.remoteVer || '?').padEnd(12)}  ${status.padEnd(10)}  ${r.info.path}`);
    }
    return;
  }

  if (options.json) {
    const result: Record<string, any> = {};
    for (const [_, info] of packages) result[info.name] = info;
    console.log(JSON.stringify({ packages: result }, null, 2));
    return;
  }

  if (options.sort === 'status') {
    packages.sort((a, b) => {
      const aE = existsSync(a[1].path), bE = existsSync(b[1].path);
      return (aE === bE ? 0 : aE ? 1 : -1) || a[0].localeCompare(b[0]);
    });
  } else {
    packages.sort((a, b) => a[0].localeCompare(b[0]));
  }

  console.log(`${t('name').padEnd(20)}  ${t('version').padEnd(12)}  ${t('path').padEnd(40)}  ${t('status_latest')}`);
  console.log('-'.repeat(90));

  for (const [_, info] of packages) {
    const exists = existsSync(info.path);
    console.log(`${info.name.padEnd(20)}  ${(info.version || '?').padEnd(12)}  ${info.path.padEnd(40)}  ${exists ? sym('ok') + ' ' + t('latest') : sym('err') + ' ' + t('not_found')}`);
  }

  const bd = binDir();
  if (existsSync(bd)) {
    const dangling: string[] = [];
    for (const f of readdirSync(bd)) {
      const linkPath = join(bd, f);
      try {
        if (lstatSync(linkPath).isSymbolicLink()) {
          const target = readlinkSync(linkPath);
          if (!existsSync(target)) dangling.push(`${linkPath} ${sym('arrow')} ${target}`);
        }
      } catch {}
    }
    if (dangling.length > 0) {
      console.log(`\n${sym('warn')} ${t('dangling_symlinks', { count: dangling.length })}:`);
      for (const p of dangling) console.log(`  ${p}`);
    }
  }

  const stale = packages.filter(([_, info]) => !existsSync(info.path)).map(([_, info]) => info.name);
  if (stale.length > 0) {
    console.log(`\n${sym('warn')} ${t('stale_entries', { count: stale.length, names: stale.join(', ') })}`);
    console.log(`  ${sym('arrow')} ${t('run_clean')}`);
  }
}
