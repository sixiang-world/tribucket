"""GitHub release fetching and HTTP/download layer for the tribucket generator."""
import json
import os
import subprocess
import sys
import time
import urllib.request
import urllib.error
import http.client

# Windows GBK console cannot encode the ✓/❌/⚠️ symbols used below
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf8"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


def parse_release(release_json):
    """Extract version, assets, and checksum assets from a GitHub release JSON."""
    # Lazy import: assets.py imports fetch_latest_release from this module at
    # module level, so importing is_checksum_asset here at module level would
    # create a circular import.
    from .assets import is_checksum_asset
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


def http_get(url, token=None, retries=5, timeout=30):
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
        except TimeoutError as e:
            # Read timeouts surface as bare TimeoutError (not URLError) on
            # some Python versions; retry them like any transient failure.
            last_err = e
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
    raise last_err


def _has_aria2():
    """Check if aria2c is available. Result is cached for subsequent calls."""
    if not hasattr(_has_aria2, "cached"):
        try:
            result = subprocess.run(["aria2c", "--version"], capture_output=True, text=True, check=True)
            ver = result.stdout.splitlines()[0] if result.stdout else "unknown"
            _has_aria2.cached = ver
        except (FileNotFoundError, subprocess.CalledProcessError):
            _has_aria2.cached = None
    return _has_aria2.cached


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
    aria2_ver = _has_aria2()
    if aria2_ver:
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

        start = time.monotonic()
        result = subprocess.run(cmd, capture_output=True, text=True)
        elapsed = time.monotonic() - start
        if result.returncode == 0 and os.path.exists(dest_path):
            fname = os.path.basename(dest_path)
            print(f"  {fname}  {elapsed:.1f}s")
            return True
        print(f"  [aria2] failed (rc={result.returncode}), falling back to urllib")

    # Fallback: urllib with retry
    fname = os.path.basename(dest_path)
    start = time.monotonic()
    body = http_get(url, token=token, timeout=120)
    elapsed = time.monotonic() - start
    with open(dest_path, "wb") as f:
        f.write(body)
    print(f"  {fname}  {elapsed:.1f}s")
    return True


def fetch_latest_release(repo, token=None):
    """Fetch the latest release from GitHub."""
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    body = http_get(url, token=token)
    release_json = json.loads(body)
    return parse_release(release_json)
