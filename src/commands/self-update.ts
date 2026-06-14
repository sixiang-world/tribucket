import { existsSync, renameSync, unlinkSync, writeFileSync, chmodSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import { httpGetJson, httpGet } from '../utils/http';
import { findSha256FromRelease, computeSha256 } from '../utils/sha256';
import { log } from '../utils/log';

const REPO = 'sixiang-world/tribucket';
const VERSION = '2.0.0';

export async function selfUpdate(): Promise<void> {
  console.log('Checking for updates...');

  let latest: string;
  let releaseData: any;
  try {
    releaseData = await httpGetJson<any>(
      `https://api.github.com/repos/${REPO}/releases/latest`
    );
    latest = releaseData.tag_name?.replace(/^v/, '');
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
    // Download new binary
    const assets = releaseData.assets || [];
    const binaryAsset = assets.find((a: any) =>
      a.name === 'tribucket' || a.name === 'tribucket-linux-amd64'
    );

    if (!binaryAsset) {
      console.error('Error: Binary asset not found in release');
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

    console.log(`Updated: ${VERSION} → ${latest}`);
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
