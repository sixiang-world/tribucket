/**
 * src/utils/progress.ts — Download progress bar with speed / ETA
 *
 * Renders a live progress line on TTY:
 *   [====>     ]  45%  2.3/5.1 MB  2.1 MB/s  3s  filename
 *
 * Falls back to discrete lines on non-TTY output so piped/redirected
 * logs still show progress.
 */

import { isNoColor } from './log';

/** Number of discrete progress lines emitted (non-TTY mode). */
let _nonTtyLineCount = 0;

export class ProgressBar {
  private _startTime: number = 0;
  private _lastUpdate: number = 0;
  /** Ring buffer of (bytes, timestamp) for speed calculation. */
  private _samples: Array<{ bytes: number; ts: number }> = [];
  private _total: number = 0;
  private _received: number = 0;
  private _filename: string = '';
  private _width: number = 30; // bar character width
  private _lastPct: number = -1; // last percentage rendered (for throttle)
  private _lineLength: number = 0; // length of last line (TTY clear)

  private _finished: boolean = false;
  private _isTty: boolean;

  constructor() {
    this._isTty = process.stdout.isTTY === true;
  }

  /**
   * Call this when a download starts to initialise the timer.
   */
  start(total: number, filename: string): void {
    this._total = total;
    this._filename = filename;
    this._received = 0;
    this._startTime = Date.now();
    this._lastUpdate = this._startTime;
    this._samples = [{ bytes: 0, ts: this._startTime }];
    this._lastPct = -1;
    this._lineLength = 0;
    this._finished = false;
    this._nonTtyLineCount = 0;
  }

  /**
   * Call repeatedly as data arrives.
   *
   * @param received  Cumulative bytes received so far.
   */
  update(received: number): void {
    if (this._finished) return;
    this._received = received;

    // Throttle: only re-render when percentage changes (TTY) or every ~500ms.
    if (this._isTty) {
      const pct = Math.floor((received * 100) / this._total);
      if (pct === this._lastPct) return;
      this._lastPct = pct;
    } else {
      const now = Date.now();
      if (now - this._lastUpdate < 500) return;
      this._lastUpdate = now;
    }

    this._recordSample(received);
    this._render();
  }

  /**
   * Call when the download is complete to clear the progress line.
   */
  done(): void {
    if (this._finished) return;
    this._finished = true;
    this._received = this._total;
    this._recordSample(this._total);

    if (this._isTty) {
      // Clear the progress line.
      if (this._lineLength > 0) {
        process.stdout.write('\r' + ' '.repeat(this._lineLength) + '\r');
      }
    }
  }

  // ---- private helpers ----

  private _recordSample(bytes: number): void {
    const now = Date.now();
    this._samples.push({ bytes, ts: now });
    // Keep only the last 3 seconds of samples.
    const cutoff = now - 3000;
    while (this._samples.length > 1 && this._samples[1].ts < cutoff) {
      this._samples.shift();
    }
  }

  private _speed(): number {
    if (this._samples.length < 2) return 0;
    const first = this._samples[0];
    const last = this._samples[this._samples.length - 1];
    const elapsedSec = (last.ts - first.ts) / 1000;
    if (elapsedSec <= 0) return 0;
    return (last.bytes - first.bytes) / elapsedSec;
  }

  private _eta(speed: number): number | null {
    if (speed <= 0) return null;
    const remaining = this._total - this._received;
    return remaining / speed;
  }

  private _render(): void {
    const pct = this._total > 0
      ? Math.min(100, Math.floor((this._received * 100) / this._total))
      : 0;
    const mb = this._bytes(this._received);
    const totalMb = this._bytes(this._total);

    // Speed
    const speed = this._speed();
    const speedStr = speed > 0 ? `${(speed / 1024 / 1024).toFixed(1)} MB/s` : '';

    // ETA
    const etaSec = this._eta(speed);
    const etaStr = etaSec !== null && etaSec > 0 ? `${Math.ceil(etaSec)}s` : '';

    // Bar characters
    const filled = this._width > 0 ? Math.floor((pct * this._width) / 100) : 0;
    const empty = this._width - filled;
    const bar = `[${'='.repeat(filled)}${filled < this._width ? '>' : ''}${' '.repeat(Math.max(0, empty - 1))}]`;

    // Compose line
    const parts = [bar, `${String(pct).padStart(3)}%`];
    if (speedStr) parts.push(speedStr);
    parts.push(`${mb}/${totalMb} MB`);
    if (etaStr) parts.push(etaStr);
    if (this._filename) parts.push(this._filename);

    const line = parts.join('  ');

    if (this._isTty) {
      // On TTY: overwrite the previous line in-place.
      // Pad to clear any leftover characters from a longer previous line.
      const padded = line.length < this._lineLength ? line + ' '.repeat(this._lineLength - line.length) : line;
      process.stdout.write(`\r  ${padded}`);
      this._lineLength = padded.length + 2;
    } else {
      // On non-TTY: output a new line each time (throttled to ~500ms).
      this._nonTtyLineCount++;
      process.stdout.write(`  ${line}\n`);
    }
  }

  private _bytes(n: number): string {
    if (n < 1024 * 1024) return (n / 1024).toFixed(1) + ' KB';
    return (n / (1024 * 1024)).toFixed(1);
  }
}
