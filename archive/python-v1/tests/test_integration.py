"""End-to-end integration tests for tribucket CLI."""
import json
import os
import sys
import tempfile
import shutil

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))

from tribucket import config, track, check, utils


@pytest.fixture
def tribucket_home(tmp_path, monkeypatch):
    """Set up isolated tribucket home directory."""
    home = str(tmp_path / ".tribucket")
    monkeypatch.setattr(config, "tribucket_home", lambda: home)
    os.makedirs(os.path.join(home, "cache"), exist_ok=True)
    os.makedirs(os.path.join(home, "backup"), exist_ok=True)
    return home


@pytest.fixture
def fake_binary(tmp_path):
    """Create a fake binary that reports a version."""
    binary = tmp_path / "mytool"
    binary.write_text("#!/bin/sh\necho 'mytool 1.2.3'\n")
    os.chmod(str(binary), 0o755)
    return str(binary)


@pytest.fixture
def fake_package_dir(tmp_path, fake_binary):
    """Create a fake portable package directory."""
    pkg_dir = tmp_path / "mytool-portable"
    pkg_dir.mkdir()

    # Copy binary
    shutil.copy2(fake_binary, str(pkg_dir / "mytool"))

    # Create tribucket.json
    tj = {
        "name": "mytool",
        "version": "1.2.3",
        "repo": "fake/mytool",
        "description": "A fake tool",
        "binary": "mytool",
        "license": "MIT",
        "version_check": {
            "cli_flags": ["--version"],
            "parse_regex": r"(\d+\.\d+\.\d+)",
            "output_stream": "stdout",
            "timeout": 5,
            "fallback_version": "1.2.3",
        },
        "asset_pattern": {
            "linux_amd64": "mytool_linux_amd64",
            "darwin_arm64": "mytool_darwin_arm64",
        },
        "install_type": "binary",
        "mirror": {"enabled": True},
    }
    with open(str(pkg_dir / "tribucket.json"), "w") as f:
        json.dump(tj, f, indent=2)

    # Create install.sh
    install_sh = """#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BINARY="$SCRIPT_DIR/mytool"
if [ -x "$BINARY" ]; then
    "$BINARY" --version
fi
"""
    with open(str(pkg_dir / "install.sh"), "w") as f:
        f.write(install_sh)
    os.chmod(str(pkg_dir / "install.sh"), 0o755)

    return str(pkg_dir)


class TestTrackFlow:
    def test_track_list_untrack(self, tribucket_home, fake_package_dir):
        # Track
        ok = track.track("mytool", fake_package_dir, version="1.2.3")
        assert ok is True

        # List
        packages = track.list_packages()
        assert len(packages) == 1
        assert packages[0][0] == "mytool"
        assert packages[0][1]["version"] == "1.2.3"

        # Get
        info = track.get_package("mytool")
        assert info is not None
        assert info["path"] == fake_package_dir

        # Untrack
        ok = track.untrack("mytool")
        assert ok is True

        packages = track.list_packages()
        assert len(packages) == 0

    def test_track_duplicate(self, tribucket_home, fake_package_dir):
        track.track("mytool", fake_package_dir, version="1.2.3")
        # Track again — should reject (already tracked)
        ok = track.track("mytool", fake_package_dir, version="1.2.4")
        assert ok is False


class TestCheckFlow:
    def test_check_tracked_package(self, tribucket_home, fake_package_dir):
        track.track("mytool", fake_package_dir, version="1.2.3")

        result = check.check_package("mytool", local_only=True)
        assert result["name"] == "mytool"
        assert result["local"] == "1.2.3"
        assert result["local_source"] == "cli"
        assert result["path_exists"] is True

    def test_check_path(self, tribucket_home, fake_binary):
        result = check.check_package(fake_binary)
        assert result["local"] == "1.2.3"
        assert result["local_source"] == "cli"

    def test_check_not_found(self, tribucket_home):
        result = check.check_package("nonexistent")
        assert "error" in result

    def test_check_stale_entry(self, tribucket_home, tmp_path):
        # Manually create a stale entry (bypass track's path check)
        stale_path = str(tmp_path / "deleted")
        cfg = config.load_config()
        cfg["packages"]["stale"] = {
            "name": "stale",
            "path": stale_path,
            "version": "1.0.0",
        }
        config.save_config(cfg)

        result = check.check_package("stale", local_only=True)
        assert result["path_exists"] is False

    def test_format_check_result(self):
        result = check.format_check_result("mytool", "1.2.3", "cli", "1.2.4")
        assert "mytool" in result
        assert "1.2.3" in result
        assert "1.2.4" in result
        assert "→" in result

    def test_format_check_result_latest(self):
        result = check.format_check_result("mytool", "1.2.3", "cli", "1.2.3")
        assert "latest" in result

    def test_format_check_result_offline(self):
        result = check.format_check_result("mytool", "1.2.3", "cli", None)
        assert "offline" in result


class TestConfigFlow:
    def test_settings_roundtrip(self, tribucket_home):
        from tribucket.config import load_config, save_config

        config_data = load_config()
        config_data["settings"]["default_install_dir"] = "/opt/tools"
        config_data["settings"]["auto_link"] = "true"
        save_config(config_data)

        loaded = load_config()
        assert loaded["settings"]["default_install_dir"] == "/opt/tools"
        assert loaded["settings"]["auto_link"] == "true"

    def test_config_corrupt_recovery(self, tribucket_home):
        from tribucket.config import load_config, config_path

        # Write corrupt config
        with open(config_path(), "w") as f:
            f.write("not json!")

        # Should recover gracefully
        loaded = load_config()
        assert loaded == {"settings": {}, "packages": {}}


class TestStaleDetection:
    def test_remove_stale_entries(self, tribucket_home, tmp_path):
        # Track a real path
        real_dir = tmp_path / "real"
        real_dir.mkdir()
        track.track("real-pkg", str(real_dir))

        # Manually create a stale entry (bypass track's path check)
        stale_path = str(tmp_path / "deleted")
        cfg = config.load_config()
        cfg["packages"]["stale-pkg"] = {
            "name": "stale-pkg",
            "path": stale_path,
            "version": "1.0.0",
        }
        config.save_config(cfg)

        removed = track.remove_stale_entries()
        assert "stale-pkg" in removed
        assert "real-pkg" not in removed

        packages = track.list_packages()
        assert len(packages) == 1
        assert packages[0][0] == "real-pkg"

    def test_find_dangling_symlinks(self, tribucket_home, monkeypatch):
        from tribucket.config import bin_dir

        bd = bin_dir()
        os.makedirs(bd, exist_ok=True)

        # Create a dangling symlink
        link_path = os.path.join(bd, "dangling")
        os.symlink("/nonexistent/path", link_path)

        dangling = track.find_dangling_symlinks()
        assert len(dangling) == 1
        assert dangling[0][0] == "dangling"

        # Clean up
        os.unlink(link_path)


class TestPlatformDetection:
    def test_linux_amd64(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "Linux")
        monkeypatch.setattr("platform.machine", lambda: "x86_64")
        assert utils.detect_platform() == "linux_amd64"

    def test_darwin_arm64(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "Darwin")
        monkeypatch.setattr("platform.machine", lambda: "arm64")
        assert utils.detect_platform() == "darwin_arm64"

    def test_linux_arm64(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "Linux")
        monkeypatch.setattr("platform.machine", lambda: "aarch64")
        assert utils.detect_platform() == "linux_arm64"


class TestCLI:
    def test_cli_version(self):
        """Test that CLI can be imported and shows version."""
        from tribucket.cli import main
        from tribucket import __version__
        assert __version__ == "2.0.0"

    def test_cli_help(self, capsys):
        """Test CLI help output."""
        from tribucket.cli import _build_parser
        parser = _build_parser()
        # Just verify parser builds without error
        assert parser.prog == "tribucket"
