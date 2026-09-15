"""Data types for tribucket generator."""

from dataclasses import dataclass, field
from typing import Optional


PLATFORMS = [
    "linux_amd64",
    "linux_arm64",
    "darwin_amd64",
    "darwin_arm64",
    "windows_amd64",
    "windows_arm64",
]

# Aliases: various naming conventions → canonical platform key
PLATFORM_ALIASES = {
    "linux-amd64": "linux_amd64", "linux_x86_64": "linux_amd64",
    "linux-x86_64": "linux_amd64", "linux-x64": "linux_amd64",
    "linux_x64": "linux_amd64",
    "linux-arm64": "linux_arm64", "linux_aarch64": "linux_arm64",
    "linux-aarch64": "linux_arm64",
    "darwin-amd64": "darwin_amd64", "darwin_x86_64": "darwin_amd64",
    "darwin-x86_64": "darwin_amd64", "darwin-x64": "darwin_amd64",
    "macos-amd64": "darwin_amd64", "macos-x64": "darwin_amd64",
    "macos_x64": "darwin_amd64", "osx-amd64": "darwin_amd64",
    "darwin-arm64": "darwin_arm64", "darwin_aarch64": "darwin_arm64",
    "darwin-aarch64": "darwin_arm64", "macos-arm64": "darwin_arm64",
    "osx-arm64": "darwin_arm64", "apple-darwin": "darwin_arm64",
    "windows-amd64": "windows_amd64", "windows_x86_64": "windows_amd64",
    "windows-x86_64": "windows_amd64", "windows-x64": "windows_amd64",
    "windows_x64": "windows_amd64", "win-amd64": "windows_amd64",
    "win-x64": "windows_amd64",
    "windows-arm64": "windows_arm64", "windows_aarch64": "windows_arm64",
    "windows-aarch64": "windows_arm64", "win-arm64": "windows_arm64",
}

# Mapping for display / file output
PLATFORM_DISPLAY = {
    "linux_amd64": ("Linux", "x86_64"),
    "linux_arm64": ("Linux", "aarch64"),
    "darwin_amd64": ("macOS", "x86_64"),
    "darwin_arm64": ("macOS", "aarch64"),
    "windows_amd64": ("Windows", "x86_64"),
    "windows_arm64": ("Windows", "aarch64"),
}


@dataclass
class PackageConfig:
    """Parsed .tribucket.yaml content."""
    name: str
    repo: str
    description: str
    binary: str
    license: str
    homepage: str
    asset_pattern: dict[str, str] = field(default_factory=dict)
    targets: list[str] = field(default_factory=lambda: ["homebrew", "scoop", "shell"])
    auto_detect: bool = False
    # Optional fields
    download_url: Optional[dict[str, str]] = None
    version: Optional[str] = None
    install_type: str = "binary"


@dataclass
class Asset:
    """A single release asset."""
    name: str
    url: str
    platform: str  # canonical platform key or "unknown"
    size: int = 0


@dataclass
class ReleaseInfo:
    """Parsed release information."""
    version: str
    tag: str
    repo: str
    assets: list[Asset] = field(default_factory=list)
    checksum_files: list[Asset] = field(default_factory=list)


@dataclass
class GeneratedFile:
    """A file to be written."""
    path: str
    content: str
    target: str  # "homebrew" | "scoop" | "shell"