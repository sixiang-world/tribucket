"""Scoop Bucket renderer."""
import json


def autoupdate_url(url, version):
    """Derive a Scoop autoupdate URL by replacing the version segment with $version.

    Preserves the upstream tag's v-prefix convention:
    - 'v1.2.3' in URL -> 'v$version'
    - '1.2.3' in URL (no v-prefix) -> '$version'

    Both forms can appear in the same URL (e.g. tag 'v1.2.3' + filename
    'tool_1.2.3_windows_amd64.zip'); we replace each occurrence with its
    matching convention.

    Only replaces within the /releases/download/ path segments (tag + filename)
    to avoid matching org/repo names that happen to contain the version string.
    """
    if "/releases/download/" in url:
        prefix, suffix = url.split("/releases/download/", 1)
        v_str = f"v{version}"
        if v_str in suffix:
            suffix = suffix.replace(v_str, "v$version")
        if version in suffix:
            suffix = suffix.replace(version, "$version")
        return prefix + "/releases/download/" + suffix
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

    # bin: 解压后包内的可执行文件名（不是归档文件本身的文件名）。
    # - 裸 .exe 发布：URL/filename 直指 .exe，bin 就是这个 filename
    # - zip/tar 归档发布：filename 是归档名，bin 应该是包内的 {binary}.exe
    #   （绝大多数 zip 根目录就是 {binary}.exe，与 portable render 的假设一致）
    bin_filename = w.get("64bit", w.get("arm64", {})).get("filename", "")
    if bin_filename.lower().endswith((".zip", ".tar.gz", ".tgz", ".tar.bz2", ".tar.xz", ".tar.zst")):
        bin_filename = f"{info['binary']}.exe"

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
