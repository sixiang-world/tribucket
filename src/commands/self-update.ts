import { existsSync, renameSync, unlinkSync, writeFileSync, chmodSync } from 'fs';
import { VERSION } from '../version';
import { join } from 'path';
import { tmpdir } from 'os';
import { httpGetJson, httpGet } from '../utils/http';
import { findSha256FromRelease, computeSha256 } from '../utils/sha256';
import { versionFromTag } from '../engine/version';
import { log, sym } from '../utils/log';

const REPO = 'sixiang-world/tribucket';

export async function selfUpdate(): Promise<void> {
  console.log('Checking for updates...');

  let latest: string;
  let releaseData: any;
  try {
    releaseData = await httpGetJson<any>(
      `https://api.github.com/repos/${REPO}/releases/latest`
    );
    latest = versionFromTag(releaseData.tag_name) || undefined;
  } catch (e: any) {
    console.error(`Error: Cannot check for updates: ${e.message}`);
    process.exit(7);
  }

  if (latest === VERSION) {
    console.log(`Already up to date (${VERSION})`);
    process.exit(0);
  }

  console.log(`Current: ${VERSION}  Latest: ${latest}`);

  const scriptPath = process.argv[1];
  if (!scriptPath) {
    console.error('Error: Cannot determine script path');
    process.exit(1);
  }

  try {
    // Download new binary — detect platform for correct asset name
    const { detectPlatform } = await import('../utils/platform');
    const plat = detectPlatform();
    if (!plat) { console.error('Error: Unsupported platform'); process.exit(1); }
    const [os, arch] = plat.split('_');
    const ext = os === 'windows' ? '.exe' : '';
    const expectedName = `tribucket-${os}-${arch}${ext}`;

    const assets = releaseData.assets || [];
    const binaryAsset = assets.find((a: any) =>
      // Try platform-specific name first, then fallback to generic
      a.name === expectedName || a.name === `tribucket${ext}`
    );

    if (!binaryAsset) {
      console.error(`Error: Binary asset not found in release (expected ${expectedName})`);
      process.exit(1);
    }

    console.log(`Downloading ${binaryAsset.name}...`);
    const newBinary = await httpGet(binaryAsset.browser_download_url, { timeout: 60000 });

    // SHA256 verification
    const expectedHash = await findSha256FromRelease(releaseData, binaryAsset.name);
    if (expectedHash) {
      const tmpPath = join(tmpdir(), `tribucket-update-${Date.now()}`);
      writeFileSync(tmpPath, newBinary);
      const actualHash = await computeSha256(tmpPath);
      unlinkSync(tmpPath);
      if (actualHash !== expectedHash) {
        console.error('Error: SHA256 mismatch — download may be corrupted');
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

    console.log(`Updated: ${VERSION} ${sym('arrow')} ${latest}`);
    console.log('Restart tribucket to use the new version.');

    // Schedule backup cleanup
    process.on('exit', () => {
      try { unlinkSync(backupPath); } catch {}
    });

  } catch (e: any) {
    console.error(`Error: Update failed: ${e.message}`);
    // Try to restore backup
    const backupPath = scriptPath + '.bak';
    if (existsSync(backupPath)) {
      try {
        renameSync(backupPath, scriptPath);
        console.log('Restored original binary from backup.');
      } catch {}
    }
    process.exit(1);
  }
}
