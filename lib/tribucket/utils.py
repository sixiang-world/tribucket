"""Shared utilities: HTTP, SHA256, platform detection, verbose logging, common helpers."""
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


# ── Exit codes ──────────────────────────────────────────────────

EXIT_OK = 0
EXIT_ERROR = 1
EXIT_USAGE = 2
EXIT_NOT_FOUND = 3
EXIT_EXISTS = 4
EXIT_NOT_TRACKED = 5
EXIT_UP_TO_DATE = 6
EXIT_NO_NETWORK = 7


# ── HTTP ────────────────────────────────────────────────────────

def http_get(url, token=None, retries=3, timeout=30):
    """Fetch a URL with optional token, retry with exponential backoff.

    Sets GitHub Accept header only for github.com/api.github.com URLs.
    """
    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; tribucket/2.0)",
    }
    # Only set GitHub-specific header for GitHub URLs
    if "github.com" in url:
        headers["Accept"] = "application/vnd.github.v3+json"
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
                log(f"HTTP {e.code}, retrying ({attempt + 1}/{retries})...")
                time.sleep(2 ** attempt)
                continue
            raise
        except urllib.error.URLError as e:
            last_err = e
            if attempt < retries - 1:
                log(f"Network error, retrying ({attempt + 1}/{retries})...")
                time.sleep(2 ** attempt)
                continue
            raise
    raise last_err


def http_get_json(url, token=None, retries=3, timeout=30):
    """Fetch JSON from a URL."""
    body = http_get(url, token=token, retries=retries, timeout=timeout)
    return json.loads(body)


# ── SHA256 ──────────────────────────────────────────────────────

def compute_sha256(filepath):
    """Compute SHA256 hex digest of a file."""
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


# ── Platform ────────────────────────────────────────────────────

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


# ── Archive ─────────────────────────────────────────────────────

def extract_archive(archive_path, dest_dir):
    """Extract an archive to dest_dir with zip-slip protection."""
    import tarfile
    import zipfile

    dest_dir = os.path.realpath(dest_dir)

    if archive_path.endswith((".tar.gz", ".tgz")):
        with tarfile.open(archive_path, "r:gz") as tar:
            # Zip-slip protection: validate all members
            for member in tar.getmembers():
                member_path = os.path.realpath(os.path.join(dest_dir, member.name))
                if not member_path.startswith(dest_dir + os.sep) and member_path != dest_dir:
                    raise ValueError(f"Archive contains path traversal: {member.name}")
            tar.extractall(dest_dir)

    elif archive_path.endswith((".tar.bz2", ".tbz2")):
        with tarfile.open(archive_path, "r:bz2") as tar:
            for member in tar.getmembers():
                member_path = os.path.realpath(os.path.join(dest_dir, member.name))
                if not member_path.startswith(dest_dir + os.sep) and member_path != dest_dir:
                    raise ValueError(f"Archive contains path traversal: {member.name}")
            tar.extractall(dest_dir)

    elif archive_path.endswith((".tar.xz", ".txz")):
        with tarfile.open(archive_path, "r:xz") as tar:
            for member in tar.getmembers():
                member_path = os.path.realpath(os.path.join(dest_dir, member.name))
                if not member_path.startswith(dest_dir + os.sep) and member_path != dest_dir:
                    raise ValueError(f"Archive contains path traversal: {member.name}")
            tar.extractall(dest_dir)

    elif archive_path.endswith(".zip"):
        with zipfile.ZipFile(archive_path, "r") as zf:
            for info in zf.infolist():
                member_path = os.path.realpath(os.path.join(dest_dir, info.filename))
                if not member_path.startswith(dest_dir + os.sep) and member_path != dest_dir:
                    raise ValueError(f"Archive contains path traversal: {info.filename}")
            zf.extractall(dest_dir)

    else:
        raise ValueError(f"Unsupported archive format: {archive_path}")


# ── tribucket.json ──────────────────────────────────────────────

def find_tribucket_json(path):
    """Find and load tribucket.json in a directory."""
    tj_path = os.path.join(path, "tribucket.json")
    if os.path.isfile(tj_path):
        try:
            with open(tj_path, encoding="utf-8") as f:
                return json.load(f)
        except (json.JSONDecodeError, OSError):
            pass
    return None


# ── Download ────────────────────────────────────────────────────

def download_file(url, dest_dir):
    """Download a file to dest_dir with progress and resume support. Returns file path or None."""
    filename = url.split("/")[-1].split("?")[0]
    dest_path = os.path.join(dest_dir, filename)

    log(f"Downloading {filename}...")

    existing_size = 0
    if os.path.exists(dest_path):
        existing_size = os.path.getsize(dest_path)

    try:
        req = urllib.request.Request(url, headers={
            "User-Agent": "Mozilla/5.0 (compatible; tribucket/2.0)",
        })
        if existing_size > 0:
            req.add_header("Range", f"bytes={existing_size}-")

        with urllib.request.urlopen(req, timeout=120) as resp:
            code = resp.getcode()
            if code == 206:
                mode = "ab"
                downloaded = existing_size
                total = int(resp.headers.get("Content-Length", 0)) + existing_size
                log(f"Resuming from {existing_size} bytes")
            elif code == 200 and existing_size > 0:
                mode = "wb"
                downloaded = 0
                total = int(resp.headers.get("Content-Length", 0))
                log("Server doesn't support resume, restarting download")
            else:
                mode = "wb"
                downloaded = 0
                total = int(resp.headers.get("Content-Length", 0))

            chunk_size = 8192
            with open(dest_path, mode) as f:
                while True:
                    chunk = resp.read(chunk_size)
                    if not chunk:
                        break
                    f.write(chunk)
                    downloaded += len(chunk)

                    if total > 0 and sys.stdout.isatty():
                        pct = downloaded * 100 // total
                        mb = downloaded / (1024 * 1024)
                        total_mb = total / (1024 * 1024)
                        sys.stdout.write(f"\r  {pct:3d}% ({mb:.1f}/{total_mb:.1f} MB)")
                        sys.stdout.flush()

            if total > 0 and sys.stdout.isatty():
                sys.stdout.write("\r" + " " * 50 + "\r")
                sys.stdout.flush()

        size_mb = os.path.getsize(dest_path) / (1024 * 1024)
        log(f"Download complete: {size_mb:.1f} MB")
        return dest_path
    except Exception as e:
        log(f"Download failed: {e}")
        return None


# ── Asset format inference ──────────────────────────────────────

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


# ── Cleanup ─────────────────────────────────────────────────────

def cleanup_old_tmp():
    """Remove temp dirs older than 24 hours."""
    import shutil
    import tempfile

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
