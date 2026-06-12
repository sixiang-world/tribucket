"""Path constants and config management for tribucket."""
import json
import os
import sys


def tribucket_home():
    """Return the tribucket data directory (~/.tribucket or $TRIBUCKET_HOME)."""
    return os.environ.get("TRIBUCKET_HOME", os.path.expanduser("~/.tribucket"))


def config_path():
    return os.path.join(tribucket_home(), "config.json")


def cache_dir():
    return os.path.join(tribucket_home(), "cache")


def backup_dir():
    return os.path.join(tribucket_home(), "backup")


def lock_dir():
    return os.path.join(tribucket_home(), "locks")


def bin_dir():
    return os.path.join(tribucket_home(), "bin")


def versions_cache_path():
    return os.path.join(cache_dir(), "versions.json")


def mirror_cache_path():
    return os.path.join(cache_dir(), "mirror_status.json")


def mirror_config_path():
    return os.path.join(tribucket_home(), "mirror.json")


def load_config():
    """Load config.json, creating defaults if missing."""
    path = config_path()
    if not os.path.exists(path):
        return {"settings": {}, "packages": {}}

    try:
        with open(path, encoding="utf-8") as f:
            config = json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print(f"Warning: config.json corrupted ({e}), using defaults", file=sys.stderr)
        return {"settings": {}, "packages": {}}

    config.setdefault("settings", {})
    config.setdefault("packages", {})
    return config


def save_config(config):
    """Write config.json atomically."""
    path = config_path()
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
        f.write("\n")
    os.replace(tmp, path)


def load_json(path, default=None):
    """Load a JSON file, returning default if missing or corrupt."""
    if not os.path.exists(path):
        return default if default is not None else {}
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError):
        return default if default is not None else {}


def save_json(path, data):
    """Write JSON file atomically."""
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    os.replace(tmp, path)
