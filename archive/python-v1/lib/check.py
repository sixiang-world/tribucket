"""Version detection engine."""
import json
import os
import re
import subprocess
import sys
import threading

from tribucket.config import load_json, versions_cache_path
from tribucket.utils import (
    http_get_json, log, find_tribucket_json,
)
from tribucket.config import save_json

_cache_lock = threading.Lock()


def detect_version(binary_path, tribucket_json, config_info=None):
    """Detect local version using priority chain.

    Returns (version_string, source) where source is 'cli', 'config', or 'fallback'.
    """
    vc = tribucket_json.get("version_check", {})
    cli_flags = vc.get("cli_flags", ["--version"])
    parse_regex = vc.get("parse_regex", r"v?(\d+\.\d+(?:\.\d+)?)")
    output_stream = vc.get("output_stream", "stdout")
    timeout = vc.get("timeout", 5)

    # 1. Try CLI
    if os.path.isfile(binary_path) and os.access(binary_path, os.X_OK):
        for flag in cli_flags:
            ver = _run_version_command(binary_path, flag, parse_regex, output_stream, timeout)
            if ver:
                return ver, "cli"

    # 2. Try config.json version
    if config_info and config_info.get("version") and config_info["version"] != "unknown":
        return config_info["version"], "config"

    # 3. Fallback to tribucket.json
    fallback = tribucket_json.get("version") or vc.get("fallback_version") or "unknown"
    return fallback, "fallback"


def _run_version_command(binary_path, flag, parse_regex, output_stream, timeout):
    """Run a binary with a version flag and extract version from output."""
    try:
        result = subprocess.run(
            [binary_path, flag],
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except (subprocess.TimeoutExpired, OSError, PermissionError):
        return None

    # Select output stream
    if output_stream == "stderr":
        text = result.stderr
    elif output_stream == "both":
        text = result.stdout + result.stderr
    else:
        text = result.stdout

    # Extract version
    match = re.search(parse_regex, text)
    if match:
        return match.group(1) if match.lastindex else match.group(0)
    return None


def check_remote_version(repo, token=None, cache=True, include_prerelease=False):
    """Get the latest remote version from GitHub API.

    Returns version string or None if unavailable.
    """
    # Check cache
    if cache:
        cached = _get_cached_remote_version(repo)
        if cached:
            log(f"Remote version (cached): {cached}")
            return cached

    if not repo:
        return None

    try:
        if include_prerelease:
            # /releases/latest excludes prereleases; use /releases and pick first
            data = http_get_json(
                f"https://api.github.com/repos/{repo}/releases",
                token=token,
            )
            if data and isinstance(data, list) and len(data) > 0:
                tag = data[0].get("tag_name", "")
            else:
                return None
        else:
            data = http_get_json(
                f"https://api.github.com/repos/{repo}/releases/latest",
                token=token,
            )
            tag = data.get("tag_name", "")

        version = tag.lstrip("v")
        if version and cache:
            _save_remote_version_cache(repo, version)
        return version
    except Exception as e:
        log(f"Failed to fetch remote version for {repo}: {e}")
        return None


def format_check_result(name, local_ver, local_source, remote_ver, path_exists=True):
    """Format a single package check result."""
    if not path_exists:
        return f"{name:20s}  ✗ not found"

    status = ""
    if remote_ver is None:
        status = "? offline"
    elif local_ver == remote_ver:
        status = "✓ latest"
    else:
        status = f"⚠ {local_ver} → {remote_ver}"

    return f"{name:20s}  {local_ver:12s} ({local_source:8s})  {status}"


def check_package(name_or_path, refresh=False, local_only=False):
    """Check a single package. Returns dict with check results."""
    from tribucket.track import get_all_packages

    # If it's a path
    if os.path.sep in name_or_path or name_or_path.startswith("."):
        return _check_path(name_or_path)

    # If it's a package name
    packages = get_all_packages()
    if name_or_path in packages:
        info = packages[name_or_path]
        return _check_tracked(name_or_path, info, refresh=refresh, local_only=local_only)

    # Try partial match
    for repo_key, info in packages.items():
        if info.get("name") == name_or_path:
            return _check_tracked(name_or_path, info, refresh=refresh, local_only=local_only)

    return {"name": name_or_path, "error": f"Package '{name_or_path}' not found"}


def _check_tracked(name, info, refresh=False, local_only=False):
    """Check a tracked package."""
    path = info.get("path", "")
    path_exists = os.path.exists(path)

    if not path_exists:
        return {
            "name": name,
            "path": path,
            "path_exists": False,
            "local": "not found",
            "local_source": "none",
            "remote": None,
            "status": "error",
        }

    # Find tribucket.json
    tj = find_tribucket_json(path)
    if not tj:
        # Try to detect version directly from binary
        binary = info.get("name", name)
        binary_path = os.path.join(path, binary)
        if not os.path.exists(binary_path):
            binary_path = path  # maybe path IS the binary

        local_ver, source = _detect_simple(binary_path)
        remote_ver = None
        if not local_only:
            repo = info.get("repo", "")
            if repo:
                token = os.environ.get("GITHUB_TOKEN")
                remote_ver = check_remote_version(repo, token=token, cache=not refresh)

        return {
            "name": name,
            "path": path,
            "path_exists": True,
            "local": local_ver,
            "local_source": source,
            "remote": remote_ver,
            "status": _compute_status(local_ver, remote_ver),
        }

    return _check_with_tribucket_json(name, path, tj, info, refresh, local_only)


def _check_with_tribucket_json(name, path, tj, info, refresh, local_only):
    """Check using tribucket.json metadata."""
    binary_name = tj.get("binary", name)
    install_type = tj.get("install_type", "binary")

    if install_type == "directory":
        binary_path = _find_binary_in_dir(path, binary_name)
    else:
        binary_path = os.path.join(path, binary_name)

    if not binary_path or not os.path.exists(binary_path):
        binary_path = os.path.join(path, binary_name)

    local_ver, source = detect_version(binary_path, tj, info)

    remote_ver = None
    if not local_only:
        token = os.environ.get("GITHUB_TOKEN")
        include_prerelease = tj.get("version_check", {}).get("include_prerelease", False)
        repo = tj.get("repo", "")

        if repo:
            remote_ver = check_remote_version(
                repo, token=token, cache=not refresh,
                include_prerelease=include_prerelease,
            )
        elif tj.get("download_url"):
            # download_url packages: try HEAD request to check if URL is reachable
            remote_ver = _check_download_url_reachable(tj, local_ver)

    return {
        "name": name,
        "path": path,
        "path_exists": True,
        "local": local_ver,
        "local_source": source,
        "remote": remote_ver,
        "status": _compute_status(local_ver, remote_ver),
    }


def _check_download_url_reachable(tj, local_ver):
    """For download_url packages: try HEAD request to check if download URL is reachable.

    Returns local_ver (to indicate 'cannot determine remote version')
    or a version string if URL contains version info.
    """
    import urllib.request
    download_url = tj.get("download_url", {})
    plat = detect_platform()
    url = download_url.get(plat, "")
    if not url:
        # Try any platform
        for v in download_url.values():
            if v and v != "NO_MATCH":
                url = v
                break
    if not url:
        return None

    try:
        req = urllib.request.Request(url, method="HEAD")
        req.add_header("User-Agent", "tribucket/2.0")
        with urllib.request.urlopen(req, timeout=5) as resp:
            if resp.status < 400:
                # URL is reachable, but we can't determine version from HEAD
                # Return local_ver to indicate "download available, same version"
                return local_ver
    except Exception:
        pass
    return None


def _check_path(path):
    """Check a bare binary path."""
    if not os.path.exists(path):
        return {"name": os.path.basename(path), "path": path, "error": "Path not found"}

    tj = {
        "version_check": {
            "cli_flags": ["--version", "-v", "-V"],
            "parse_regex": r"v?(\d+\.\d+(?:\.\d+)?)",
            "output_stream": "stdout",
            "timeout": 5,
        }
    }
    ver, source = detect_version(path, tj)
    return {
        "name": os.path.basename(path),
        "path": path,
        "path_exists": True,
        "local": ver,
        "local_source": source,
        "remote": None,
        "status": "unknown",
    }


def _detect_simple(binary_path):
    """Simple version detection without tribucket.json."""
    tj = {
        "version_check": {
            "cli_flags": ["--version"],
            "parse_regex": r"v?(\d+\.\d+(?:\.\d+)?)",
            "output_stream": "stdout",
            "timeout": 5,
        }
    }
    return detect_version(binary_path, tj)


def _find_binary_in_dir(path, binary_pattern):
    """Find a binary file in a directory tree."""
    import glob
    direct = os.path.join(path, binary_pattern)
    if os.path.exists(direct):
        return direct
    matches = glob.glob(os.path.join(path, "**", binary_pattern), recursive=True)
    return matches[0] if matches else None


def _compute_status(local_ver, remote_ver):
    if remote_ver is None:
        return "unknown"
    if local_ver == remote_ver:
        return "latest"
    return "outdated"


def _get_cached_remote_version(repo):
    """Get cached remote version if still valid."""
    cache = load_json(versions_cache_path(), {})
    entry = cache.get(repo, {})
    if not entry:
        return None

    from datetime import datetime, timezone, timedelta
    checked_at = entry.get("checked_at", "")
    ttl = entry.get("ttl_seconds", 3600)
    try:
        dt = datetime.fromisoformat(checked_at)
        if datetime.now(timezone.utc) - dt < timedelta(seconds=ttl):
            return entry.get("remote_version")
    except (ValueError, TypeError):
        pass
    return None


def _save_remote_version_cache(repo, version):
    """Cache a remote version result (thread-safe)."""
    from datetime import datetime, timezone
    with _cache_lock:
        cache = load_json(versions_cache_path(), {})
        cache[repo] = {
            "remote_version": version,
            "checked_at": datetime.now(timezone.utc).isoformat(),
            "ttl_seconds": 3600,
        }
        save_json(versions_cache_path(), cache)
