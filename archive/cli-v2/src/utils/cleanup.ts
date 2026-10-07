import { readdirSync, statSync, rmSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';

export function cleanupOldTmp(): void {
  const now = Date.now();
  try {
    for (const name of readdirSync(tmpdir())) {
      if (name.startsWith('tribucket-')) {
        const path = join(tmpdir(), name);
        try {
          if (statSync(path).isDirectory()) {
            const age = now - statSync(path).mtimeMs;
            if (age > 86400000) {
              rmSync(path, { recursive: true, force: true });
            }
          }
        } catch {}
      }
    }
  } catch {}
}
