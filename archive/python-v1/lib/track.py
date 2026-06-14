"""Global package tracking — config.json read/write."""
import os
import sys
from datetime import datetime, timezone

from tribucket.config import load_config, save_config, bin_dir


def track(name, path, version=None, linked=False):
    """Add a package to the tracked list."""
    config = load_config()

    if not os.path.exists(path):
        print(f"Error: [{name}] path does not exist: {path}")
        return False

    # Use owner/repo as key if available, otherwise just name
    repo = _detect_repo(path, name)
    repo_key = repo if repo else name

    # Check for duplicate
    if repo_key in config["packages"]:
        existing = config["packages"][repo_key]
        if os.path.exists(existing.get("path", "")):
            print(f"Error: [{name}] is already tracked at {existing['path']}")
            print(f"  → Use 'tribucket update {name}' to update, or 'tribucket uninstall {name}' first.")
            return False

    config["packages"][repo_key] = {
        "name": name,
        "path": os.path.abspath(path),
        "version": version or "unknown",
        "installed_at": datetime.now(timezone.utc).isoformat(),
        "linked": linked,
    }
    save_config(config)
    log(f"Tracked: {name} at {path}")
    return True


def untrack(name):
    """Remove a package from the tracked list."""
    config = load_config()
    repo_key = _find_repo_key(config, name)

    if not repo_key or repo_key not in config["packages"]:
        print(f"Error: [{name}] is not tracked.")
        return False

    del config["packages"][repo_key]
    save_config(config)
    print(f"Untracked: {name}")
    return True


def list_packages():
    """List all tracked packages. Returns list of (name, info) tuples."""
    config = load_config()
    packages = config.get("packages", {})
    result = []
    for repo_key, info in packages.items():
        result.append((info.get("name", repo_key), info))
    return result


def get_package(name):
    """Get info for a tracked package by name. Returns dict or None."""
    config = load_config()
    # Try direct key lookup first
    result = config["packages"].get(name)
    if result:
        return result
    # Search by name field
    for key, info in config["packages"].items():
        if info.get("name") == name:
            return info
    return None


def get_all_packages():
    """Get all tracked packages as dict. Returns {name: info}."""
    config = load_config()
    return config.get("packages", {})


def update_package_version(name, version):
    """Update the version for a tracked package."""
    config = load_config()
    repo_key = _find_repo_key(config, name)

    if repo_key and repo_key in config["packages"]:
        config["packages"][repo_key]["version"] = version
        save_config(config)
        return True
    return False


def remove_stale_entries():
    """Find and remove entries with non-existent paths. Returns list of removed names."""
    config = load_config()
    removed = []
    for repo_key, info in list(config["packages"].items()):
        path = info.get("path", "")
        if not os.path.exists(path):
            del config["packages"][repo_key]
            removed.append(info.get("name", repo_key))

    if removed:
        save_config(config)
    return removed


def find_dangling_symlinks():
    """Find symlinks in ~/.tribucket/bin/ that point to non-existent targets."""
    bd = bin_dir()
    results = []
    if not os.path.isdir(bd):
        return results

    for name in os.listdir(bd):
        path = os.path.join(bd, name)
        if os.path.islink(path) and not os.path.exists(path):
            target = os.readlink(path)
            results.append((name, path, target))
    return results


def _find_repo_key(config, name):
    """Find the repo_key for a package name in config."""
    for repo_key, info in config["packages"].items():
        if info.get("name") == name:
            return repo_key
    if name in config["packages"]:
        return name
    return None


def _detect_repo(path, name):
    """Try to detect owner/repo from tribucket.json in the package path."""
    from tribucket.utils import find_tribucket_json
    tj = find_tribucket_json(path)
    if tj and tj.get("repo"):
        return tj["repo"]
    return None


def log(msg):
    from tribucket.utils import log as _log
    _log(msg)
