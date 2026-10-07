"""SHA256 computation, checksum parsing, and hash caching for the tribucket generator."""
import hashlib, os, tempfile, urllib.error, http.client

from .release import http_get, download_file


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
        if len(parts) >= 2 and parts[-1] == target_filename:
            return parts[0].lower()
    return None


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
        except (urllib.error.URLError, http.client.HTTPException, urllib.error.HTTPError):
            continue

    # Fallback: download and compute
    if verbose:
        print(f"  Downloading {filename} to compute SHA256...")
    # Put the temp file inside a per-package subdir (instead of a flat
    # "tribucket_{pkg}_{filename}" name) so the download progress log shows the
    # REAL asset name, not a confusing prefixed temp name.
    tmp_dir = os.path.join(tempfile.gettempdir(), "tribucket", pkg_name, version or "0")
    os.makedirs(tmp_dir, exist_ok=True)
    # filename is URL-derived; defensively strip any path separators so a
    # malicious or malformed URL cannot escape tmp_dir.
    filename = filename.replace("\\", "/").rsplit("/", 1)[-1]
    tmp_path = os.path.join(tmp_dir, filename)
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
