"""Scoop Bucket renderer."""
import json


def autoupdate_url(url, version):
    """Derive a Scoop autoupdate URL by replacing the version segment with $version.

    Preserves the upstream tag's v-prefix convention:
    - 'v1.2.3' in URL -> 'v$version'
    - '1.2.3' in URL (no v-prefix) -> '$version'

    Only replaces within the /releases/download/ path segments (tag + filename)
    to avoid matching org/repo names that happen to contain the version string.
    """
    if "/releases/download/" in url:
        prefix, suffix = url.split("/releases/download/", 1)
        v_str = f"v{version}"
        if v_str in suffix:
            return prefix + "/releases/download/" + suffix.replace(v_str, "v$version")
        if version in suffix:
            return prefix + "/releases/download/" + suffix.replace(version, "$version")
    return url


def render_bucket(info, is_download_url=False):
    """Render a Scoop Bucket .json file from package info.

    Args:
        info: Dict with keys: name, repo, description, homepage, license,
              binary, version, windows (dict of arch_key -> {url, hash, filename}).
        is_download_url: If True, use the download_url checkver pattern
                         instead of the default GitHub checkver.
    """
    w = info["windows"]
    repo = info.get("repo", "")

    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key in w:
            entry = w[arch_key]
            architecture[arch_key] = {
                "url": entry["url"],
                "hash": entry["hash"],
            }
            if is_download_url:
                autoupdate_arch[arch_key] = {
                    "url": entry["url"],
                }
            else:
                autoupdate_arch[arch_key] = {
                    "url": autoupdate_url(entry["url"], info["version"]),
                }

    # bin: use 64bit filename if available, else arm64
    bin_filename = w.get("64bit", w.get("arm64", {})).get("filename", "")

    bucket = {
        "version": info["version"],
        "description": info["description"],
        "homepage": info["homepage"],
        "license": info["license"],
        "architecture": architecture,
        "bin": [[bin_filename, info["binary"]]],
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }

    if is_download_url:
        # Download_url packages: omit checkver since Scoop's PowerShell-based
        # checkver can't be auto-generated from Python regex/jsonpath config.
        # Scoop will use the hardcoded version; users configure checkver manually.
        pass
    else:
        bucket["checkver"] = {
            "github": f"https://github.com/{repo}",
        }

    return json.dumps(bucket, indent=2, ensure_ascii=False) + "\n"
