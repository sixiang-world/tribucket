"""Tests for tribucket_gen (moved from scripts/generate.py)."""
import json
import os
import hashlib
import pytest

from tribucket_gen.__main__ import build_parser
from tribucket_gen.assets import (
    match_asset, is_checksum_asset, infer_asset_format, check_asset_patterns,
)
from tribucket_gen.core import load_packages, process_package, PLATFORM_KEYS
from tribucket_gen.release import http_get, fetch_latest_release, parse_release
from tribucket_gen.hashing import (
    cache_key_path, compute_sha256, parse_checksum_file, get_cached_hash, write_cache,
    get_sha256_for_asset,
)
from tribucket_gen.render.homebrew import render_formula, class_name_from
from tribucket_gen.render.scoop import render_bucket, autoupdate_url
from tribucket_gen.render.portable import (
    render_install_sh, render_bat, generate_portable,
    derive_tribucket_json, infer_install_type,
)


class TestRenderArgs:
    def test_defaults(self):
        args = build_parser().parse_args(["render"])
        assert args.only == []
        assert args.skip_hash is False and args.dry_run is False and args.verbose is False

    def test_only_multiple(self):
        args = build_parser().parse_args(["render", "--only", "ccx", "--only", "bat"])
        assert args.only == ["ccx", "bat"]

    def test_flags(self):
        args = build_parser().parse_args(["render", "--skip-hash", "--dry-run", "--verbose"])
        assert args.skip_hash and args.dry_run and args.verbose

    def test_portable(self):
        args = build_parser().parse_args(["render", "--portable", "--portable-dir", "/tmp/x"])
        assert args.portable and args.portable_dir == "/tmp/x"

    def test_check_subcommand(self):
        args = build_parser().parse_args(["check"])
        assert args.command == "check"

    def test_requires_command(self):
        with pytest.raises(SystemExit):
            build_parser().parse_args([])


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
        pkgs = load_packages(str(pkg_dir))
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
        pkgs = load_packages(str(pkg_dir), only=["a", "c"])
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
        pkgs = load_packages(str(pkg_dir), only=["a", "missing"])
        assert len(pkgs) == 1
        captured = capsys.readouterr()
        assert "missing" in captured.out


class TestMatchAsset:
    def test_substring_match(self):
        assets = [
            {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-amd64.tar.gz"},
            {"name": "tool-linux-arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-arm64.tar.gz"},
        ]
        result = match_asset(assets, "tool-linux-amd64")
        assert result is not None
        assert result["name"] == "tool-linux-amd64.tar.gz"

    def test_glob_match(self):
        assets = [
            {"name": "fzf-0.50_linux_amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v0.50/fzf-0.50_linux_amd64.tar.gz"},
            {"name": "fzf-0.50_linux_arm64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v0.50/fzf-0.50_linux_arm64.tar.gz"},
        ]
        result = match_asset(assets, "fzf-*_linux_amd64.tar.gz")
        assert result is not None
        assert "amd64" in result["name"]

    def test_no_match(self):
        assets = [
            {"name": "tool-linux-amd64.tar.gz", "browser_download_url": "https://github.com/o/r/releases/download/v1.0/tool-linux-amd64.tar.gz"},
        ]
        result = match_asset(assets, "tool-windows-amd64.exe")
        assert result is None

    def test_exe_match(self):
        assets = [
            {"name": "ccx-windows-amd64.exe", "browser_download_url": "https://github.com/o/r/releases/download/v2.8.12/ccx-windows-amd64.exe"},
        ]
        result = match_asset(assets, "ccx-windows-amd64.exe")
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
        version, assets, checksum_assets = parse_release(release_json)
        assert version == "1.2.3"
        assert len(assets) == 3
        assert len(checksum_assets) == 1
        assert checksum_assets[0]["name"] == "SHA256SUMS"

    def test_parse_release_strips_v_prefix(self):
        release_json = {"tag_name": "v2.0.0", "assets": []}
        version, _, _ = parse_release(release_json)
        assert version == "2.0.0"

    def test_parse_release_no_v_prefix(self):
        release_json = {"tag_name": "2.0.0", "assets": []}
        version, _, _ = parse_release(release_json)
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
        _, _, checksum_assets = parse_release(release_json)
        names = {a["name"] for a in checksum_assets}
        assert "tool.tar.gz.sha256" in names
        assert "sha256sums.txt" in names
        assert "checksums.txt" in names


class TestSHA256:
    def test_cache_key_path(self):
        path = cache_key_path("/repo/.cache", "ccx", "2.8.12", "ccx-linux-amd64.tar.gz")
        assert path.replace("\\", "/").endswith(".cache/ccx/2.8.12/ccx-linux-amd64.tar.gz.sha256")

    def test_cache_hit(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        key_path = cache_key_path(cache_dir, "pkg", "1.0", "file.tar.gz")
        os.makedirs(os.path.dirname(key_path), exist_ok=True)
        with open(key_path, "w") as f:
            f.write("abc123")
        result = get_cached_hash(cache_dir, "pkg", "1.0", "file.tar.gz")
        assert result == "abc123"

    def test_cache_miss(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        result = get_cached_hash(cache_dir, "pkg", "1.0", "file.tar.gz")
        assert result is None

    def test_write_cache(self, tmp_path):
        cache_dir = str(tmp_path / ".cache")
        write_cache(cache_dir, "pkg", "1.0", "file.tar.gz", "deadbeef")
        key_path = cache_key_path(cache_dir, "pkg", "1.0", "file.tar.gz")
        with open(key_path) as f:
            assert f.read() == "deadbeef"

    def test_compute_sha256(self, tmp_path):
        content = b"hello world"
        fpath = str(tmp_path / "test.bin")
        with open(fpath, "wb") as f:
            f.write(content)
        expected = hashlib.sha256(content).hexdigest()
        result = compute_sha256(fpath)
        assert result == expected

    def test_filename_traversal_sanitized(self, tmp_path, monkeypatch):
        """A URL-derived filename containing path separators cannot escape the
        per-package tmp dir — get_sha256_for_asset must strip them."""
        captured = {}

        def fake_download(url, dest_path, token=None, verbose=False):
            captured["dest_path"] = dest_path
            with open(dest_path, "wb") as f:
                f.write(b"x")

        monkeypatch.setattr("tribucket_gen.hashing.download_file", fake_download)
        cache_dir = str(tmp_path / ".cache")
        malicious_filename = "..\\..\\evil.exe"
        get_sha256_for_asset(
            "https://x/evil.exe", malicious_filename,
            [], [], cache_dir, "pkg", "1.0", verbose=False,
        )
        # The basename after stripping path separators is "evil.exe"
        assert captured["dest_path"].replace("\\", "/").endswith("/pkg/1.0/evil.exe")

    def test_parse_checksum_file(self):
        content = "abc123  tool-linux-amd64.tar.gz\ndef456  tool-linux-arm64.tar.gz\n"
        result = parse_checksum_file(content, "tool-linux-amd64.tar.gz")
        assert result == "abc123"

    def test_parse_checksum_file_no_match(self):
        content = "abc123  other-file.tar.gz\n"
        result = parse_checksum_file(content, "tool-linux-amd64.tar.gz")
        assert result is None


class TestFormulaRendering:
    def test_class_name_simple(self):
        assert class_name_from("ccx") == "Ccx"

    def test_class_name_hyphenated(self):
        assert class_name_from("claude-code") == "ClaudeCode"

    def test_class_name_single(self):
        assert class_name_from("bat") == "Bat"

    def test_class_name_multi_hyphen(self):
        assert class_name_from("my-cool-tool") == "MyCoolTool"

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
        result = render_formula(info)
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
        result = render_formula(info)
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
        result = render_formula(info)
        assert "on_intel do" in result
        assert "on_arm do" not in result


    def test_render_formula_test_block(self):
        """The Ruby test block must contain literal #{bin}, not Python's bin() builtin."""
        info = {
            "name": "tool",
            "description": "A tool",
            "homepage": "https://x",
            "license": "MIT",
            "binary": "tool",
            "version": "1.0",
            "platforms": {
                "darwin_amd64": {"url": "https://x/tool-darwin", "sha256": "aaa"},
            }
        }
        result = render_formula(info)
        assert '#{bin}/tool --version' in result
        assert 'built-in' not in result


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
        result = render_bucket(info)
        parsed = json.loads(result)
        assert parsed["version"] == "2.8.12"
        assert parsed["architecture"]["64bit"]["hash"] == "abc123"
        assert parsed["bin"] == [["ccx-windows-amd64.exe", "ccx"]]
        assert "checkver" in parsed
        assert parsed["checkver"] == {"github": "https://github.com/BenedictKing/ccx"}
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
        result = render_bucket(info)
        parsed = json.loads(result)
        assert "64bit" in parsed["architecture"]
        assert "arm64" not in parsed["architecture"]

    def test_autoupdate_url(self):
        url = "https://github.com/o/r/releases/download/v1.2.3/file.zip"
        au_url = autoupdate_url(url, "1.2.3")
        assert au_url == "https://github.com/o/r/releases/download/v$version/file.zip"

    def test_autoupdate_url_no_v_prefix(self):
        url = "https://github.com/o/r/releases/download/1.2.3/file.zip"
        au_url = autoupdate_url(url, "1.2.3")
        assert au_url == "https://github.com/o/r/releases/download/v$version/file.zip"

    def test_render_bucket_download_url(self):
        info = {
            "name": "go",
            "repo": "golang/go",
            "description": "Go programming language",
            "homepage": "https://go.dev/",
            "license": "BSD-3-Clause",
            "binary": "go",
            "version": "1.24.3",
            "windows": {
                "64bit": {
                    "url": "https://go.dev/dl/go1.24.3.windows-amd64.zip",
                    "hash": "abc123",
                    "filename": "go1.24.3.windows-amd64.zip",
                },
            },
        }
        result = render_bucket(info, is_download_url=True)
        parsed = json.loads(result)
        # Download_url packages omit checkver (Scoop uses hardcoded version)
        assert "checkver" not in parsed
        assert "autoupdate" in parsed


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

        monkeypatch.setattr("tribucket_gen.release.http_get", mock_http_get)
        monkeypatch.setattr("tribucket_gen.hashing.http_get", mock_http_get)

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
        formula, bucket, new_version, new_urls = process_package(pkg, cache_dir, verbose=False)

        assert "class Tool < Formula" in formula
        assert 'version "1.0.0"' in formula
        assert 'sha256 "aaa111"' in formula

        bucket_parsed = json.loads(bucket)
        assert bucket_parsed["version"] == "1.0.0"
        assert bucket_parsed["architecture"]["64bit"]["hash"] == "eee555"

        # GitHub release packages don't trigger write-back
        assert new_version is None
        assert new_urls is None

    def test_process_package_rejects_unsafe_version(self, tmp_path, monkeypatch):
        """Versions outside [A-Za-z0-9._+~-] flow into URLs/Ruby/JSON paths —
        resolve_package must bail out rather than render."""
        fake_release = {
            "tag_name": "1.0#{evil}",
            "assets": [],
        }

        def mock_http_get(url, token=None, retries=3):
            return json.dumps(fake_release).encode()

        monkeypatch.setattr("tribucket_gen.release.http_get", mock_http_get)
        monkeypatch.setattr("tribucket_gen.hashing.http_get", mock_http_get)

        pkg = {
            "name": "tool", "repo": "o/r", "description": "A tool",
            "binary": "tool", "license": "MIT",
            "homepage": "https://github.com/o/r",
            "asset_pattern": {"linux_amd64": "tool-linux-amd64.tar.gz",
                              "linux_arm64": "NO_MATCH",
                              "darwin_amd64": "NO_MATCH", "darwin_arm64": "NO_MATCH",
                              "windows_amd64": "NO_MATCH", "windows_arm64": "NO_MATCH"},
        }
        result = process_package(pkg, str(tmp_path / ".cache"), verbose=False)
        # 4-tuple per the documented API; empty/None components signal refusal
        assert result == (None, None, None, None)


class TestCheckverIntegration:
    def test_download_url_package_with_checkver(self, tmp_path, monkeypatch):
        """Full pipeline: download_url package with checkver detects new version."""
        fake_checkver_response = json.dumps({"version": "2.0.0"})

        def mock_http_get(url, token=None, retries=3, timeout=None):
            if "api.example.com" in url:
                return fake_checkver_response.encode()
            # For SHA256 download, return a small binary
            return b"fake-binary-content"

        monkeypatch.setattr("tribucket_gen.release.http_get", mock_http_get)
        monkeypatch.setattr("tribucket_gen.hashing.http_get", mock_http_get)

        pkg = {
            "name": "demo",
            "repo": "owner/demo",
            "version": "1.0.0",
            "description": "Demo tool",
            "binary": "demo",
            "license": "MIT",
            "homepage": "https://example.com",
            "download_url": {
                "linux_amd64": "https://example.com/releases/demo-1.0.0-linux-amd64.tar.gz",
                "darwin_amd64": "https://example.com/releases/demo-1.0.0-darwin-amd64.tar.gz",
                "windows_amd64": "https://example.com/releases/demo-1.0.0-windows-amd64.zip",
            },
            "checkver": {
                "url": "https://api.example.com/latest",
                "jsonpath": "$.version",
                "regex": "([\\d.]+)"
            }
        }

        cache_dir = str(tmp_path / ".cache")
        formula, bucket, new_version, new_urls = process_package(
            pkg, cache_dir, verbose=False
        )

        # Should detect version 2.0.0
        assert 'version "2.0.0"' in formula
        assert new_version == "2.0.0"
        assert new_urls is not None
        assert "2.0.0" in new_urls["linux_amd64"]
        assert "1.0.0" not in new_urls["linux_amd64"]

    def test_download_url_package_zero_config(self, tmp_path, monkeypatch):
        """Zero-config: extracts version from URL, uses in-place replace."""
        def mock_http_get(url, token=None, retries=3, timeout=None):
            return b"fake-binary-content"

        monkeypatch.setattr("tribucket_gen.release.http_get", mock_http_get)
        monkeypatch.setattr("tribucket_gen.hashing.http_get", mock_http_get)

        pkg = {
            "name": "go",
            "repo": "golang/go",
            "version": "1.24.3",
            "description": "Go language",
            "binary": "go",
            "license": "BSD-3-Clause",
            "homepage": "https://go.dev/",
            "download_url": {
                "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz",
                "darwin_amd64": "https://go.dev/dl/go1.24.3.darwin-amd64.tar.gz",
                "windows_amd64": "https://go.dev/dl/go1.24.3.windows-amd64.zip",
            },
        }

        cache_dir = str(tmp_path / ".cache")
        formula, bucket, new_version, new_urls = process_package(
            pkg, cache_dir, verbose=False
        )

        # Version from URL matches hardcoded — no update triggered
        assert 'version "1.24.3"' in formula
        assert new_version is None  # no change
        assert new_urls is None


# ── Portable generation tests ──────────────────────────────────────


SAMPLE_PKG = {
    "name": "go-wxpush",
    "repo": "hezhizheng/go-wxpush",
    "description": "WeChat push notification utility",
    "binary": "go-wxpush",
    "license": "MIT",
    "homepage": "https://github.com/hezhizheng/go-wxpush",
    "version": "1.5.2",
    "asset_pattern": {
        "linux_amd64": "go-wxpush_linux_amd64",
        "linux_arm64": "go-wxpush_linux_arm64",
        "darwin_amd64": "go-wxpush_darwin_amd64",
        "darwin_arm64": "NO_MATCH",
        "windows_amd64": "go-wxpush_windows_amd64.exe",
        "windows_arm64": "NO_MATCH",
    },
}

JDK_PKG = {
    "name": "corretto-jdk17",
    "repo": "corretto/corretto-17",
    "description": "Amazon Corretto JDK 17",
    "binary": "bin/java",
    "license": "GPL-2.0",
    "homepage": "https://aws.amazon.com/corretto/",
    "version": "17.0.12",
    "asset_pattern": {
        "linux_amd64": "amazon-corretto-17_*-linux-x64.tar.gz",
        "linux_arm64": "amazon-corretto-17_*-linux-aarch64.tar.gz",
        "darwin_amd64": "amazon-corretto-17_*-macos-x64.tar.gz",
        "darwin_arm64": "amazon-corretto-17_*-macos-aarch64.tar.gz",
        "windows_amd64": "amazon-corretto-17_*-windows-x64.zip",
        "windows_arm64": "NO_MATCH",
    },
}


class TestInferAssetFormat:
    def test_tar_gz(self):
        pat = {"linux_amd64": "foo_1.0_linux_amd64.tar.gz"}
        assert infer_asset_format(pat) == {"linux_amd64": "tar.gz"}

    def test_zip(self):
        pat = {"windows_amd64": "foo_1.0_windows_amd64.zip"}
        assert infer_asset_format(pat) == {"windows_amd64": "zip"}

    def test_exe(self):
        pat = {"windows_amd64": "foo.exe"}
        assert infer_asset_format(pat) == {"windows_amd64": "exe"}

    def test_binary(self):
        pat = {"linux_amd64": "foo_linux_amd64"}
        assert infer_asset_format(pat) == {"linux_amd64": "binary"}

    def test_no_match_excluded(self):
        pat = {"linux_amd64": "foo.tar.gz", "darwin_arm64": "NO_MATCH"}
        result = infer_asset_format(pat)
        assert "darwin_arm64" not in result
        assert result["linux_amd64"] == "tar.gz"


class TestInferInstallType:
    def test_binary_default(self):
        assert infer_install_type(SAMPLE_PKG) == "binary"

    def test_jdk_directory(self):
        assert infer_install_type(JDK_PKG) == "directory"

    def test_various_jdk_names(self):
        for prefix in ("corretto-jdk", "temurin-jdk", "zulu-jdk", "graalvm-ce-jdk"):
            pkg = {"name": f"{prefix}17"}
            assert infer_install_type(pkg) == "directory"

    def test_non_jdk_is_binary(self):
        pkg = {"name": "not-a-jdk"}
        assert infer_install_type(pkg) == "binary"


class TestDeriveTribucketJson:
    def test_basic_fields(self):
        tj = derive_tribucket_json(SAMPLE_PKG, "1.5.2")
        assert tj["name"] == "go-wxpush"
        assert tj["version"] == "1.5.2"
        assert tj["repo"] == "hezhizheng/go-wxpush"
        assert tj["binary"] == "go-wxpush"
        assert tj["license"] == "MIT"

    def test_version_check_defaults(self):
        tj = derive_tribucket_json(SAMPLE_PKG, "1.5.2")
        vc = tj["version_check"]
        assert vc["cli_flags"] == ["--version"]
        assert "parse_regex" in vc
        assert vc["timeout"] == 5
        assert vc["fallback_version"] == "1.5.2"

    def test_install_type_inferred(self):
        tj = derive_tribucket_json(SAMPLE_PKG, "1.5.2")
        assert tj["install_type"] == "binary"

        tj_jdk = derive_tribucket_json(JDK_PKG, "17.0.12")
        assert tj_jdk["install_type"] == "directory"

    def test_asset_format_inferred(self):
        tj = derive_tribucket_json(SAMPLE_PKG, "1.5.2")
        assert tj["asset_format"]["linux_amd64"] == "binary"
        assert tj["asset_format"]["windows_amd64"] == "exe"

    def test_mirror_enabled(self):
        tj = derive_tribucket_json(SAMPLE_PKG, "1.5.2")
        assert tj["mirror"]["enabled"] is True

    def test_optional_prerelease(self):
        pkg = {**SAMPLE_PKG, "version_check": {"include_prerelease": True}}
        tj = derive_tribucket_json(pkg, "1.5.2")
        assert tj["version_check"]["include_prerelease"] is True

    def test_optional_download_url(self):
        pkg = {**SAMPLE_PKG, "download_url": {"linux_amd64": "https://example.com/foo"}}
        tj = derive_tribucket_json(pkg, "1.5.2")
        assert "download_url" in tj
        assert tj["download_url"]["linux_amd64"] == "https://example.com/foo"


class TestRenderInstallSh:
    def test_has_shebang(self):
        sh = render_install_sh(SAMPLE_PKG, derive_tribucket_json(SAMPLE_PKG, "1.5.2"))
        assert sh.startswith("#!/usr/bin/env bash")

    def test_checks_for_tribucket_cli(self):
        sh = render_install_sh(SAMPLE_PKG, derive_tribucket_json(SAMPLE_PKG, "1.5.2"))
        assert 'command -v tribucket' in sh

    def test_has_standalone_fallback(self):
        sh = render_install_sh(SAMPLE_PKG, derive_tribucket_json(SAMPLE_PKG, "1.5.2"))
        assert "standalone mode" in sh

    def test_contains_package_name(self):
        sh = render_install_sh(SAMPLE_PKG, derive_tribucket_json(SAMPLE_PKG, "1.5.2"))
        assert 'NAME="go-wxpush"' in sh
        assert 'REPO="hezhizheng/go-wxpush"' in sh


class TestRenderBat:
    def test_has_package_name(self):
        bat = render_bat(SAMPLE_PKG)
        assert "go-wxpush" in bat

    def test_has_exe_extension(self):
        bat = render_bat(SAMPLE_PKG)
        assert "go-wxpush.exe" in bat

    def test_checks_binary_exists(self):
        bat = render_bat(SAMPLE_PKG)
        assert "if not exist" in bat


class TestGeneratePortable:
    def test_creates_files(self, tmp_path):
        ok = generate_portable(SAMPLE_PKG, str(tmp_path), verbose=False)
        assert ok is True

        pkg_dir = tmp_path / "go-wxpush"
        assert (pkg_dir / "tribucket.json").exists()
        assert (pkg_dir / "install.sh").exists()
        assert (pkg_dir / "cmd" / "tribucket-update.bat").exists()

    def test_tribucket_json_valid(self, tmp_path):
        generate_portable(SAMPLE_PKG, str(tmp_path))
        with open(tmp_path / "go-wxpush" / "tribucket.json") as f:
            tj = json.load(f)
        assert tj["name"] == "go-wxpush"
        assert tj["version"] == "1.5.2"

    def test_install_sh_executable(self, tmp_path):
        generate_portable(SAMPLE_PKG, str(tmp_path))
        install_sh = tmp_path / "go-wxpush" / "install.sh"
        assert os.access(str(install_sh), os.X_OK)

    def test_dry_run_no_files(self, tmp_path):
        ok = generate_portable(SAMPLE_PKG, str(tmp_path), dry_run=True)
        assert ok is True
        # No files should be created in dry_run mode
        assert not (tmp_path / "go-wxpush").exists()

    def test_jdk_package(self, tmp_path):
        generate_portable(JDK_PKG, str(tmp_path))
        with open(tmp_path / "corretto-jdk17" / "tribucket.json") as f:
            tj = json.load(f)
        assert tj["install_type"] == "directory"
        assert tj["binary"] == "bin/java"
