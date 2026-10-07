"""Tests for the pluggable render registry."""
import json

from tribucket_gen.render import Ctx, render_all


PKG = {
    "name": "tool", "repo": "o/r", "description": "A test tool", "binary": "tool",
    "license": "MIT", "homepage": "https://github.com/o/r",
}


def _ctx():
    return Ctx(
        version="1.0.0", repo="o/r",
        platforms={
            "linux_amd64": {"url": "u1", "sha256": "a"},
            "darwin_arm64": {"url": "u2", "sha256": "b"},
            "windows_amd64": {"url": "u3", "sha256": "c"},
        },
        windows={"64bit": {"url": "u3", "hash": "c", "filename": "tool.exe"}},
        is_download_url=False,
    )


def test_render_all_outputs_both_targets():
    out = render_all(PKG, _ctx())
    assert set(out) == {"Formula/tool.rb", "bucket/tool.json"}
    assert "class Tool < Formula" in out["Formula/tool.rb"]
    assert json.loads(out["bucket/tool.json"])["version"] == "1.0.0"


def test_no_windows_assets_skips_bucket():
    ctx = _ctx()
    ctx.windows = {}
    out = render_all(PKG, ctx)
    assert set(out) == {"Formula/tool.rb"}
