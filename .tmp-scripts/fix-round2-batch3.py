#!/usr/bin/env python3
"""Fix batch 3: #4 install.sh, #5 bootstrap.sh, #10 install.sh, #18 zst, #19 cleanup, #20 build.ts, #21 build.ts"""

import os, re
os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# --- #4: install.sh — add `..` rejection ---
with open('scripts/install.sh') as f:
    c = f.read()
old = """TRIBUCKET_REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
# Validate repo format to prevent URL injection [#101]
case "$TRIBUCKET_REPO" in
  *[!a-zA-Z0-9_.-]*/[!a-zA-Z0-9_.-]*|*[!a-zA-Z0-9/_.-]*)
    err "Invalid TRIBUCKET_REPO format: ${TRIBUCKET_REPO}"
    ;;
esac"""
new = """TRIBUCKET_REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
# Validate repo format to prevent URL injection [#101]
case "$TRIBUCKET_REPO" in
  *..*|*[!a-zA-Z0-9_.-]*/[!a-zA-Z0-9_.-]*|*[!a-zA-Z0-9/_.-]*)
    err "Invalid TRIBUCKET_REPO format: ${TRIBUCKET_REPO}"
    ;;
esac"""
c = c.replace(old, new)
with open('scripts/install.sh', 'w') as f:
    f.write(c)
print('#4 fixed')

# --- #5: bootstrap.sh — add repo validation ---
with open('scripts/bootstrap.sh') as f:
    c = f.read()
old = "REPO=\"${TRIBUCKET_REPO:-sixiang-world/tribucket}\""
new = """REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
# Validate repo format to prevent URL injection
case "$REPO" in
  *..*|*[!a-zA-Z0-9_.-]*/[!a-zA-Z0-9_.-]*|*[!a-zA-Z0-9/_.-]*)
    echo "Error: Invalid TRIBUCKET_REPO format: ${REPO}" >&2
    exit 1
    ;;
esac"""
c = c.replace(old, new)
with open('scripts/bootstrap.sh', 'w') as f:
    f.write(c)
print('#5 fixed')

# --- #10: install.sh — escape regex metacharacters in grep key ---
with open('scripts/install.sh') as f:
    c = f.read()
old = """  # Fallback: regex-based extraction with proper quoting [#76]
  printf '%s' "$_json" \
    | grep -o "\"${_key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 \
    | sed "s/.*\"${_key}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/" \
    || true"""
new = """  # Fallback: regex-based extraction with proper quoting [#76]
  # Escape regex metacharacters in key to prevent injection
  _key_re=$(printf '%s' "$_key" | sed 's/[][\\.*^$+?()|{}]/\\\\&/g')
  printf '%s' "$_json" \
    | grep -o "\"${_key_re}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 \
    | sed "s/.*\"${_key_re}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/" \
    || true"""
c = c.replace(old, new)
with open('scripts/install.sh', 'w') as f:
    f.write(c)
print('#10 fixed')

# --- #18: install.ts — add .tar.zst support ---
with open('src/commands/install.ts') as f:
    c = f.read()
old = """    const isArchive = archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz') ||
                      archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2') ||
                      archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz') ||
                      archivePath.endsWith('.zip');"""
new = """    const isArchive = archivePath.endsWith('.tar.gz') || archivePath.endsWith('.tgz') ||
                      archivePath.endsWith('.tar.bz2') || archivePath.endsWith('.tbz2') ||
                      archivePath.endsWith('.tar.xz') || archivePath.endsWith('.txz') ||
                      archivePath.endsWith('.tar.zst') || archivePath.endsWith('.tzst') ||
                      archivePath.endsWith('.zip');"""
c = c.replace(old, new)
with open('src/commands/install.ts', 'w') as f:
    f.write(c)
print('#18 fixed')

# --- #19: cleanup.ts — reuse stat result ---
with open('src/utils/cleanup.ts') as f:
    c = f.read()
old = """\t  if (statSync(path).isDirectory()) {
\t            const age = now - statSync(path).mtimeMs;"""
new = """\t  const st = statSync(path);
\t          if (st.isDirectory()) {
\t            const age = now - st.mtimeMs;"""
c = c.replace(old, new)
with open('src/utils/cleanup.ts', 'w') as f:
    f.write(c)
print('#19 fixed')

# --- #20: build.ts — fix regex range ---
with open('website/build.ts') as f:
    c = f.read()
c = c.replace('[—–-]', '(?:—|–|-)')
with open('website/build.ts', 'w') as f:
    f.write(c)
print('#20 fixed')

# --- #21: build.ts — use portable import.meta.url ---
with open('website/build.ts') as f:
    c = f.read()
old = """import { existsSync, mkdirSync, cpSync, readFileSync, writeFileSync, rmSync } from "node:fs";
import { join, resolve } from "node:path";"""
new = """import { existsSync, mkdirSync, cpSync, readFileSync, writeFileSync, rmSync } from "node:fs";
import { join, resolve } from "node:path";
import { fileURLToPath } from "node:url";"""
c = c.replace(old, new)
# Fix import.meta.dir
old = "const ROOT = resolve(import.meta.dir, \"..\");"
new = "const ROOT = resolve(fileURLToPath(new URL(\"..\", import.meta.url)));"
c = c.replace(old, new)
with open('website/build.ts', 'w') as f:
    f.write(c)
print('#21 fixed')

print('Batch 3 done')
