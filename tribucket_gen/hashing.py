"""SHA256 computation, checksum parsing, and hash caching for the tribucket generator."""
import hashlib
import http.client
import json
import os
import re
import tempfile
import urllib.error

from .release import http_get, download_file


_SHA256_RE = re.compile(r"[0-9a-fA-F]{64}")
_FORMULA_VERSION_RE = re.compile(r'^  version "([^"\n]+)"[ \t]*$', re.MULTILINE)
_FORMULA_HASH_RE = re.compile(
    r'^([ \t]+)url "([^"\n]+)"[ \t]*\n\1sha256 "([0-9a-fA-F]{64})"[ \t]*$',
    re.MULTILINE,
)


def load_generated_hashes(cache_dir, pkg_name):
    """Read (version, URL) hashes from the render outputs beside .cache."""
    root = os.path.dirname(os.path.abspath(cache_dir))
    hashes = {}

    def record(version, url, sha):
        if not isinstance(version, str) or not isinstance(url, str):
            return
        if isinstance(sha, str) and _SHA256_RE.fullmatch(sha):
            key = (version, url)
            if key not in hashes:
                hashes[key] = sha
            elif hashes[key] and hashes[key].lower() != sha.lower():
                hashes[key] = None

    try:
        with open(os.path.join(root, "bucket", pkg_name + ".json"), encoding="utf-8") as f:
            manifest = json.load(f)
    except (OSError, ValueError):
        manifest = {}
    if isinstance(manifest, dict):
        version = manifest.get("version")
        record(version, manifest.get("url"), manifest.get("hash"))
        arches = manifest.get("architecture", {})
        if isinstance(arches, dict):
            for entry in arches.values():
                if isinstance(entry, dict):
                    record(version, entry.get("url"), entry.get("hash"))

    try:
        with open(os.path.join(root, "Formula", pkg_name + ".rb"), encoding="utf-8") as f:
            formula = f.read()
    except (OSError, UnicodeError):
        return hashes
    versions = _FORMULA_VERSION_RE.findall(formula)
    if len(versions) == 1:
        for _, url, sha in _FORMULA_HASH_RE.findall(formula):
            record(versions[0], url, sha)
    return hashes


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
    """Get SHA256 from its URL cache entry, a checksum file, or the asset."""
    # Older filename-only keys cannot distinguish URLs with the same basename.
    cache_dir = os.path.join(cache_dir, "by-url")
    cache_key = hashlib.sha256(url.encode("utf-8")).hexdigest()
    cached = get_cached_hash(cache_dir, pkg_name, version, cache_key)
    if cached and _SHA256_RE.fullmatch(cached):
        if verbose:
            print(f"  [cache hit] {filename}")
        return cached

    # Try to find hash from checksum files in the release
    for cksum_asset in checksum_assets:
        cksum_url = cksum_asset["browser_download_url"]
        if verbose:
            print(f"  Trying checksum file: {cksum_asset['name']}")
        try:
            body = http_get(cksum_url)
            content = body.decode("utf-8", errors="replace")
            sha = parse_checksum_file(content, filename)
            if sha and _SHA256_RE.fullmatch(sha):
                if verbose:
                    print(f"  [checksum hit] {filename} = {sha}")
                write_cache(cache_dir, pkg_name, version, cache_key, sha)
                return sha
        except (urllib.error.URLError, http.client.HTTPException, urllib.error.HTTPError):
            continue

    # Fallback: download and compute
    if verbose:
        print(f"  Downloading {filename} to compute SHA256...")
    filename = filename.replace("\\", "/").rsplit("/", 1)[-1]
    if filename in ("", ".", ".."):
        filename = "asset"
    with tempfile.TemporaryDirectory(prefix="tribucket-") as tmp_dir:
        tmp_path = os.path.join(tmp_dir, filename)
        download_file(url, tmp_path, verbose=verbose)
        sha = compute_sha256(tmp_path)
    write_cache(cache_dir, pkg_name, version, cache_key, sha)
    return sha
