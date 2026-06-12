#!/usr/bin/env python3
"""tribucket CLI — argparse command routing."""
import argparse
import json
import os
import platform
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

from tribucket import __version__
from tribucket.utils import (
    EXIT_OK, EXIT_ERROR, EXIT_USAGE, EXIT_NOT_FOUND, EXIT_EXISTS,
    EXIT_NOT_TRACKED, EXIT_UP_TO_DATE, EXIT_NO_NETWORK, log,
)


def main(argv=None):
    # Python version check
    if sys.version_info < (3, 8):
        print(f"Error: tribucket requires Python 3.8 or later (found {sys.version_info.major}.{sys.version_info.minor})",
              file=sys.stderr)
        sys.exit(EXIT_ERROR)

    if argv is None:
        argv = sys.argv[1:]

    parser = _build_parser()
    args = parser.parse_args(argv)

    if not hasattr(args, "func") and not args.show_version:
        parser.print_help()
        sys.exit(EXIT_OK)

    # Handle --version (with optional --json)
    if args.show_version:
        if args.json_output:
            print(json.dumps({
                "version": __version__,
                "python": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
                "platform": _detect_platform_str(),
            }))
        else:
            print(f"tribucket {__version__}")
        sys.exit(EXIT_OK)

    try:
        args.func(args)
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        sys.exit(130)
    except SystemExit:
        raise
    except Exception as e:
        if os.environ.get("TRIBUCKET_VERBOSE") == "1":
            import traceback
            traceback.print_exc()
        else:
            print(f"Error: {e}", file=sys.stderr)
        sys.exit(EXIT_ERROR)


def _build_parser():
    parser = argparse.ArgumentParser(
        prog="tribucket",
        description="Lightweight portable package manager",
    )
    parser.add_argument("--version", "-V", action="store_true", dest="show_version",
                        help="Show version")
    parser.add_argument("--json", dest="json_output", action="store_true",
                        help="JSON output (with --version)")
    parser.add_argument("--no-color", action="store_true", default=False,
                        help="Disable colored output")

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

    # self-update
    p = sub.add_parser("self-update", help="Update tribucket CLI itself")
    p.set_defaults(func=_cmd_self_update)

    # clean
    p = sub.add_parser("clean", help="Remove stale entries and dangling symlinks")
    p.set_defaults(func=_cmd_clean)

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


# ── Helpers ──────────────────────────────────────────────────────

NO_COLOR = False


def _detect_platform_str():
    """Detect platform as linux_amd64 etc."""
    import platform as _platform
    sys_name = _platform.system().lower()
    machine = _platform.machine().lower()
    os_map = {"linux": "linux", "darwin": "darwin", "windows": "windows"}
    arch_map = {"x86_64": "amd64", "amd64": "amd64", "aarch64": "arm64", "arm64": "arm64"}
    os_key = os_map.get(sys_name, sys_name)
    arch_key = arch_map.get(machine, machine)
    return f"{os_key}_{arch_key}"


def _init_color(args):
    global NO_COLOR
    NO_COLOR = getattr(args, "no_color", False) or os.environ.get("NO_COLOR") or not sys.stdout.isatty()


def _sym(name):
    """Return symbol or plain fallback."""
    if NO_COLOR:
        return {"ok": "OK", "warn": "WARN", "err": "ERR", "skip": "SKIP",
                "arrow": "->", "bullet": "*"}.get(name, "")
    symbols = {"ok": "✓", "warn": "⚠", "err": "✗", "skip": "?",
               "arrow": "→", "bullet": "•"}
    return symbols.get(name, "")


# ── Command implementations ──────────────────────────────────────

def _cmd_install(args):
    _init_color(args)
    from tribucket.install import install_package
    ok = install_package(
        args.name,
        target_dir=args.dir,
        link=args.link,
        force=args.force,
        mirror_mode=args.mirror,
    )
    if not ok:
        sys.exit(EXIT_ERROR)


def _cmd_uninstall(args):
    _init_color(args)
    from tribucket.track import get_all_packages, untrack
    from tribucket.config import bin_dir
    import shutil

    packages = get_all_packages()
    info = packages.get(args.name)
    if not info:
        print(f"Error: '{args.name}' is not tracked.", file=sys.stderr)
        sys.exit(EXIT_NOT_TRACKED)

    path = info.get("path", "")

    if os.path.exists(path):
        shutil.rmtree(path)
        print(f"Deleted: {path}")

    bd = bin_dir()
    for f in os.listdir(bd) if os.path.isdir(bd) else []:
        link = os.path.join(bd, f)
        if os.path.islink(link) and os.readlink(link).startswith(path):
            os.unlink(link)
            print(f"Removed symlink: {link}")

    from tribucket.config import backup_dir
    backup = os.path.join(backup_dir(), args.name)
    if os.path.exists(backup):
        shutil.rmtree(backup)
        print(f"Removed backup: {backup}")

    untrack(args.name)


def _cmd_track(args):
    _init_color(args)
    from tribucket.track import track
    path = args.path or os.getcwd()
    ok = track(args.name, path)
    if not ok:
        sys.exit(EXIT_ERROR)


def _cmd_untrack(args):
    _init_color(args)
    from tribucket.track import untrack
    ok = untrack(args.name)
    if not ok:
        sys.exit(EXIT_NOT_FOUND)


def _cmd_list(args):
    _init_color(args)
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

    if args.sort == "status":
        packages.sort(key=lambda x: (os.path.exists(x[1].get("path", "")), x[0]))
        packages.reverse()
    else:
        packages.sort(key=lambda x: x[0])

    print(f"{'Name':20s}  {'Version':12s}  {'Path':40s}  {'Status'}")
    print("-" * 90)

    for name, info in packages:
        path = info.get("path", "")
        version = info.get("version", "?")
        exists = os.path.exists(path)
        status = f"{_sym('ok')} latest" if exists else f"{_sym('err')} not found"
        print(f"{name:20s}  {version:12s}  {path:40s}  {status}")

    dangling = find_dangling_symlinks()
    if dangling:
        print(f"\n{_sym('warn')} Found {len(dangling)} dangling symlink(s):")
        for name, path, target in dangling:
            print(f"  {path} -> {target}")


def _cmd_check(args):
    _init_color(args)
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

    # Concurrent check for --all with multiple targets
    if len(targets) > 1 and not args.local_only:
        results = _concurrent_check(targets, args.refresh, args.local_only)
    else:
        results = [check_package(t, refresh=args.refresh, local_only=args.local_only)
                   for t in targets]

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
            print(f"{r['name']:20s}  {_sym('err')} {r['error']}")
        else:
            print(format_check_result(
                r["name"], r["local"], r["local_source"],
                r["remote"], r.get("path_exists", True)
            ))


def _concurrent_check(targets, refresh, local_only, workers=4):
    """Check multiple packages concurrently."""
    from tribucket.check import check_package
    results = [None] * len(targets)

    with ThreadPoolExecutor(max_workers=workers) as executor:
        future_to_idx = {
            executor.submit(check_package, t, refresh=refresh, local_only=local_only): i
            for i, t in enumerate(targets)
        }
        for future in as_completed(future_to_idx):
            idx = future_to_idx[future]
            try:
                results[idx] = future.result()
            except Exception as e:
                results[idx] = {"name": targets[idx], "error": str(e)}

    return results


def _cmd_update(args):
    _init_color(args)
    if args.all:
        from tribucket.track import get_all_packages
        packages = get_all_packages()
        if not packages:
            print("No packages tracked.")
            return

        names = list(packages.keys())

        # --all --dry-run: show what would be updated
        if args.dry_run:
            from tribucket.check import check_package
            would_update = []
            for name in names:
                result = check_package(name, local_only=False)
                remote = result.get("remote")
                local = result.get("local")
                if remote and local != remote:
                    would_update.append((name, local, remote))
                elif remote:
                    print(f"{name:20s}  {local} — already up to date")

            if would_update:
                print(f"\n{_sym('warn')} {len(would_update)} package(s) would be updated:")
                for name, local, remote in would_update:
                    print(f"  {name}: {local} -> {remote}")
            else:
                print(f"\n{_sym('ok')} All packages up to date.")
            return

        # Concurrent update for --all
        if len(names) > 1:
            success, failed = _concurrent_update(names, args.force, args.mirror, args.no_backup)
        else:
            from tribucket.update import update_package
            success = 0
            failed = 0
            ok = update_package(names[0], force=args.force, mirror_mode=args.mirror,
                                no_backup=args.no_backup)
            if ok:
                success = 1
            else:
                failed = 1

        print(f"\n{success} updated, {failed} failed.")
        sys.exit(EXIT_OK if failed == 0 else EXIT_ERROR)
        return

    if not args.name:
        parser = argparse.ArgumentParser()
        parser.error("Specify a package name or use --all")

    if args.dry_run:
        from tribucket.check import check_package
        result = check_package(args.name)
        if "error" in result:
            print(f"Error: {result['error']}")
            sys.exit(EXIT_NOT_FOUND)
        remote = result.get("remote")
        local = result.get("local")
        if remote and local != remote:
            print(f"{args.name}: {local} -> {remote} (would update)")
        else:
            print(f"{args.name}: {local} — already up to date")
        sys.exit(EXIT_OK)

    from tribucket.update import update_package
    ok = update_package(args.name, force=args.force, mirror_mode=args.mirror,
                        no_backup=args.no_backup)
    if not ok:
        sys.exit(EXIT_ERROR)


def _concurrent_update(names, force, mirror_mode, no_backup, workers=4):
    """Update multiple packages concurrently."""
    from tribucket.update import update_package
    import threading

    success = 0
    failed = 0
    lock = threading.Lock()

    def _do_update(name):
        nonlocal success, failed
        try:
            ok = update_package(name, force=force,
                               mirror_mode=mirror_mode, no_backup=no_backup)
            with lock:
                if ok:
                    success += 1
                else:
                    failed += 1
        except Exception:
            with lock:
                failed += 1

    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = [executor.submit(_do_update, name) for name in names]
        for future in as_completed(futures):
            pass  # Results captured via lock

    return success, failed


def _cmd_info(args):
    _init_color(args)
    from tribucket.track import get_all_packages

    packages = get_all_packages()
    info = packages.get(args.name)
    if not info:
        print(f"Error: '{args.name}' is not tracked.", file=sys.stderr)
        sys.exit(EXIT_NOT_FOUND)

    path = info.get("path", "")

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


def _cmd_self_update(args):
    _init_color(args)
    import urllib.request
    import shutil

    print("Checking for updates...")

    # Get latest version from GitHub
    try:
        req = urllib.request.Request(
            "https://api.github.com/repos/sixiang-world/tribucket/releases/latest",
            headers={"Accept": "application/vnd.github.v3+json", "User-Agent": "tribucket/2.0"},
        )
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
            latest = data["tag_name"].lstrip("v")
    except Exception as e:
        print(f"Error: Cannot check for updates: {e}", file=sys.stderr)
        sys.exit(EXIT_NO_NETWORK)

    if latest == __version__:
        print(f"Already up to date ({__version__})")
        sys.exit(EXIT_OK)

    print(f"Current: {__version__}  Latest: {latest}")

    # Determine install location
    script_path = os.path.abspath(sys.argv[0])
    lib_dir = os.path.join(os.path.dirname(script_path), "..", "lib", "tribucket")
    if not os.path.isdir(lib_dir):
        # Try relative to script
        lib_dir = os.path.join(os.path.dirname(script_path), "lib", "tribucket")

    base_url = "https://raw.githubusercontent.com/sixiang-world/tribucket/main"

    try:
        # 1. Download and update bin/tribucket
        url = f"{base_url}/bin/tribucket"
        req = urllib.request.Request(url, headers={"User-Agent": "tribucket/2.0"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            new_cli = resp.read()

        # SHA256 verification (best-effort)
        try:
            from tribucket.utils import find_sha256_from_release, compute_sha256
            cksum_url = "https://api.github.com/repos/sixiang-world/tribucket/releases/latest"
            req_ck = urllib.request.Request(cksum_url,
                headers={"Accept": "application/vnd.github.v3+json", "User-Agent": "tribucket/2.0"})
            with urllib.request.urlopen(req_ck, timeout=10) as resp_ck:
                release_data = json.loads(resp_ck.read())
            expected = find_sha256_from_release(release_data, "tribucket")
            if expected:
                import tempfile
                with tempfile.NamedTemporaryFile(delete=False, suffix="_tribucket") as tmp:
                    tmp.write(new_cli)
                    tmp.flush()
                    actual = compute_sha256(tmp.name)
                os.unlink(tmp.name)
                if actual != expected:
                    print(f"Error: SHA256 mismatch — download may be corrupted", file=sys.stderr)
                    sys.exit(EXIT_ERROR)
                log("SHA256 verification OK")
        except Exception:
            log("SHA256 verification skipped")

        backup_path = script_path + ".bak"
        shutil.copy2(script_path, backup_path)
        with open(script_path, "wb") as f:
            f.write(new_cli)
        print(f"Updated: {script_path}")

        # 2. Download and update lib/tribucket/*.py
        LIB_MODULES = [
            "__init__.py", "cli.py", "config.py", "utils.py",
            "check.py", "update.py", "mirror.py", "track.py", "install.py",
        ]
        if os.path.isdir(lib_dir):
            updated_lib = 0
            for module in LIB_MODULES:
                module_url = f"{base_url}/lib/tribucket/{module}"
                module_path = os.path.join(lib_dir, module)
                try:
                    req = urllib.request.Request(module_url, headers={"User-Agent": "tribucket/2.0"})
                    with urllib.request.urlopen(req, timeout=15) as resp:
                        content = resp.read()
                    with open(module_path, "wb") as f:
                        f.write(content)
                    updated_lib += 1
                except Exception:
                    pass
            if updated_lib:
                print(f"Updated: {updated_lib} engine modules in {lib_dir}")

        print(f"Updated: {__version__} -> {latest}")

    except Exception as e:
        print(f"Error: Update failed: {e}", file=sys.stderr)
        sys.exit(EXIT_ERROR)


def _cmd_clean(args):
    _init_color(args)
    from tribucket.track import remove_stale_entries, find_dangling_symlinks
    from tribucket.config import bin_dir
    import os

    # Remove stale entries
    removed = remove_stale_entries()
    if removed:
        print(f"Removed {len(removed)} stale entry(ies):")
        for name in removed:
            print(f"  {_sym('ok')} {name}")
    else:
        print("No stale entries found.")

    # Remove dangling symlinks
    bd = bin_dir()
    dangling = find_dangling_symlinks()
    if dangling:
        print(f"\nRemoving {len(dangling)} dangling symlink(s):")
        for name, path, target in dangling:
            os.unlink(path)
            print(f"  {_sym('ok')} {path} -> {target}")
    elif not removed:
        print("Nothing to clean.")


def _cmd_config(args):
    _init_color(args)
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
