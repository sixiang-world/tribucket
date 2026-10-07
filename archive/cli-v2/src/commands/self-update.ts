import { existsSync, renameSync, unlinkSync, writeFileSync, chmodSync } from 'fs';
import { VERSION } from '../version';
import { join } from 'path';
import { tmpdir } from 'os';
import { httpGetJson, httpGet } from '../utils/http';
import { findSha256FromRelease, computeSha256 } from '../utils/sha256';
import { versionFromTag } from '../engine/version';
import { log, sym } from '../utils/log';
import { t } from '../utils/locale';

const REPO = 'sixiang-world/tribucket';

/** Escape regex special characters in a string. */
function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

export async function selfUpdate(): Promise<void> {
  console.log(t('checking_for_updates'));

  let latest: string | null = null;
  let releaseData: any;
  try {
    releaseData = await httpGetJson<any>(
      `https://api.github.com/repos/${REPO}/releases/latest`
    );
    latest = versionFromTag(releaseData.tag_name);
  } catch (e: any) {
    console.error(`${sym('err')} ${t('error_cannot_check_updates', { message: e.message })}`);
    process.exit(7);
  }

  if (!latest) {
    console.error(`${sym('err')} Could not determine latest version`);
    process.exit(1);
  }

  if (latest === VERSION) {
    console.log(t('already_up_to_date', { version: VERSION }));
    process.exit(0);
  }

  console.log(t('current_latest', { current: VERSION, latest }));

  const rawPath = process.argv[1];
  let scriptPath = rawPath;
  // Resolve symlinks to get the actual binary path
  try { const { realpathSync } = await import('fs'); scriptPath = realpathSync(rawPath); } catch {}
  if (!scriptPath) {
    console.error(`${sym('err')} ${t('error_cannot_determine_path')}`);
    process.exit(1);
  }
  // Detect dev mode: when running via `bun run src/index.ts`, process.argv[1]
  // points to the bun binary, not the compiled tribucket binary. Self-update
  // would overwrite bun, which is catastrophic.
  const isDev = scriptPath.endsWith('bun') || scriptPath.endsWith('bun.exe') ||
                scriptPath.includes('node_modules') || scriptPath.endsWith('.ts');
  if (isDev) {
    console.error(`${sym('err')} ${t('error_self_update_dev')}`);
    console.error(`  ${sym('arrow')} ${t('error_self_update_dev_hint')}`);
    process.exit(1);
  }

  try {
    // Download new binary — detect platform for correct asset name
    const { detectPlatform } = await import('../utils/platform');
    const plat = detectPlatform();
    if (!plat) { console.error(`${sym('err')} ${t('error_unsupported_platform')}`); process.exit(1); }
    const [os, arch] = plat.split('_');
    const ext = os === 'windows' ? '.exe' : '';
    const isDebug = typeof DEBUG_BUILD !== 'undefined' && DEBUG_BUILD;
    const debugSuffix = isDebug ? '-debug' : '';
    const expectedName = `tribucket-${os}-${arch}${debugSuffix}${ext}`;
    const tag = releaseData.tag_name;

    // --- Strategy: CNB first, then GitHub fallback ---
    let newBinary: Buffer;
    let binaryName = expectedName;
    let useCnb = false;

    // 1. Try CNB release first (China-friendly CDN, no token needed)
    const cnbUrl = `https://cnb.cool/shisheng820/tribucket/-/releases/download/${tag}/${expectedName}`;
    try {
      newBinary = await httpGet(cnbUrl, { timeout: 60000 });
      useCnb = true;
      log(`Downloaded from CNB: ${cnbUrl}`);
    } catch {
      // 2. Fall back to GitHub release
      const assets = releaseData.assets || [];
      const binaryAsset = assets.find((a: any) =>
        a.name === expectedName || a.name === `tribucket${ext}`
      );
      if (!binaryAsset) {
        console.error(`${sym('err')} ${t('error_binary_asset_not_found', { filename: expectedName })}`);
        process.exit(1);
      }
      binaryName = binaryAsset.name;
      console.log(t('downloading', { filename: binaryAsset.name }));
      newBinary = await httpGet(binaryAsset.browser_download_url, { timeout: 60000 });
    }

    // SHA256 verification — source-appropriate checksum
    if (useCnb) {
      // CNB: fetch sha256sums.txt and match our file
      try {
        const cksumUrl = `https://cnb.cool/shisheng820/tribucket/-/releases/download/${tag}/sha256sums.txt`;
        const cksumBody = await httpGet(cksumUrl, { timeout: 15000 });
        const cksumText = new TextDecoder().decode(cksumBody);
        const re = new RegExp('^([a-f0-9]{64})\\s+' + escapeRegex(binaryName) + '$', 'm');
        const match = cksumText.match(re);
        if (match) {
          const tmpPath = join(tmpdir(), `tribucket-update-${Date.now()}`);
          writeFileSync(tmpPath, newBinary);
          const actualHash = await computeSha256(tmpPath);
          unlinkSync(tmpPath);
          if (actualHash !== match[1]) {
            console.error(`${sym('err')} ${t('error_sha256_corrupted')}`);
            process.exit(1);
          }
          log('SHA256 verified via CNB checksum');
        } else {
          log('No matching checksum in CNB sha256sums.txt, skipping verification');
        }
      } catch {
        log('Could not fetch CNB checksums, skipping verification');
      }
    } else {
      // GitHub: existing SHA256 verification from release assets
      const expectedHash = await findSha256FromRelease(releaseData, binaryName);
      if (expectedHash) {
        const tmpPath = join(tmpdir(), `tribucket-update-${Date.now()}`);
        writeFileSync(tmpPath, newBinary);
        const actualHash = await computeSha256(tmpPath);
        unlinkSync(tmpPath);
        if (actualHash !== expectedHash) {
          console.error(`${sym('err')} ${t('error_sha256_corrupted')}`);
          process.exit(1);
        }
        log('SHA256 verification OK');
      } else {
        log('No checksum file in release, skipping verification');
      }
    }

    // Backup current binary
    const backupPath = scriptPath + '.bak';
    renameSync(scriptPath, backupPath);

    // Write new binary
    writeFileSync(scriptPath, newBinary);

    // Make executable (Bun compile output should already be, but be safe)
    try { chmodSync(scriptPath, 0o755); } catch {}

    console.log(t('updated', { from: VERSION, arrow: sym('arrow'), to: latest }));
    console.log(t('restart_to_use'));

    // Schedule backup cleanup
    process.on('exit', () => {
      try { unlinkSync(backupPath); } catch {}
    });

  } catch (e: any) {
    console.error(`${sym('err')} ${t('error_update_failed', { message: e.message })}`);
    // Try to restore backup
    const backupPath = scriptPath + '.bak';
    if (existsSync(backupPath)) {
      try {
        renameSync(backupPath, scriptPath);
        console.log(t('restored_from_backup'));
      } catch {}
    }
    process.exit(1);
  }
}
