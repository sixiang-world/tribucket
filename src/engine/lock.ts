import { writeFileSync, readFileSync, unlinkSync, existsSync, mkdirSync } from 'fs';
import { join } from 'path';
import { lockDir } from '../config/paths';
import { error, log } from '../utils/log';
import { EXIT_ERROR } from '../types';

export class PackageLock {
  private name: string;
  private lockPath: string;

  constructor(name: string) {
    this.name = name;
    this.lockPath = join(lockDir(), `${name}.lock`);
  }

  acquire(): void {
    mkdirSync(lockDir(), { recursive: true });

    // Atomic create: wx flag is the primary mutual exclusion mechanism.
    // Only if wx fails do we check for stale lock (not the other way around),
    // avoiding the TOCTOU gap between existsSync-check and writeFileSync.
    try {
      writeFileSync(this.lockPath, String(process.pid), { flag: 'wx' });
      return;  // Lock acquired
    } catch (err: any) {
      if (err.code !== 'EEXIST') throw err;
    }

    // File exists — check if the lock holder is still alive
    try {
      const rawPid = readFileSync(this.lockPath, 'utf-8').trim();
      const pid = parseInt(rawPid);
      if (!pid || isNaN(pid)) {
        log(`Corrupted lock file for '${this.name}', removing: ${rawPid}`);
      } else if (this.isProcessAlive(pid)) {
        error('locked', `Another update for '${this.name}' is in progress.`);
        process.exit(EXIT_ERROR);
      }
    } catch (e: any) { log(`Failed to read lock file: ${e.message}`); }
    // Stale or corrupted lock — overwrite
    writeFileSync(this.lockPath, String(process.pid));
  }

  release(): void {
    if (existsSync(this.lockPath)) {
      try { unlinkSync(this.lockPath); } catch {}
    }
  }

  private isProcessAlive(pid: number): boolean {
    // NOTE: process.kill(pid, 0) is unreliable on Windows — it may throw
    // for alive processes or succeed for dead-but-recycled PIDs.
    // This is a known limitation; the `wx` atomic create on acquire()
    // provides the primary mutual exclusion guarantee.
    try {
      process.kill(pid, 0);
      return true;
    } catch {
      return false;
    }
  }
}
