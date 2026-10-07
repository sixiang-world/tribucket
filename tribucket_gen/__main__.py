"""CLI entry: python -m tribucket_gen <command>."""
import argparse
import json
import os
import sys
import urllib.error

from . import __version__
from .assets import check_asset_patterns
from .core import load_packages, process_package
from .render.portable import generate_portable

# Windows GBK console cannot encode the ✓/❌/⚠️ symbols used below
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf8"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


def _repo_root():
    root = os.getcwd()
    if not os.path.isdir(os.path.join(root, "packages")):
        print("[error] run from the repository root (packages/ not found)")
        sys.exit(1)
    return root


def build_parser():
    p = argparse.ArgumentParser(
        prog="tribucket_gen",
        description="Generate Homebrew Formula and Scoop bucket from packages/*.json",
    )
    p.add_argument("--version", action="version", version=__version__)
    sub = p.add_subparsers(dest="command", required=True)

    r = sub.add_parser("render", help="Render Formula/*.rb and bucket/*.json from packages/*.json")
    r.add_argument("--only", action="append", default=[], help="single package (can repeat)")
    r.add_argument("--skip-hash", action="store_true", help="Skip SHA256 computation")
    r.add_argument("--dry-run", action="store_true", help="Print output, don't write files")
    r.add_argument("--verbose", action="store_true")
    r.add_argument("--portable", action="store_true", help="Also generate portable/<name>/")
    r.add_argument("--portable-dir", default=None)

    sub.add_parser("check", help="Validate asset_pattern of packages against latest releases")

    d = sub.add_parser("draft", help="Draft a packages/*.json definition from a GitHub repo")
    d.add_argument("repo")
    d.add_argument("--name")
    d.add_argument("--description")
    d.add_argument("--binary")
    d.add_argument("--license", dest="license_id")
    d.add_argument("--homepage")
    d.add_argument("--templates", default=None, help="Override templates.json path")
    d.add_argument("--json", action="store_true", help="Print machine-readable JSON only")
    d.add_argument("--out", default=None, help="Write definition to this path")
    return p


def cmd_render(args):
    repo_dir = _repo_root()
    packages_dir = os.path.join(repo_dir, "packages")
    formula_dir = os.path.join(repo_dir, "Formula")
    bucket_dir = os.path.join(repo_dir, "bucket")
    cache_dir = os.path.join(repo_dir, ".cache")
    portable_dir = args.portable_dir or os.path.join(repo_dir, "portable")

    pkgs = load_packages(packages_dir, only=args.only or None)
    if not pkgs:
        print("[error] No packages found.")
        return 1

    has_errors = False
    for pkg in pkgs:
        name = pkg["name"]
        print(f"\n[{name}]")
        try:
            formula, bucket, new_version, new_urls = process_package(
                pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose
            )
        except urllib.error.URLError as e:
            print(f"  [warn] {name}: network error — {e}")
            continue
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_errors = True
            continue

        if formula is None and bucket is None:
            continue

        if new_version and not args.dry_run:
            pkg_path = os.path.join(packages_dir, f"{name}.json")
            try:
                with open(pkg_path, encoding="utf-8") as f:
                    pkg_data = json.load(f)
                pkg_data["version"] = new_version
                if new_urls:
                    pkg_data["download_url"] = new_urls
                with open(pkg_path, "w", encoding="utf-8") as f:
                    json.dump(pkg_data, f, indent=2, ensure_ascii=False)
                    f.write("\n")
                print(f"  -> packages/{name}.json (version → {new_version})")
            except Exception as e:
                print(f"  [warn] {name}: failed to write back version: {e}")

        if args.dry_run:
            if formula:
                print(f"\n--- Formula/{name}.rb ---")
                print(formula)
            if bucket:
                print(f"\n--- bucket/{name}.json ---")
                print(bucket)
            if args.portable:
                generate_portable(pkg, portable_dir, dry_run=True, verbose=args.verbose)
        else:
            if formula:
                os.makedirs(formula_dir, exist_ok=True)
                with open(os.path.join(formula_dir, f"{name}.rb"), "w", encoding="utf-8") as f:
                    f.write(formula)
                print(f"  -> Formula/{name}.rb")
            if bucket:
                os.makedirs(bucket_dir, exist_ok=True)
                with open(os.path.join(bucket_dir, f"{name}.json"), "w", encoding="utf-8") as f:
                    f.write(bucket)
                print(f"  -> bucket/{name}.json")
            if args.portable:
                generate_portable(pkg, portable_dir, verbose=args.verbose)
                print(f"  -> portable/{name}/")

    print(f"\nDone. Processed {len(pkgs)} package(s).")
    if has_errors:
        print("Some packages had errors (see above).")
        return 2
    return 0


def cmd_check(args):
    repo_dir = _repo_root()
    pkgs = load_packages(os.path.join(repo_dir, "packages"))
    if not pkgs:
        print("[error] No packages found.")
        return 1
    print(f"Checking asset patterns for {len(pkgs)} package(s)...\n")
    ok = check_asset_patterns(pkgs)
    print(f"\n{'All patterns OK.' if ok else 'Some patterns have issues (see above).'}")
    return 0 if ok else 1


def cmd_draft(args):
    from .draft import DraftError, draft
    try:
        pkg, notes = draft(
            args.repo, name=args.name, description=args.description,
            binary=args.binary, license_id=args.license_id, homepage=args.homepage,
            templates_path=args.templates,
        )
    except DraftError as e:
        is_no_template = "no known template" in str(e)
        print(f"[draft error] {e}", file=sys.stderr)
        for a in e.assets[:20]:
            print(f"  asset: {a}", file=sys.stderr)
        return 2 if is_no_template else 1
    except Exception as e:  # network etc.
        print(f"[draft error] {e}", file=sys.stderr)
        return 1
    if args.json or args.out:
        payload = json.dumps(pkg, indent=2, ensure_ascii=False) + "\n"
        if args.out:
            with open(args.out, "w", encoding="utf-8") as f:
                f.write(payload)
        else:
            print(payload, end="")
    else:
        print(json.dumps(pkg, indent=2, ensure_ascii=False))
        for n in notes:
            print(f"# {n}")
    return 0


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.command == "render":
        return cmd_render(args)
    if args.command == "check":
        return cmd_check(args)
    if args.command == "draft":
        return cmd_draft(args)
    return 1


if __name__ == "__main__":
    sys.exit(main())
