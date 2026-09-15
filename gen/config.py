"""Load .tribucket.yaml (or .tribucket.json) configuration."""

import json
import os
from pathlib import Path
from typing import Optional

from .types import PackageConfig, PLATFORMS


def _try_import_yaml():
    """Try to import PyYAML; return None if unavailable."""
    try:
        import yaml
        return yaml
    except ImportError:
        return None


def _resolve_homepage(repo: str, homepage: Optional[str]) -> str:
    if homepage:
        return homepage
    return f"https://github.com/{repo}"


def load_config(config_path: Optional[str] = None) -> PackageConfig:
    """Load and validate .tribucket.yaml from the given path or auto-detect.

    Search order (when config_path is None):
      1. .tribucket.yaml
      2. .tribucket.yml
      3. .tribucket.json
      4. packages/*.json (legacy tribucket repo format, first match)

    Raises FileNotFoundError if none found.
    Raises ValueError if required fields are missing.
    """
    if config_path:
        path = Path(config_path)
        if not path.exists():
            raise FileNotFoundError(f"Config file not found: {config_path}")
        return _parse_file(path)

    # Auto-detect
    candidates = [
        ".tribucket.yaml",
        ".tribucket.yml",
        ".tribucket.json",
    ]
    for name in candidates:
        path = Path(name)
        if path.exists():
            return _parse_file(path)

    # Legacy: packages/*.json
    packages_dir = Path("packages")
    if packages_dir.is_dir():
        json_files = sorted(packages_dir.glob("*.json"))
        if json_files:
            return _parse_file(json_files[0])

    raise FileNotFoundError(
        "No config file found. Create .tribucket.yaml or specify path with --config"
    )


def _parse_file(path: Path) -> PackageConfig:
    """Parse a single config file."""
    content = path.read_text(encoding="utf-8")

    if path.suffix in (".yaml", ".yml"):
        yaml = _try_import_yaml()
        if yaml is None:
            raise ImportError(
                "PyYAML is required to parse .tribucket.yaml. "
                "Install it with: pip install pyyaml"
            )
        data = yaml.safe_load(content)
    elif path.suffix == ".json":
        data = json.loads(content)
    else:
        raise ValueError(f"Unsupported config format: {path.suffix}")

    if not isinstance(data, dict):
        raise ValueError(f"Config must be a mapping, got {type(data).__name__}")

    return _build_config(data)


def _build_config(data: dict) -> PackageConfig:
    """Build PackageConfig from parsed dict, with validation."""
    # Required fields
    missing = []
    for field in ("name", "repo", "description", "binary", "license"):
        if field not in data:
            missing.append(field)
    if missing:
        raise ValueError(f"Missing required fields: {', '.join(missing)}")

    # Parse asset_pattern: normalize keys, strip NO_MATCH
    raw_pattern = data.get("asset_pattern", {})
    asset_pattern = {}
    for key, val in raw_pattern.items():
        # Normalize platform key (e.g. "linux-amd64" → "linux_amd64")
        canonical = key.replace("-", "_")
        if val and val != "NO_MATCH":
            asset_pattern[canonical] = val

    # Parse targets
    valid_targets = {"homebrew", "scoop", "shell", "aur", "nix"}
    targets = data.get("targets", ["homebrew", "scoop", "shell"])
    if isinstance(targets, list):
        targets = [t for t in targets if t in valid_targets]
    if not targets:
        targets = ["homebrew", "scoop", "shell"]

    return PackageConfig(
        name=data["name"],
        repo=data["repo"],
        description=data["description"],
        binary=data["binary"],
        license=data["license"],
        homepage=_resolve_homepage(data["repo"], data.get("homepage")),
        asset_pattern=asset_pattern,
        targets=targets,
        auto_detect=data.get("auto_detect", False),
        download_url=data.get("download_url"),
        version=data.get("version"),
        install_type=data.get("install_type", "binary"),
    )


def generate_example_config(repo: str, name: Optional[str] = None) -> str:
    """Generate an example .tribucket.yaml for a repo."""
    if not name:
        name = repo.split("/")[-1] if "/" in repo else repo

    return f"""# tribucket configuration
# Docs: https://tribucket.hunluan.space/docs/configuration

name: {name}
repo: {repo}
description: "TODO: one-line description"
binary: {name}
license: MIT
homepage: https://github.com/{repo}

# Set auto_detect to true and tribucket will infer asset_pattern
# from the latest GitHub Release automatically.
auto_detect: true

# Or manually specify asset_pattern (overrides auto_detect):
# asset_pattern:
#   linux_amd64: "{name}-linux-amd64.tar.gz"
#   linux_arm64: "{name}-linux-arm64.tar.gz"
#   darwin_amd64: "{name}-darwin-amd64.tar.gz"
#   darwin_arm64: "{name}-darwin-arm64.tar.gz"
#   windows_amd64: "{name}-windows-amd64.zip"
#   windows_arm64: "NO_MATCH"

# Output targets (default: all)
targets:
  - homebrew
  - scoop
  - shell
"""