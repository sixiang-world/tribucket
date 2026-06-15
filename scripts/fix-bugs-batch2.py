#!/usr/bin/env python3
"""Fix BUG #3 (update.ts SIGINT), BUG #6 (clean.ts catch), BUG #7 (uninstall.ts startsWith)."""

import os

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- BUG #3: update.ts — per-call SIGINT handler ---
with open('src/commands/update.ts', 'r') as f:
    c = f.read()

# Remove module-level handler
old = (
    '// SIGINT handler for graceful interrupt\n'
    'let sigintHandler: NodeJS.SignalsHandler | null = null;\n'
    '\n'
    'function handleSigint() {\n'
    '  console.log(`\\n${t(\'interrupted\')}`);\n'
    '  process.exit(130);\n'
    '}\n'
    '\n'
)
c = c.replace(old, '')

# Replace install with local variable
old = (
    '  // Install SIGINT handler\n'
    '  sigintHandler = handleSigint;\n'
    '  process.on(\'SIGINT\', sigintHandler);\n'
)
new = (
    '  // Install SIGINT handler (per-call local variable)\n'
    '  const sigintHandler = () => {\n'
    '    console.log(`\\n${t(\'interrupted\')}`);\n'
    '    process.exit(130);\n'
    '  };\n'
    '  process.on(\'SIGINT\', sigintHandler);\n'
)
c = c.replace(old, new)

# Replace cleanup
old = (
    '    // Remove SIGINT handler\n'
    '    if (sigintHandler) {\n'
    '      process.removeListener(\'SIGINT\', sigintHandler);\n'
    '      sigintHandler = null;\n'
    '    }\n'
)
new = (
    '    // Remove SIGINT handler\n'
    '    process.removeListener(\'SIGINT\', sigintHandler);\n'
)
c = c.replace(old, new)

with open('src/commands/update.ts', 'w') as f:
    f.write(c)
print('BUG #3 fixed')

# --- BUG #6: clean.ts — catch block try-catch ---
with open('src/commands/clean.ts', 'r') as f:
    c = f.read()

old = (
    '} catch {\n'
    '  unlinkSync(linkPath);\n'
    '  console.log(`  ${sym(\'ok\')} ${linkPath}`);'
)
new = (
    '} catch {\n'
    '  try { unlinkSync(linkPath); } catch {}\n'
    '  console.log(`  ${sym(\'ok\')} ${linkPath}`);'
)
c = c.replace(old, new)
with open('src/commands/clean.ts', 'w') as f:
    f.write(c)
print('BUG #6 fixed')

# --- BUG #7: uninstall.ts — precise symlink target matching ---
with open('src/commands/uninstall.ts', 'r') as f:
    c = f.read()

old = (
    '          if (target.startsWith(path)) {\n'
    '            unlinkSync(link);\n'
)
new = (
    '          if (target === path || target.startsWith(path + \'/\') || target.startsWith(path + \'\\\\\')) {\n'
    '            unlinkSync(link);\n'
)
c = c.replace(old, new)
with open('src/commands/uninstall.ts', 'w') as f:
    f.write(c)
print('BUG #7 fixed')

print('All batch 2 fixes applied')
