#!/usr/bin/env bash
# fetch_release.sh — Fetch latest GitHub release assets for a repo
# Usage: bash fetch_release.sh <owner/repo> [--token TOKEN]
# Output: JSON with {version, assets: [{name, url, platform_guess}], raw_count}

set -euo pipefail

REPO="${1:?Usage: fetch_release.sh <owner/repo>}"
TOKEN="${2:-${GITHUB_TOKEN:-}}"

# Build auth header
AUTH_HEADER=""
if [[ -n "$TOKEN" ]]; then
    AUTH_HEADER="Authorization: token $TOKEN"
fi

# Fetch latest release
URL="https://api.github.com/repos/${REPO}/releases/latest"

HEADERS=(-H "Accept: application/vnd.github.v3+json" -H "User-Agent: tribucket-gen/1.0")
if [[ -n "$AUTH_HEADER" ]]; then
    HEADERS+=(-H "$AUTH_HEADER")
fi

RESPONSE=$(curl -sf --retry 3 --retry-delay 2 "${HEADERS[@]}" "$URL" 2>/dev/null) || {
    echo '{"error": "Failed to fetch release. Check repo name and network/token."}' 
    exit 1
}

# Parse with python3 (available everywhere)
python3 -c "
import json, sys, re

data = json.loads(sys.stdin.read())
tag = data.get('tag_name', '')
version = tag.lstrip('v')
assets = data.get('assets', [])

PLATFORM_PATTERNS = [
    ('linux_amd64',   [r'linux.*x86_64', r'linux.*x64', r'linux.*amd64', r'linux[-_]amd64', r'linux[-_]x86_64']),
    ('linux_arm64',   [r'linux.*aarch64', r'linux.*arm64', r'linux[-_]arm64', r'linux[-_]aarch64']),
    ('darwin_amd64',  [r'darwin.*x86_64', r'darwin.*x64', r'darwin.*amd64', r'macos.*x86_64', r'macos.*x64', r'macos[-_]amd64', r'osx.*x86_64']),
    ('darwin_arm64',  [r'darwin.*aarch64', r'darwin.*arm64', r'macos.*aarch64', r'macos.*arm64', r'osx.*aarch64', r'apple[-_]darwin']),
    ('windows_amd64', [r'windows.*x86_64', r'windows.*x64', r'windows.*amd64', r'win[-_]x86_64', r'win[-_]x64', r'win[-_]amd64']),
    ('windows_arm64', [r'windows.*aarch64', r'windows.*arm64', r'win[-_]aarch64', r'win[-_]arm64']),
]

def guess_platform(name):
    # Match case-insensitively since some projects use Linux/Linux/Darwin/Windows
    for plat, patterns in PLATFORM_PATTERNS:
        for p in patterns:
            if re.search(p, name, re.IGNORECASE):
                return plat
    return 'unknown'

result = {
    'version': version,
    'tag': tag,
    'repo': '$REPO',
    'raw_count': len(assets),
    'assets': []
}

# Filter out non-binary assets (rpm, deb, apk, source tarballs, sbom, checksums)
SKIP_EXTENSIONS = ('.rpm', '.deb', '.apk', '.sbom.json', '.sigstore.json')
SKIP_PATTERNS = ('checksums', 'sha256sums', 'SHA256SUMS', '.sha256', '.sha512', 'source', 'Source')

def should_skip(name):
    for ext in SKIP_EXTENSIONS:
        if name.endswith(ext):
            return True
    # Skip source-only tarballs (no arch in name)
    if name.endswith('.tar.gz') and not any(k in name.lower() for k in ['x86_64', 'x64', 'amd64', 'aarch64', 'arm64', 'darwin', 'linux', 'windows', 'win']):
        return True
    for pat in SKIP_PATTERNS:
        if pat.lower() in name.lower():
            return True
    return False

for a in assets:
    name = a['name']
    if should_skip(name):
        continue
    url = a['browser_download_url']
    plat = guess_platform(name)
    result['assets'].append({
        'name': name,
        'url': url,
        'platform': plat,
        'size': a.get('size', 0)
    })

# Summary
matched = [a for a in result['assets'] if a['platform'] != 'unknown']
checksums = [a for a in result['assets'] if any(k in a['name'].lower() for k in ['sha256', 'checksum', '.sha256', 'sha512'])]
result['summary'] = {
    'total_assets': len(assets),
    'platform_matched': len(matched),
    'checksum_files': len(checksums),
    'has_checksums': len(checksums) > 0
}

print(json.dumps(result, indent=2, ensure_ascii=False))
" <<< "$RESPONSE"