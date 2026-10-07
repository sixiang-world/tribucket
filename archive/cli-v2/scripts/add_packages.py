#!/usr/bin/env python3
"""Batch-add new packages by querying GitHub releases API.

Usage:
    python scripts/add_packages.py [--dry-run]
"""
import json
import os
import re
import sys

# Add scripts/ to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import generate


# Tools to add: (name, repo, description, binary, license)
NEW_PACKAGES = [
    ("starship", "starship/starship", "Cross-shell prompt customization", "starship", "ISC"),
    ("hyperfine", "sharkdp/hyperfine", "Command-line benchmarking tool", "hyperfine", "Apache-2.0"),
    ("dust", "bootandy/dust", "More intuitive version of du (disk usage)", "dust", "Apache-2.0"),
    ("procs", "dalance/procs", "Modern replacement for ps (process viewer)", "procs", "MIT"),
    ("bottom", "ClementTsang/bottom", "Cross-platform graphical system monitor", "btm", "MIT"),
    ("duf", "muesli/duf", "Better df alternative - disk usage/free utility", "duf", "MIT"),
    ("sd", "chmln/sd", "Intuitive find & replace CLI (sed alternative)", "sd", "MIT"),
    ("jq", "jqlang/jq", "Lightweight command-line JSON processor", "jq", "MIT"),
    ("yazi", "sxyazi/yazi", "Blazing fast terminal file manager", "yazi", "MIT"),
    ("erdtree", "solidiquis/erdtree", "Modern filesystem and disk usage visualizer", "erd", "MIT"),
    ("shellcheck", "koalaman/shellcheck", "Static analysis tool for shell scripts", "shellcheck", "GPL-3.0"),
    ("shfmt", "mvdan/sh", "Shell parser, formatter, and interpreter", "shfmt", "BSD-3-Clause"),
    ("ast-grep", "ast-grep/ast-grep", "Structural search/replace using AST patterns", "sg", "MIT"),
    ("tree-sitter", "tree-sitter/tree-sitter", "Parser generator tool and incremental parsing library", "tree-sitter", "MIT"),
    ("deno", "denoland/deno", "Modern runtime for JavaScript and TypeScript", "deno", "MIT"),
    # helm: SKIP — binaries hosted on get.helm.sh, not in GitHub release assets
    # fnm: SKIP — unified arch per OS (one zip for all macOS, no per-arch split)
    ("mise", "jdx/mise", "Polyglot runtime manager (asdf replacement)", "mise", "MIT"),
    ("helix", "helix-editor/helix", "Post-modern modal text editor", "hx", "MPL-2.0"),
    ("neovim", "neovim/neovim", "Hyperextensible Vim-based text editor", "nvim", "Apache-2.0"),
    ("zellij", "zellij-org/zellij", "Terminal multiplexer with batteries included", "zellij", "MIT"),
    ("lazygit", "jesseduffield/lazygit", "Simple terminal UI for git commands", "lazygit", "MIT"),
    ("glow", "charmbracelet/glow", "Render markdown on the CLI", "glow", "MIT"),
    ("k9s", "derailed/k9s", "Terminal UI for managing Kubernetes clusters", "k9s", "Apache-2.0"),
    ("opentofu", "opentofu/opentofu", "Open-source infrastructure as code tool (Terraform fork)", "tofu", "MPL-2.0"),
    ("cosign", "sigstore/cosign", "Container signing, verification, and storage", "cosign", "Apache-2.0"),
    ("xh", "ducaale/xh", "Friendly and fast HTTP requests tool (HTTPie alternative)", "xh", "MIT"),
    ("gping", "orf/gping", "Ping with a graph", "gping", "MIT"),
    ("watchexec", "watchexec/watchexec", "Execute commands in response to file modifications", "watchexec", "Apache-2.0"),
    ("surrealdb", "surrealdb/surrealdb", "Scalable, distributed document-graph database", "surreal", "BSL-1.1"),
]

# Platform detection patterns
PLATFORM_RULES = {
    "linux_amd64": ["linux", "x86_64", "x64", "amd64"],
    "linux_arm64": ["linux", "aarch64", "arm64"],
    "darwin_amd64": ["darwin", "macos", "mac", "x86_64", "x64", "amd64"],
    "darwin_arm64": ["darwin", "macos", "mac", "aarch64", "arm64"],
    "windows_amd64": ["windows", "win", "x86_64", "x64", "amd64"],
    "windows_arm64": ["windows", "win", "aarch64", "arm64"],
}


def classify_asset(name, lower_name):
    """Determine which platform an asset belongs to."""
    is_linux = any(k in lower_name for k in ["linux", "linuxmusl", "linux-gnu", "linux-musl"])
    is_darwin = any(k in lower_name for k in ["darwin", "macos", "mac-", "apple", "-mac."])
    is_windows = any(k in lower_name for k in ["windows", "win32", "win64", "win-arm", ".exe", "pc-windows"])
    is_amd64 = any(k in lower_name for k in ["x86_64", "x64", "amd64", "64-bit", "win64"])
    is_arm64 = any(k in lower_name for k in ["aarch64", "arm64", "win-arm64"])
    is_source = any(k in lower_name for k in ["source", ".tar.gz", "src."]) and not any(
        k in lower_name for k in ["linux", "darwin", "windows", "macos", "win"]
    )

    # Skip source archives, checksums, signatures, installers
    SKIP_EXT = (".sig", ".sha256", ".asc", ".prov", ".pkg", ".msi", ".deb", ".rpm", ".pub")
    if is_source or any(lower_name.endswith(ext) for ext in SKIP_EXT) or "sha256sum" in lower_name or "checksums" in lower_name:
        return None

    platforms = []
    if is_linux and is_amd64:
        platforms.append("linux_amd64")
    if is_linux and is_arm64:
        platforms.append("linux_arm64")
    if is_darwin and is_amd64:
        platforms.append("darwin_amd64")
    if is_darwin and is_arm64:
        platforms.append("darwin_arm64")
    if is_windows and is_amd64:
        platforms.append("windows_amd64")
    if is_windows and is_arm64:
        platforms.append("windows_arm64")

    return platforms if platforms else None


def find_pattern(assets, platform, binary):
    """Find the best asset_pattern substring for a platform."""
    os_part, arch_part = platform.split("_")  # e.g. "linux", "amd64"

    # OS keywords that should be present in the asset name
    OS_KEYWORDS = {
        "linux": ["linux"],
        "darwin": ["darwin", "macos", "mac-", "apple", "-mac."],
        "windows": ["windows", "win32", "win64", "win-arm", "pc-windows"],
    }

    candidates = []
    for asset in assets:
        name = asset["name"]
        lower = name.lower()
        classified = classify_asset(name, lower)
        if not classified or platform not in classified:
            continue

        # Verify the asset actually contains the expected OS keyword
        os_keywords = OS_KEYWORDS.get(os_part, [])
        if not any(kw in lower for kw in os_keywords):
            continue

        candidates.append(name)

    if not candidates:
        return None

    # Prefer common archive formats over package formats
    PREFERRED_EXT = (".tar.gz", ".tar.xz", ".zip", ".tgz")
    preferred = [c for c in candidates if any(c.lower().endswith(ext) for ext in PREFERRED_EXT)]
    if preferred:
        candidates = preferred

    # Pick the shortest name (most likely to be a stable pattern)
    best = min(candidates, key=len)
    return best


def analyze_repo(repo, binary):
    """Fetch latest release and determine asset patterns."""
    try:
        version, assets, _ = generate.fetch_latest_release(repo)
    except Exception as e:
        print(f"  ERROR fetching {repo}: {e}")
        return None

    patterns = {}
    for plat in ["linux_amd64", "linux_arm64", "darwin_amd64", "darwin_arm64", "windows_amd64", "windows_arm64"]:
        pattern = find_pattern(assets, plat, binary)
        if pattern:
            patterns[plat] = pattern
        else:
            patterns[plat] = f"NO_MATCH_{plat}"

    return version, patterns


def main():
    dry_run = "--dry-run" in sys.argv
    packages_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "packages")

    for name, repo, description, binary, license in NEW_PACKAGES:
        pkg_path = os.path.join(packages_dir, f"{name}.json")
        if os.path.exists(pkg_path):
            print(f"[skip] {name} already exists")
            continue

        print(f"[{name}] Querying {repo}...")
        result = analyze_repo(repo, binary)
        if not result:
            continue

        version, patterns = result

        pkg = {
            "name": name,
            "repo": repo,
            "description": description,
            "binary": binary,
            "license": license,
            "homepage": f"https://github.com/{repo}",
            "asset_pattern": patterns,
        }

        if dry_run:
            print(f"  Version: v{version}")
            for plat, pat in patterns.items():
                status = "OK" if not pat.startswith("NO_MATCH") else "MISSING"
                print(f"  {plat}: [{status}] {pat}")
        else:
            with open(pkg_path, "w", encoding="utf-8") as f:
                json.dump(pkg, f, indent=2, ensure_ascii=False)
                f.write("\n")
            print(f"  -> packages/{name}.json (v{version})")


if __name__ == "__main__":
    main()
