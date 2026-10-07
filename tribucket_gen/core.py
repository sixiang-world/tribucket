"""Orchestration: load packages, resolve release context, render outputs."""
import json
import os
import re

from .release import fetch_latest_release
from .assets import match_asset
from .hashing import get_cached_hash, get_sha256_for_asset
from .checkver import run_checkver, apply_autoupdate, in_place_replace
from .render import Ctx, render_all

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]

# Versions flow into URLs, filenames, Ruby class names, and JSON paths.
# Reject anything outside this safe charset before it reaches render.
_SAFE_VERSION_RE = re.compile(r"^[A-Za-z0-9._+~-]+$")


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


def resolve_package(pkg, cache_dir, skip_hash=False, verbose=False):
    """Fetch latest release / run checkver, match assets, compute hashes.

    Supports two modes:
      - GitHub release: uses ``repo`` + ``asset_pattern`` to match assets from the
        latest GitHub release.
      - Custom download URL: if ``download_url`` is present, uses those direct URLs
        and reads the version from the required ``version`` field.

    Args:
        pkg: Package dict from packages/*.json.
        cache_dir: Path to the .cache directory.
        skip_hash: If True, skip SHA256 computation (use empty strings).
        verbose: Print detailed progress.

    Returns:
        Ctx (from .render), or None when a download_url package is missing its
        'version' field (nothing can be resolved).
    """
    name = pkg["name"]
    token = os.environ.get("GITHUB_TOKEN")

    platforms = {}  # platform_key -> {url, sha256}
    windows = {}    # arch_key -> {url, hash, filename}

    if "download_url" in pkg:
        # ── Custom download URL path ──────────────────────────────────
        hardcoded_version = pkg.get("version")
        if not hardcoded_version:
            print(f"  [error] {name}: 'download_url' present but 'version' field is missing")
            return None

        repo = pkg.get("repo", "")
        download_urls = pkg["download_url"]

        # 1. Run checkver to detect latest version
        try:
            latest_version, captures = run_checkver(pkg)
        except Exception as e:
            print(f"  [warn] {name}: checkver error: {e}, using hardcoded version")
            latest_version = hardcoded_version
            captures = {"version": hardcoded_version}

        if latest_version is None:
            latest_version = hardcoded_version
            captures = {"version": hardcoded_version}

        # 2. Construct new URLs if version changed
        if latest_version != hardcoded_version:
            if verbose:
                print(f"  Version: {hardcoded_version} → {latest_version}")

            if "autoupdate" in pkg:
                download_urls = apply_autoupdate(
                    pkg["autoupdate"], latest_version, captures
                )
            else:
                download_urls = in_place_replace(
                    pkg["download_url"], hardcoded_version, latest_version
                )

        version = latest_version
        if not _SAFE_VERSION_RE.fullmatch(version or ""):
            print(f"[error] {name}: refusing unsafe version {version!r}")
            return None

        if verbose:
            print(f"  Using download URLs (v{version})")

        for plat_key in PLATFORM_KEYS:
            url = download_urls.get(plat_key)
            if not url or url == "NO_MATCH":
                continue

            filename = url.split("/")[-1]

            # Get SHA256
            if skip_hash:
                sha = ""
            else:
                sha = get_cached_hash(cache_dir, name, version, filename)
                if sha:
                    if verbose:
                        print(f"  [cache hit] {filename}")
                else:
                    # No checksum assets for custom downloads — pass empty lists
                    sha = get_sha256_for_asset(
                        url, filename, [], [],
                        cache_dir, name, version, verbose,
                    )

            platforms[plat_key] = {"url": url, "sha256": sha}

            # Collect Windows assets for bucket
            if plat_key.startswith("windows_"):
                arch_key = "64bit" if "amd64" in plat_key else "arm64"
                windows[arch_key] = {"url": url, "hash": sha, "filename": filename}

        # Track whether version changed for write-back
        version_changed = (latest_version != hardcoded_version)
        new_download_urls_for_writeback = download_urls if version_changed else None

        return Ctx(
            version=version,
            repo=repo,
            platforms=platforms,
            windows=windows,
            is_download_url=True,
            changed_version=(latest_version if version_changed else None),
            new_urls=new_download_urls_for_writeback,
        )

    # ── GitHub release API path ───────────────────────────────────
    repo = pkg["repo"]

    if verbose:
        print(f"  Fetching latest release for {repo}...")

    version, all_assets, checksum_assets = fetch_latest_release(repo, token)
    if not _SAFE_VERSION_RE.fullmatch(version or ""):
        print(f"[error] {name}: refusing unsafe version {version!r}")
        return None
    if verbose:
        print(f"  Latest: v{version} ({len(all_assets)} assets)")

    # Match assets per platform
    for plat_key in PLATFORM_KEYS:
        pattern = pkg.get("asset_pattern", {}).get(plat_key)
        if not pattern:
            continue
        asset = match_asset(all_assets, pattern)
        if not asset:
            print(f"  [warn] {name}: no asset matching '{pattern}' for {plat_key}")
            continue

        url = asset["browser_download_url"]
        filename = asset["name"]

        # Get SHA256
        if skip_hash:
            sha = ""
        else:
            sha = get_cached_hash(cache_dir, name, version, filename)
            if sha:
                if verbose:
                    print(f"  [cache hit] {filename}")
            else:
                sha = get_sha256_for_asset(
                    url, filename, all_assets, checksum_assets,
                    cache_dir, name, version, verbose,
                )

        platforms[plat_key] = {"url": url, "sha256": sha}

        # Collect Windows assets for bucket
        if plat_key.startswith("windows_"):
            arch_key = "64bit" if "amd64" in plat_key else "arm64"
            windows[arch_key] = {"url": url, "hash": sha, "filename": filename}

    return Ctx(
        version=version,
        repo=repo,
        platforms=platforms,
        windows=windows,
        is_download_url=False,
    )


def process_package(pkg, cache_dir, skip_hash=False, verbose=False):
    """Tuple-compat API over resolve_package + registry rendering.

    Returns:
        Tuple of (formula_content, bucket_content, changed_version, new_urls).
        formula/bucket may be None if the package lacks assets for that format;
        all four are None when the package could not be resolved.
    """
    ctx = resolve_package(pkg, cache_dir, skip_hash=skip_hash, verbose=verbose)
    if ctx is None:
        return None, None, None, None
    outputs = render_all(pkg, ctx)
    formula = outputs.get(f"Formula/{pkg['name']}.rb")
    bucket = outputs.get(f"bucket/{pkg['name']}.json")
    return formula, bucket, ctx.changed_version, ctx.new_urls
