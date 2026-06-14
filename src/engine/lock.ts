import { writeFileSync, readFileSync, unlinkSync, existsSync, mkdirSync } from 'fs';
import { join } from 'path';
import { lockDir } from '../config/paths';
import { error } from '../utils/log';
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
        const pid = parseInt(readFileSync(this.lockPath, 'utf-8').trim());
        if (pid && this.isProcessAlive(pid)) {
          error('locked', `Another update for '${this.name}' is in progress.`);
          process.exit(EXIT_ERROR);
        }
      } catch {}
      // Stale lock — remove it
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
    try {
      process.kill(pid, 0);
      return true;
    } catch {
      return false;
    }
  }
}
