"""Exercise add through the CLI with a simulated GitHub release."""
import json
from urllib.error import URLError

import pytest

from tribucket_gen import core, release
from tribucket_gen import __main__ as cli
from tribucket_gen.__main__ import main


@pytest.fixture
def add_repo(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    (tmp_path / "packages").mkdir()
    return tmp_path


def mock_release(monkeypatch, names, validation_fails=False):
    calls = []

    def http_get(url, token=None):
        assert url == "https://api.github.com/repos/example/tool/releases/latest"
        calls.append(url)
        if validation_fails and len(calls) == 2:
            raise URLError("validation timed out")
        return json.dumps({
            "tag_name": "v1.2.3",
            "assets": [
                {"name": name, "browser_download_url": f"https://example.com/{name}"}
                for name in names
            ],
        }).encode()

    monkeypatch.setattr(release, "http_get", http_get)
    monkeypatch.setattr(core, "get_sha256_for_asset", lambda *args, **kwargs: "a" * 64)
    return calls


ASSETS = ("tool-linux-amd64.tar.gz", "tool-windows-amd64.exe")
ADD = ["add", "example/tool", "--description", "Example tool", "--license", "MIT"]


def test_add_writes_valid_outputs(add_repo, monkeypatch):
    mock_release(monkeypatch, ASSETS)

    assert main(ADD + ["--name", "example-tool", "--binary", "run-tool",
                       "--homepage", "https://example.com"]) == 0

    pkg = json.loads((add_repo / "packages/example-tool.json").read_text(encoding="utf-8"))
    manifest = json.loads((add_repo / "bucket/example-tool.json").read_text(encoding="utf-8"))
    formula = (add_repo / "Formula/example-tool.rb").read_text(encoding="utf-8")
    assert pkg["name"] == "example-tool"
    assert pkg["binary"] == "run-tool"
    assert pkg["homepage"] == "https://example.com"
    assert manifest["version"] == "1.2.3"
    assert manifest["architecture"]["64bit"]["hash"] == "a" * 64
    assert "class ExampleTool < Formula" in formula


@pytest.mark.parametrize("network_error", [False, True])
def test_add_rolls_back_on_validation_failure(add_repo, monkeypatch, capsys, network_error):
    names = ASSETS if network_error else ASSETS[:1]
    calls = mock_release(monkeypatch, names, validation_fails=network_error)

    assert main(ADD) == 1

    assert len(calls) == 2
    assert ("validation timed out" if network_error else "only 1 platform(s) match") in capsys.readouterr().out
    assert not (add_repo / "packages/tool.json").exists()
    assert not (add_repo / "Formula/tool.rb").exists()
    assert not (add_repo / "bucket/tool.json").exists()


def test_add_preserves_existing_files(add_repo, monkeypatch):
    mock_release(monkeypatch, ASSETS)
    existing = add_repo / "packages/Tool.json"
    existing.write_text("existing definition", encoding="utf-8")

    assert main(ADD) == 1

    assert existing.read_text(encoding="utf-8") == "existing definition"
    assert list(existing.parent.iterdir()) == [existing]


def test_add_removes_partial_files_on_render_failure(add_repo, monkeypatch):
    mock_release(monkeypatch, ASSETS)
    partial = add_repo / "Formula/tool.rb"

    def fail_render(args):
        assert args.only == ["tool"]
        partial.parent.mkdir()
        partial.write_text("partial output", encoding="utf-8")
        return 2

    monkeypatch.setattr(cli, "cmd_render", fail_render)
    assert main(ADD) == 2
    assert not (add_repo / "packages/tool.json").exists()
    assert not partial.exists()
