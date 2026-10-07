"""Asset matching and pattern validation layer for the tribucket generator."""
import os
import sys
from fnmatch import fnmatch

from .release import fetch_latest_release   # check_asset_patterns 需要

# Windows GBK console cannot encode the ✓/❌/⚠️ symbols used below
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf8"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


CHECKSUM_PATTERNS = ("sha256sums", "SHA256SUMS", "checksums.txt", ".sha256")


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


# infer_asset_format — inlined here so the generator is self-contained and
# does not depend on the archived Python v1 CLI (lib/tribucket/). This is the
# only function the generator ever needed from that module.
def infer_asset_format(asset_pattern):
    """Infer archive format from asset filename patterns."""
    formats = {}
    for platform, pattern in asset_pattern.items():
        if pattern == "NO_MATCH" or not pattern:
            continue
        if pattern.endswith(".tar.gz"):
            formats[platform] = "tar.gz"
        elif pattern.endswith(".tar.bz2"):
            formats[platform] = "tar.bz2"
        elif pattern.endswith(".tar.xz"):
            formats[platform] = "tar.xz"
        elif pattern.endswith(".zip"):
            formats[platform] = "zip"
        elif pattern.endswith(".exe"):
            formats[platform] = "exe"
        else:
            formats[platform] = "binary"
    return formats


def check_asset_patterns(pkgs):
    """Validate asset_pattern against latest GitHub releases.

    Prints a per-package status:
      ✅  all non-NO_MATCH patterns match at least one asset
      ⚠️  some patterns match, some don't
      ❌  no patterns match (package will produce zero output)
      —   download_url package (always fine)
      ?   network error (couldn't check)

    Returns True if all packages pass (no ❌), False otherwise.
    """
    token = os.environ.get("GITHUB_TOKEN")
    all_ok = True

    for pkg in pkgs:
        name = pkg["name"]

        # download_url packages always pass
        if "download_url" in pkg:
            print(f"  —  {name}: download_url (hardcoded)")
            continue

        repo = pkg.get("repo", "")
        if not repo:
            print(f"  ❌ {name}: no repo field")
            all_ok = False
            continue

        # Fetch latest release
        try:
            version, all_assets, _ = fetch_latest_release(repo, token)
        except Exception as e:
            print(f"  ?  {name}: network error — {e}")
            continue

        # Check each platform
        patterns = pkg.get("asset_pattern", {})
        matched = 0
        total = 0
        for plat, pat in patterns.items():
            if pat == "NO_MATCH" or not pat:
                continue
            total += 1
            if match_asset(all_assets, pat):
                matched += 1

        if total == 0:
            print(f"  ❌ {name}: no asset_pattern defined")
            all_ok = False
        elif matched == 0:
            print(f"  ❌ {name}: 0/{total} patterns matched (zero output)")
            all_ok = False
        elif matched < total:
            missing = total - matched
            print(f"  ⚠️  {name}: {matched}/{total} matched ({missing} platform(s) missing)")
        else:
            print(f"  ✅ {name}: {matched}/{total} matched")

    return all_ok
