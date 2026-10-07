"""Homebrew Formula renderer."""
def class_name_from(name):
    """Derive a Ruby class name from a package name.

    'ccx' -> 'Ccx', 'claude-code' -> 'ClaudeCode', 'my-cool-tool' -> 'MyCoolTool'
    """
    return "".join(part.capitalize() for part in name.split("-"))


def render_formula(info):
    """Render a Homebrew Formula .rb file from package info.

    Args:
        info: Dict with keys: name, description, homepage, license, binary, version,
              platforms (dict of platform_key -> {url, sha256}).

    Returns:
        String content of the .rb file.
    """
    class_name = class_name_from(info["name"])
    p = info["platforms"]

    def platform_block(os_name, arch, platform_key):
        if platform_key not in p:
            return ""
        data = p[platform_key]
        return (
            f"    on_{arch} do\n"
            f'      url "{data["url"]}"\n'
            f'      sha256 "{data["sha256"]}"\n'
            f"    end\n"
        )

    def os_block(os_name, platform_keys):
        blocks = ""
        if os_name == "macos":
            blocks += platform_block(os_name, "arm", "darwin_arm64")
            blocks += platform_block(os_name, "intel", "darwin_amd64")
        else:
            blocks += platform_block(os_name, "arm", "linux_arm64")
            blocks += platform_block(os_name, "intel", "linux_amd64")
        if not blocks:
            return ""
        return f"  on_{os_name} do\n{blocks}  end\n\n"

    macos_block = os_block("macos", ["darwin_arm64", "darwin_amd64"])
    linux_block = os_block("linux", ["linux_arm64", "linux_amd64"])

    binary = info["binary"]

    formula = (
        f"class {class_name} < Formula\n"
        f'  desc "{info["description"]}"\n'
        f'  homepage "{info["homepage"]}"\n'
        f'  version "{info["version"]}"\n'
        f'  license "{info["license"]}"\n'
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
