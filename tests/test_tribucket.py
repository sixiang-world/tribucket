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


class TestUtilsShared:
    """Tests for shared utility functions consolidated in utils.py."""

    def test_find_tribucket_json(self, tmp_path):
        tj = {"name": "test", "version": "1.0.0"}
        with open(tmp_path / "tribucket.json", "w") as f:
            json.dump(tj, f)
        result = utils.find_tribucket_json(str(tmp_path))
        assert result["name"] == "test"

    def test_find_tribucket_json_missing(self, tmp_path):
        result = utils.find_tribucket_json(str(tmp_path))
        assert result is None

    def test_find_tribucket_json_corrupt(self, tmp_path):
        (tmp_path / "tribucket.json").write_text("not json")
        result = utils.find_tribucket_json(str(tmp_path))
        assert result is None

    def test_save_json_file(self, tmp_path):
        path = str(tmp_path / "out.json")
        utils.save_json_file(path, {"a": 1, "b": [2, 3]})
        with open(path) as f:
            data = json.load(f)
        assert data == {"a": 1, "b": [2, 3]}

    def test_save_json_file_atomic(self, tmp_path):
        path = str(tmp_path / "out.json")
        utils.save_json_file(path, {"x": 1})
        # No .tmp file should remain
        assert not os.path.exists(path + ".tmp")

    def test_infer_asset_format(self):
        pat = {
            "linux_amd64": "foo_1.0_linux_amd64.tar.gz",
            "windows_amd64": "foo_1.0_windows_amd64.zip",
            "darwin_arm64": "NO_MATCH",
        }
        result = utils.infer_asset_format(pat)
        assert result["linux_amd64"] == "tar.gz"
        assert result["windows_amd64"] == "zip"
        assert "darwin_arm64" not in result

    def test_download_file(self, tmp_path, monkeypatch):
        def mock_urlopen(req, timeout=None):
            data = b"fake-content"
            called = [False]
            class MockResp:
                headers = {"Content-Length": str(len(data))}
                def read(self, size=-1):
                    if called[0]:
                        return b""
                    called[0] = True
                    return data
                def __enter__(self):
                    return self
                def __exit__(self, *args):
                    pass
            return MockResp()

        monkeypatch.setattr("urllib.request.urlopen", mock_urlopen)
        result = utils.download_file("https://example.com/test.tar.gz", str(tmp_path))
        assert result is not None
        assert os.path.exists(result)
        assert os.path.getsize(result) == len(b"fake-content")

    def test_exit_code_constants(self):
        assert utils.EXIT_OK == 0
        assert utils.EXIT_ERROR == 1
        assert utils.EXIT_USAGE == 2
        assert utils.EXIT_NOT_FOUND == 3
        assert utils.EXIT_EXISTS == 4
        assert utils.EXIT_NOT_TRACKED == 5
        assert utils.EXIT_UP_TO_DATE == 6
        assert utils.EXIT_NO_NETWORK == 7


class TestMirror:
    def test_build_direct_url(self):
        from tribucket.mirror import build_direct_url
        url = build_direct_url("owner/repo", "1.0.0", "foo-1.0.0-linux.tar.gz")
        assert url == "https://github.com/owner/repo/releases/download/v1.0.0/foo-1.0.0-linux.tar.gz"

    def test_build_mirror_url(self):
        from tribucket.mirror import build_mirror_url
        template = "https://mirror.example.com/https://github.com/{repo}/releases/download/v{version}/{asset}"
        url = build_mirror_url(template, "owner/repo", "1.0.0", "foo.tar.gz")
        assert "mirror.example.com" in url
        assert "owner/repo" in url
        assert "1.0.0" in url

    def test_select_provider_direct_forced(self, monkeypatch):
        from tribucket.mirror import select_provider
        monkeypatch.setattr("tribucket.mirror.load_json", lambda path, default={}: {"force": "direct"})
        name, template = select_provider()
        assert name == "direct"
        assert template is None

    def test_select_provider_direct_fallback(self, monkeypatch):
        from tribucket.mirror import select_provider
        # All providers fail
        monkeypatch.setattr("tribucket.mirror.test_provider", lambda p, timeout=3: (False, 0))
        monkeypatch.setattr("tribucket.mirror._test_direct", lambda timeout=3: (False, 0))
        monkeypatch.setattr("tribucket.mirror.load_json", lambda path, default={}: default)
        name, template = select_provider()
        assert name == "direct"

    def test_resolve_download_url_direct(self, monkeypatch):
        from tribucket.mirror import resolve_download_url
        monkeypatch.setattr("tribucket.mirror.select_provider", lambda mode="auto": ("direct", None))
        url, provider = resolve_download_url("owner/repo", "1.0.0", "foo.tar.gz")
        assert "github.com" in url
        assert provider == "direct"

    def test_resolve_download_url_mirror(self, monkeypatch):
        from tribucket.mirror import resolve_download_url
        template = "https://mirror.example.com/{repo}/v{version}/{asset}"
        monkeypatch.setattr("tribucket.mirror.select_provider", lambda mode="auto": ("mymirror", template))
        url, provider = resolve_download_url("owner/repo", "1.0.0", "foo.tar.gz")
        assert "mirror.example.com" in url
        assert provider == "mymirror"


class TestUpdate:
    def test_update_not_tracked(self, monkeypatch):
        from tribucket.update import update_package
        monkeypatch.setattr("tribucket.track.get_all_packages", lambda: {})
        ok = update_package("nonexistent")
        assert ok is False

    def test_update_stale_path(self, tmp_path, monkeypatch):
        from tribucket.update import update_package
        monkeypatch.setattr("tribucket.track.get_all_packages",
                            lambda: {"pkg": {"name": "pkg", "path": str(tmp_path / "gone"), "version": "1.0"}})
        ok = update_package("pkg")
        assert ok is False

    def test_lock_package(self, tmp_path, monkeypatch):
        from tribucket.update import _lock_package
        monkeypatch.setattr("tribucket.update.lock_dir", lambda: str(tmp_path / "locks"))
        with _lock_package("test-pkg"):
            # Lock acquired successfully
            assert os.path.exists(tmp_path / "locks" / "test-pkg.lock")
