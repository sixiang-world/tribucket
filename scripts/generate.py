#!/usr/bin/env python3
"""tribucket generator — produces Formula/*.rb and bucket/*.json from packages/*.json.

Usage:
    python scripts/generate.py [--only NAME ...] [--skip-hash] [--dry-run] [--verbose]
"""
import argparse
import hashlib
import json
import os
import sys
import time
import urllib.request
import urllib.error
from fnmatch import fnmatch


CHECKSUM_PATTERNS = ("sha256sums", "SHA256SUMS", "checksums.txt", ".sha256")


def load_packages(packages_dir, only=None):
    """Load package definitions from packages/*.json."""
    pkgs = []
    for f in sorted(os.listdir(packages_dir)):
        if not f.endswith(".json"):
            continue
        path = os.path.join(packages_dir, f)
        with open(path, encoding="utf-8") as fh:
            pkg = json.load(fh)
        pkgs.append(pkg)

    if only:
        only_set = set(only)
        found = {p["name"] for p in pkgs}
        missing = only_set - found
        for m in missing:
            print(f"[warn] Package '{m}' not found in {packages_dir}")
        pkgs = [p for p in pkgs if p["name"] in only_set]

    return pkgs


def match_asset(assets, pattern):
    """Find the first asset whose name matches the pattern (substring or glob)."""
    # First try substring match
    for asset in assets:
        if pattern in asset["name"]:
            return asset
    # Then try glob match
    for asset in assets:
        if fnmatch(asset["name"], f"*{pattern}*"):
            return asset
    return None


def is_checksum_asset(name):
    """Check if an asset name looks like a checksum file."""
    lower = name.lower()
    return any(p.lower() in lower for p in CHECKSUM_PATTERNS)


def parse_release(release_json):
    """Extract version, assets, and checksum assets from a GitHub release JSON."""
    tag = release_json["tag_name"]
    version = tag.lstrip("v")
    all_assets = release_json.get("assets", [])
    checksum_assets = [a for a in all_assets if is_checksum_asset(a["name"])]
    return version, all_assets, checksum_assets


def http_get(url, token=None, retries=3):
    """Fetch a URL with optional GitHub token and retry logic."""
    headers = {"Accept": "application/vnd.github.v3+json"}
    if token:
        headers["Authorization"] = f"token {token}"

    req = urllib.request.Request(url, headers=headers)
    last_err = None
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                return resp.read()
        except urllib.error.HTTPError as e:
            last_err = e
            if e.code == 403:
                raise
            if e.code >= 500 and attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
        except urllib.error.URLError as e:
            last_err = e
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
    raise last_err


def fetch_latest_release(repo, token=None):
    """Fetch the latest release from GitHub."""
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    body = http_get(url, token=token)
    release_json = json.loads(body)
    return parse_release(release_json)


def cache_key_path(cache_dir, pkg_name, version, filename):
    """Return the path to a cached SHA256 hash file."""
    return os.path.join(cache_dir, pkg_name, version, f"{filename}.sha256")


def get_cached_hash(cache_dir, pkg_name, version, filename):
    """Return cached SHA256 hash if it exists, else None."""
    path = cache_key_path(cache_dir, pkg_name, version, filename)
    if os.path.isfile(path):
        with open(path) as f:
            return f.read().strip()
    return None


def write_cache(cache_dir, pkg_name, version, filename, sha256_hash):
    """Write a SHA256 hash to the cache."""
    path = cache_key_path(cache_dir, pkg_name, version, filename)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(sha256_hash)


def compute_sha256(filepath):
    """Compute SHA256 hex digest of a file."""
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_checksum_file(content, target_filename):
    """Extract SHA256 hash for target_filename from a checksum file."""
    for line in content.strip().splitlines():
        parts = line.strip().split()
        if len(parts) >= 2 and target_filename in parts[-1]:
            return parts[0].lower()
    return None


def parse_args(argv=None):
    """Parse CLI arguments. Accepts list for testing; defaults to sys.argv[1:]."""
    parser = argparse.ArgumentParser(
        description="Generate Homebrew Formula and Scoop Bucket from packages/*.json"
    )
    parser.add_argument(
        "--only", action="append", default=[],
        help="Generate for a single package only (can repeat)"
    )
    parser.add_argument(
        "--skip-hash", action="store_true", default=False,
        help="Skip SHA256 computation (reuse existing hashes)"
    )
    parser.add_argument(
        "--dry-run", action="store_true", default=False,
        help="Print generated content to stdout, don't write files"
    )
    parser.add_argument(
        "--verbose", action="store_true", default=False,
        help="Print detailed progress"
    )
    return parser.parse_args(argv)


def main():
    args = parse_args()
    print("generate.py scaffold OK")


if __name__ == "__main__":
    main()
