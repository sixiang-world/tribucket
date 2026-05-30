"""Tests for scripts/checkver.py"""
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
