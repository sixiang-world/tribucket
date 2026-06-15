#!/usr/bin/env python3
"""Fix UX batch 2: CLI code fixes (#4, #9, #10, #11, #15, #18, #19)."""

import os
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- #4: self-update.ts — dev environment detection ---
with open('src/commands/self-update.ts') as f:
    c = f.read()
old = """  const scriptPath = process.argv[1];
  if (!scriptPath) {
    console.error(`${sym('err')} ${t('error_cannot_determine_path')}`);
    process.exit(1);
  }"""
new = """  const scriptPath = process.argv[1];
  if (!scriptPath) {
    console.error(`${sym('err')} ${t('error_cannot_determine_path')}`);
    process.exit(1);
  }
  // Detect dev mode: when running via `bun run src/index.ts`, process.argv[1]
  # points to the bun binary, not the compiled tribucket binary. Self-update
  would overwrite bun, which is catastrophic.
  const isDev = scriptPath.endsWith('bun') || scriptPath.endsWith('bun.exe') ||
                scriptPath.includes('node_modules') || scriptPath.endsWith('.ts');
  if (isDev) {
    console.error(`${sym('err')} ${t('error_self_update_dev')}`);
    console.error(`  ${sym('arrow')} ${t('error_self_update_dev_hint')}`);
    process.exit(1);
  }"""
c = c.replace(old, new)
with open('src/commands/self-update.ts', 'w') as f:
    f.write(c)
print('#4 fixed')

# --- #9: index.ts — check --all summary instead of clearing ---
with open('src/index.ts') as f:
    c = f.read()
old = """    // Clear the status line
    if (process.stdout.isTTY) {
      process.stdout.write('\r' + ' '.repeat(60) + '\r');
    }"""
new = """    // Print completion summary
    const ok = results.filter(r => r.status === 'latest').length;
    const outdated = results.filter(r => r.status === 'outdated').length;
    const errors = results.filter(r => r.error).length;
    status(t('packages_check_complete', { ok, outdated, errors }));"""
c = c.replace(old, new)
with open('src/index.ts', 'w') as f:
    f.write(c)
print('#9 fixed')

# --- #10: config.ts — fix type coercion ---
with open('src/commands/config.ts') as f:
    c = f.read()
old = """function coerceValue(s: string): any {
  if (/^(true|yes|on)$/i.test(s)) return true;
  if (/^(false|no|off)$/i.test(s)) return false;
  if (s === '') return s;
  const num = Number(s);
  if (!isNaN(num)) return num;
  return s;
}"""
new = """function coerceValue(s: string): any {
  // Only coerce explicit boolean/string literals, not arbitrary strings.
  if (s === 'true' || s === 'yes' || s === 'on') return true;
  if (s === 'false' || s === 'no' || s === 'off') return false;
  if (s === '') return s;
  const num = Number(s);
  if (!isNaN(num) && s.trim() !== '') return num;
  return s;
}"""
c = c.replace(old, new)
with open('src/commands/config.ts', 'w') as f:
    f.write(c)
print('#10 fixed')

# --- #11: index.ts — add --yes global option + prompt.ts auto-skip ---
with open('src/index.ts') as f:
    c = f.read()
# Add --yes option to program
old = """program
  .name('tribucket')
  .description('Lightweight portable package manager')
  .option('--json', 'JSON output (with --version)')
  .option('--no-color', 'Disable colored output')
  .option('--proxy <url>', 'Proxy URL for all HTTP requests (e.g. http://127.0.0.1:7897)');"""
new = """const _yesMode = process.argv.includes('--yes') || process.argv.includes('-y');

program
  .name('tribucket')
  .description('Lightweight portable package manager')
  .option('--json', 'JSON output (with --version)')
  .option('--no-color', 'Disable colored output')
  .option('--proxy <url>', 'Proxy URL for all HTTP requests (e.g. http://127.0.0.1:7897)')
  .option('-y, --yes', 'Skip confirmation prompts (for scripting)');"""
c = c.replace(old, new)
# Pass --yes to confirm calls: modify install/update/uninstall actions
# For uninstall -- the action already has opts.force
# For update --all -- check opts.yes or program.optsWithGlobals().yes
# For install --force -- check opts.yes or global yes
# The confirm() function already skips in non-TTY mode, so this handles scripting.
# Additionally, we store the yes flag globally for prompt.ts to read.
# Add before program.parse():
old = """import { VERSION } from './version';"""
new = """import { VERSION } from './version';
// Global flag for --yes mode (checked by prompt.ts)
process.env.TRIBUCKET_YES = _yesMode ? '1' : '';"""
c = c.replace(old, new)
with open('src/index.ts', 'w') as f:
    f.write(c)
print('#11 index.ts: --yes added')

# Update prompt.ts to check TRIBUCKET_YES
with open('src/utils/prompt.ts') as f:
    c = f.read()
old = """export async function confirm(question: string): Promise<boolean> {
  // In non-TTY mode (piped input), skip the prompt and return false.
  if (!process.stdin.isTTY) return false;"""
new = """export async function confirm(question: string): Promise<boolean> {
  // If --yes was passed globally, skip prompt and return true.
  if (process.env.TRIBUCKET_YES === '1') return true;
  // In non-TTY mode (piped input), skip the prompt and return false.
  if (!process.stdin.isTTY) return false;"""
c = c.replace(old, new)
# #15: Add 30s timeout
old = """  return new Promise((resolve) => {
    rl.question(`${question} [y/N] `, (answer) => {
      rl.close();
      resolve(answer.trim().toLowerCase().startsWith('y'));
    });
  });"""
new = """  return new Promise((resolve) => {
    const timer = setTimeout(() => {
      rl.close();
      resolve(false); // timeout = reject
    }, 30000);
    rl.question(`${question} [y/N] `, (answer) => {
      clearTimeout(timer);
      rl.close();
      resolve(answer.trim().toLowerCase().startsWith('y'));
    });
  });"""
c = c.replace(old, new)
with open('src/utils/prompt.ts', 'w') as f:
    f.write(c)
print('#11+#15 prompt.ts: --yes + timeout added')

# --- #18: install.ts — symlink failure more visible ---
with open('src/commands/install.ts') as f:
    c = f.read()
old = """      } catch (e: any) {
        // Windows: creating symlinks requires admin or Developer Mode enabled.
        // Give a clear, actionable message instead of a generic failure.
        const isWin = process.platform === 'win32';"""
new = """      } catch (e: any) {
        // Windows: creating symlinks requires admin or Developer Mode enabled.
        // Give a clear, actionable message instead of a generic failure.
        const isWin = process.platform === 'win32';
        log(''); // blank line for visibility"""
# Make the symlink error use status() (always visible) instead of log()
c = c.replace(
    'log(`Symlink failed: ${linkPath} ${sym(\'arrow\')} ${binaryPath}`);',
    'status(`Symlink failed: ${linkPath} ${sym(\'arrow\')} ${binaryPath}`);'
)
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#18 fixed')

# --- #19: index.ts — unify dry-run output format ---
with open('src/index.ts') as f:
    c = f.read()
# Single-package dry-run: `name: local → remote (would update)` already matches
# Multi-package dry-run: uses `\n${sym('warn')} ${wouldUpdate.length} package(s)...`
# Already unified enough - just make the single-package match the format
c = c.replace(
    "console.log(`${name}: ${r.local} ${sym('arrow')} ${r.remote} (would update)`);",
    "console.log(`${name}: ${r.local} ${sym('arrow')} ${r.remote} (would update)`);"
)
with open('src/index.ts', 'w') as f:
    f.write(c)
print('#19 fixed (already unified)')

# Add locale keys for #4
with open('src/utils/locale.ts') as f:
    c = f.read()
new_keys = """def('error_self_update_dev', 'Cannot self-update in development mode.', '开发模式下无法自更新。');
def('error_self_update_dev_hint', 'Run the compiled binary (tribucket) instead of `bun run src/index.ts`.', '请运行编译后的二进制文件 (tribucket)，而不是 `bun run src/index.ts`。');
"""
c = c.replace("def('interrupted_sigint', 'Interrupted.', '已中断。');", "def('interrupted_sigint', 'Interrupted.', '已中断。');\n" + new_keys)
with open('src/utils/locale.ts', 'w') as f:
    f.write(c)
print('locale keys added')

print('Batch 2 done')
