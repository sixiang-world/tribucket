import { mkdirSync, writeFileSync, readFileSync, unlinkSync, existsSync } from 'fs';
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

    if (existsSync(this.lockPath)) {
      try {
        const pid = parseInt(readFileSync(this.lockPath, 'utf-8').trim());
        if (pid && this.isProcessAlive(pid)) {
          error('locked', `Another update for '${this.name}' is in progress.`);
          process.exit(EXIT_ERROR);
        }
      } catch {}
    }

    writeFileSync(this.lockPath, String(process.pid));
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
