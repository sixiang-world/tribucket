export const VERBOSE = typeof DEBUG_BUILD !== 'undefined'
  ? DEBUG_BUILD
  : process.env.TRIBUCKET_VERBOSE === '1';

export function log(msg: string): void {
  if (VERBOSE) {
    const ts = new Date().toTimeString().slice(0, 8);
    process.stderr.write(`[${ts}] ${msg}\n`);
  }
}

/** Always-visible status message (to stderr, not gated by VERBOSE). */
export function status(msg: string): void {
  process.stderr.write(`${sym('arrow')} ${msg}\n`);
}

export function error(category: string, message: string, suggestion?: string): void {
  process.stderr.write(`Error: [${category}] ${message}\n`);
  if (suggestion) {
    process.stderr.write(`  ${sym('arrow')} ${suggestion}\n`);
  }
}

// NO_COLOR state – true when colors/symbols should be disabled
let _noColor: boolean | null = null;

export function setNoColor(v: boolean): void {
  _noColor = v;
}

export function isNoColor(): boolean {
  if (_noColor !== null) return _noColor;
  // Auto-detect: non-TTY or NO_COLOR env var
  _noColor = !process.stdout.isTTY;
  if (process.env.NO_COLOR !== undefined && process.env.NO_COLOR !== '') {
    _noColor = true;
  }
  return _noColor;
}

// Symbol map with ASCII fallback when NO_COLOR is active
const SYMBOLS: Record<string, [string, string]> = {
  ok:    ['\u2713', 'OK'],
  warn:  ['\u26A0', 'WARN'],
  err:   ['\u2717', 'ERR'],
  skip:  ['?', '?'],
  arrow: ['\u2192', '->'],
  bullet: ['\u2022', '*'],
};

export function sym(name: string): string {
  const pair = SYMBOLS[name];
  if (!pair) return '';
  return _noColor ? pair[1] : pair[0];
}

/**
 * Format a byte count into a human-readable string (KB / MB / GB).
 * Used by download progress display.
 */
export function formatBytes(bytes: number): string {
  if (bytes < 1024) return bytes + ' B';
  const kb = bytes / 1024;
  if (kb < 1024) return kb.toFixed(1) + ' KB';
  const mb = kb / 1024;
  if (mb < 1024) return mb.toFixed(1) + ' MB';
  return (mb / 1024).toFixed(1) + ' GB';
}
