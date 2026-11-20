import hashlib
import json
from pathlib import Path

import pytest

from tribucket_gen.core import process_package


def package_for_urls(monkeypatch, mode, version, urls):
    pkg = {
        "name": "tool",
        "repo": "owner/tool",
        "description": "A test tool",
        "binary": "tool",
        "license": "MIT",
        "homepage": "https://example.com",
    }
    if mode == "direct":
        return dict(pkg, version=version, download_url=urls)

    patterns = {platform: url.rsplit("/", 1)[-1].partition("?")[0] for platform, url in urls.items()}
    assets = [
        {"name": patterns[platform], "browser_download_url": url}
        for platform, url in urls.items()
    ]
    checksums = [{"name": "SHA256SUMS", "browser_download_url": "https://example.com/SHA256SUMS"}]
    monkeypatch.setattr(
        "tribucket_gen.core.fetch_latest_release",
        lambda repo, token: (version, assets, checksums),
    )
    return dict(pkg, asset_pattern=patterns)


def save_outputs(root, rendered):
    formula, bucket, _, _ = rendered
    for name, content in (("Formula/tool.rb", formula), ("bucket/tool.json", bucket)):
        if content is not None:
            path = root / name
            path.parent.mkdir(exist_ok=True)
            path.write_text(content, encoding="utf-8")


@pytest.mark.parametrize("mode", ["release", "direct"])
def test_second_render_uses_both_generated_hashes(tmp_path, monkeypatch, mode):
    urls = {
        "linux_amd64": "https://example.com/tool-linux.tar.gz",
        "windows_amd64": "https://example.com/tool-windows.zip",
    }
    pkg = package_for_urls(monkeypatch, mode, "1.0.0", urls)

    def download(url, dest_path, **kwargs):
        Path(dest_path).write_bytes(url.encode())

    def get_checksums(url):
        return "\n".join(
            f"{hashlib.sha256(url.encode()).hexdigest()}  {url.rsplit('/', 1)[-1]}"
            for url in urls.values()
        ).encode()

    monkeypatch.setattr("tribucket_gen.hashing.download_file", download)
    monkeypatch.setattr("tribucket_gen.hashing.http_get", get_checksums)
    first = process_package(pkg, tmp_path / ".cache-first")
    assert all(first[:2])
    save_outputs(tmp_path, first)

    def unexpected_request(*args, **kwargs):
        pytest.fail(f"unchanged asset triggered a network request: {args[0]}")

    monkeypatch.setattr("tribucket_gen.hashing.download_file", unexpected_request)
    monkeypatch.setattr("tribucket_gen.hashing.http_get", unexpected_request)
    assert process_package(pkg, tmp_path / ".cache-empty") == first


@pytest.mark.parametrize(
    ("version", "url", "invalid_old_hash"),
    [
        ("2.0.0", "https://example.com/tool.zip", False),
        ("1.0.0", "https://example.com/tool.zip?revision=2", False),
        ("1.0.0", "https://example.com/tool.zip", True),
    ],
)
def test_version_url_and_hash_validity_control_reuse(tmp_path, monkeypatch, version, url, invalid_old_hash):
    initial_url = "https://example.com/tool.zip"
    original_pkg = package_for_urls(monkeypatch, "release", "1.0.0", {"windows_amd64": initial_url})
    checksum_requests = []

    def get_checksums(checksum_url):
        checksum_requests.append(checksum_url)
        return f"{len(checksum_requests):064x}  tool.zip\n".encode()

    monkeypatch.setattr("tribucket_gen.hashing.http_get", get_checksums)
    old = process_package(original_pkg, tmp_path / ".cache")
    save_outputs(tmp_path, old)
    cache_dir = tmp_path / ".cache"
    if invalid_old_hash:
        cache_dir = tmp_path / ".cache-empty"
        manifest_path = tmp_path / "bucket" / "tool.json"
        manifest = json.loads(old[1])
        manifest["architecture"]["64bit"]["hash"] = "z" * 64
        manifest_path.write_text(json.dumps(manifest), encoding="utf-8")

    pkg = package_for_urls(monkeypatch, "release", version, {"windows_amd64": url})
    _, bucket, _, _ = process_package(pkg, cache_dir)
    assert json.loads(bucket)["architecture"]["64bit"]["hash"] == f"{2:064x}"
    assert len(checksum_requests) == 2
