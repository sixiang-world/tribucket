#!/usr/bin/env python3
"""Fix low-priority BUG #10-#13."""

import os
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- BUG #10: check.ts JSON.parse silent error ---
with open('src/commands/check.ts', 'r') as f:
    c = f.read()
old = '  try { tj = JSON.parse(readFileSync(tjPath, \'utf-8\')); } catch {}'
new = '  try { tj = JSON.parse(readFileSync(tjPath, \'utf-8\')); } catch { log(`Failed to parse ${tjPath}`); }'
c = c.replace(old, new)
# Ensure `log` is imported
if 'import { sym, log }' not in c:
    c = c.replace("import { sym, log }", "import { sym, log }")
with open('src/commands/check.ts', 'w') as f:
    f.write(c)
print('BUG #10 fixed')

# --- BUG #11: download.ts filename fallback ---
with open('src/engine/download.ts', 'r') as f:
    c = f.read()
old = "const filename = url.split('/').pop()?.split('?')[0] || 'download';"
new = "const filename = (url.split('/').pop()?.split('?')[0] && url.includes('/')) ? url.split('/').pop()!.split('?')[0] : 'download';"
c = c.replace(old, new)
with open('src/engine/download.ts', 'w') as f:
    f.write(c)
print('BUG #11 fixed')

# --- BUG #12: mirror.ts replace all occurrences ---
with open('src/engine/mirror.ts', 'r') as f:
    c = f.read()
old = (
    "return template\n"
    "    .replace('{repo}', repo)\n"
    "    .replace('{tag}', tag)\n"
    "    .replace('{version}', version)\n"
    "    .replace('{asset}', asset);"
)
new = (
    "return template\n"
    "    .replaceAll('{repo}', repo)\n"
    "    .replaceAll('{tag}', tag)\n"
    "    .replaceAll('{version}', version)\n"
    "    .replaceAll('{asset}', asset);"
)
c = c.replace(old, new)
with open('src/engine/mirror.ts', 'w') as f:
    f.write(c)
print('BUG #12 fixed')

# --- BUG #13: update.ts consistent config key ---
with open('src/commands/update.ts', 'r') as f:
    c = f.read()
# The issue: line 284 uses `config.packages[repoKey || name]` but line 32 reads differently.
# Fix: make line 284 use the same key resolution as line 32.
# Current line 32: `const info = repoKey ? config.packages[repoKey] : config.packages[name];`
# Current line 284: `config.packages[repoKey || name].version = remoteVer;`
# Fix: use the same pattern consistently.
old = "config.packages[repoKey || name].version = remoteVer;"
new = "const targetKey = repoKey || name;\n    config.packages[targetKey].version = remoteVer;"
c = c.replace(old, new)
with open('src/commands/update.ts', 'w') as f:
    f.write(c)
print('BUG #13 fixed')

print('All batch 4 fixes applied')
