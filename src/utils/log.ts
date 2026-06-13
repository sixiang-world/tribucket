export const VERBOSE = process.env.TRIBUCKET_VERBOSE === '1';

export function log(msg: string): void {
  if (VERBOSE) {
    const ts = new Date().toTimeString().slice(0, 8);
    process.stderr.write(`[${ts}] ${msg}\n`);
  }
}

export function error(category: string, message: string, suggestion?: string): void {
  process.stderr.write(`Error: [${category}] ${message}\n`);
  if (suggestion) {
    process.stderr.write(`  → ${suggestion}\n`);
  }
}
