"""Tests for scripts/checkver.py"""
import json
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'scripts'))
import checkver


class TestExtractVersionFromUrl:
    def test_go_style(self):
        url = "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
        assert checkver.extract_version_from_url(url) == "1.24.3"

    def test_node_style_with_v(self):
        url = "https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-x64.tar.gz"
        assert checkver.extract_version_from_url(url) == "22.15.0"

    def test_jdk_multi_segment(self):
        url = "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_x64.tar.gz"
        result = checkver.extract_version_from_url(url)
        assert result in ["21.50.19", "21.0.11"]  # picks longest match

    def test_no_version(self):
        url = "https://example.com/downloads/tool-linux-amd64.tar.gz"
        assert checkver.extract_version_from_url(url) is None

    def test_year_version(self):
        url = "https://github.com/org/repo/releases/download/2025.3.0/tool.tar.gz"
        assert checkver.extract_version_from_url(url) == "2025.3.0"


class TestResolveJsonpath:
    def test_root_field(self):
        data = {"version": "1.2.3", "name": "test"}
        assert checkver.resolve_jsonpath(data, "$.version") == "1.2.3"

    def test_nested_field(self):
        data = {"release": {"version": "2.0.0"}}
        assert checkver.resolve_jsonpath(data, "$.release.version") == "2.0.0"

    def test_array_index(self):
        data = [{"version": "1.0"}, {"version": "2.0"}]
        assert checkver.resolve_jsonpath(data, "$[0].version") == "1.0"
        assert checkver.resolve_jsonpath(data, "$[1].version") == "2.0"

    def test_field_then_array(self):
        data = {"assets": [{"name": "a.zip"}, {"name": "b.zip"}]}
        assert checkver.resolve_jsonpath(data, "$.assets[0].name") == "a.zip"

    def test_null_on_missing(self):
        data = {"foo": "bar"}
        assert checkver.resolve_jsonpath(data, "$.missing") is None

    def test_null_on_non_dict(self):
        assert checkver.resolve_jsonpath("plain string", "$.field") is None

    def test_no_dollar_prefix(self):
        data = {"version": "1.0"}
        assert checkver.resolve_jsonpath(data, "version") == "1.0"


class TestRunCheckver:
    def test_zero_config_extracts_from_url(self, monkeypatch):
        """Without checkver field, auto-extract from download_url."""
        pkg = {
            "name": "go",
            "version": "1.24.3",
            "download_url": {
                "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "1.24.3"
        assert captures["version"] == "1.24.3"

    def test_github_mode(self, monkeypatch):
        """checkver: 'github' uses repo's GitHub API."""
        fake_release = json.dumps({"tag_name": "v3.0.0", "assets": []})

        def mock_http_get(url, token=None, retries=3):
            return fake_release.encode()

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "tool",
            "repo": "owner/repo",
            "version": "2.0.0",
            "download_url": {"linux_amd64": "https://x/tool-2.0.0.tar.gz"},
            "checkver": "github"
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "3.0.0"

    def test_regex_with_numbered_capture(self, monkeypatch):
        """checkver.regex extracts first capture group as version."""
        def mock_http_get(url, token=None, retries=3):
            return b"go1.24.3"

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "go",
            "version": "1.24.0",
            "download_url": {"linux_amd64": "https://x/go1.24.0.tar.gz"},
            "checkver": {
                "url": "https://go.dev/dl/?mode=json",
                "regex": "go([\\d.]+)"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "1.24.3"

    def test_named_capture_groups(self, monkeypatch):
        """Scoop-style (?<name>...) groups are available in captures."""
        def mock_http_get(url, token=None, retries=3):
            return b"zulu21.50.19-ca-jdk21.0.11"

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "zulu",
            "version": "21.0.0",
            "download_url": {"linux_amd64": "https://x/zulu-old.tar.gz"},
            "checkver": {
                "url": "https://api.example.com/latest",
                "jsonpath": "$.filename",
                "regex": "zulu(?<build>[\\d.]+)-ca-jdk(?<ver>[\\d.]+)",
                "replace": "${ver}"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "21.0.11"
        assert captures["build"] == "21.50.19"
        assert captures["ver"] == "21.0.11"
        assert captures["version"] == "21.0.11"

    def test_jsonpath_then_regex(self, monkeypatch):
        """jsonpath extracts a field, then regex extracts version from it."""
        fake_json = json.dumps({"download_url": "https://cdn.x/zulu21.50.19-ca-jdk21.0.11_linux_x64.tar.gz"})

        def mock_http_get(url, token=None, retries=3):
            return fake_json.encode()

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "zulu",
            "version": "21.0.0",
            "download_url": {"linux_amd64": "https://x/old.tar.gz"},
            "checkver": {
                "url": "https://api.example.com/latest",
                "jsonpath": "$.download_url",
                "regex": "jdk([\\d.]+)"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "21.0.11"

    def test_fallback_on_http_error(self, monkeypatch):
        """When checkver.url fails, fall back to hardcoded version."""
        def mock_http_get(url, token=None, retries=3):
            raise OSError("Connection refused")

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "tool",
            "version": "1.0.0",
            "download_url": {"linux_amd64": "https://broken.example.com/tool.tar.gz"},
            "checkver": {
                "url": "https://broken.example.com/api",
                "regex": "v([\\d.]+)"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "1.0.0"
        assert captures["version"] == "1.0.0"

    def test_fallback_on_regex_mismatch(self, monkeypatch):
        """When regex doesn't match, fall back to hardcoded version."""
        def mock_http_get(url, token=None, retries=3):
            return b"unexpected format"

        monkeypatch.setattr(checkver, "http_get", mock_http_get)

        pkg = {
            "name": "tool",
            "version": "1.0.0",
            "download_url": {"linux_amd64": "https://x/tool-1.0.0.tar.gz"},
            "checkver": {
                "url": "https://x/api",
                "regex": "v([\\d.]+)"
            }
        }
        version, captures = checkver.run_checkver(pkg)
        assert version == "1.0.0"
