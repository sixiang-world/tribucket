"""CLI entry: python -m tribucket_gen <command>."""
import argparse
import json
import os
import shutil
import sys
import tempfile
from functools import partial
from pathlib import Path

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

    overrides = argparse.ArgumentParser(add_help=False)
    overrides.add_argument("repo", metavar="owner/repo")
    overrides.add_argument("--name")
    overrides.add_argument("--description")
    overrides.add_argument("--binary")
    overrides.add_argument("--license", dest="license_id")
    overrides.add_argument("--homepage")

    sub.add_parser("add", parents=[overrides], help="Draft, validate, and render a new package")
    d = sub.add_parser("draft", parents=[overrides], help="Draft a package definition from a GitHub repo")
    d.add_argument("--templates", default=None, help="Override templates.json path")
    d.add_argument("--json", action="store_true", help="Print machine-readable JSON only")
    d.add_argument("--out", default=None, help="Write definition to this path")

    v = sub.add_parser("validate", help="Validate a package definition file")
    v.add_argument("file", help="Path to definition JSON, or '-' for stdin")
    v.add_argument("--json", action="store_true")
    v.add_argument("--packages-dir", default=None)
    v.add_argument("--offline", action="store_true", help="Skip online asset check")
    return p


def _write_package_changes(repo_dir, changes):
    """Stage the file contents before replacing any of a package's files."""
    with tempfile.TemporaryDirectory(dir=repo_dir) as staging:
        staging = Path(staging)
        prepared = {}
        for index, (path, content) in enumerate(changes.items()):
            path.parent.mkdir(parents=True, exist_ok=True)
            new = staging / f"{index}.new"
            new.write_text(content, encoding="utf-8")
            backup = staging / f"{index}.bak" if path.exists() else None
            if backup is not None:
                shutil.copy2(path, backup)
            prepared[path] = (new, backup)

        replaced = []
        try:
            for path, (new, backup) in prepared.items():
                os.replace(new, path)
                replaced.append((path, backup))
        except OSError:
            for path, backup in reversed(replaced):
                if backup is not None:
                    os.replace(backup, path)
                else:
                    path.unlink()
            raise


def cmd_render(args):
    repo_dir = Path(_repo_root())
    cache_dir = repo_dir / ".cache"
    portable_dir = args.portable_dir or repo_dir / "portable"
    wanted = set(args.only)
    paths = sorted(path for path in (repo_dir / "packages").glob("*.json")
                   if not wanted or path.stem in wanted)
    summary = {"updated": [], "unchanged": [], "failed": []}
    for missing in sorted(wanted - {path.stem for path in paths}):
        print(f"[error] {missing}: package not found")
        summary["failed"].append(missing)

    for pkg_path in paths:
        name = pkg_path.stem
        if args.verbose or args.dry_run:
            print(f"\n[{name}]")
        try:
            pkg = json.loads(pkg_path.read_text(encoding="utf-8"))
            if pkg["name"] != name:
                raise ValueError("definition name does not match its filename")
            formula, bucket, version, urls = process_package(
                pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose
            )
            if formula is None and bucket is None:
                raise ValueError("no Formula or Scoop manifest could be rendered")

            changes = {}
            for rel_path, text in ((f"Formula/{name}.rb", formula), (f"bucket/{name}.json", bucket)):
                if text is None:
                    continue
                path = repo_dir / rel_path
                if args.dry_run:
                    print(f"\n--- {rel_path} ---\n{text}")
                if not path.exists() or path.read_text(encoding="utf-8") != text:
                    changes[path] = text
            if version:
                pkg["version"] = version
                if urls:
                    pkg["download_url"] = urls
                changes[pkg_path] = json.dumps(pkg, indent=2, ensure_ascii=False) + "\n"

            if args.portable and not generate_portable(
                pkg, portable_dir, dry_run=args.dry_run, verbose=args.verbose
            ):
                raise ValueError("portable outputs could not be rendered")
            if changes and not args.dry_run:
                _write_package_changes(repo_dir, changes)
                for path in changes:
                    print(f"  -> {path.relative_to(repo_dir).as_posix()}")
        except Exception as exc:
            print(f"[error] {name}: {exc}")
            summary["failed"].append(name)
        else:
            summary["updated" if changes else "unchanged"].append(name)

    print("\nRender summary" + (" (dry run)" if args.dry_run else ""))
    for status, names in summary.items():
        print(f"  {status} ({len(names)}): {', '.join(names) or 'none'}")
    if summary["failed"]:
        return 2
    if not paths:
        print("[error] No packages found.")
        return 1
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


def cmd_draft(args, *, add=False):
    from .draft import DraftError, draft
    root = Path(_repo_root()) if add else None
    try:
        pkg, notes = draft(
            args.repo, name=args.name, description=args.description,
            binary=args.binary, license_id=args.license_id, homepage=args.homepage,
            templates_path=getattr(args, "templates", None), token=os.environ.get("GITHUB_TOKEN"),
        )
    except DraftError as e:
        is_no_template = e.kind == "no-template"
        print(f"[draft error] {e}", file=sys.stderr)
        for a in e.assets[:20]:
            print(f"  asset: {a}", file=sys.stderr)
        return 2 if is_no_template else 1
    except Exception as e:  # network etc.
        print(f"[draft error] {e}", file=sys.stderr)
        return 1
    if add:
        return _add_package(root, pkg)
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


def _add_package(root, pkg):
    name = pkg["name"]
    definition = root / "packages" / f"{name}.json"
    outputs = (root / "Formula" / f"{name}.rb", root / "bucket" / f"{name}.json")
    created = []
    status = 1
    try:
        for path in (definition, *outputs):
            if path.parent.is_dir() and any(
                existing.name.casefold() == path.name.casefold() for existing in path.parent.iterdir()
            ):
                print(f"[error] {path.relative_to(root)} already exists", file=sys.stderr)
                return 1
        with definition.open("x", encoding="utf-8", newline="\n") as f:
            created.append(definition)
            json.dump(pkg, f, indent=2, ensure_ascii=False)
            f.write("\n")
        parser = build_parser()
        if cmd_validate(parser.parse_args(["validate", str(definition)]), strict=True):
            return 1
        created.extend(outputs)
        status = cmd_render(parser.parse_args(["render", "--only", name]))
        return status
    except (OSError, ValueError) as e:
        print(f"[add error] {e}", file=sys.stderr)
        return 1
    finally:
        if status:
            for path in created:
                path.unlink(missing_ok=True)


def cmd_validate(args, *, strict=False):
    from .validate import validate_definition
    if args.file == "-":
        pkg = json.load(sys.stdin)
    else:
        with open(args.file, encoding="utf-8") as f:
            pkg = json.load(f)
    packages_dir = args.packages_dir or os.path.join(os.getcwd(), "packages")
    fetch = None
    if not args.offline:
        from .release import fetch_latest_release
        fetch = partial(fetch_latest_release, token=os.environ.get("GITHUB_TOKEN"))
    errors, warnings = validate_definition(
        pkg, packages_dir=packages_dir, fetch_release=fetch,
        definition_path=None if args.file == "-" else args.file,
    )
    if strict:
        errors.extend(warnings)
        warnings = []
    if args.json:
        print(json.dumps({"ok": not errors, "errors": errors, "warnings": warnings},
                         ensure_ascii=False, indent=2))
    else:
        for e in errors:
            print(f"[error] {e}")
        for w in warnings:
            print(f"[warn] {w}")
        print("OK" if not errors else f"{len(errors)} error(s)")
    return 0 if not errors else 1


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.command == "render":
        return cmd_render(args)
    if args.command == "check":
        return cmd_check(args)
    if args.command == "draft":
        return cmd_draft(args)
    if args.command == "add":
        return cmd_draft(args, add=True)
    if args.command == "validate":
        return cmd_validate(args)
    return 1


if __name__ == "__main__":
    sys.exit(main())
