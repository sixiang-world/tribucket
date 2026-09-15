"""tribucket generator CLI — entry point.

Usage:
    python -m gen init [repo]          # Create .tribucket.yaml
    python -m gen generate             # Generate all formats
    python -m gen generate --target homebrew  # Generate specific format
    python -m gen detect <repo>        # Detect asset patterns
    python -m gen check [repo]         # Validate patterns
"""

import argparse
import json
import os
import sys
from fnmatch import fnmatch
from pathlib import Path
from urllib.request import Request, urlopen

from . import __version__
from .config import load_config, generate_example_config
from .detector import fetch_release, detect_patterns, format_detection_report
from .types import PackageConfig


def cmd_init(args):
    """Create a .tribucket.yaml interactively or from a repo URL."""
    repo = args.repo
    if not repo:
        repo = input("GitHub repo (owner/repo): ").strip()

    if not repo or "/" not in repo:
        print("Error: repo must be in owner/repo format", file=sys.stderr)
        sys.exit(1)

    # Clean up URL if full URL given
    if repo.startswith("https://github.com/"):
        repo = repo.replace("https://github.com/", "").rstrip("/")
    if repo.endswith(".git"):
        repo = repo[:-4]

    output = args.output or ".tribucket.yaml"
    if os.path.exists(output) and not args.force:
        print(f"Error: {output} already exists. Use --force to overwrite.", file=sys.stderr)
        sys.exit(1)

    content = generate_example_config(repo)
    Path(output).write_text(content, encoding="utf-8")
    print(f"Created {output}")
    print(f"Edit the file, then run: python -m gen generate")


def cmd_generate(args):
    """Generate multi-format package manager definitions."""
    config = load_config(args.config)

    # If auto_detect is enabled and no asset_pattern, detect first
    if config.auto_detect and not config.asset_pattern:
        print("auto_detect enabled — fetching latest release...")
        token = os.environ.get("GITHUB_TOKEN")
        try:
            release = fetch_release(config.repo, token)
            patterns = detect_patterns(release)
            config.asset_pattern = {k: v for k, v in patterns.items() if v != "NO_MATCH"}
            version = release.version
            print(f"Detected v{version}, {len(config.asset_pattern)}/6 platforms")
        except Exception as e:
            print(f"Warning: auto_detect failed: {e}", file=sys.stderr)
            print("Falling back to manual asset_pattern")
            version = config.version or "0.0.0"
    else:
        # Try to get latest version from GitHub
        token = os.environ.get("GITHUB_TOKEN")
        try:
            release = fetch_release(config.repo, token)
            version = release.version
        except Exception:
            version = config.version or "0.0.0"

    if not config.asset_pattern:
        print("Error: no asset_pattern defined and auto_detect found nothing.", file=sys.stderr)
        print("Run: python -m gen detect <owner/repo>", file=sys.stderr)
        sys.exit(1)

    # Resolve download URLs and SHA256
    print(f"Resolving assets for v{version}...")
    platforms = _resolve_assets(config, version, token)

    # Determine output directory
    output_dir = Path(args.output_dir) if args.output_dir else Path(".")

    # Determine which targets to generate
    targets = config.targets
    if args.target:
        targets = [t.strip() for t in args.target.split(",")]

    generated = []

    if "homebrew" in targets:
        from .generators.homebrew import generate_homebrew, formula_filename
        darwin_linux = {k: v for k, v in platforms.items() if not k.startswith("windows_")}
        if darwin_linux:
            content = generate_homebrew(config, version, darwin_linux)
            filename = formula_filename(config)
            path = output_dir / "Formula" / filename
            generated.append(("homebrew", str(path), content))
        else:
            print("Warning: no macOS/Linux assets, skipping Homebrew Formula")

    if "scoop" in targets:
        from .generators.scoop import generate_scoop, manifest_filename
        windows = {}
        for plat_key in ("windows_amd64", "windows_arm64"):
            if plat_key in platforms:
                arch_key = "64bit" if "amd64" in plat_key else "arm64"
                entry = platforms[plat_key]
                windows[arch_key] = {
                    "url": entry["url"],
                    "hash": entry["sha256"],
                    "filename": entry["url"].split("/")[-1],
                }
        if windows:
            content = generate_scoop(config, version, windows)
            filename = manifest_filename(config)
            path = output_dir / "bucket" / filename
            generated.append(("scoop", str(path), content))
        else:
            print("Warning: no Windows assets, skipping Scoop Manifest")

    if "shell" in targets:
        from .generators.shell import generate_shell, shell_filename
        content = generate_shell(config, version)
        filename = shell_filename(config)
        path = output_dir / "scripts" / filename
        generated.append(("shell", str(path), content))

    # Write or preview
    if args.dry_run:
        for target, path, content in generated:
            print(f"\n{'='*60}")
            print(f"[{target}] {path}")
            print(f"{'='*60}")
            print(content)
    else:
        for target, path, content in generated:
            p = Path(path)
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(content, encoding="utf-8")
            print(f"  → {path}")
        print(f"\nGenerated {len(generated)} file(s)")


def _resolve_assets(config: PackageConfig, version: str, token=None) -> dict:
    """Resolve asset_pattern to actual URLs and SHA256 hashes."""
    release = fetch_release(config.repo, token)
    all_assets = release.assets

    result = {}
    for plat_key, pattern in config.asset_pattern.items():
        # Find matching asset
        matched = None
        for asset in all_assets:
            if pattern in asset.name:
                matched = asset
                break
        if not matched:
            for asset in all_assets:
                if fnmatch(asset.name, f"*{pattern}*"):
                    matched = asset
                    break

        if not matched:
            continue

        # Try to find SHA256 from checksum files
        sha = ""
        for cksum in release.checksum_files:
            try:
                req = Request(cksum.url, headers={
                    "User-Agent": "tribucket-gen/0.1",
                })
                if token:
                    req.add_header("Authorization", f"token {token}")
                with urlopen(req, timeout=30) as resp:
                    content = resp.read().decode("utf-8", errors="replace")
                for line in content.strip().splitlines():
                    parts = line.strip().split()
                    if len(parts) >= 2 and parts[-1] == matched.name:
                        sha = parts[0].lower()
                        break
                if sha:
                    break
            except Exception:
                continue

        result[plat_key] = {
            "url": matched.url,
            "sha256": sha,
        }

    return result


def cmd_detect(args):
    """Detect asset patterns from a GitHub repo's latest release."""
    repo = args.repo
    if not repo:
        print("Error: repo is required (owner/repo or full URL)", file=sys.stderr)
        sys.exit(1)

    # Clean up URL
    if repo.startswith("https://github.com/"):
        repo = repo.replace("https://github.com/", "").rstrip("/")
    if repo.endswith(".git"):
        repo = repo[:-4]

    token = os.environ.get("GITHUB_TOKEN")

    try:
        release = fetch_release(repo, token)
    except Exception as e:
        print(f"Error fetching release: {e}", file=sys.stderr)
        sys.exit(1)

    patterns = detect_patterns(release)
    report = format_detection_report(release, patterns)
    print(report)

    # Optionally output as JSON
    if args.json:
        output = {
            "version": release.version,
            "tag": release.tag,
            "repo": release.repo,
            "asset_pattern": patterns,
            "assets": [
                {"name": a.name, "platform": a.platform, "url": a.url}
                for a in release.assets
            ],
        }
        print("\n--- JSON ---")
        print(json.dumps(output, indent=2, ensure_ascii=False))

    # Optionally generate config
    if args.generate:
        name = repo.split("/")[-1]
        # Fill in detected patterns
        example = generate_example_config(repo, name)
        # Replace auto_detect with actual patterns
        pattern_lines = "\n".join(
            f'  {k}: "{v}"' if v != "NO_MATCH" else f'  {k}: "NO_MATCH"'
            for k, v in patterns.items()
        )
        example = example.replace(
            "auto_detect: true",
            f"# auto_detect: true  # (detected automatically)\n\nasset_pattern:\n{pattern_lines}"
        )
        output_path = args.generate
        Path(output_path).write_text(example, encoding="utf-8")
        print(f"\nGenerated config: {output_path}")


def cmd_check(args):
    """Validate asset_pattern against the latest release."""
    config = load_config(args.config)

    if not config.asset_pattern:
        print("No asset_pattern defined. Nothing to check.")
        sys.exit(0)

    token = os.environ.get("GITHUB_TOKEN")

    try:
        release = fetch_release(config.repo, token)
    except Exception as e:
        print(f"Error fetching release: {e}", file=sys.stderr)
        sys.exit(1)

    print(f"Repository: {config.repo}")
    print(f"Latest: {release.tag}")
    print()

    from fnmatch import fnmatch

    matched = 0
    total = 0
    for plat_key, pattern in config.asset_pattern.items():
        if pattern == "NO_MATCH":
            print(f"  {plat_key:20s} — (skipped)")
            continue

        total += 1
        found = None
        for asset in release.assets:
            if pattern in asset.name:
                found = asset.name
                break
        if not found:
            for asset in release.assets:
                if fnmatch(asset.name, f"*{pattern}*"):
                    found = asset.name
                    break

        if found:
            print(f"  {plat_key:20s} ✓ {found}")
            matched += 1
        else:
            print(f"  {plat_key:20s} ✗ no match for \"{pattern}\"")

    print(f"\nResult: {matched}/{total} platforms matched")
    if matched < total:
        sys.exit(1)


def main(argv=None):
    parser = argparse.ArgumentParser(
        prog="tribucket-gen",
        description="Generate multi-format package manager definitions from .tribucket.yaml",
    )
    parser.add_argument("--version", action="version", version=f"tribucket-gen {__version__}")

    sub = parser.add_subparsers(dest="command")

    # init
    p_init = sub.add_parser("init", help="Create .tribucket.yaml")
    p_init.add_argument("repo", nargs="?", help="GitHub repo (owner/repo or URL)")
    p_init.add_argument("-o", "--output", help="Output file (default: .tribucket.yaml)")
    p_init.add_argument("--force", action="store_true", help="Overwrite existing file")

    # generate
    p_gen = sub.add_parser("generate", help="Generate package manager definitions")
    p_gen.add_argument("-c", "--config", help="Config file path (auto-detect if omitted)")
    p_gen.add_argument("-o", "--output-dir", help="Output directory (default: current)")
    p_gen.add_argument("-t", "--target", help="Comma-separated targets: homebrew,scoop,shell")
    p_gen.add_argument("--dry-run", action="store_true", help="Preview without writing files")

    # detect
    p_detect = sub.add_parser("detect", help="Detect asset patterns from GitHub Release")
    p_detect.add_argument("repo", help="GitHub repo (owner/repo or URL)")
    p_detect.add_argument("--json", action="store_true", help="Also output JSON")
    p_detect.add_argument("-g", "--generate", metavar="FILE", help="Generate .tribucket.yaml to FILE")

    # check
    p_check = sub.add_parser("check", help="Validate asset_pattern against latest release")
    p_check.add_argument("-c", "--config", help="Config file path")

    args = parser.parse_args(argv)

    if not args.command:
        parser.print_help()
        sys.exit(0)

    handlers = {
        "init": cmd_init,
        "generate": cmd_generate,
        "detect": cmd_detect,
        "check": cmd_check,
    }
    handlers[args.command](args)


if __name__ == "__main__":
    main()