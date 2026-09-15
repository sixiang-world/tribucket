"""Detect asset patterns from GitHub Release assets."""

import json
import re
import urllib.request
import urllib.error
from typing import Optional

from .types import Asset, ReleaseInfo, PLATFORMS, PLATFORM_ALIASES


# Platform detection regexes (order matters: more specific first)
_PLATFORM_PATTERNS: list[tuple[str, list[re.Pattern]]] = [
    ("linux_amd64", [
        re.compile(r"linux.*x86_64", re.I),
        re.compile(r"linux.*x64", re.I),
        re.compile(r"linux.*amd64", re.I),
        re.compile(r"linux[-_]amd64", re.I),
        re.compile(r"linux[-_]x86_64", re.I),
    ]),
    ("linux_arm64", [
        re.compile(r"linux.*aarch64", re.I),
        re.compile(r"linux.*arm64", re.I),
        re.compile(r"linux[-_]arm64", re.I),
        re.compile(r"linux[-_]aarch64", re.I),
    ]),
    ("darwin_amd64", [
        re.compile(r"darwin.*x86_64", re.I),
        re.compile(r"darwin.*x64", re.I),
        re.compile(r"darwin.*amd64", re.I),
        re.compile(r"macos.*x86_64", re.I),
        re.compile(r"macos.*x64", re.I),
        re.compile(r"macos[-_]amd64", re.I),
        re.compile(r"osx.*x86_64", re.I),
    ]),
    ("darwin_arm64", [
        re.compile(r"darwin.*aarch64", re.I),
        re.compile(r"darwin.*arm64", re.I),
        re.compile(r"macos.*aarch64", re.I),
        re.compile(r"macos.*arm64", re.I),
        re.compile(r"osx.*aarch64", re.I),
        re.compile(r"apple[-_]darwin", re.I),
    ]),
    ("windows_amd64", [
        re.compile(r"windows.*x86_64", re.I),
        re.compile(r"windows.*x64", re.I),
        re.compile(r"windows.*amd64", re.I),
        re.compile(r"win[-_]x86_64", re.I),
        re.compile(r"win[-_]x64", re.I),
        re.compile(r"win[-_]amd64", re.I),
    ]),
    ("windows_arm64", [
        re.compile(r"windows.*aarch64", re.I),
        re.compile(r"windows.*arm64", re.I),
        re.compile(r"win[-_]aarch64", re.I),
        re.compile(r"win[-_]arm64", re.I),
    ]),
]

# Extensions to skip (not binary distributions)
_SKIP_EXTENSIONS = (".rpm", ".deb", ".apk", ".sbom.json", ".sigstore.json",
                    ".minisig", ".sig", ".asc")
_SKIP_PATTERNS = re.compile(
    r"(checksums|sha256sums|sha512sums|shasums|\.sha256|\.sha512|\.md5|"
    r"source[_\.]|\.sbom|install\.sh|install\.ps1|\.bash|\.zsh|\.fish|"
    r"\.powershell|\.usage\.|\.minisig$|\.sig$|\.asc$)",
    re.IGNORECASE,
)


def guess_platform(name: str) -> str:
    """Guess platform from an asset filename."""
    for plat, patterns in _PLATFORM_PATTERNS:
        for p in patterns:
            if p.search(name):
                return plat
    return "unknown"


def _should_skip_asset(name: str) -> bool:
    """Check if an asset should be skipped (not a binary distribution)."""
    for ext in _SKIP_EXTENSIONS:
        if name.endswith(ext):
            return True
    if _SKIP_PATTERNS.search(name):
        return True
    # Skip source tarballs (no arch indicator)
    if name.endswith((".tar.gz", ".tar.xz", ".tar.bz2", ".tgz")):
        lower = name.lower()
        arch_indicators = ["x86_64", "x64", "amd64", "aarch64", "arm64",
                           "darwin", "linux", "windows", "win", "macos", "osx"]
        if not any(k in lower for k in arch_indicators):
            return True
    return False


def _http_get_json(url: str, token: Optional[str] = None) -> dict:
    """Fetch JSON from a URL with optional auth."""
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "tribucket-gen/0.1",
    }
    if token:
        headers["Authorization"] = f"token {token}"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode("utf-8"))


def fetch_release(repo: str, token: Optional[str] = None) -> ReleaseInfo:
    """Fetch the latest release from GitHub.

    Args:
        repo: owner/repo format.
        token: Optional GitHub token for higher rate limits.

    Returns:
        ReleaseInfo with parsed assets.

    Raises:
        urllib.error.HTTPError on API failures.
    """
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    data = _http_get_json(url, token)

    tag = data.get("tag_name", "")
    version = tag.lstrip("v")
    raw_assets = data.get("assets", [])

    assets = []
    checksum_files = []

    for a in raw_assets:
        name = a["name"]
        asset = Asset(
            name=name,
            url=a["browser_download_url"],
            platform=guess_platform(name),
            size=a.get("size", 0),
        )

        # Check if it's a checksum file
        lower = name.lower()
        if any(k in lower for k in ["sha256", "sha512", "checksums", "shasums"]):
            checksum_files.append(asset)
            continue

        if _should_skip_asset(name):
            continue

        assets.append(asset)

    return ReleaseInfo(
        version=version,
        tag=tag,
        repo=repo,
        assets=assets,
        checksum_files=checksum_files,
    )


def detect_patterns(release: ReleaseInfo) -> dict[str, str]:
    """Auto-detect asset_pattern from release assets.

    For each platform, picks the best matching asset and constructs a pattern.
    Prefers .tar.gz > .tar.xz > .tar.zst > .zip > bare binary.

    Returns:
        Dict of platform_key → pattern_string (empty dict if no assets).
    """
    # Group assets by platform
    by_platform: dict[str, list[Asset]] = {}
    for asset in release.assets:
        if asset.platform != "unknown":
            by_platform.setdefault(asset.platform, []).append(asset)

    if not by_platform:
        return {}

    patterns = {}
    for plat in PLATFORMS:
        candidates = by_platform.get(plat, [])
        if not candidates:
            patterns[plat] = "NO_MATCH"
            continue

        # Pick the best candidate (prefer .tar.gz, then smallest name)
        best = _pick_best_asset(candidates)
        pattern = _asset_to_pattern(best.name, release.repo)
        patterns[plat] = pattern

    return patterns


def _pick_best_asset(assets: list[Asset]) -> Asset:
    """Pick the best asset from candidates (prefer archive formats)."""
    def score(a: Asset) -> tuple:
        name = a.name.lower()
        # Prefer archive formats over bare binaries
        format_score = 0
        if name.endswith(".tar.gz") or name.endswith(".tgz"):
            format_score = 0
        elif name.endswith(".tar.xz"):
            format_score = 1
        elif name.endswith(".tar.zst"):
            format_score = 2
        elif name.endswith(".zip"):
            format_score = 3
        else:
            format_score = 4  # bare binary
        # Shorter name = simpler pattern
        return (format_score, len(a.name))

    return min(assets, key=score)


def _asset_to_pattern(name: str, repo: str) -> str:
    """Convert an asset filename to a match pattern.

    Strategy: find the version-like segment and replace with *,
    or use the shortest unique suffix.
    """
    # Try to find and replace version in the name
    # Common: v1.2.3, 1.2.3, v1.2.3-
    version_re = re.compile(r"v?\d+\.\d+(?:\.\d+)?(?:-[\w.]+)?")
    match = version_re.search(name)
    if match:
        # Replace version with * to make it version-agnostic
        pattern = name[:match.start()] + "*" + name[match.end():]
        # Clean up: if pattern starts with name-*, simplify
        return pattern

    # Fallback: return the name as-is (exact match per version)
    return name


def format_detection_report(release: ReleaseInfo, patterns: dict[str, str]) -> str:
    """Format a human-readable detection report."""
    lines = [
        f"Repository: {release.repo}",
        f"Latest version: {release.tag}",
        f"Total assets: {len(release.assets) + len(release.checksum_files)}",
        f"Binary assets: {len(release.assets)}",
        f"Checksum files: {len(release.checksum_files)}",
        "",
        "Detected patterns:",
    ]

    for plat in PLATFORMS:
        pattern = patterns.get(plat, "NO_MATCH")
        if pattern == "NO_MATCH":
            lines.append(f"  {plat:20s} → (no asset found)")
        else:
            # Find the matching asset name
            matching = [a.name for a in release.assets if a.platform == plat]
            if matching:
                lines.append(f"  {plat:20s} → {pattern}")
                lines.append(f"  {'':20s}   (e.g. {matching[0]})")
            else:
                lines.append(f"  {plat:20s} → {pattern}")

    matched = sum(1 for v in patterns.values() if v != "NO_MATCH")
    lines.append("")
    lines.append(f"Coverage: {matched}/6 platforms")

    return "\n".join(lines)