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

    // Check for stale lock from a dead process
    if (existsSync(this.lockPath)) {
      try {
        const rawPid = readFileSync(this.lockPath, 'utf-8').trim();
        const pid = parseInt(rawPid);
        if (!pid || isNaN(pid)) {
          // Corrupted lock file — log and remove
          log(`Corrupted lock file for '${this.name}', removing: ${rawPid}`);
        } else if (this.isProcessAlive(pid)) {
          error('locked', `Another update for '${this.name}' is in progress.`);
          process.exit(EXIT_ERROR);
        }
      } catch (e: any) { log(`Failed to read lock file: ${e.message}`); }
      // Stale or corrupted lock — remove it
      try { unlinkSync(this.lockPath); } catch {}
    }

    // Atomic create: wx flag fails if file was created between our check and here
    try {
      writeFileSync(this.lockPath, String(process.pid), { flag: 'wx' });
    } catch {
      error('locked', `Another update for '${this.name}' is in progress.`);
      process.exit(EXIT_ERROR);
    }
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
