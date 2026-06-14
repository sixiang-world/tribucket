#!/usr/bin/env python3
"""tribucket generator — produces Formula/*.rb, bucket/*.json, and portable/ templates from packages/*.json.

Usage:
    python scripts/generate.py [--only NAME ...] [--skip-hash] [--dry-run] [--verbose]
    python scripts/generate.py --portable [--only NAME ...]
"""
import argparse
import hashlib
import json
import os
import sys
import time
import urllib.request
import urllib.error
import http.client
import subprocess
import tempfile
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


def http_get(url, token=None, retries=3, timeout=30):
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
            with _opener.open(req, timeout=timeout) as resp:
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
        except http.client.HTTPException as e:
            last_err = e
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
    raise last_err


def _has_aria2():
    """Check if aria2c is available."""
    try:
        subprocess.run(["aria2c", "--version"], capture_output=True, check=True)
        return True
    except (FileNotFoundError, subprocess.CalledProcessError):
        return False


def download_file(url, dest_path, token=None, verbose=False):
    """Download a file using aria2c (multi-connection + retry) with urllib fallback.

    aria2c settings:
      -x 16: 16 connections per server
      -s 16: 16 splits
      -k 10M: minimum split size 10MB
      --retry-wait=2: 2s wait between retries
      --max-tries=5: retry up to 5 times
      --continue=true: resume partial downloads
    """
    if _has_aria2():
        cmd = [
            "aria2c",
            "-x", "16",
            "-s", "16",
            "-k", "10M",
            "--retry-wait=2",
            "--max-tries=5",
            "--continue=true",
            "--console-log-level=warn",
            "--summary-interval=0",
            "-d", os.path.dirname(dest_path),
            "-o", os.path.basename(dest_path),
        ]
        if token:
            cmd.append(f"--header=Authorization: token {token}")
        cmd.append(url)

        if verbose:
            print(f"  [aria2] downloading with 16 connections...")
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0 and os.path.exists(dest_path):
            if verbose:
                print(f"  [aria2] download complete")
            return True
        if verbose:
            print(f"  [aria2] failed (rc={result.returncode}), falling back to urllib")

    # Fallback: urllib with retry
    body = http_get(url, token=token, timeout=120)
    with open(dest_path, "wb") as f:
        f.write(body)
    return True


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


def render_bucket(info, is_download_url=False):
    """Render a Scoop Bucket .json file from package info.

    Args:
        info: Dict with keys: name, repo, description, homepage, license,
              binary, version, windows (dict of arch_key -> {url, hash, filename}).
        is_download_url: If True, use the download_url checkver pattern
                         instead of the default GitHub checkver.
    """
    w = info["windows"]
    repo = info.get("repo", "")

    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key in w:
            entry = w[arch_key]
            architecture[arch_key] = {
                "url": entry["url"],
                "hash": entry["hash"],
            }
            if is_download_url:
                autoupdate_arch[arch_key] = {
                    "url": entry["url"],
                }
            else:
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
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }

    if is_download_url:
        # Download_url packages: omit checkver since Scoop's PowerShell-based
        # checkver can't be auto-generated from Python regex/jsonpath config.
        # Scoop will use the hardcoded version; users configure checkver manually.
        pass
    else:
        bucket["checkver"] = {
            "github": f"https://github.com/{repo}",
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
    tmp_path = os.path.join(tempfile.gettempdir(), f"tribucket_{pkg_name}_{filename}")
    try:
        download_file(url, tmp_path, verbose=verbose)
        sha = compute_sha256(tmp_path)
        write_cache(cache_dir, pkg_name, version, filename, sha)
        return sha
    finally:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass


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
        hardcoded_version = pkg.get("version")
        if not hardcoded_version:
            print(f"  [error] {name}: 'download_url' present but 'version' field is missing")
            return None, None, None, None

        repo = pkg.get("repo", "")
        download_urls = pkg["download_url"]

        # 1. Run checkver to detect latest version
        from checkver import run_checkver, apply_autoupdate, in_place_replace
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

    else:
        # ── GitHub release API path ───────────────────────────────────
        version_changed = False
        new_download_urls_for_writeback = None

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
        bucket = render_bucket(bucket_info, is_download_url=("download_url" in pkg))
    else:
        print(f"  [warn] {name}: no Windows assets, skipping Bucket")

    return formula, bucket, \
           (latest_version if version_changed else None), \
            new_download_urls_for_writeback


# infer_asset_format imported from tribucket.utils (avoids duplication)
import sys as _sys
_lib_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib")
if _lib_dir not in _sys.path:
    _sys.path.insert(0, _lib_dir)
from tribucket.utils import infer_asset_format


def infer_install_type(pkg):
    """Determine install_type from package name conventions.

    JDK/GraalVM packages extract to a directory; everything else is single binary.
    """
    DIRECTORY_NAMES = (
        "corretto-jdk", "temurin-jdk", "zulu-jdk", "liberica-jdk",
        "microsoft-jdk", "sapmachine-jdk", "dragonwell-jdk", "graalvm-ce-jdk",
        "tencent-kona-jdk",
    )
    name = pkg["name"]
    if any(name.startswith(j) for j in DIRECTORY_NAMES):
        return "directory"
    return "binary"


def derive_tribucket_json(pkg, version=None):
    """Derive tribucket.json from packages/*.json fields."""
    name = pkg["name"]
    ver = version or pkg.get("version", "0.0.0")
    repo = pkg.get("repo", "")
    homepage = pkg.get("homepage", f"https://github.com/{repo}" if repo else "")

    # Version check defaults
    vc = pkg.get("version_check", {})
    cli_flags = vc.get("cli_flags", ["--version"])
    parse_regex = vc.get("parse_regex", r"v?(\d+\.\d+(?:\.\d+)?)")
    output_stream = vc.get("output_stream", "stdout")
    timeout = vc.get("timeout", 5)

    # Install type
    install_type = pkg.get("install_type") or infer_install_type(pkg)

    # Binary field: for directory type, use relative pattern
    binary = pkg.get("binary", name)

    tribucket = {
        "name": name,
        "version": ver,
        "repo": repo,
        "description": pkg.get("description", ""),
        "binary": binary,
        "homepage": homepage,
        "license": pkg.get("license", "Unknown"),
        "version_check": {
            "cli_flags": cli_flags,
            "parse_regex": parse_regex,
            "output_stream": output_stream,
            "timeout": timeout,
            "fallback_version": ver,
        },
        "asset_pattern": pkg.get("asset_pattern", {}),
        "asset_format": infer_asset_format(pkg.get("asset_pattern", {})),
        "install_type": install_type,
        "mirror": {"enabled": True},
    }

    # Optional fields
    if pkg.get("download_url"):
        tribucket["download_url"] = pkg["download_url"]
    if vc.get("include_prerelease"):
        tribucket["version_check"]["include_prerelease"] = True

    return tribucket


def render_install_sh(pkg, tribucket_json):
    """Render the install.sh script for a portable package.

    Uses tribucket CLI when available, falls back to standalone mode.
    """
    name = tribucket_json["name"]
    repo = tribucket_json["repo"]
    binary = tribucket_json["binary"]
    fallback_version = tribucket_json["version_check"]["fallback_version"]

    lines = [
        "#!/usr/bin/env bash",
        "set -euo pipefail",
        "",
        f"# === tribucket auto-generated install.sh ===",
        f"# Package: {name}",
        f"# Repo: {repo}",
        f"# Do not edit — regenerate with: python scripts/generate.py --only {name}",
        "",
        'SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"',
        f'BINARY="$SCRIPT_DIR/{binary}"',
        f'REPO="{repo}"',
        f'NAME="{name}"',
        "",
        "# --- 如果 tribucket CLI 可用，委托给它 ---",
        'if command -v tribucket &>/dev/null; then',
        '    case "${1:-check}" in',
        "        check|status)",
        '            tribucket check "$NAME"',
        "            ;;",
        "        update|upgrade)",
        '            tribucket update "$NAME"',
        "            ;;",
        "        install)",
        '            tribucket install "$NAME" --dir "$SCRIPT_DIR" --force',
        "            ;;",
        "        *)",
        f'            echo "Usage: $0 [check|update|install]"',
        '            echo "  check   — 查看版本信息"',
        '            echo "  update  — 更新到最新版（带备份）"',
        '            echo "  install — 强制重新安装"',
        "            echo \"\"",
        '            echo "Or use tribucket directly:"',
        f'            echo "  tribucket check $NAME"',
        f'            echo "  tribucket update $NAME"',
        "            exit 1",
        "            ;;",
        "    esac",
        "    exit $?",
        "fi",
        "",
        "# --- tribucket CLI 不可用：最小化 fallback ---",
        'echo "tribucket CLI not found. Running in standalone mode."',
        'echo "For full features (backup, resume, mirror), install tribucket:"',
        'echo "  curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash"',
        "echo \"\"",
        "",
        "# 检测本地版本",
        "detect_version() {",
        '    if [ -x "$BINARY" ]; then',
        '        "$BINARY" --version 2>&1 | grep -oP \'v?\\d+\\.\\d+(?:\\.\\d+)?\' | head -1',
        "    else",
        '        echo ""',
        "    fi",
        "}",
        "",
        "# 查远程版本",
        "check_remote() {",
        f'    curl -sf "https://api.github.com/repos/$REPO/releases/latest" \\',
        '        | grep -oP \'"tag_name":\\s*"\\K[^\"]+\' | sed \'s/^v//\' 2>/dev/null || echo ""',
        "}",
        "",
        "LOCAL=$(detect_version)",
        "REMOTE=$(check_remote)",
        "",
        'echo "Package: $NAME"',
        'echo "Local:   ${LOCAL:-not installed}"',
        'echo "Remote:  ${REMOTE:-unknown}"',
        "",
        'if [ -z "$LOCAL" ]; then',
        '    echo ""',
        '    echo "Binary not found. Install tribucket for automatic setup:"',
        '    echo "  curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash"',
        "    exit 1",
        "fi",
        "",
        'if [ -z "$REMOTE" ]; then',
        '    echo "Status:  ? unable to check remote"',
        "    exit 0",
        "fi",
        "",
        'if [ "$LOCAL" = "$REMOTE" ]; then',
        '    echo "Status:  ✓ up to date"',
        "    exit 0",
        "fi",
        "",
        'echo "Status:  ⚠ update available ($LOCAL → $REMOTE)"',
        "echo \"\"",
        'echo "For backup-safe updates, install tribucket CLI."',
        f'echo "Or update manually from: https://github.com/{repo}/releases"',
        "",
    ]
    return "\n".join(lines)


def render_bat(pkg):
    """Render the .bat entry point for a portable package."""
    name = pkg["name"]
    binary = pkg.get("binary", name)
    # Windows binary typically has .exe suffix
    win_binary = binary if binary.endswith(".exe") else f"{binary}.exe"

    lines = [
        "@echo off",
        "REM Auto-generated by generate.py — do not edit",
        f"REM Package: {name}",
        "",
        "SET SCRIPT_DIR=%~dp0",
        f'SET BINARY=%SCRIPT_DIR%{win_binary}',
        "",
        f'if not exist "%BINARY%" (',
        f'    echo Error: %BINARY% not found.',
        f'    echo Please install with: tribucket install {name}',
        "    exit /b 1",
        ")",
        "",
        '"%BINARY%" --version',
        "if %ERRORLEVEL% neq 0 (",
        '    echo Error: Failed to run %BINARY%',
        "    exit /b 1",
        ")",
        "",
        "echo.",
        f"echo To update, run: tribucket update {name}",
        f"echo Or visit: https://github.com/{pkg.get('repo', '')}/releases",
    ]
    return "\n".join(lines)


def generate_portable(pkg, output_dir, dry_run=False, verbose=False):
    """Generate portable/<name>/ directory from packages/*.json.

    Creates:
      - tribucket.json (derived metadata)
      - install.sh (tribucket CLI proxy + standalone fallback)
      - cmd/tribucket-update.bat (Windows entry point)

    Args:
        pkg: Package dict from packages/*.json.
        output_dir: Root output directory (e.g. repo_root/portable).
        dry_run: If True, print content to stdout instead of writing.
        verbose: Print progress.

    Returns:
        True if portable files were generated, False on error.
    """
    name = pkg["name"]
    version = pkg.get("version", "0.0.0")

    tribucket_json = derive_tribucket_json(pkg, version)
    install_sh = render_install_sh(pkg, tribucket_json)
    bat_content = render_bat(pkg)

    if dry_run:
        print(f"\n--- portable/{name}/tribucket.json ---")
        print(json.dumps(tribucket_json, indent=2, ensure_ascii=False))
        print(f"\n--- portable/{name}/install.sh ---")
        print(install_sh)
        print(f"\n--- portable/{name}/cmd/tribucket-update.bat ---")
        print(bat_content)
        return True

    portable_dir = os.path.join(output_dir, name)
    os.makedirs(portable_dir, exist_ok=True)

    # tribucket.json
    path = os.path.join(portable_dir, "tribucket.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(tribucket_json, f, indent=2, ensure_ascii=False)
        f.write("\n")
    if verbose:
        print(f"  -> portable/{name}/tribucket.json")

    # install.sh
    path = os.path.join(portable_dir, "install.sh")
    with open(path, "w", encoding="utf-8") as f:
        f.write(install_sh)
    os.chmod(path, 0o755)
    if verbose:
        print(f"  -> portable/{name}/install.sh")

    # cmd/tribucket-update.bat
    cmd_dir = os.path.join(portable_dir, "cmd")
    os.makedirs(cmd_dir, exist_ok=True)
    path = os.path.join(cmd_dir, "tribucket-update.bat")
    with open(path, "w", encoding="utf-8") as f:
        f.write(bat_content)
    if verbose:
        print(f"  -> portable/{name}/cmd/tribucket-update.bat")

    return True


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
