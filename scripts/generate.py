#!/usr/bin/env python3
"""tribucket generator — produces Formula/*.rb, bucket/*.json, and portable/ templates from packages/*.json.

Usage:
    python scripts/generate.py [--only NAME ...] [--skip-hash] [--dry-run] [--verbose]
    python scripts/generate.py --portable [--only NAME ...]
"""
import argparse
import json
import os
import sys
import urllib.error

# Windows GBK console cannot encode the ✓/❌/⚠️ symbols used below
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf8"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# Delegation imports: the release/assets/hashing/checkver layers now live in
# the tribucket_gen package (repo root). The names below are re-exported so
# existing consumers of scripts/generate.py (tests, CI) keep working.
import os as _os
import sys as _sys
_sys.path.insert(0, _os.path.dirname(_os.path.dirname(_os.path.abspath(__file__))))

from tribucket_gen.release import (  # noqa: E402,F401
    _build_opener, http_get, _has_aria2, download_file, fetch_latest_release, parse_release,
)
from tribucket_gen.assets import (  # noqa: E402,F401
    CHECKSUM_PATTERNS, match_asset, is_checksum_asset, infer_asset_format, check_asset_patterns,
)
from tribucket_gen.hashing import (  # noqa: E402,F401
    cache_key_path, get_cached_hash, write_cache, compute_sha256, parse_checksum_file,
    get_sha256_for_asset,
)
import tribucket_gen.checkver as _checkver_mod  # noqa: E402
from tribucket_gen.checkver import run_checkver, apply_autoupdate, in_place_replace  # noqa: E402,F401
from tribucket_gen.core import load_packages, process_package, PLATFORM_KEYS  # noqa: E402,F401
from tribucket_gen.render.homebrew import class_name_from, render_formula  # noqa: E402,F401
from tribucket_gen.render.scoop import autoupdate_url, render_bucket  # noqa: E402,F401
from tribucket_gen.render.portable import (  # noqa: E402,F401
    infer_install_type, derive_tribucket_json, render_install_sh, render_bat, generate_portable,
)


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
    parser.add_argument(
        "--check-assets", action="store_true", default=False,
        help="Only validate asset_pattern against latest releases, then exit"
    )
    parser.add_argument(
        "--portable", action="store_true", default=False,
        help="Also generate portable/<name>/ templates"
    )
    parser.add_argument(
        "--portable-dir", default=None,
        help="Output directory for portable templates (default: <repo>/portable)"
    )
    return parser.parse_args(argv)


def main():
    args = parse_args()

    # Resolve paths relative to script location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_dir = os.path.dirname(script_dir)
    packages_dir = os.path.join(repo_dir, "packages")
    formula_dir = os.path.join(repo_dir, "Formula")
    bucket_dir = os.path.join(repo_dir, "bucket")
    cache_dir = os.path.join(repo_dir, ".cache")
    portable_dir = args.portable_dir or os.path.join(repo_dir, "portable")

    # Load packages
    pkgs = load_packages(packages_dir, only=args.only or None)
    if not pkgs:
        print("[error] No packages found.")
        sys.exit(1)

    # --check-assets mode: validate patterns and exit
    if args.check_assets:
        print(f"Checking asset patterns for {len(pkgs)} package(s)...\n")
        ok = check_asset_patterns(pkgs)
        print(f"\n{'All patterns OK.' if ok else 'Some patterns have issues (see above).'}")
        sys.exit(0 if ok else 1)

    # Check download backend
    aria2_ver = _has_aria2()
    if aria2_ver:
        print(f"Download backend: aria2 {aria2_ver} (16 connections, 5 retries, resume)")
    else:
        print("Download backend: urllib (install aria2 for faster downloads)")

    print(f"Processing {len(pkgs)} package(s)...")

    has_errors = False

    for pkg in pkgs:
        name = pkg["name"]
        print(f"\n[{name}]")

        try:
            formula, bucket, new_version, new_urls = process_package(
                pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose
            )
        except urllib.error.URLError as e:
            print(f"  [warn] {name}: network error — {e}")
            continue
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_errors = True
            continue

        if formula is None and bucket is None:
            continue

        # Write back updated version to packages/*.json
        if new_version and not args.dry_run:
            pkg_path = os.path.join(packages_dir, f"{name}.json")
            try:
                with open(pkg_path, encoding="utf-8") as f:
                    pkg_data = json.load(f)
                pkg_data["version"] = new_version
                if new_urls:
                    pkg_data["download_url"] = new_urls
                with open(pkg_path, "w", encoding="utf-8") as f:
                    json.dump(pkg_data, f, indent=2, ensure_ascii=False)
                    f.write("\n")
                print(f"  -> packages/{name}.json (version → {new_version})")
            except Exception as e:
                print(f"  [warn] {name}: failed to write back version: {e}")

        if args.dry_run:
            if formula:
                print(f"\n--- Formula/{name}.rb ---")
                print(formula)
            if bucket:
                print(f"\n--- bucket/{name}.json ---")
                print(bucket)
            if args.portable:
                generate_portable(pkg, portable_dir, dry_run=True, verbose=args.verbose)
        else:
            if formula:
                os.makedirs(formula_dir, exist_ok=True)
                path = os.path.join(formula_dir, f"{name}.rb")
                with open(path, "w", encoding="utf-8") as f:
                    f.write(formula)
                print(f"  -> Formula/{name}.rb")

            if bucket:
                os.makedirs(bucket_dir, exist_ok=True)
                path = os.path.join(bucket_dir, f"{name}.json")
                with open(path, "w", encoding="utf-8") as f:
                    f.write(bucket)
                print(f"  -> bucket/{name}.json")

            if args.portable:
                generate_portable(pkg, portable_dir, verbose=args.verbose)
                print(f"  -> portable/{name}/")

    print(f"\nDone. Processed {len(pkgs)} package(s).")
    if has_errors:
        print("Some packages had errors (see above).")
        sys.exit(2)


if __name__ == "__main__":
    main()
