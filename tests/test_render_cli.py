import json
from pathlib import Path
from urllib.error import HTTPError, URLError

import pytest

from tribucket_gen import __main__ as cli


def test_check_does_not_pass_when_release_is_unreachable(tmp_path, monkeypatch, capsys):
    monkeypatch.chdir(tmp_path)
    packages = tmp_path / "packages"
    packages.mkdir()
    (packages / "demo.json").write_text('{"name":"demo","repo":"owner/demo"}', encoding="utf-8")

    def fetch(*args):
        raise URLError("offline")

    monkeypatch.setattr("tribucket_gen.assets.fetch_latest_release", fetch)
    assert cli.main(["check"]) == 1
    assert "demo: network error" in capsys.readouterr().out


@pytest.mark.parametrize("error", [
    URLError("offline"),
    HTTPError("https://example.test", 503, "unavailable", None, None),
    ValueError("bad release"),
])
def test_render_reports_failure_and_updates_other_packages(tmp_path, monkeypatch, capsys, error):
    monkeypatch.chdir(tmp_path)
    packages = tmp_path / "packages"
    packages.mkdir()
    for name in ("bad", "good", "same"):
        (packages / f"{name}.json").write_text(json.dumps({"name": name}), encoding="utf-8")
    bucket = tmp_path / "bucket"
    bucket.mkdir()
    (bucket / "same.json").write_text('{"version": "1.0"}\n', encoding="utf-8")

    def process(pkg, cache_dir, **kwargs):
        if pkg["name"] == "bad":
            raise error
        return None, '{"version": "1.0"}\n', None, None

    monkeypatch.setattr(cli, "process_package", process)
    assert cli.main(["render"]) == 2
    assert (bucket / "good.json").is_file()
    assert not (bucket / "bad.json").exists()
    output = capsys.readouterr().out
    assert f"[error] bad: {error}" in output
    assert "updated (1): good" in output
    assert "unchanged (1): same" in output
    assert "failed (1): bad" in output


def test_render_restores_outputs_if_writeback_fails(tmp_path, monkeypatch, capsys):
    monkeypatch.chdir(tmp_path)
    (tmp_path / "packages").mkdir()
    (tmp_path / "Formula").mkdir()
    definition = tmp_path / "packages/demo.json"
    definition.write_text('{"name": "demo", "version": "1.0"}\n', encoding="utf-8")
    formula = tmp_path / "Formula/demo.rb"
    formula.write_text("old formula\n", encoding="utf-8")
    monkeypatch.setattr(cli, "process_package", lambda *a, **kw: (
        "new formula\n", '{"version": "2.0"}\n', "2.0", None,
    ))
    replace = cli.os.replace

    def failing_replace(source, destination):
        if Path(destination) == definition:
            raise PermissionError("definition is locked")
        return replace(source, destination)

    monkeypatch.setattr(cli.os, "replace", failing_replace)
    assert cli.main(["render"]) == 2
    assert formula.read_text(encoding="utf-8") == "old formula\n"
    assert not (tmp_path / "bucket/demo.json").exists()
    assert json.loads(definition.read_text(encoding="utf-8"))["version"] == "1.0"
    assert "failed (1): demo" in capsys.readouterr().out
