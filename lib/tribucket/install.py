"""First-time package installation engine."""
import json
import os
import platform
import shutil
import sys
import tempfile

from tribucket.utils import (
    compute_sha256, detect_platform, extract_archive, download_file,
    http_get, http_get_json, log, error, infer_asset_format,
    find_tribucket_json,
)
from tribucket.mirror import resolve_download_url
from tribucket.track import track, get_all_packages


REPO_URL = "https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages"


def install_package(name, target_dir=None, link=False, force=False, mirror_mode="auto"):
    """Install a package for the first time.

    1. Fetch package metadata from tribucket repo
    2. Generate portable template files
    3. Download binary
    4. Verify and install
    5. Auto-track

    Returns True on success.
    """
    # Check if already installed
    packages = get_all_packages()
    if name in packages and not force:
        info = packages[name]
        if os.path.exists(info.get("path", "")):
            error("exists", f"'{name}' is already installed at {info['path']}")
            print(f"  → Use 'tribucket update {name}' to update, or 'tribucket uninstall {name}' first.")
            return False

    # 1. Fetch package metadata
    pkg = _fetch_package_metadata(name)
    if not pkg:
        return False

    # 2. Determine target directory
    if target_dir is None:
        target_dir = os.getcwd()
    target_dir = os.path.join(target_dir, name)

    # Validate target directory
    if not _validate_install_dir(target_dir, force):
        return False

    # 3. Create directory
    os.makedirs(target_dir, exist_ok=True)

    # 4. Generate portable template files
    _generate_template_files(pkg, target_dir)

    # 5. Detect platform and download binary
    plat = detect_platform()
    if not plat:
        error("platform", "Unsupported platform")
        return False

    binary_name = pkg.get("binary", name)
    asset_pattern = pkg.get("asset_pattern", {})
    pattern = asset_pattern.get(plat)
    if not pattern or pattern == "NO_MATCH":
        error("platform", f"No asset available for {plat}")
        return False

    # Get version
    version = pkg.get("version", "0.0.0")
    repo = pkg.get("repo", "")

    # Resolve download URL
    url, provider = resolve_download_url(repo, version, pattern, mirror_mode)
    log(f"Download URL ({provider}): {url}")

    # Download
    tmp_dir = tempfile.mkdtemp(prefix="tribucket-install-")
    try:
        archive_path = download_file(url, tmp_dir)
        if not archive_path:
            error("network", "Download failed")
            return False

        # Extract
        extract_dir = os.path.join(tmp_dir, "extracted")
        os.makedirs(extract_dir)
        extract_archive(archive_path, extract_dir)

        # Install files
        install_type = pkg.get("install_type", "binary")
        _install_files(extract_dir, target_dir, binary_name, install_type)

        # Verify
        binary_path = os.path.join(target_dir, binary_name)
        if install_type == "directory":
            # Find binary in directory
            import glob
            matches = glob.glob(os.path.join(target_dir, "**", binary_name), recursive=True)
            if matches:
                binary_path = matches[0]

        if os.path.isfile(binary_path):
            os.chmod(binary_path, 0o755)

        # Track
        track(name, target_dir, version=version, linked=False)

        # Create symlink if requested
        if link:
            _create_symlink(name, binary_path)

        print(f"Installed: {target_dir}")
        if not link:
            print(f"Not in PATH. Options:")
            print(f"  1. Add to PATH:  export PATH=\"{target_dir}:$PATH\"")
            print(f"  2. Reinstall with symlink:  tribucket install {name} --link")

        return True

    finally:
        shutil.rmtree(tmp_dir, ignore_errors=True)


def _fetch_package_metadata(name):
    """Fetch package metadata from tribucket repo."""
    url = f"{REPO_URL}/{name}.json"
    try:
        data = http_get_json(url)
        log(f"Fetched metadata for {name}")
        return data
    except Exception as e:
        error("not-found", f"Package '{name}' not found in tribucket repo",
              f"Check the package name or visit https://github.com/sixiang-world/tribucket/tree/main/packages")
        return None


def _validate_install_dir(target_dir, force):
    """Validate that the target directory is safe to install into."""
    FORBIDDEN = ["/", "/usr", "/bin", "/sbin", "/etc", "/var", "/tmp"]

    real_target = os.path.realpath(target_dir)

    for forbidden in FORBIDDEN:
        if real_target == forbidden or real_target.startswith(forbidden + "/"):
            error("forbidden", f"Refusing to install into system directory: {target_dir}")
            print(f"  → Use --dir to specify a user directory, e.g.: --dir ~/apps")
            return False

    # Check for tribucket's own directory
    tribucket_home = os.path.expanduser("~/.tribucket")
    if real_target.startswith(os.path.realpath(tribucket_home)):
        error("forbidden", "Cannot install into tribucket's own directory.")
        return False

    # Check if directory exists and is not empty
    if os.path.exists(target_dir) and os.listdir(target_dir):
        if not force:
            error("exists", f"Directory not empty: {target_dir}")
            print(f"  → Use --force to overwrite.")
            return False

    return True


def _generate_template_files(pkg, target_dir):
    """Generate tribucket.json, install.sh, cmd/ in target_dir."""
    # tribucket.json
    version = pkg.get("version", "0.0.0")
    tribucket_json = {
        "name": pkg["name"],
        "version": version,
        "repo": pkg.get("repo", ""),
        "description": pkg.get("description", ""),
        "binary": pkg.get("binary", pkg["name"]),
        "homepage": pkg.get("homepage", ""),
        "license": pkg.get("license", "Unknown"),
        "version_check": {
            "cli_flags": ["--version"],
            "parse_regex": r"v?(\d+\.\d+(?:\.\d+)?)",
            "output_stream": "stdout",
            "timeout": 5,
            "fallback_version": version,
        },
        "asset_pattern": pkg.get("asset_pattern", {}),
        "asset_format": infer_asset_format(pkg.get("asset_pattern", {})),
        "install_type": pkg.get("install_type", "binary"),
        "mirror": {"enabled": True},
    }

    path = os.path.join(target_dir, "tribucket.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(tribucket_json, f, indent=2, ensure_ascii=False)
        f.write("\n")

    # install.sh — use generate.py's render function if available
    try:
        sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
        from generate import render_install_sh, render_bat
        install_sh = render_install_sh(pkg, tribucket_json)
        bat_content = render_bat(pkg)
    except ImportError:
        install_sh = _fallback_install_sh(pkg)
        bat_content = _fallback_bat(pkg)

    path = os.path.join(target_dir, "install.sh")
    with open(path, "w") as f:
        f.write(install_sh)
    os.chmod(path, 0o755)

    cmd_dir = os.path.join(target_dir, "cmd")
    os.makedirs(cmd_dir, exist_ok=True)
    path = os.path.join(cmd_dir, "tribucket-update.bat")
    with open(path, "w") as f:
        f.write(bat_content)


def _install_files(extract_dir, target_dir, binary_name, install_type):
    """Install extracted files to target directory."""
    if install_type == "directory":
        entries = os.listdir(extract_dir)
        if len(entries) == 1 and os.path.isdir(os.path.join(extract_dir, entries[0])):
            # Single directory in archive — copy contents
            src = os.path.join(extract_dir, entries[0])
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
            # Multiple items — copy all
            for entry in entries:
                s = os.path.join(extract_dir, entry)
                d = os.path.join(target_dir, entry)
                if os.path.isdir(s):
                    if os.path.exists(d):
                        shutil.rmtree(d)
                    shutil.copytree(s, d)
                else:
                    shutil.copy2(s, d)
    else:
        # Single binary
        import glob
        matches = glob.glob(os.path.join(extract_dir, "**", binary_name), recursive=True)
        if matches:
            shutil.copy2(matches[0], target_dir)
        else:
            # Try all files
            for entry in os.listdir(extract_dir):
                s = os.path.join(extract_dir, entry)
                if os.path.isfile(s):
                    shutil.copy2(s, target_dir)
                    break


def _create_symlink(name, binary_path):
    """Create a symlink in ~/.tribucket/bin/."""
    from tribucket.config import bin_dir
    bd = bin_dir()
    os.makedirs(bd, exist_ok=True)
    link_path = os.path.join(bd, os.path.basename(binary_path))
    if os.path.exists(link_path) or os.path.islink(link_path):
        os.unlink(link_path)
    os.symlink(binary_path, link_path)
    log(f"Symlink: {link_path} → {binary_path}")


def _fallback_install_sh(pkg):
    """Fallback install.sh when generate.py is not available."""
    name = pkg["name"]
    repo = pkg.get("repo", "")
    return f"""#!/usr/bin/env bash
set -euo pipefail
# tribucket auto-generated install.sh — Package: {name}
echo "tribucket CLI not found. Install tribucket for full features."
echo "  curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash"
"""


def _fallback_bat(pkg):
    """Fallback .bat when generate.py is not available."""
    name = pkg["name"]
    binary = pkg.get("binary", name)
    win_binary = binary if binary.endswith(".exe") else f"{binary}.exe"
    return f"""@echo off
REM Auto-generated — Package: {name}
SET SCRIPT_DIR=%~dp0
SET BINARY=%SCRIPT_DIR%{win_binary}
if not exist "%BINARY%" (
    echo Error: %BINARY% not found.
    echo Please install with: tribucket install {name}
    exit /b 1
)
"%BINARY%" --version
echo.
echo To update, run: tribucket update {name}
"""
