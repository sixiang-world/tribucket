#!/usr/bin/env python3
"""Fix BUG #4 (archive.ts PowerShell) and BUG #5 (admin/sync.js timing)."""

import os
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- BUG #4: archive.ts — escape single quotes in PowerShell path ---
with open('src/utils/archive.ts', 'r') as f:
    c = f.read()

# Escape single quotes by doubling them (PowerShell escape rule)
old = (
    '        const psCmd =\n'
    '          "Expand-Archive -LiteralPath \'" + archivePath +\n'
    '          "\' -DestinationPath \'" + destDir + "\' -Force";'
)
new = (
    '        // Escape single quotes by doubling them (PowerShell escape rule)\n'
    '        const escapedPath = archivePath.replace(/\'/g, "\'\'");\n'
    '        const escapedDest = destDir.replace(/\'/g, "\'\'");\n'
    '        const psCmd =\n'
    '          "Expand-Archive -LiteralPath \'" + escapedPath +\n'
    '          "\' -DestinationPath \'" + escapedDest + "\' -Force";'
)
c = c.replace(old, new)
with open('src/utils/archive.ts', 'w') as f:
    f.write(c)
print('BUG #4 fixed')

# --- BUG #5: admin/sync.js — timing-safe comparison ---
with open('functions/admin/sync.js', 'r') as f:
    c = f.read()

old = (
    '  if (!expected || token !== expected) {\n'
    '    return new Response(JSON.stringify({ error: \'Unauthorized\' }), {\n'
    '      status: 401,\n'
    '      headers: { ...CORS, \'Content-Type\': \'application/json\' },\n'
    '    });\n'
    '  }'
)
new = (
    '  // Constant-time comparison to prevent timing attacks\n'
    '  function safeCompare(a, b) {\n'
    '    if (typeof a !== \'string\' || typeof b !== \'string\' || a.length !== b.length) return false;\n'
    '    let result = 0;\n'
    '    for (let i = 0; i < a.length; i++) result |= a.charCodeAt(i) ^ b.charCodeAt(i);\n'
    '    return result === 0;\n'
    '  }\n'
    '  if (!expected || !safeCompare(token, expected)) {\n'
    '    return new Response(JSON.stringify({ error: \'Unauthorized\' }), {\n'
    '      status: 401,\n'
    '      headers: { ...CORS, \'Content-Type\': \'application/json\' },\n'
    '    });\n'
    '  }'
)
c = c.replace(old, new)
with open('functions/admin/sync.js', 'w') as f:
    f.write(c)
print('BUG #5 fixed')

print('All batch 3 fixes applied')
