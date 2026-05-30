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


def _build_opener():
    """Build a URL opener that respects HTTP_PROXY/HTTPS_PROXY env vars."""
    proxy_handler = urllib.request.ProxyHandler()
    return urllib.request.build_opener(proxy_handler)


_opener = _build_opener()


def http_get(url, token=None, retries=3):
    """Fetch a URL with optional GitHub token and retry logic.

    Respects HTTP_PROXY / HTTPS_PROXY / ALL_PROXY environment variables.
    """
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "Mozilla/5.0 (compatible; tribucket/1.0; +https://github.com/sixiang-world/tribucket)",
    }
    if token:
        headers["Authorization"] = f"token {token}"

    req = urllib.request.Request(url, headers=headers)
    last_err = None
    for attempt in range(retries):
        try:
            with _opener.open(req, timeout=30) as resp:
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


def class_name_from(name):
    """Derive a Ruby class name from a package name.

    'ccx' -> 'Ccx', 'claude-code' -> 'ClaudeCode', 'my-cool-tool' -> 'MyCoolTool'
    """
    return "".join(part.capitalize() for part in name.split("-"))


def render_formula(info):
    """Render a Homebrew Formula .rb file from package info.

    Args:
        info: Dict with keys: name, description, homepage, license, binary, version,
              platforms (dict of platform_key -> {url, sha256}).

    Returns:
        String content of the .rb file.
    """
    class_name = class_name_from(info["name"])
    p = info["platforms"]

    def platform_block(os_name, arch, platform_key):
        if platform_key not in p:
            return ""
        data = p[platform_key]
        return (
            f"    on_{arch} do\n"
            f'      url "{data["url"]}"\n'
            f'      sha256 "{data["sha256"]}"\n'
            f"    end\n"
        )

    def os_block(os_name, platform_keys):
        blocks = ""
        if os_name == "macos":
            blocks += platform_block(os_name, "arm", "darwin_arm64")
            blocks += platform_block(os_name, "intel", "darwin_amd64")
        else:
            blocks += platform_block(os_name, "arm", "linux_arm64")
            blocks += platform_block(os_name, "intel", "linux_amd64")
        if not blocks:
            return ""
        return f"  on_{os_name} do\n{blocks}  end\n\n"

    macos_block = os_block("macos", ["darwin_arm64", "darwin_amd64"])
    linux_block = os_block("linux", ["linux_arm64", "linux_amd64"])

    binary = info["binary"]

    formula = (
        f"class {class_name} < Formula\n"
        f'  desc "{info["description"]}"\n'
        f'  homepage "{info["homepage"]}"\n'
        f'  version "{info["version"]}"\n'
        f'  license "{info["license"]}"\n'
        f"\n"
        f"{macos_block}"
        f"{linux_block}"
        f"  def install\n"
        f'    bin.install Dir["{binary}*"].first => "{binary}"\n'
        f"  end\n"
        f"\n"
        f"  test do\n"
        f'    assert_match version.to_s, shell_output("#{{bin}}/{binary} --version 2>&1", 1)\n'
        f"  end\n"
        f"end\n"
    )
    return formula


def autoupdate_url(url, version):
    """Derive a Scoop autoupdate URL by replacing the version segment with $version.

    Handles both 'v1.2.3' and '1.2.3' in the URL path.
    """
    # Try v-prefixed first
    v_str = f"v{version}"
    if v_str in url:
        return url.replace(v_str, "v$version", 1)
    # Try bare version
    if version in url:
        return url.replace(version, "v$version", 1)
    return url


def render_bucket(info):
    """Render a Scoop Bucket .json file from package info.

    Args:
        info: Dict with keys: name, repo, description, homepage, license, binary, version,
              windows (dict of arch_key -> {url, hash, filename}).

    Returns:
        String content of the .json file.
    """
    w = info["windows"]
    repo = info["repo"]

    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key in w:
            entry = w[arch_key]
            architecture[arch_key] = {
                "url": entry["url"],
                "hash": entry["hash"],
            }
            autoupdate_arch[arch_key] = {
                "url": autoupdate_url(entry["url"], info["version"]),
            }

    # bin: use 64bit filename if available, else arm64
    bin_filename = w.get("64bit", w.get("arm64", {})).get("filename", "")

    bucket = {
        "version": info["version"],
        "description": info["description"],
        "homepage": info["homepage"],
        "license": info["license"],
        "architecture": architecture,
        "bin": [[bin_filename, info["binary"]]],
        "checkver": {
            "github": f"https://github.com/{repo}",
        },
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }
    return json.dumps(bucket, indent=2, ensure_ascii=False) + "\n"


def get_sha256_for_asset(url, filename, all_assets, checksum_assets, cache_dir, pkg_name, version, verbose):
    """Get SHA256 for an asset, trying checksum files first, then downloading."""
    # Try to find hash from checksum files in the release
    for cksum_asset in checksum_assets:
        cksum_url = cksum_asset["browser_download_url"]
        if verbose:
            print(f"  Trying checksum file: {cksum_asset['name']}")
        try:
            body = http_get(cksum_url)
            content = body.decode("utf-8", errors="replace")
            sha = parse_checksum_file(content, filename)
            if sha:
                if verbose:
                    print(f"  [checksum hit] {filename} = {sha}")
                write_cache(cache_dir, pkg_name, version, filename, sha)
                return sha
        except Exception:
            continue

    # Fallback: download and compute
    if verbose:
        print(f"  Downloading {filename} to compute SHA256...")
    import tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix=f"_{filename}") as tmp:
        tmp_path = tmp.name
        body = http_get(url)
        tmp.write(body)
    try:
        sha = compute_sha256(tmp_path)
        write_cache(cache_dir, pkg_name, version, filename, sha)
        return sha
    finally:
        os.unlink(tmp_path)


def process_package(pkg, cache_dir, skip_hash=False, verbose=False):
    """Process a single package: fetch release, compute hashes, render templates.

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
        Tuple of (formula_content, bucket_content).
        Either may be None if the package lacks assets for that format.
    """
    name = pkg["name"]
    token = os.environ.get("GITHUB_TOKEN")

    PLATFORM_KEYS = [
        "linux_amd64", "linux_arm64",
        "darwin_amd64", "darwin_arm64",
        "windows_amd64", "windows_arm64",
    ]

    platforms = {}  # platform_key -> {url, sha256}
    windows = {}    # arch_key -> {url, hash, filename}

    if "download_url" in pkg:
        # ── Custom download URL path ──────────────────────────────────
        version = pkg.get("version")
        if not version:
            print(f"  [error] {name}: 'download_url' present but 'version' field is missing")
            return None, None

        repo = pkg.get("repo", "")
        download_urls = pkg["download_url"]

        if verbose:
            print(f"  Using custom download URLs (v{version})")

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

    else:
        # ── GitHub release API path ───────────────────────────────────
        repo = pkg["repo"]

        if verbose:
            print(f"  Fetching latest release for {repo}...")

        version, all_assets, checksum_assets = fetch_latest_release(repo, token)
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

    # ── Common rendering logic ────────────────────────────────────

    # Render Formula (needs at least one macOS or Linux platform)
    darwin_linux = {k: v for k, v in platforms.items() if not k.startswith("windows_")}
    formula = None
    if darwin_linux:
        formula_info = {
            "name": name,
            "description": pkg["description"],
            "homepage": pkg["homepage"],
            "license": pkg["license"],
            "binary": pkg["binary"],
            "version": version,
            "platforms": darwin_linux,
        }
        formula = render_formula(formula_info)
    else:
        print(f"  [warn] {name}: no macOS/Linux assets, skipping Formula")

    # Render Bucket (needs at least one Windows platform)
    bucket = None
    if windows:
        bucket_info = {
            "name": name,
            "repo": repo,
            "description": pkg["description"],
            "homepage": pkg["homepage"],
            "license": pkg["license"],
            "binary": pkg["binary"],
            "version": version,
            "windows": windows,
        }
        bucket = render_bucket(bucket_info)
    else:
        print(f"  [warn] {name}: no Windows assets, skipping Bucket")

    return formula, bucket


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

    # Resolve paths relative to script location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_dir = os.path.dirname(script_dir)
    packages_dir = os.path.join(repo_dir, "packages")
    formula_dir = os.path.join(repo_dir, "Formula")
    bucket_dir = os.path.join(repo_dir, "bucket")
    cache_dir = os.path.join(repo_dir, ".cache")

    # Load packages
    pkgs = load_packages(packages_dir, only=args.only or None)
    if not pkgs:
        print("[error] No packages found.")
        sys.exit(1)

    print(f"Processing {len(pkgs)} package(s)...")

    has_errors = False

    for pkg in pkgs:
        name = pkg["name"]
        print(f"\n[{name}]")

        try:
            formula, bucket = process_package(pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose)
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_errors = True
            continue

        if formula is None and bucket is None:
            continue

        if args.dry_run:
            if formula:
                print(f"\n--- Formula/{name}.rb ---")
                print(formula)
            if bucket:
                print(f"\n--- bucket/{name}.json ---")
                print(bucket)
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

    print(f"\nDone. Processed {len(pkgs)} package(s).")
    if has_errors:
        print("Some packages had errors (see above).")
        sys.exit(2)


if __name__ == "__main__":
    main()
