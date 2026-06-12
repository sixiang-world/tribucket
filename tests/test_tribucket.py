"""Tests for lib/tribucket/ modules."""
import json
import os
import sys
import tempfile

import pytest

# Add lib/ to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'lib'))

from tribucket import config, track, check, utils


class TestConfig:
    def test_tribucket_home_default(self):
        home = config.tribucket_home()
        assert home.endswith(".tribucket")

    def test_tribucket_home_env(self, monkeypatch):
        monkeypatch.setenv("TRIBUCKET_HOME", "/tmp/test-tribucket")
        assert config.tribucket_home() == "/tmp/test-tribucket"

    def test_load_config_missing(self, tmp_path, monkeypatch):
        monkeypatch.setattr(config, "tribucket_home", lambda: str(tmp_path))
        result = config.load_config()
        assert result == {"settings": {}, "packages": {}}

    def test_save_and_load_config(self, tmp_path, monkeypatch):
        monkeypatch.setattr(config, "tribucket_home", lambda: str(tmp_path))
        cfg = {"settings": {"key": "value"}, "packages": {"a": {"name": "a"}}}
        config.save_config(cfg)
        loaded = config.load_config()
        assert loaded["settings"]["key"] == "value"
        assert loaded["packages"]["a"]["name"] == "a"

    def test_load_config_corrupt(self, tmp_path, monkeypatch):
        monkeypatch.setattr(config, "tribucket_home", lambda: str(tmp_path))
        cfg_path = config.config_path()
        os.makedirs(os.path.dirname(cfg_path), exist_ok=True)
        with open(cfg_path, "w") as f:
            f.write("not json{{{")
        result = config.load_config()
        assert result == {"settings": {}, "packages": {}}

    def test_load_json(self, tmp_path):
        path = tmp_path / "test.json"
        with open(path, "w") as f:
            json.dump({"a": 1}, f)
        result = config.load_json(str(path))
        assert result == {"a": 1}

    def test_load_json_missing(self, tmp_path):
        result = config.load_json(str(tmp_path / "missing.json"), default={"x": 1})
        assert result == {"x": 1}

    def test_save_json(self, tmp_path):
        path = str(tmp_path / "out.json")
        config.save_json(path, {"b": 2})
        with open(path) as f:
            assert json.load(f) == {"b": 2}


class TestUtils:
    def test_compute_sha256(self, tmp_path):
        f = tmp_path / "test.txt"
        f.write_text("hello world")
        sha = utils.compute_sha256(str(f))
        assert len(sha) == 64
        assert sha == "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9"

    def test_detect_platform_linux(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "Linux")
        monkeypatch.setattr("platform.machine", lambda: "x86_64")
        assert utils.detect_platform() == "linux_amd64"

    def test_detect_platform_darwin_arm(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "Darwin")
        monkeypatch.setattr("platform.machine", lambda: "arm64")
        assert utils.detect_platform() == "darwin_arm64"

    def test_detect_platform_unsupported(self, monkeypatch):
        monkeypatch.setattr("platform.system", lambda: "FreeBSD")
        assert utils.detect_platform() is None

    def test_verbose_log(self, monkeypatch, capsys):
        monkeypatch.setattr(utils, "VERBOSE", True)
        utils.log("test message")
        captured = capsys.readouterr()
        assert "test message" in captured.err

    def test_verbose_log_off(self, monkeypatch, capsys):
        monkeypatch.setattr(utils, "VERBOSE", False)
        utils.log("test message")
        captured = capsys.readouterr()
        assert captured.err == ""


class TestTrack:
    def setup_method(self, tmp_path=None):
        """Reset config for each test."""
        self._tmpdir = tempfile.mkdtemp()
        self._orig_home = config.tribucket_home

    def teardown_method(self):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)

    def _patch_home(self, monkeypatch):
        monkeypatch.setattr(config, "tribucket_home", lambda: self._tmpdir)

    def test_track_and_list(self, tmp_path, monkeypatch):
        self._patch_home(monkeypatch)
        pkg_dir = tmp_path / "mypkg"
        pkg_dir.mkdir()

        ok = track.track("mypkg", str(pkg_dir))
        assert ok is True

        packages = track.list_packages()
        assert len(packages) == 1
        assert packages[0][0] == "mypkg"

    def test_track_nonexistent_path(self, tmp_path, monkeypatch):
        self._patch_home(monkeypatch)
        ok = track.track("missing", "/nonexistent/path")
        assert ok is False

    def test_untrack(self, tmp_path, monkeypatch):
        self._patch_home(monkeypatch)
        pkg_dir = tmp_path / "mypkg"
        pkg_dir.mkdir()

        track.track("mypkg", str(pkg_dir))
        ok = track.untrack("mypkg")
        assert ok is True

        packages = track.list_packages()
        assert len(packages) == 0

    def test_untrack_not_tracked(self, monkeypatch):
        self._patch_home(monkeypatch)
        ok = track.untrack("nonexistent")
        assert ok is False

    def test_get_package(self, tmp_path, monkeypatch):
        self._patch_home(monkeypatch)
        pkg_dir = tmp_path / "mypkg"
        pkg_dir.mkdir()

        track.track("mypkg", str(pkg_dir), version="1.0.0")
        info = track.get_package("mypkg")
        assert info is not None
        assert info["version"] == "1.0.0"

    def test_update_package_version(self, tmp_path, monkeypatch):
        self._patch_home(monkeypatch)
        pkg_dir = tmp_path / "mypkg"
        pkg_dir.mkdir()

        track.track("mypkg", str(pkg_dir), version="1.0.0")
        ok = track.update_package_version("mypkg", "2.0.0")
        assert ok is True

        info = track.get_package("mypkg")
        assert info["version"] == "2.0.0"


class TestCheck:
    def test_detect_version_from_binary(self, tmp_path):
        binary = tmp_path / "mytool"
        binary.write_text("#!/bin/sh\necho 'mytool 1.2.3'\n")
        os.chmod(str(binary), 0o755)

        tj = {
            "version_check": {
                "cli_flags": ["--version"],
                "parse_regex": r"(\d+\.\d+\.\d+)",
                "output_stream": "stdout",
                "timeout": 5,
            }
        }
        ver, source = check.detect_version(str(binary), tj)
        assert ver == "1.2.3"
        assert source == "cli"

    def test_detect_version_fallback(self, tmp_path):
        binary = tmp_path / "nonexistent"
        tj = {
            "version_check": {
                "cli_flags": ["--version"],
                "parse_regex": r"(\d+\.\d+\.\d+)",
                "output_stream": "stdout",
                "timeout": 5,
                "fallback_version": "3.0.0",
            },
            "version": "2.0.0",
        }
        ver, source = check.detect_version(str(binary), tj)
        assert ver == "2.0.0"
        assert source == "fallback"

    def test_format_check_result(self):
        result = check.format_check_result("go-wxpush", "1.5.2", "cli", "1.5.3")
        assert "go-wxpush" in result
        assert "1.5.2" in result
        assert "1.5.3" in result

    def test_format_check_result_latest(self):
        result = check.format_check_result("ripgrep", "14.1.0", "cli", "14.1.0")
        assert "latest" in result

    def test_format_check_result_offline(self):
        result = check.format_check_result("tool", "1.0", "cli", None)
        assert "offline" in result
