#!/usr/bin/env python3
"""tribucket generator — produces Formula/*.rb and bucket/*.json from packages/*.json.

Usage:
    python scripts/generate.py [--only NAME ...] [--skip-hash] [--dry-run] [--verbose]
"""
import argparse
import json
import os
import sys


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
