#!/usr/bin/env python3
"""
scripts/kv-sync.py — Sync packages/Formula/bucket to EdgeOne KV

Reads all package definitions, Formula files, and bucket files from the
local repository and POSTs them to the /admin/sync endpoint of
tribucket.hunluan.space, which writes them to EdgeOne KV.

Usage:
    ADMIN_SYNC_SECRET=<secret> python scripts/kv-sync.py
    ADMIN_SYNC_SECRET=<secret> TRIBUCKET_SITE=https://tribucket.hunluan.space python scripts/kv-sync.py

Environment:
    ADMIN_SYNC_SECRET  (required)  — Bearer token for /admin/sync auth
    TRIBUCKET_SITE     (optional)  — Base URL (default: https://tribucket.hunluan.space)
"""

import json
import os
import sys
import urllib.request
import urllib.error

# Paths relative to repo root
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACKAGES_DIR = os.path.join(REPO_ROOT, "packages")
FORMULA_DIR = os.path.join(REPO_ROOT, "Formula")
BUCKET_DIR = os.path.join(REPO_ROOT, "bucket")

SITE = os.environ.get("TRIBUCKET_SITE", "https://tribucket.hunluan.space")
SECRET = os.environ.get("ADMIN_SYNC_SECRET", "")


def name_to_key(prefix, name):
    """Convert package name to KV key: hyphens → underscores, prefixed with tri_."""
    return "tri_" + prefix + name.replace("-", "_")


def load_json_files(directory):
    """Read all .json files from a directory, return list of (stem, data)."""
    results = []
    if not os.path.isdir(directory):
        return results
    for fname in sorted(os.listdir(directory)):
        if not fname.endswith(".json"):
            continue
        stem = fname[: -len(".json")]
        with open(os.path.join(directory, fname), "r", encoding="utf-8") as f:
            data = json.load(f)
        results.append((stem, data))
    return results


def load_text_files(directory, ext):
    """Read all files with given extension from a directory, return list of (stem, content)."""
    results = []
    if not os.path.isdir(directory):
        return results
    for fname in sorted(os.listdir(directory)):
        if not fname.endswith(ext):
            continue
        stem = fname[: -len(ext)]
        with open(os.path.join(directory, fname), "r", encoding="utf-8") as f:
            content = f.read()
        results.append((stem, content))
    return results


def build_index(packages):
    """Build the package metadata index array (name, repo, description, homepage, license)."""
    index = []
    for stem, data in packages:
        index.append({
            "name": data.get("name", stem),
            "repo": data.get("repo", ""),
            "description": data.get("description", ""),
            "homepage": data.get("homepage", ""),
            "license": data.get("license", ""),
        })
    index.sort(key=lambda p: p["name"])
    return index


def sync(items, index):
    """POST items and index to the admin sync endpoint."""
    url = f"{SITE.rstrip('/')}/admin/sync"
    payload = json.dumps({"items": items, "index": index}).encode("utf-8")

    req = urllib.request.Request(
        url,
        data=payload,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {SECRET}",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            print(f"  ✓ Synced: {result.get('count', 0)} keys")
            if not result.get("ok"):
                print(f"  ✗ Server returned error: {result}")
                sys.exit(1)
    except urllib.error.HTTPError as e:
        print(f"  ✗ HTTP {e.code}: {e.read().decode('utf-8')}")
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"  ✗ Connection failed: {e.reason}")
        sys.exit(1)


def main():
    if not SECRET:
        print("ERROR: ADMIN_SYNC_SECRET environment variable is required")
        sys.exit(1)

    print(":: KV Sync — tribucket")

    # 1. Load packages
    packages = load_json_files(PACKAGES_DIR)
    print(f"  packages: {len(packages)}")

    # 2. Load Formula files
    formulas = load_text_files(FORMULA_DIR, ".rb")
    print(f"  formulas: {len(formulas)}")

    # 3. Load bucket files
    buckets = load_json_files(BUCKET_DIR)
    print(f"  buckets: {len(buckets)}")

    # 4. Build items
    items = []

    for stem, data in packages:
        items.append({
            "key": name_to_key("p_", stem),
            "value": json.dumps(data),
        })

    for stem, content in formulas:
        items.append({
            "key": name_to_key("f_", stem),
            "value": content,
        })

    for stem, data in buckets:
        items.append({
            "key": name_to_key("b_", stem),
            "value": json.dumps(data),
        })

    # 5. Build package index
    index = build_index(packages)
    print(f"  index entries: {len(index)}")

    # 6. Sync
    print(f"  total items: {len(items)}")
    sync(items, index)
    print("  ✓ KV sync complete")


if __name__ == "__main__":
    main()
