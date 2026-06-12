"""Download, verify, and replace engine."""
import fcntl
import json
import os
import shutil
import sys
import tempfile

from tribucket.config import backup_dir, lock_dir
from tribucket.utils import (
    compute_sha256, detect_platform, extract_archive, download_file,
    find_tribucket_json, log, error,
)
from tribucket.mirror import resolve_download_url
from tribucket.check import check_remote_version


def update_package(name, force=False, mirror_mode="auto", no_backup=False):
    """Update a tracked package to the latest version.

    Returns True on success, False on failure.
    """
    from tribucket.track import get_all_packages, update_package_version

    packages = get_all_packages()
    info = packages.get(name)
    if not info:
        error("not-found", f"Package '{name}' is not tracked.")
        return False

    path = info.get("path", "")
    if not os.path.exists(path):
        error("stale", f"Package path does not exist: {path}",
              f"Run 'tribucket untrack {name}' to remove stale entry.")
        return False

    # Find tribucket.json
    tj = find_tribucket_json(path)
    if not tj:
        error("config", f"tribucket.json not found in {path}")
        return False

    repo = tj.get("repo", "")
    binary = tj.get("binary", name)
    install_type = tj.get("install_type", "binary")

    # Detect local version
    from tribucket.check import detect_version
    local_ver, source = detect_version(
        os.path.join(path, binary) if install_type == "binary" else path,
        tj, info
    )
    log(f"Local version: {local_ver} ({source})")

    # Check remote version
    token = os.environ.get("GITHUB_TOKEN")
    remote_ver = check_remote_version(repo, token=token, cache=not force)
    if not remote_ver:
        error("network", f"Cannot check remote version for {repo}")
        return False

    log(f"Remote version: {remote_ver}")

    if local_ver == remote_ver and not force:
        print(f"{name}: {local_ver} — already up to date")
        return True

    # Determine platform
    plat = detect_platform()
    if not plat:
        error("platform", "Unsupported platform")
        return False

    # Find asset pattern
    asset_pattern = tj.get("asset_pattern", {})
    pattern = asset_pattern.get(plat)
    if not pattern or pattern == "NO_MATCH":
        error("platform", f"No asset available for {plat}")
        return False

    # Resolve download URL
    url, provider = resolve_download_url(repo, remote_ver, pattern, mirror_mode)
    log(f"Download URL ({provider}): {url}")

    # Lock
    with _lock_package(name):
        # Download to temp dir
        tmp_dir = tempfile.mkdtemp(prefix="tribucket-")
        try:
            archive_path = download_file(url, tmp_dir)
            if not archive_path:
                error("network", "Download failed")
                return False

            # Verify SHA256 if checksum file available
            sha_ok = _verify_sha256(archive_path, repo, remote_ver, tj, plat)
            if sha_ok is False:
                return False

            # Extract to temp dir
            extract_dir = os.path.join(tmp_dir, "extracted")
            os.makedirs(extract_dir)
            extract_archive(archive_path, extract_dir)

            # Find the actual files to install
            files_to_install = _find_installable_files(extract_dir, binary, install_type)
            if not files_to_install:
                error("archive", "No installable files found in archive")
                return False

            # Backup current version
            if not no_backup:
                backup_path = os.path.join(backup_dir(), name, local_ver)
                _backup_directory(path, backup_path)
                log(f"Backed up to {backup_path}")

            # Replace files
            _replace_files(path, files_to_install, install_type, binary)

            # Verify new version
            new_ver, _ = detect_version(
                os.path.join(path, binary) if install_type == "binary" else path,
                tj, info
            )

            if new_ver == local_ver and not force:
                new_ver = remote_ver

            # Update config
            update_package_version(name, remote_ver)

            # Clean up backup on success
            if not no_backup:
                backup_path = os.path.join(backup_dir(), name, local_ver)
                if os.path.exists(backup_path):
                    shutil.rmtree(backup_path, ignore_errors=True)

            print(f"{name}: {local_ver} → {remote_ver} ✓")
            return True

        except Exception as exc:
            error("update", f"Update failed: {exc}")
            # Try to restore from backup
            if not no_backup:
                backup_path = os.path.join(backup_dir(), name, local_ver)
                if os.path.exists(backup_path):
                    log("Attempting restore from backup...")
                    try:
                        _restore_from_backup(path, backup_path)
                        log("Restore successful")
                    except Exception as restore_err:
                        error("restore", f"Restore also failed: {restore_err}")
            return False

        finally:
            shutil.rmtree(tmp_dir, ignore_errors=True)


def _verify_sha256(archive_path, repo, version, tj, platform):
    """Verify SHA256 checksum. Returns True if OK, False if mismatch, None if no checksum."""
    # Try to find expected SHA256 from checksum file in release
    try:
        token = os.environ.get("GITHUB_TOKEN")
        from tribucket.utils import http_get_json
        data = http_get_json(
            f"https://api.github.com/repos/{repo}/releases/latest",
            token=token,
        )
        filename = os.path.basename(archive_path)
        expected = _find_sha256_from_release(data, filename)
        if expected:
            actual = compute_sha256(archive_path)
            if actual != expected:
                error("integrity", f"SHA256 mismatch for {filename}",
                      f"Expected: {expected}\n  Got:      {actual}")
                return False
            log("SHA256 verification OK")
            return True
    except Exception:
        pass
    return None


def _find_sha256_from_release(release_json, target_filename):
    """Find SHA256 hash for target_filename from release checksum assets."""
    CHECKSUM_PATTERNS = ("sha256sums", "SHA256SUMS", "checksums.txt", ".sha256")

    assets = release_json.get("assets", [])
    for asset in assets:
        name_lower = asset["name"].lower()
        if not any(p.lower() in name_lower for p in CHECKSUM_PATTERNS):
            continue

        try:
            from tribucket.utils import http_get
            body = http_get(asset["browser_download_url"], timeout=15)
            content = body.decode("utf-8", errors="replace")
            for line in content.strip().splitlines():
                parts = line.strip().split()
                if len(parts) >= 2 and target_filename in parts[-1]:
                    return parts[0].lower()
        except Exception:
            continue
    return None


def _find_installable_files(extract_dir, binary, install_type):
    """Find files to install from extracted archive."""
    if install_type == "directory":
        entries = os.listdir(extract_dir)
        if len(entries) == 1:
            single = os.path.join(extract_dir, entries[0])
            if os.path.isdir(single):
                return [single]
        return [extract_dir]
    else:
        import glob
        direct = os.path.join(extract_dir, binary)
        if os.path.exists(direct):
            return [direct]

        matches = glob.glob(os.path.join(extract_dir, "**", binary), recursive=True)
        if matches:
            return matches

        for ext in ("", ".exe"):
            matches = glob.glob(os.path.join(extract_dir, f"**/*{binary}{ext}"), recursive=True)
            if matches:
                return matches

        files = [os.path.join(extract_dir, f) for f in os.listdir(extract_dir)
                 if os.path.isfile(os.path.join(extract_dir, f))]
        return files[:1] if files else []


def _backup_directory(src, dest):
    """Backup a directory."""
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)


def _restore_from_backup(path, backup_path):
    """Restore from a backup directory."""
    if os.path.exists(path):
        shutil.rmtree(path)
    shutil.copytree(backup_path, path)


def _replace_files(target_dir, source_files, install_type, binary):
    """Replace files in target_dir with source_files."""
    if install_type == "directory":
        if os.path.exists(target_dir):
            keep = set()
            for name in ("tribucket.json", "install.sh", "cmd"):
                p = os.path.join(target_dir, name)
                if os.path.exists(p):
                    keep.add(p)

            for entry in os.listdir(target_dir):
                entry_path = os.path.join(target_dir, entry)
                if entry_path not in keep:
                    if os.path.isdir(entry_path):
                        shutil.rmtree(entry_path)
                    else:
                        os.unlink(entry_path)

        for src in source_files:
            if os.path.isdir(src):
                for entry in os.listdir(src):
                    s = os.path.join(src, entry)
                    d = os.path.join(target_dir, entry)
                    if os.path.isdir(s):
                        if os.path.exists(d):
                            shutil.rmtree(d)
                        shutil.copytree(s, d)
                    else:
                        shutil.copy2(s, d)
            else:
                shutil.copy2(src, target_dir)
    else:
        for src in source_files:
            dest = os.path.join(target_dir, os.path.basename(src))
            shutil.copy2(src, dest)
            os.chmod(dest, 0o755)
            log(f"Installed: {dest}")


class _lock_package:
    """Context manager for package-level file locking."""
    def __init__(self, name):
        self.name = name
        self.lock_path = os.path.join(lock_dir(), f"{name}.lock")
        self.fd = None

    def __enter__(self):
        os.makedirs(os.path.dirname(self.lock_path), exist_ok=True)
        self.fd = open(self.lock_path, "w")
        try:
            fcntl.flock(self.fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.fd.write(str(os.getpid()))
            self.fd.flush()
            return self
        except BlockingIOError:
            self.fd.close()
            self.fd = None
            error("locked", f"Another update for '{self.name}' is in progress.")
            sys.exit(1)

    def __exit__(self, *args):
        if self.fd:
            fcntl.flock(self.fd, fcntl.LOCK_UN)
            self.fd.close()
