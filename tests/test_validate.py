"""Tests for tribucket_gen.validate."""
import pytest

from tribucket_gen.validate import validate_definition


def asset(name):
    return {"name": name, "browser_download_url": f"https://x/{name}"}


def fake_fetch(assets):
    def _f(repo, token=None):
        return "1.0.0", assets, []
    return _f


GOOD = {
    "name": "tool", "repo": "o/r", "description": "A tool",
    "binary": "tool", "license": "MIT", "homepage": "https://github.com/o/r",
    "asset_pattern": {
        "linux_amd64": "tool-linux-amd64.tar.gz", "linux_arm64": "NO_MATCH",
        "darwin_amd64": "tool-darwin-amd64.tar.gz", "darwin_arm64": "NO_MATCH",
        "windows_amd64": "tool-windows-amd64.exe", "windows_arm64": "NO_MATCH",
    },
}
RELEASE_ASSETS = [
    asset("tool-linux-amd64.tar.gz"), asset("tool-darwin-amd64.tar.gz"),
    asset("tool-windows-amd64.exe"),
]


def test_good_definition_passes(tmp_path):
    errs, warns = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=fake_fetch(RELEASE_ASSETS))
    assert errs == []
    assert warns == []


def test_missing_required_fields():
    errs, _ = validate_definition({"name": "x"}, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("repo" in e for e in errs) and any("description" in e for e in errs)


def test_invalid_name():
    pkg = dict(GOOD, name="Bad_Name")
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("invalid name" in e for e in errs)


def test_quote_in_description_rejected():
    pkg = dict(GOOD, description='has "quotes"')
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("forbidden characters" in e for e in errs)


def test_ruby_interpolation_rejected():
    pkg = dict(GOOD, description='Fast#{%x[evil]}')
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("forbidden characters" in e for e in errs)


def test_digit_leading_name_rejected():
    pkg = dict(GOOD, name="7-zip")
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("invalid name" in e for e in errs)


def test_missing_platform_key():
    pkg = {**GOOD, "asset_pattern": {k: v for k, v in GOOD["asset_pattern"].items() if k != "linux_arm64"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("linux_arm64" in e for e in errs)


def test_pattern_matching_nothing_rejected():
    pkg = {**GOOD, "asset_pattern": {**GOOD["asset_pattern"], "linux_amd64": "nonexistent-*.tar.gz"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("matches no asset" in e for e in errs)


def test_too_few_matching_platforms_rejected():
    pkg = {**GOOD, "asset_pattern": {**GOOD["asset_pattern"],
           "darwin_amd64": "NO_MATCH", "windows_amd64": "NO_MATCH"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("near-zero output" in e for e in errs)


def test_duplicate_name_rejected(tmp_path):
    (tmp_path / "tool.json").write_text("{}", encoding="utf-8")
    errs, _ = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("already exists" in e for e in errs)


def test_network_error_becomes_warning():
    def boom(repo, token=None):
        raise RuntimeError("timeout")
    errs, warns = validate_definition(GOOD, fetch_release=boom)
    assert errs == [] and any("could not fetch release" in w for w in warns)


def test_offline_skips_online_check(tmp_path):
    errs, warns = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=None)
    assert errs == [] and warns == []
