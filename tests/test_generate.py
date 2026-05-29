"""Tests for scripts/generate.py"""
import sys
import os
import json
import hashlib
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


class TestGitHubAPI:
    def test_parse_release(self):
        release_json = {
            "tag_name": "v1.2.3",
            "assets": [
                {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.2.3/tool-linux-amd64.tar.gz"},
                {"name": "tool-windows-amd64.exe", "browser_download_url": "https://github.com/o/r/releases/download/v1.2.3/tool-windows-amd64.exe"},
                {"name": "SHA256SUMS", "browser_download_url": "https://github.com/o/r/releases/download/v1.2.3/SHA256SUMS"},
            ]
        }
        version, assets, checksum_assets = generate.parse_release(release_json)
        assert version == "1.2.3"
        assert len(assets) == 3
        assert len(checksum_assets) == 1
        assert checksum_assets[0]["name"] == "SHA256SUMS"

    def test_parse_release_strips_v_prefix(self):
        release_json = {"tag_name": "v2.0.0", "assets": []}
        version, _, _ = generate.parse_release(release_json)
        assert version == "2.0.0"

    def test_parse_release_no_v_prefix(self):
        release_json = {"tag_name": "2.0.0", "assets": []}
        version, _, _ = generate.parse_release(release_json)
        assert version == "2.0.0"

    def test_checksum_asset_names(self):
        release_json = {
            "tag_name": "v1.0",
            "assets": [
                {"name": "tool.tar.gz", "browser_download_url": "https://x"},
                {"name": "tool.tar.gz.sha256", "browser_download_url": "https://x"},
                {"name": "sha256sums.txt", "browser_download_url": "https://x"},
                {"name": "checksums.txt", "browser_download_url": "https://x"},
            ]
        }
        _, _, checksum_assets = generate.parse_release(release_json)
        names = {a["name"] for a in checksum_assets}
        assert "tool.tar.gz.sha256" in names
        assert "sha256sums.txt" in names
        assert "checksums.txt" in names


class TestSHA256:
    def test_cache_key_path(self):
        path = generate.cache_key_path("/repo/.cache", "ccx", "2.8.12", "ccx-linux-amd64.tar.gz")
        assert path.replace("\\", "/").endswith(".cache/ccx/2.8.12/ccx-linux-amd64.tar.gz.sha256")

    def test_cache_hit(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        key_path = generate.cache_key_path(cache_dir, "pkg", "1.0", "file.tar.gz")
        os.makedirs(os.path.dirname(key_path), exist_ok=True)
        with open(key_path, "w") as f:
            f.write("abc123")
        result = generate.get_cached_hash(cache_dir, "pkg", "1.0", "file.tar.gz")
        assert result == "abc123"

    def test_cache_miss(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        result = generate.get_cached_hash(cache_dir, "pkg", "1.0", "file.tar.gz")
        assert result is None

    def test_write_cache(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        generate.write_cache(cache_dir, "pkg", "1.0", "file.tar.gz", "deadbeef")
        key_path = generate.cache_key_path(cache_dir, "pkg", "1.0", "file.tar.gz")
        with open(key_path) as f:
            assert f.read() == "deadbeef"

    def test_compute_sha256(self, tmp_path):
        content = b"hello world"
        fpath = str(tmp_path / "test.bin")
        with open(fpath, "wb") as f:
            f.write(content)
        expected = hashlib.sha256(content).hexdigest()
        result = generate.compute_sha256(fpath)
        assert result == expected

    def test_parse_checksum_file(self):
        content = "abc123  tool-linux-amd64.tar.gz\ndef456  tool-linux-arm64.tar.gz\n"
        result = generate.parse_checksum_file(content, "tool-linux-amd64.tar.gz")
        assert result == "abc123"

    def test_parse_checksum_file_no_match(self):
        content = "abc123  other-file.tar.gz\n"
        result = generate.parse_checksum_file(content, "tool-linux-amd64.tar.gz")
        assert result is None


class TestFormulaRendering:
    def test_class_name_simple(self):
        assert generate.class_name_from("ccx") == "Ccx"

    def test_class_name_hyphenated(self):
        assert generate.class_name_from("claude-code") == "ClaudeCode"

    def test_class_name_single(self):
        assert generate.class_name_from("bat") == "Bat"

    def test_class_name_multi_hyphen(self):
        assert generate.class_name_from("my-cool-tool") == "MyCoolTool"

    def test_render_formula_basic(self):
        info = {
            "name": "ccx",
            "description": "Claude / Codex / Gemini API Proxy",
            "homepage": "https://github.com/BenedictKing/ccx",
            "license": "MIT",
            "binary": "ccx",
            "version": "2.8.12",
            "platforms": {
                "darwin_amd64": {"url": "https://x/ccx-darwin-amd64", "sha256": "aaa"},
                "darwin_arm64": {"url": "https://x/ccx-darwin-arm64", "sha256": "bbb"},
                "linux_amd64": {"url": "https://x/ccx-linux-amd64", "sha256": "ccc"},
                "linux_arm64": {"url": "https://x/ccx-linux-arm64", "sha256": "ddd"},
            }
        }
        result = generate.render_formula(info)
        assert "class Ccx < Formula" in result
        assert 'version "2.8.12"' in result
        assert 'sha256 "aaa"' in result
        assert "on_macos do" in result
        assert "on_linux do" in result

    def test_render_formula_missing_linux(self):
        info = {
            "name": "tool",
            "description": "A tool",
            "homepage": "https://x",
            "license": "MIT",
            "binary": "tool",
            "version": "1.0",
            "platforms": {
                "darwin_amd64": {"url": "https://x/tool-darwin", "sha256": "aaa"},
                "darwin_arm64": {"url": "https://x/tool-darwin-arm", "sha256": "bbb"},
            }
        }
        result = generate.render_formula(info)
        assert "on_macos do" in result
        assert "on_linux do" not in result

    def test_render_formula_missing_arm(self):
        info = {
            "name": "tool",
            "description": "A tool",
            "homepage": "https://x",
            "license": "MIT",
            "binary": "tool",
            "version": "1.0",
            "platforms": {
                "darwin_amd64": {"url": "https://x/tool-darwin", "sha256": "aaa"},
                "linux_amd64": {"url": "https://x/tool-linux", "sha256": "bbb"},
            }
        }
        result = generate.render_formula(info)
        assert "on_intel do" in result
        assert "on_arm do" not in result


class TestBucketRendering:
    def test_render_bucket_basic(self):
        info = {
            "name": "ccx",
            "repo": "BenedictKing/ccx",
            "description": "Claude / Codex / Gemini API Proxy",
            "homepage": "https://github.com/BenedictKing/ccx",
            "license": "MIT",
            "binary": "ccx",
            "version": "2.8.12",
            "windows": {
                "64bit": {
                    "url": "https://github.com/BenedictKing/ccx/releases/download/v2.8.12/ccx-windows-amd64.exe",
                    "hash": "abc123",
                    "filename": "ccx-windows-amd64.exe",
                },
                "arm64": {
                    "url": "https://github.com/BenedictKing/ccx/releases/download/v2.8.12/ccx-windows-arm64.exe",
                    "hash": "def456",
                    "filename": "ccx-windows-arm64.exe",
                },
            },
        }
        result = generate.render_bucket(info)
        parsed = json.loads(result)
        assert parsed["version"] == "2.8.12"
        assert parsed["architecture"]["64bit"]["hash"] == "abc123"
        assert parsed["bin"] == [["ccx-windows-amd64.exe", "ccx"]]
        assert "checkver" in parsed
        assert "autoupdate" in parsed

    def test_render_bucket_only_64bit(self):
        info = {
            "name": "tool",
            "repo": "o/tool",
            "description": "A tool",
            "homepage": "https://x",
            "license": "MIT",
            "binary": "tool",
            "version": "1.0",
            "windows": {
                "64bit": {
                    "url": "https://github.com/o/tool/releases/download/v1.0/tool-windows-amd64.zip",
                    "hash": "aaa",
                    "filename": "tool-windows-amd64.zip",
                },
            },
        }
        result = generate.render_bucket(info)
        parsed = json.loads(result)
        assert "64bit" in parsed["architecture"]
        assert "arm64" not in parsed["architecture"]

    def test_autoupdate_url(self):
        url = "https://github.com/o/r/releases/download/v1.2.3/file.zip"
        au_url = generate.autoupdate_url(url, "1.2.3")
        assert au_url == "https://github.com/o/r/releases/download/v$version/file.zip"

    def test_autoupdate_url_no_v_prefix(self):
        url = "https://github.com/o/r/releases/download/1.2.3/file.zip"
        au_url = generate.autoupdate_url(url, "1.2.3")
        assert au_url == "https://github.com/o/r/releases/download/v$version/file.zip"


class TestFullPipeline:
    def test_process_package_basic(self, tmp_path, monkeypatch):
        """Test the full process_package flow with mocked GitHub API."""
        fake_release = {
            "tag_name": "v1.0.0",
            "assets": [
                {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-linux-amd64.tar.gz"},
                {"name": "tool-linux-arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-linux-arm64.tar.gz"},
                {"name": "tool-darwin-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-darwin-amd64.tar.gz"},
                {"name": "tool-darwin-arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-darwin-arm64.tar.gz"},
                {"name": "tool-windows-amd64.exe", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-windows-amd64.exe"},
                {"name": "tool-windows-arm64.exe", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/tool-windows-arm64.exe"},
                {"name": "SHA256SUMS", "browser_download_url": "https://github.com/o/r/releases/download/v1.0.0/SHA256SUMS"},
            ]
        }
        checksum_content = (
            "aaa111  tool-linux-amd64.tar.gz\n"
            "bbb222  tool-linux-arm64.tar.gz\n"
            "ccc333  tool-darwin-amd64.tar.gz\n"
            "ddd444  tool-darwin-arm64.tar.gz\n"
            "eee555  tool-windows-amd64.exe\n"
            "fff666  tool-windows-arm64.exe\n"
        )

        def mock_http_get(url, token=None, retries=3):
            if "SHA256SUMS" in url:
                return checksum_content.encode()
            return json.dumps(fake_release).encode()

        monkeypatch.setattr(generate, "http_get", mock_http_get)

        pkg = {
            "name": "tool",
            "repo": "o/r",
            "description": "A test tool",
            "binary": "tool",
            "license": "MIT",
            "homepage": "https://github.com/o/r",
            "asset_pattern": {
                "linux_amd64": "tool-linux-amd64.tar.gz",
                "linux_arm64": "tool-linux-arm64.tar.gz",
                "darwin_amd64": "tool-darwin-amd64.tar.gz",
                "darwin_arm64": "tool-darwin-arm64.tar.gz",
                "windows_amd64": "tool-windows-amd64.exe",
                "windows_arm64": "tool-windows-arm64.exe",
            },
        }

        cache_dir = str(tmp_path / ".cache")
        formula, bucket = generate.process_package(pkg, cache_dir, verbose=False)

        assert "class Tool < Formula" in formula
        assert 'version "1.0.0"' in formula
        assert 'sha256 "aaa111"' in formula

        bucket_parsed = json.loads(bucket)
        assert bucket_parsed["version"] == "1.0.0"
        assert bucket_parsed["architecture"]["64bit"]["hash"] == "eee555"
