"""Generate Scoop Manifest .json file."""

import json
import re
from ..types import PackageConfig


def _autoupdate_url(url: str, version: str) -> str:
    """Derive a Scoop autoupdate URL by replacing the version segment with $version.

    Only replaces within /releases/download/ path segments to avoid matching
    org/repo names that happen to contain the version string.
    """
    if "/releases/download/" not in url:
        return url

    prefix, suffix = url.split("/releases/download/", 1)
    v_str = f"v{version}"
    if v_str in suffix:
        return prefix + "/releases/download/" + suffix.replace(v_str, "v$version")
    if version in suffix:
        return prefix + "/releases/download/" + suffix.replace(version, "v$version")
    return url


def generate_scoop(
    config: PackageConfig,
    version: str,
    windows: dict[str, dict],  # arch_key → {"url": ..., "hash": ..., "filename": ...}
) -> str:
    """Render a Scoop Bucket .json manifest.

    Args:
        config: Package configuration.
        version: Version string.
        windows: Dict mapping "64bit"/"arm64" to url/hash/filename.

    Returns:
        JSON string of the manifest.
    """
    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key not in windows:
            continue
        entry = windows[arch_key]
        architecture[arch_key] = {
            "url": entry["url"],
            "hash": entry["hash"],
        }
        autoupdate_arch[arch_key] = {
            "url": _autoupdate_url(entry["url"], version),
        }

    # bin: use the first available filename
    bin_entry = windows.get("64bit", windows.get("arm64", {}))
    bin_filename = bin_entry.get("filename", "")

    manifest = {
        "version": version,
        "description": config.description,
        "homepage": config.homepage,
        "license": config.license,
        "architecture": architecture,
        "bin": [[bin_filename, config.binary]],
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }

    # checkver: use GitHub by default
    if config.repo:
        manifest["checkver"] = {
            "github": f"https://github.com/{config.repo}",
        }

    return json.dumps(manifest, indent=2, ensure_ascii=False) + "\n"


def manifest_filename(config: PackageConfig) -> str:
    """Return the Scoop manifest filename: 'claude-code' → 'claude-code.json'."""
    return f"{config.name}.json"