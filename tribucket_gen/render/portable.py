"""Portable (standalone) template renderer: tribucket.json + install.sh + .bat."""
import json
import os

from ..assets import infer_asset_format


def infer_install_type(pkg):
    """Determine install_type from package name conventions.

    JDK/GraalVM packages extract to a directory; everything else is single binary.
    """
    DIRECTORY_NAMES = (
        "corretto-jdk", "temurin-jdk", "zulu-jdk", "liberica-jdk",
        "microsoft-jdk", "sapmachine-jdk", "dragonwell-jdk", "graalvm-ce-jdk",
        "tencent-kona-jdk",
    )
    name = pkg["name"]
    if any(name.startswith(j) for j in DIRECTORY_NAMES):
        return "directory"
    return "binary"


def derive_tribucket_json(pkg, version=None):
    """Derive tribucket.json from packages/*.json fields."""
    name = pkg["name"]
    ver = version or pkg.get("version", "0.0.0")
    repo = pkg.get("repo", "")
    homepage = pkg.get("homepage", f"https://github.com/{repo}" if repo else "")

    # Version check defaults
    vc = pkg.get("version_check", {})
    cli_flags = vc.get("cli_flags", ["--version"])
    parse_regex = vc.get("parse_regex", r"v?(\d+\.\d+(?:\.\d+)?)")
    output_stream = vc.get("output_stream", "stdout")
    timeout = vc.get("timeout", 5)

    # Install type
    install_type = pkg.get("install_type") or infer_install_type(pkg)

    # Binary field: for directory type, use relative pattern
    binary = pkg.get("binary", name)

    tribucket = {
        "name": name,
        "version": ver,
        "repo": repo,
        "description": pkg.get("description", ""),
        "binary": binary,
        "homepage": homepage,
        "license": pkg.get("license", "Unknown"),
        "version_check": {
            "cli_flags": cli_flags,
            "parse_regex": parse_regex,
            "output_stream": output_stream,
            "timeout": timeout,
            "fallback_version": ver,
        },
        "asset_pattern": pkg.get("asset_pattern", {}),
        "asset_format": infer_asset_format(pkg.get("asset_pattern", {})),
        "install_type": install_type,
        "mirror": {"enabled": True},
    }

    # Optional fields
    if pkg.get("download_url"):
        tribucket["download_url"] = pkg["download_url"]
    if vc.get("include_prerelease"):
        tribucket["version_check"]["include_prerelease"] = True

    return tribucket


def render_install_sh(pkg, tribucket_json):
    """Render the install.sh script for a portable package.

    Uses tribucket CLI when available, falls back to standalone mode.
    """
    name = tribucket_json["name"]
    repo = tribucket_json["repo"]
    binary = tribucket_json["binary"]
    fallback_version = tribucket_json["version_check"]["fallback_version"]

    lines = [
        "#!/usr/bin/env bash",
        "set -euo pipefail",
        "",
        f"# === tribucket auto-generated install.sh ===",
        f"# Package: {name}",
        f"# Repo: {repo}",
        f"# Do not edit — regenerate with: python -m tribucket_gen render --only {name}",
        "",
        'SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"',
        f'BINARY="$SCRIPT_DIR/{binary}"',
        f'REPO="{repo}"',
        f'NAME="{name}"',
        "",
        "# --- 如果 tribucket CLI 可用，委托给它 ---",
        'if command -v tribucket &>/dev/null; then',
        '    case "${1:-check}" in',
        "        check|status)",
        '            tribucket check "$NAME"',
        "            ;;",
        "        update|upgrade)",
        '            tribucket update "$NAME"',
        "            ;;",
        "        install)",
        '            tribucket install "$NAME" --dir "$SCRIPT_DIR" --force',
        "            ;;",
        "        *)",
        f'            echo "Usage: $0 [check|update|install]"',
        '            echo "  check   — 查看版本信息"',
        '            echo "  update  — 更新到最新版（带备份）"',
        '            echo "  install — 强制重新安装"',
        "            echo \"\"",
        '            echo "Or use tribucket directly:"',
        f'            echo "  tribucket check $NAME"',
        f'            echo "  tribucket update $NAME"',
        "            exit 1",
        "            ;;",
        "    esac",
        "    exit $?",
        "fi",
        "",
        "# --- tribucket CLI 不可用：最小化 fallback ---",
        'echo "tribucket CLI has been archived. Running in standalone mode."',
        f'echo "Or update manually from: https://github.com/{repo}/releases"',
        "echo \"\"",
        "",
        "# 检测本地版本",
        "detect_version() {",
        '    if [ -x "$BINARY" ]; then',
        '        "$BINARY" --version 2>&1 | grep -oP \'v?\\d+\\.\\d+(?:\\.\\d+)?\' | head -1',
        "    else",
        '        echo ""',
        "    fi",
        "}",
        "",
        "# 查远程版本",
        "check_remote() {",
        f'    curl -sf "https://api.github.com/repos/$REPO/releases/latest" \\',
        '        | grep -oP \'"tag_name":\\s*"\\K[^\"]+\' | sed \'s/^v//\' 2>/dev/null || echo ""',
        "}",
        "",
        "LOCAL=$(detect_version)",
        "REMOTE=$(check_remote)",
        "",
        'echo "Package: $NAME"',
        'echo "Local:   ${LOCAL:-not installed}"',
        'echo "Remote:  ${REMOTE:-unknown}"',
        "",
        'if [ -z "$LOCAL" ]; then',
        '    echo ""',
        '    echo "Binary not found. Install tribucket for automatic setup:"',
        f'    echo "Or update manually from: https://github.com/{repo}/releases"',
        "    exit 1",
        "fi",
        "",
        'if [ -z "$REMOTE" ]; then',
        '    echo "Status:  ? unable to check remote"',
        "    exit 0",
        "fi",
        "",
        'if [ "$LOCAL" = "$REMOTE" ]; then',
        '    echo "Status:  ✓ up to date"',
        "    exit 0",
        "fi",
        "",
        'echo "Status:  ⚠ update available ($LOCAL → $REMOTE)"',
        "echo \"\"",
        'echo "For backup-safe updates, install tribucket CLI."',
        f'echo "Or update manually from: https://github.com/{repo}/releases"',
        "",
    ]
    return "\n".join(lines)


def render_bat(pkg):
    """Render the .bat entry point for a portable package."""
    name = pkg["name"]
    binary = pkg.get("binary", name)
    # Windows binary typically has .exe suffix
    win_binary = binary if binary.endswith(".exe") else f"{binary}.exe"

    lines = [
        "@echo off",
        "REM Auto-generated by tribucket_gen — do not edit",
        f"REM Package: {name}",
        "",
        "SET SCRIPT_DIR=%~dp0",
        f'SET BINARY=%SCRIPT_DIR%{win_binary}',
        "",
        f'if not exist "%BINARY%" (',
        f'    echo Error: %BINARY% not found.',
        f'    echo Please install with: tribucket install {name}',
        "    exit /b 1",
        ")",
        "",
        '"%BINARY%" --version',
        "if %ERRORLEVEL% neq 0 (",
        '    echo Error: Failed to run %BINARY%',
        "    exit /b 1",
        ")",
        "",
        "echo.",
        f"echo To update, run: tribucket update {name}",
        f"echo Or visit: https://github.com/{pkg.get('repo', '')}/releases",
    ]
    return "\n".join(lines)


def generate_portable(pkg, output_dir, dry_run=False, verbose=False):
    """Generate portable/<name>/ directory from packages/*.json.

    Creates:
      - tribucket.json (derived metadata)
      - install.sh (tribucket CLI proxy + standalone fallback)
      - cmd/tribucket-update.bat (Windows entry point)

    Args:
        pkg: Package dict from packages/*.json.
        output_dir: Root output directory (e.g. repo_root/portable).
        dry_run: If True, print content to stdout instead of writing.
        verbose: Print progress.

    Returns:
        True if portable files were generated, False on error.
    """
    name = pkg["name"]
    version = pkg.get("version", "0.0.0")

    tribucket_json = derive_tribucket_json(pkg, version)
    install_sh = render_install_sh(pkg, tribucket_json)
    bat_content = render_bat(pkg)

    if dry_run:
        print(f"\n--- portable/{name}/tribucket.json ---")
        print(json.dumps(tribucket_json, indent=2, ensure_ascii=False))
        print(f"\n--- portable/{name}/install.sh ---")
        print(install_sh)
        print(f"\n--- portable/{name}/cmd/tribucket-update.bat ---")
        print(bat_content)
        return True

    portable_dir = os.path.join(output_dir, name)
    os.makedirs(portable_dir, exist_ok=True)

    # tribucket.json
    path = os.path.join(portable_dir, "tribucket.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(tribucket_json, f, indent=2, ensure_ascii=False)
        f.write("\n")
    if verbose:
        print(f"  -> portable/{name}/tribucket.json")

    # install.sh
    path = os.path.join(portable_dir, "install.sh")
    with open(path, "w", encoding="utf-8") as f:
        f.write(install_sh)
    os.chmod(path, 0o755)
    if verbose:
        print(f"  -> portable/{name}/install.sh")

    # cmd/tribucket-update.bat
    cmd_dir = os.path.join(portable_dir, "cmd")
    os.makedirs(cmd_dir, exist_ok=True)
    path = os.path.join(cmd_dir, "tribucket-update.bat")
    with open(path, "w", encoding="utf-8") as f:
        f.write(bat_content)
    if verbose:
        print(f"  -> portable/{name}/cmd/tribucket-update.bat")

    return True
