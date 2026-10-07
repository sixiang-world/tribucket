"""Tests for tribucket_gen.draft — template matching from release assets."""
import json
import pytest

from tribucket_gen import draft as draft_mod
from tribucket_gen.draft import DraftError, draft, load_templates, sanitize_name


def asset(name):
    return {"name": name, "browser_download_url": f"https://github.com/o/r/releases/download/v1.0.0/{name}"}


def fake_fetcher(release_assets, version="1.0.0"):
    def _f(repo, token=None):
        return version, release_assets, []
    return _f


FAKE_META = {"description": "A cool tool", "license": "MIT"}


def meta_fetcher(repo):
    return FAKE_META


TEMPLATES = load_templates()  # 真实的 skills/tribucket-gen/templates.json


def test_sanitize_name():
    assert sanitize_name("My Tool") == "my-tool"
    assert sanitize_name("Rust_Grep!!") == "rust-grep"
    assert sanitize_name("") == ""


def test_rust_triple_bare_template():
    assets = [
        asset("ripgrep-14.1.1-x86_64-unknown-linux-gnu.tar.gz"),
        asset("ripgrep-14.1.1-aarch64-unknown-linux-gnu.tar.gz"),
        asset("ripgrep-14.1.1-x86_64-apple-darwin.tar.gz"),
        asset("ripgrep-14.1.1-aarch64-apple-darwin.tar.gz"),
        asset("ripgrep-14.1.1-x86_64-pc-windows-msvc.zip"),
        asset("templates.json"),
    ]
    pkg, notes = draft("o/ripgrep", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert pkg["name"] == "ripgrep"
    assert pkg["repo"] == "o/ripgrep"
    assert pkg["license"] == "MIT"
    assert pkg["asset_pattern"]["linux_amd64"] == "x86_64-unknown-linux-gnu.tar.gz"
    assert pkg["asset_pattern"]["darwin_arm64"] == "aarch64-apple-darwin.tar.gz"
    assert pkg["asset_pattern"]["windows_amd64"] == "x86_64-pc-windows-msvc.zip"


def test_simple_hyphen_template_and_name_override():
    assets = [
        asset("cosign-linux-amd64"), asset("cosign-linux-arm64"),
        asset("cosign-darwin-amd64"), asset("cosign-darwin-arm64"),
        asset("cosign-windows-amd64.exe"),
    ]
    pkg, _ = draft("o/cosign", name="Cosign Tool", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert pkg["name"] == "cosign-tool"
    assert pkg["asset_pattern"]["linux_amd64"] == "cosign-linux-amd64"
    assert pkg["asset_pattern"]["windows_arm64"] == "NO_MATCH"  # 资产不存在 → NO_MATCH


def test_underscore_version_uses_glob_for_version():
    assets = [
        asset("lazygit_0.41.0_linux_x86_64.tar.gz"),
        asset("lazygit_0.41.0_linux_arm64.tar.gz"),
        asset("lazygit_0.41.0_darwin_x86_64.tar.gz"),
        asset("lazygit_0.41.0_darwin_arm64.tar.gz"),
        asset("lazygit_0.41.0_windows_x86_64.zip"),
    ]
    pkg, _ = draft("o/lazygit", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    # 版本号嵌入文件名 → 用 * 代替 {name}_{version}，否则下个版本就失配
    assert pkg["asset_pattern"]["linux_amd64"] == "*_linux_x86_64.tar.gz"
    assert pkg["asset_pattern"]["windows_amd64"] == "*_windows_x86_64.zip"


def test_no_template_match_raises_with_assets():
    assets = [asset("totally-weird-bin")]
    with pytest.raises(DraftError) as e:
        draft("o/weird", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert "totally-weird-bin" in str(e.value.assets)


def test_description_and_license_overrides_beat_meta():
    assets = [asset("tool-linux-amd64"), asset("tool-darwin-amd64")]
    pkg, _ = draft(
        "o/tool", description="My own desc", license_id="Apache-2.0",
        fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher,
    )
    assert pkg["description"] == "My own desc"
    assert pkg["license"] == "Apache-2.0"


def test_description_cleaned_of_control_chars():
    assets = [asset("tool-linux-amd64"), asset("tool-darwin-amd64")]
    pkg, _ = draft("o/tool", description="bad\x01desc\"quote",
                   fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert "\x01" not in pkg["description"]
    assert '"' not in pkg["description"]


def test_description_neutralizes_ruby_interpolation():
    """#{...} in any submitter-controlled field would execute when Homebrew
    loads the committed formula; clean_text must neutralize it."""
    assets = [asset("tool-linux-amd64"), asset("tool-darwin-amd64")]
    pkg, _ = draft("o/tool", description="Fast#{%x[evil]}",
                   fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert "#{" not in pkg["description"]


def test_vendored_templates_in_sync():
    """skills/ 下的权威模板与包内 vendored 副本必须逐字节一致（防漂移）。"""
    import pathlib
    repo_root = pathlib.Path(__file__).resolve().parent.parent
    canonical = repo_root / "skills" / "tribucket-gen" / "templates.json"
    vendored = repo_root / "tribucket_gen" / "templates.json"
    assert vendored.read_text(encoding="utf-8") == canonical.read_text(encoding="utf-8")


# --- fix-round-1 regression tests (appended; brief's 8 tests above unchanged) ---

def test_alias_rescue_skips_rule_claimed_asset():
    """Regression: the apple-darwin alias must not re-claim an asset already
    matched by another platform's RULE-derived pattern — otherwise
    darwin_arm64 silently points at the x86_64 binary the darwin_amd64 rule
    already claimed (wrong-but-matching output)."""
    assets = [asset("proj-1.0-x86_64-apple-darwin.tar.gz")]
    aliases = draft_mod.load_template_doc()["platform_aliases"]
    tpl = next(t for t in load_templates() if t["id"] == "rust-triple-bare")
    pat = draft_mod.build_asset_pattern(tpl, "proj", assets, aliases=aliases)
    assert pat["darwin_amd64"] == "x86_64-apple-darwin.tar.gz"
    assert pat["darwin_arm64"] == "NO_MATCH"  # rule-claimed asset is off-limits to rescue


def test_alias_rescue_still_works_when_no_rule_claimed():
    """Universal darwin builds (SKILL.md: darwin_amd64/darwin_arm64 share one
    pattern): with no rule claiming the asset, the apple-darwin alias rescue
    must keep producing a pattern."""
    assets = [asset("proj-1.0-universal-apple-darwin.tar.gz")]
    aliases = draft_mod.load_template_doc()["platform_aliases"]
    tpl = next(t for t in load_templates() if t["id"] == "rust-triple-bare")
    pat = draft_mod.build_asset_pattern(tpl, "proj", assets, aliases=aliases)
    assert pat["darwin_arm64"] == "proj-1.0-universal-apple-darwin.tar.gz"


def test_draft_error_kind_attribute():
    """DraftError carries a machine-readable kind: generic (default) vs no-template."""
    assert DraftError("boom").kind == "generic"
    assert DraftError("no known template", kind="no-template").kind == "no-template"


def test_cmd_draft_exit_code_mapping(monkeypatch, capsys):
    """cmd_draft pins the exit contract: no-template DraftError -> 2
    (needs-manual in CI), other DraftError -> 1, transient error -> 1."""
    import tribucket_gen.__main__ as cli

    def no_template(repo, **kw):
        raise DraftError("no known template matches this repo's release assets",
                         assets=["weird-bin"], kind="no-template")

    def generic(repo, **kw):
        raise DraftError("invalid package name: ''")

    def transient(repo, **kw):
        raise RuntimeError("network down")

    args = cli.build_parser().parse_args(["draft", "o/r"])
    for fake, expected in ((no_template, 2), (generic, 1), (transient, 1)):
        monkeypatch.setattr(draft_mod, "draft", fake)
        assert cli.cmd_draft(args) == expected
        assert "[draft error]" in capsys.readouterr().err
