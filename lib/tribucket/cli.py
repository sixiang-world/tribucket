#!/usr/bin/env python3
"""tribucket CLI — argparse command routing."""
import argparse
import json
import os
import sys

from tribucket import __version__


def main(argv=None):
    # Python version check
    if sys.version_info < (3, 8):
        print(f"Error: tribucket requires Python 3.8 or later (found {sys.version_info.major}.{sys.version_info.minor})",
              file=sys.stderr)
        sys.exit(1)

    if argv is None:
        argv = sys.argv[1:]

    parser = _build_parser()
    args = parser.parse_args(argv)

    if not hasattr(args, "func"):
        parser.print_help()
        sys.exit(0)

    try:
        args.func(args)
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        if os.environ.get("TRIBUCKET_VERBOSE") == "1":
            import traceback
            traceback.print_exc()
        else:
            print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


def _build_parser():
    parser = argparse.ArgumentParser(
        prog="tribucket",
        description="Lightweight portable package manager",
    )
    parser.add_argument("--version", action="version", version=f"tribucket {__version__}")

    sub = parser.add_subparsers(dest="command")

    # install
    p = sub.add_parser("install", help="Install a package")
    p.add_argument("name", help="Package name")
    p.add_argument("--dir", "-d", default=None, help="Install directory (default: cwd)")
    p.add_argument("--link", action="store_true", help="Create symlink in ~/.tribucket/bin/")
    p.add_argument("--force", action="store_true", help="Overwrite existing installation")
    p.add_argument("--mirror", default="auto", choices=["auto", "cn", "direct"])
    p.set_defaults(func=_cmd_install)

    # uninstall
    p = sub.add_parser("uninstall", help="Uninstall a package")
    p.add_argument("name", help="Package name")
    p.set_defaults(func=_cmd_uninstall)

    # track
    p = sub.add_parser("track", help="Track an existing package")
    p.add_argument("name", help="Package name")
    p.add_argument("path", nargs="?", default=None, help="Package path (default: cwd)")
    p.set_defaults(func=_cmd_track)

    # untrack
    p = sub.add_parser("untrack", help="Stop tracking a package")
    p.add_argument("name", help="Package name")
    p.set_defaults(func=_cmd_untrack)

    # list
    p = sub.add_parser("list", help="List tracked packages")
    p.add_argument("--json", dest="json_output", action="store_true", help="JSON output")
    p.add_argument("--check", action="store_true", help="Run version detection")
    p.add_argument("--sort", default="name", choices=["name", "status"])
    p.set_defaults(func=_cmd_list)

    # check
    p = sub.add_parser("check", help="Check package versions")
    p.add_argument("targets", nargs="*", help="Package names or paths")
    p.add_argument("--all", action="store_true", help="Check all tracked packages")
    p.add_argument("--refresh", action="store_true", help="Force remote version check")
    p.add_argument("--local-only", action="store_true", help="Skip remote check")
    p.add_argument("--json", dest="json_output", action="store_true", help="JSON output")
    p.set_defaults(func=_cmd_check)

    # update
    p = sub.add_parser("update", help="Update a package")
    p.add_argument("name", nargs="?", help="Package name")
    p.add_argument("--all", action="store_true", help="Update all packages")
    p.add_argument("--force", action="store_true", help="Force re-download")
    p.add_argument("--dry-run", action="store_true", help="Show what would be updated")
    p.add_argument("--mirror", default="auto", choices=["auto", "cn", "direct"])
    p.add_argument("--no-backup", action="store_true", help="Skip backup")
    p.set_defaults(func=_cmd_update)

    # info
    p = sub.add_parser("info", help="Show package details")
    p.add_argument("name", help="Package name")
    p.set_defaults(func=_cmd_info)

    # config
    p = sub.add_parser("config", help="Manage configuration")
    config_sub = p.add_subparsers(dest="config_command")
    config_sub.add_parser("list", help="Show all settings")
    gp = config_sub.add_parser("get", help="Get a setting")
    gp.add_argument("key", help="Setting key")
    sp = config_sub.add_parser("set", help="Set a setting")
    sp.add_argument("key", help="Setting key")
    sp.add_argument("value", help="Setting value")
    up = config_sub.add_parser("unset", help="Unset a setting")
    up.add_argument("key", help="Setting key")
    p.set_defaults(func=_cmd_config)

    return parser


# ── Command implementations ──────────────────────────────────────

def _cmd_install(args):
    from tribucket.install import install_package
    ok = install_package(
        args.name,
        target_dir=args.dir,
        link=args.link,
        force=args.force,
        mirror_mode=args.mirror,
    )
    if not ok:
        sys.exit(1)


def _cmd_uninstall(args):
    from tribucket.track import get_all_packages, untrack
    from tribucket.config import bin_dir
    import shutil

    packages = get_all_packages()
    info = packages.get(args.name)
    if not info:
        print(f"Error: '{args.name}' is not tracked.", file=sys.stderr)
        sys.exit(1)

    path = info.get("path", "")

    # Delete package directory
    if os.path.exists(path):
        shutil.rmtree(path)
        print(f"Deleted: {path}")

    # Delete symlink
    bd = bin_dir()
    for f in os.listdir(bd) if os.path.isdir(bd) else []:
        link = os.path.join(bd, f)
        if os.path.islink(link) and os.readlink(link).startswith(path):
            os.unlink(link)
            print(f"Removed symlink: {link}")

    # Delete backup
    from tribucket.config import backup_dir
    backup = os.path.join(backup_dir(), args.name)
    if os.path.exists(backup):
        shutil.rmtree(backup)
        print(f"Removed backup: {backup}")

    # Untrack
    untrack(args.name)


def _cmd_track(args):
    from tribucket.track import track
    path = args.path or os.getcwd()
    ok = track(args.name, path)
    if not ok:
        sys.exit(1)


def _cmd_untrack(args):
    from tribucket.track import untrack
    ok = untrack(args.name)
    if not ok:
        sys.exit(1)


def _cmd_list(args):
    from tribucket.track import list_packages, find_dangling_symlinks

    packages = list_packages()
    if not packages:
        return

    if args.json_output:
        result = {}
        for name, info in packages:
            result[name] = info
        print(json.dumps({"packages": result}, indent=2, ensure_ascii=False))
        return

    # Sort
    if args.sort == "status":
        # Packages with stale entries first, then by name
        packages.sort(key=lambda x: (os.path.exists(x[1].get("path", "")), x[0]))
        packages.reverse()  # stale first
    else:
        packages.sort(key=lambda x: x[0])

    # Header
    print(f"{'Name':20s}  {'Version':12s}  {'Path':40s}  {'Status'}")
    print("-" * 90)

    for name, info in packages:
        path = info.get("path", "")
        version = info.get("version", "?")
        exists = os.path.exists(path)
        status = "✓" if exists else "✗ not found"
        print(f"{name:20s}  {version:12s}  {path:40s}  {status}")

    # Check for dangling symlinks
    dangling = find_dangling_symlinks()
    if dangling:
        print(f"\n⚠ Found {len(dangling)} dangling symlink(s):")
        for name, path, target in dangling:
            print(f"  {path} → {target}")


def _cmd_check(args):
    from tribucket.check import check_package, format_check_result
    from tribucket.track import get_all_packages

    if args.all:
        packages = get_all_packages()
        targets = list(packages.keys())
    elif args.targets:
        targets = args.targets
    else:
        parser = argparse.ArgumentParser()
        parser.error("Specify package names or use --all")

    results = []
    for target in targets:
        result = check_package(target, refresh=args.refresh, local_only=args.local_only)
        results.append(result)

    if args.json_output:
        output = {}
        for r in results:
            name = r.get("name", "?")
            output[name] = {
                "local": r.get("local"),
                "remote": r.get("remote"),
                "status": r.get("status"),
                "source": r.get("local_source"),
            }
        print(json.dumps(output, indent=2, ensure_ascii=False))
        return

    for r in results:
        if "error" in r:
            print(f"{r['name']:20s}  ✗ {r['error']}")
        else:
            print(format_check_result(
                r["name"], r["local"], r["local_source"],
                r["remote"], r.get("path_exists", True)
            ))


def _cmd_update(args):
    if args.all:
        from tribucket.track import get_all_packages
        packages = get_all_packages()
        if not packages:
            print("No packages tracked.")
            return

        from tribucket.update import update_package
        success = 0
        failed = 0
        for name in packages:
            ok = update_package(name, force=args.force, mirror_mode=args.mirror,
                                no_backup=args.no_backup)
            if ok:
                success += 1
            else:
                failed += 1
        print(f"\n{success} updated, {failed} failed.")
        return

    if not args.name:
        parser = argparse.ArgumentParser()
        parser.error("Specify a package name or use --all")

    if args.dry_run:
        from tribucket.check import check_package
        result = check_package(args.name)
        if "error" in result:
            print(f"Error: {result['error']}")
            sys.exit(1)
        remote = result.get("remote")
        local = result.get("local")
        if remote and local != remote:
            print(f"{args.name}: {local} → {remote} (would update)")
        else:
            print(f"{args.name}: {local} — already up to date")
        return

    from tribucket.update import update_package
    ok = update_package(args.name, force=args.force, mirror_mode=args.mirror,
                        no_backup=args.no_backup)
    if not ok:
        sys.exit(1)


def _cmd_info(args):
    from tribucket.track import get_all_packages
    import json

    packages = get_all_packages()
    info = packages.get(args.name)
    if not info:
        print(f"Error: '{args.name}' is not tracked.", file=sys.stderr)
        sys.exit(1)

    path = info.get("path", "")

    # Try to load tribucket.json
    tj = None
    tj_path = os.path.join(path, "tribucket.json")
    if os.path.isfile(tj_path):
        try:
            with open(tj_path) as f:
                tj = json.load(f)
        except (json.JSONDecodeError, OSError):
            pass

    print(f"Name:        {args.name}")
    if tj:
        print(f"Repo:        {tj.get('repo', '?')}")
        print(f"Description: {tj.get('description', '?')}")
        print(f"Binary:      {tj.get('binary', '?')}")
        print(f"License:     {tj.get('license', '?')}")
        print(f"Homepage:    {tj.get('homepage', '?')}")
        print(f"Install:     {tj.get('install_type', 'binary')}")
    print()
    print(f"Installed:   {path}")
    print(f"Version:     {info.get('version', '?')}")
    print(f"Tracked at:  {info.get('installed_at', '?')}")


def _cmd_config(args):
    from tribucket.config import load_config, save_config

    config = load_config()

    if args.config_command == "list":
        settings = config.get("settings", {})
        if not settings:
            print("No settings configured.")
            return
        for key, value in settings.items():
            print(f"{key} = {value}")

    elif args.config_command == "get":
        value = config.get("settings", {}).get(args.key)
        if value is None:
            print(f"Setting '{args.key}' is not set.")
        else:
            print(value)

    elif args.config_command == "set":
        config.setdefault("settings", {})[args.key] = args.value
        save_config(config)
        print(f"Set {args.key} = {args.value}")

    elif args.config_command == "unset":
        settings = config.get("settings", {})
        if args.key in settings:
            del settings[args.key]
            save_config(config)
            print(f"Unset {args.key}")
        else:
            print(f"Setting '{args.key}' is not set.")

    else:
        print("Usage: tribucket config [list|get|set|unset]")


if __name__ == "__main__":
    main()
