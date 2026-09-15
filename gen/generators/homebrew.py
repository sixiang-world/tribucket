"""Generate Homebrew Formula .rb file."""

from ..types import PackageConfig


def _class_name(name: str) -> str:
    """Derive Ruby class name: 'claude-code' → 'ClaudeCode'."""
    return "".join(part.capitalize() for part in name.split("-"))


def generate_homebrew(
    config: PackageConfig,
    version: str,
    platforms: dict[str, dict],  # platform_key → {"url": ..., "sha256": ...}
) -> str:
    """Render a Homebrew Formula .rb file.

    Args:
        config: Package configuration.
        version: Version string (without 'v' prefix).
        platforms: Dict mapping platform_key to {"url": ..., "sha256": ...}.

    Returns:
        Formula content as string.
    """
    class_name = _class_name(config.name)

    def _platform_block(arch: str, platform_key: str) -> str:
        if platform_key not in platforms:
            return ""
        data = platforms[platform_key]
        return (
            f"    on_{arch} do\n"
            f'      url "{data["url"]}"\n'
            f'      sha256 "{data["sha256"]}"\n'
            f"    end\n"
        )

    def _os_block(os_name: str, arch_map: list[tuple[str, str]]) -> str:
        blocks = ""
        for arch, plat_key in arch_map:
            blocks += _platform_block(arch, plat_key)
        if not blocks:
            return ""
        return f"  on_{os_name} do\n{blocks}  end\n\n"

    macos_block = _os_block("macos", [("arm", "darwin_arm64"), ("intel", "darwin_amd64")])
    linux_block = _os_block("linux", [("arm", "linux_arm64"), ("intel", "linux_amd64")])

    binary = config.binary

    formula = (
        f"class {class_name} < Formula\n"
        f'  desc "{config.description}"\n'
        f'  homepage "{config.homepage}"\n'
        f'  version "{version}"\n'
        f'  license "{config.license}"\n'
        f"\n"
        f"{macos_block}"
        f"{linux_block}"
        f"  def install\n"
        f'    bin.install Dir["{binary}*"].first => "{binary}"\n'
        f"  end\n"
        f"\n"
        f"  test do\n"
        f'    assert_match version.to_s, shell_output("#{{bin}}/{binary} --version 2>&1", 1)\n'
        f"  end\n"
        f"end\n"
    )
    return formula


def formula_filename(config: PackageConfig) -> str:
    """Return the Formula filename: 'claude-code' → 'ClaudeCode.rb'."""
    return f"{_class_name(config.name)}.rb"