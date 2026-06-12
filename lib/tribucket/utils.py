"""Shared utilities: HTTP, SHA256, platform detection, verbose logging."""
import hashlib
import json
import os
import platform
import sys
import time
import urllib.error
import urllib.request


VERBOSE = os.environ.get("TRIBUCKET_VERBOSE", "0") == "1"


def log(msg):
    if VERBOSE:
        ts = time.strftime("%H:%M:%S")
        print(f"[{ts}] {msg}", file=sys.stderr)


def error(category, message, suggestion=None):
    print(f"Error: [{category}] {message}", file=sys.stderr)
    if suggestion:
        print(f"  → {suggestion}", file=sys.stderr)


def http_get(url, token=None, retries=3, timeout=30):
    """Fetch a URL with optional GitHub token and retry logic."""
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "Mozilla/5.0 (compatible; tribucket/2.0)",
    }
    if token:
        headers["Authorization"] = f"token {token}"

    req = urllib.request.Request(url, headers=headers)
    last_err = None
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(req, timeout=timeout) as resp:
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


def http_get_json(url, token=None, retries=3, timeout=30):
    """Fetch JSON from a URL."""
    body = http_get(url, token=token, retries=retries, timeout=timeout)
    return json.loads(body)


def compute_sha256(filepath):
    """Compute SHA256 hex digest of a file."""
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def detect_platform():
    """Detect current platform as linux_amd64, darwin_arm64, etc."""
    sys_name = platform.system().lower()
    machine = platform.machine().lower()

    os_map = {"linux": "linux", "darwin": "darwin", "windows": "windows"}
    os_key = os_map.get(sys_name)
    if not os_key:
        return None

    arch_map = {"x86_64": "amd64", "amd64": "amd64", "aarch64": "arm64", "arm64": "arm64"}
    arch_key = arch_map.get(machine)
    if not arch_key:
        return None

    return f"{os_key}_{arch_key}"


def extract_archive(archive_path, dest_dir):
    """Extract a tar.gz or zip archive to dest_dir."""
    import tarfile
    import zipfile

    if archive_path.endswith(".tar.gz") or archive_path.endswith(".tgz"):
        with tarfile.open(archive_path, "r:gz") as tar:
            tar.extractall(dest_dir)
    elif archive_path.endswith(".zip"):
        with zipfile.ZipFile(archive_path, "r") as zf:
            zf.extractall(dest_dir)
    else:
        raise ValueError(f"Unsupported archive format: {archive_path}")


def cleanup_old_tmp():
    """Remove temp dirs older than 24 hours."""
    import tempfile
    import shutil

    tmp_base = tempfile.gettempdir()
    now = time.time()
    try:
        for name in os.listdir(tmp_base):
            if name.startswith("tribucket-"):
                path = os.path.join(tmp_base, name)
                if os.path.isdir(path):
                    age = now - os.path.getmtime(path)
                    if age > 86400:
                        shutil.rmtree(path, ignore_errors=True)
                        log(f"Cleaned up old temp dir: {path}")
    except OSError:
        pass
