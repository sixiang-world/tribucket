"""Tests for scripts/generate.py"""
import sys
import os
import json
import pytest

# Add scripts/ to path so we can import generate
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

import generate


class TestParseArgs:
    def test_defaults(self):
        args = generate.parse_args([])
        assert args.only == []
        assert args.skip_hash is False
        assert args.dry_run is False
        assert args.verbose is False

    def test_only_single(self):
        args = generate.parse_args(['--only', 'ccx'])
        assert args.only == ['ccx']

    def test_only_multiple(self):
        args = generate.parse_args(['--only', 'ccx', '--only', 'bat'])
        assert args.only == ['ccx', 'bat']

    def test_flags(self):
        args = generate.parse_args(['--skip-hash', '--dry-run', '--verbose'])
        assert args.skip_hash is True
        assert args.dry_run is True
        assert args.verbose is True


class TestLoadPackages:
    def test_load_single(self, tmp_path):
        pkg_dir = tmp_path / "packages"
        pkg_dir.mkdir()
        (pkg_dir / "foo.json").write_text(json.dumps({
            "name": "foo", "repo": "o/foo", "description": "d",
            "binary": "foo", "license": "MIT", "homepage": "https://x",
            "asset_pattern": {
                "linux_amd64": "a", "linux_arm64": "b",
                "darwin_amd64": "c", "darwin_arm64": "d",
                "windows_amd64": "e", "windows_arm64": "f"
            }
        }))
        pkgs = generate.load_packages(str(pkg_dir))
        assert len(pkgs) == 1
        assert pkgs[0]["name"] == "foo"

    def test_load_with_filter(self, tmp_path):
        pkg_dir = tmp_path / "packages"
        pkg_dir.mkdir()
        for name in ["a", "b", "c"]:
            (pkg_dir / f"{name}.json").write_text(json.dumps({
                "name": name, "repo": f"o/{name}", "description": "d",
                "binary": name, "license": "MIT", "homepage": "https://x",
                "asset_pattern": {
                    "linux_amd64": "a", "linux_arm64": "b",
                    "darwin_amd64": "c", "darwin_arm64": "d",
                    "windows_amd64": "e", "windows_arm64": "f"
                }
            }))
        pkgs = generate.load_packages(str(pkg_dir), only=["a", "c"])
        names = [p["name"] for p in pkgs]
        assert names == ["a", "c"]

    def test_missing_only_warns(self, tmp_path, capsys):
        pkg_dir = tmp_path / "packages"
        pkg_dir.mkdir()
        (pkg_dir / "a.json").write_text(json.dumps({
            "name": "a", "repo": "o/a", "description": "d",
            "binary": "a", "license": "MIT", "homepage": "https://x",
            "asset_pattern": {
                "linux_amd64": "a", "linux_arm64": "b",
                "darwin_amd64": "c", "darwin_arm64": "d",
                "windows_amd64": "e", "windows_arm64": "f"
            }
        }))
        pkgs = generate.load_packages(str(pkg_dir), only=["a", "missing"])
        assert len(pkgs) == 1
        captured = capsys.readouterr()
        assert "missing" in captured.out


class TestMatchAsset:
    def test_substring_match(self):
        assets = [
            {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-amd64.tar.gz"},
            {"name": "tool-linux-arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-arm64.tar.gz"},
        ]
        result = generate.match_asset(assets, "tool-linux-amd64")
        assert result is not None
        assert result["name"] == "tool-linux-amd64.tar.gz"

    def test_glob_match(self):
        assets = [
            {"name": "fzf-0.50_linux_amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v0.50/fzf-0.50_linux_amd64.tar.gz"},
            {"name": "fzf-0.50_linux_arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v0.50/fzf-0.50_linux_arm64.tar.gz"},
        ]
        result = generate.match_asset(assets, "fzf-*_linux_amd64.tar.gz")
        assert result is not None
        assert "amd64" in result["name"]

    def test_no_match(self):
        assets = [
            {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-amd64.tar.gz"},
        ]
        result = generate.match_asset(assets, "tool-windows-amd64.exe")
        assert result is None

    def test_exe_match(self):
        assets = [
            {"name": "ccx-windows-amd64.exe", "browser_download_url": "https://github.com/o/r/releases/download/v2.8.12/ccx-windows-amd64.exe"},
        ]
        result = generate.match_asset(assets, "ccx-windows-amd64.exe")
        assert result is not None
        assert result["name"] == "ccx-windows-amd64.exe"
