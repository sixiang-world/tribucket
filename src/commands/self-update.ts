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

export async function selfUpdate(): Promise<void> {
  console.log(t('checking_for_updates'));

  let latest: string;
  let releaseData: any;
  try {
    releaseData = await httpGetJson<any>(
      `https://api.github.com/repos/${REPO}/releases/latest`
    );
    latest = versionFromTag(releaseData.tag_name) || undefined;
  } catch (e: any) {
    console.error(`${sym('err')} ${t('error_cannot_check_updates', { message: e.message })}`);
    process.exit(7);
  }

  if (latest === VERSION) {
    console.log(t('already_up_to_date', { version: VERSION }));
    process.exit(0);
  }

  console.log(t('current_latest', { current: VERSION, latest }));

  const scriptPath = process.argv[1];
  if (!scriptPath) {
    console.error(`${sym('err')} ${t('error_cannot_determine_path')}`);
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

    const assets = releaseData.assets || [];
    const binaryAsset = assets.find((a: any) =>
      // Try platform-specific name first, then fallback to generic
      a.name === expectedName || a.name === `tribucket${ext}`
    );

    if (!binaryAsset) {
      console.error(`${sym('err')} ${t('error_binary_asset_not_found', { filename: expectedName })}`);
      process.exit(1);
    }

    console.log(t('downloading', { filename: binaryAsset.name }));
    const newBinary = await httpGet(binaryAsset.browser_download_url, { timeout: 60000 });

    // SHA256 verification
    const expectedHash = await findSha256FromRelease(releaseData, binaryAsset.name);
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
      log('No checksum file in release — skipping verification');
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
