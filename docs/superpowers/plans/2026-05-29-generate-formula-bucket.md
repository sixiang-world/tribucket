# Automated Formula & Bucket Generation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build `scripts/generate.py` that reads `packages/*.json`, fetches GitHub release metadata, and auto-generates `Formula/*.rb` and `bucket/*.json` for all 17 packages.

**Architecture:** A single Python script with clear internal sections: CLI parsing, package loading, GitHub API client, asset matching, SHA256 computation with caching, and template rendering for Homebrew and Scoop. Each section is independently testable via functions.

**Tech Stack:** Python 3.6+ (stdlib only — `argparse`, `json`, `urllib`, `hashlib`, `glob`, `fnmatch`, `pathlib`). No third-party dependencies.

---

## File Structure

| File | Responsibility |
|------|---------------|
| `scripts/generate.py` | Main script — CLI, API, templates, all logic |
| `tests/test_generate.py` | Unit tests for pure functions (no network) |
| `tests/fixtures/packages/test-pkg.json` | Test fixture package definition |
| `.gitignore` | Add `.cache/` |
| `.github/workflows/validate.yml` | Add dry-run CI step |
| `README.md` | Update to remove "仅支持 ccx" notes |
| `CONTRIBUTING.md` | Document the generate workflow |

---

### Task 1: Scaffold and CLI Parsing

**Files:**
- Create: `scripts/generate.py`
- Create: `tests/test_generate.py`

- [ ] **Step 1: Write test for CLI argument parsing**

Create `tests/test_generate.py`:

```python
"""Tests for scripts/generate.py"""
import sys
import os
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: FAIL — `ModuleNotFoundError: No module named 'generate'`

- [ ] **Step 3: Write minimal generate.py with CLI parsing**

Create `scripts/generate.py`:

```python
#!/usr/bin/env python3
"""tribucket generator — produces Formula/*.rb and bucket/*.json from packages/*.json.

Usage:
    python scripts/generate.py [--only NAME ...] [--skip-hash] [--dry-run] [--verbose]
"""
import argparse
import json
import os
import sys


def parse_args(argv=None):
    """Parse CLI arguments. Accepts list for testing; defaults to sys.argv[1:]."""
    parser = argparse.ArgumentParser(
        description="Generate Homebrew Formula and Scoop Bucket from packages/*.json"
    )
    parser.add_argument(
        "--only", action="append", default=[],
        help="Generate for a single package only (can repeat)"
    )
    parser.add_argument(
        "--skip-hash", action="store_true", default=False,
        help="Skip SHA256 computation (reuse existing hashes)"
    )
    parser.add_argument(
        "--dry-run", action="store_true", default=False,
        help="Print generated content to stdout, don't write files"
    )
    parser.add_argument(
        "--verbose", action="store_true", default=False,
        help="Print detailed progress"
    )
    return parser.parse_args(argv)


def main():
    args = parse_args()
    # TODO: implement in later tasks
    print("generate.py scaffold OK")


if __name__ == "__main__":
    main()
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — 4 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): scaffold script with CLI argument parsing"
```

---

### Task 2: Package Loading

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`
- Create: `tests/fixtures/packages/test-pkg.json`

- [ ] **Step 1: Create test fixture**

Create `tests/fixtures/packages/test-pkg.json`:

```json
{
  "name": "test-pkg",
  "repo": "owner/test-pkg",
  "description": "A test package",
  "binary": "tp",
  "license": "MIT",
  "homepage": "https://github.com/owner/test-pkg",
  "asset_pattern": {
    "linux_amd64": "test-pkg-linux-amd64.tar.gz",
    "linux_arm64": "test-pkg-linux-arm64.tar.gz",
    "darwin_amd64": "test-pkg-darwin-amd64.tar.gz",
    "darwin_arm64": "test-pkg-darwin-arm64.tar.gz",
    "windows_amd64": "test-pkg-windows-amd64.exe",
    "windows_arm64": "test-pkg-windows-arm64.exe"
  }
}
```

- [ ] **Step 2: Write tests for load_packages**

Add to `tests/test_generate.py`:

```python
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
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestLoadPackages -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'load_packages'`

- [ ] **Step 4: Implement load_packages**

Add to `scripts/generate.py` (after the imports, before `parse_args`):

```python
def load_packages(packages_dir, only=None):
    """Load package definitions from packages/*.json.

    Args:
        packages_dir: Path to the packages/ directory.
        only: Optional list of package names to filter by.

    Returns:
        List of package dicts.
    """
    pkgs = []
    for f in sorted(os.listdir(packages_dir)):
        if not f.endswith(".json"):
            continue
        path = os.path.join(packages_dir, f)
        with open(path, encoding="utf-8") as fh:
            pkg = json.load(fh)
        pkgs.append(pkg)

    if only:
        only_set = set(only)
        found = {p["name"] for p in pkgs}
        missing = only_set - found
        for m in missing:
            print(f"[warn] Package '{m}' not found in {packages_dir}")
        pkgs = [p for p in pkgs if p["name"] in only_set]

    return pkgs
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 7 tests pass

- [ ] **Step 6: Commit**

```bash
git add scripts/generate.py tests/test_generate.py tests/fixtures/packages/test-pkg.json
git commit -m "feat(generate): add package loading with --only filter"
```

---

### Task 3: Asset Pattern Matching

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Write tests for match_asset**

Add to `tests/test_generate.py`:

```python
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
        result = generate.match_asset(assets, "fzf-*-linux_amd64.tar.gz")
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestMatchAsset -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'match_asset'`

- [ ] **Step 3: Implement match_asset**

Add to `scripts/generate.py`:

```python
from fnmatch import fnmatch


def match_asset(assets, pattern):
    """Find the first asset whose name matches the pattern (substring or glob).

    Args:
        assets: List of asset dicts from GitHub API (each has 'name' and 'browser_download_url').
        pattern: Substring or glob pattern from package asset_pattern.

    Returns:
        The matching asset dict, or None.
    """
    # First try substring match
    for asset in assets:
        if pattern in asset["name"]:
            return asset
    # Then try glob match
    for asset in assets:
        if fnmatch(asset["name"], f"*{pattern}*"):
            return asset
    return None
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 11 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): add asset pattern matching (substring + glob)"
```

---

### Task 4: GitHub API Client

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Write tests for GitHub API functions**

Add to `tests/test_generate.py`:

```python
import json as json_mod


class TestGitHubAPI:
    def test_parse_release(self):
        """Test that fetch_latest_release returns the right structure."""
        # We test the parsing logic, not the HTTP call
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
        """Various checksum file naming patterns are detected."""
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestGitHubAPI -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'parse_release'`

- [ ] **Step 3: Implement parse_release and http_get**

Add to `scripts/generate.py`:

```python
import time
import urllib.request
import urllib.error


CHECKSUM_PATTERNS = ("sha256sums", "SHA256SUMS", "checksums.txt", ".sha256")


def is_checksum_asset(name):
    """Check if an asset name looks like a checksum file."""
    lower = name.lower()
    return any(p.lower() in lower for p in CHECKSUM_PATTERNS)


def parse_release(release_json):
    """Extract version, assets, and checksum assets from a GitHub release JSON.

    Args:
        release_json: Parsed JSON dict from GitHub API /releases/latest.

    Returns:
        Tuple of (version_str, all_assets, checksum_assets).
        version_str has the 'v' prefix stripped.
    """
    tag = release_json["tag_name"]
    version = tag.lstrip("v")
    all_assets = release_json.get("assets", [])
    checksum_assets = [a for a in all_assets if is_checksum_asset(a["name"])]
    return version, all_assets, checksum_assets


def http_get(url, token=None, retries=3):
    """Fetch a URL with optional GitHub token and retry logic.

    Args:
        url: The URL to fetch.
        token: Optional GitHub API token.
        retries: Number of retry attempts.

    Returns:
        Response body as bytes.

    Raises:
        urllib.error.URLError on failure after retries.
    """
    headers = {"Accept": "application/vnd.github.v3+json"}
    if token:
        headers["Authorization"] = f"token {token}"

    req = urllib.request.Request(url, headers=headers)
    last_err = None
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                return resp.read()
        except urllib.error.HTTPError as e:
            last_err = e
            if e.code == 403:
                raise  # Rate limit — don't retry
            if e.code >= 500 and attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
        except urllib.error.URLError as e:
            last_err = e
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
                continue
            raise
    raise last_err


def fetch_latest_release(repo, token=None):
    """Fetch the latest release from GitHub.

    Args:
        repo: GitHub repo in 'owner/repo' format.
        token: Optional GitHub API token.

    Returns:
        Tuple of (version_str, all_assets, checksum_assets).
    """
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    body = http_get(url, token=token)
    release_json = json.loads(body)
    return parse_release(release_json)
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 15 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): add GitHub API client with retry and rate limit handling"
```

---

### Task 5: SHA256 Computation with Cache

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`
- Modify: `.gitignore`

- [ ] **Step 1: Write tests for SHA256 functions**

Add to `tests/test_generate.py`:

```python
import hashlib


class TestSHA256:
    def test_cache_key_path(self):
        path = generate.cache_key_path("/repo/.cache", "ccx", "2.8.12", "ccx-linux-amd64.tar.gz")
        assert path.endswith(".cache/ccx/2.8.12/ccx-linux-amd64.tar.gz.sha256")

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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestSHA256 -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'cache_key_path'`

- [ ] **Step 3: Implement SHA256 functions**

Add to `scripts/generate.py`:

```python
import hashlib


def cache_key_path(cache_dir, pkg_name, version, filename):
    """Return the path to a cached SHA256 hash file."""
    return os.path.join(cache_dir, pkg_name, version, f"{filename}.sha256")


def get_cached_hash(cache_dir, pkg_name, version, filename):
    """Return cached SHA256 hash if it exists, else None."""
    path = cache_key_path(cache_dir, pkg_name, version, filename)
    if os.path.isfile(path):
        with open(path) as f:
            return f.read().strip()
    return None


def write_cache(cache_dir, pkg_name, version, filename, sha256_hash):
    """Write a SHA256 hash to the cache."""
    path = cache_key_path(cache_dir, pkg_name, version, filename)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(sha256_hash)


def compute_sha256(filepath):
    """Compute SHA256 hex digest of a file."""
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_checksum_file(content, target_filename):
    """Extract SHA256 hash for target_filename from a checksum file.

    Args:
        content: Text content of the checksum file.
        target_filename: The asset filename to find the hash for.

    Returns:
        Hex hash string, or None if not found.
    """
    for line in content.strip().splitlines():
        parts = line.strip().split()
        if len(parts) >= 2 and target_filename in parts[-1]:
            return parts[0].lower()
    return None
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 22 tests pass

- [ ] **Step 5: Add .cache/ to .gitignore**

Append to `.gitignore`:

```
# Generator cache
.cache/
```

- [ ] **Step 6: Commit**

```bash
git add scripts/generate.py tests/test_generate.py .gitignore
git commit -m "feat(generate): add SHA256 computation with file-based cache"
```

---

### Task 6: Homebrew Formula Template Rendering

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Write tests for Formula rendering**

Add to `tests/test_generate.py`:

```python
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestFormulaRendering -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'class_name_from'`

- [ ] **Step 3: Implement Formula rendering**

Add to `scripts/generate.py`:

```python
def class_name_from(name):
    """Derive a Ruby class name from a package name.

    'ccx' -> 'Ccx', 'claude-code' -> 'ClaudeCode', 'my-cool-tool' -> 'MyCoolTool'
    """
    return "".join(part.capitalize() for part in name.split("-"))


def render_formula(info):
    """Render a Homebrew Formula .rb file from package info.

    Args:
        info: Dict with keys: name, description, homepage, license, binary, version,
              platforms (dict of platform_key -> {url, sha256}).

    Returns:
        String content of the .rb file.
    """
    class_name = class_name_from(info["name"])
    p = info["platforms"]

    def platform_block(os_name, arch, platform_key):
        if platform_key not in p:
            return ""
        data = p[platform_key]
        return (
            f"    on_{arch} do\n"
            f'      url "{data["url"]}"\n'
            f'      sha256 "{data["sha256"]}"\n'
            f"    end\n"
        )

    def os_block(os_name, platform_keys):
        blocks = ""
        if os_name == "macos":
            blocks += platform_block(os_name, "arm", "darwin_arm64")
            blocks += platform_block(os_name, "intel", "darwin_amd64")
        else:
            blocks += platform_block(os_name, "arm", "linux_arm64")
            blocks += platform_block(os_name, "intel", "linux_amd64")
        if not blocks:
            return ""
        return f"  on_{os_name} do\n{blocks}  end\n\n"

    macos_block = os_block("macos", ["darwin_arm64", "darwin_amd64"])
    linux_block = os_block("linux", ["linux_arm64", "linux_amd64"])

    binary = info["binary"]

    formula = (
        f"class {class_name} < Formula\n"
        f'  desc "{info["description"]}"\n'
        f'  homepage "{info["homepage"]}"\n'
        f'  version "{info["version"]}"\n'
        f'  license "{info["license"]}"\n'
        f"\n"
        f"{macos_block}"
        f"{linux_block}"
        f"  def install\n"
        f'    bin.install Dir["{binary}*"].first => "{binary}"\n'
        f"  end\n"
        f"\n"
        f"  test do\n"
        f'    assert_match version.to_s, shell_output("#{bin}/{binary} --version 2>&1", 1)\n'
        f"  end\n"
        f"end\n"
    )
    return formula
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 29 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): add Homebrew Formula template rendering"
```

---

### Task 7: Scoop Bucket Template Rendering

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Write tests for Bucket rendering**

Add to `tests/test_generate.py`:

```python
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestBucketRendering -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'render_bucket'`

- [ ] **Step 3: Implement Bucket rendering**

Add to `scripts/generate.py`:

```python
def autoupdate_url(url, version):
    """Derive a Scoop autoupdate URL by replacing the version segment with $version.

    Handles both 'v1.2.3' and '1.2.3' in the URL path.
    """
    # Try v-prefixed first
    v_str = f"v{version}"
    if v_str in url:
        return url.replace(v_str, "v$version", 1)
    # Try bare version
    if version in url:
        return url.replace(version, "$version", 1)
    return url


def render_bucket(info):
    """Render a Scoop Bucket .json file from package info.

    Args:
        info: Dict with keys: name, repo, description, homepage, license, binary, version,
              windows (dict of arch_key -> {url, hash, filename}).

    Returns:
        String content of the .json file.
    """
    w = info["windows"]
    repo = info["repo"]

    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key in w:
            entry = w[arch_key]
            architecture[arch_key] = {
                "url": entry["url"],
                "hash": entry["hash"],
            }
            autoupdate_arch[arch_key] = {
                "url": autoupdate_url(entry["url"], info["version"]),
            }

    # bin: use 64bit filename if available, else arm64
    bin_filename = w.get("64bit", w.get("arm64", {})).get("filename", "")

    bucket = {
        "version": info["version"],
        "description": info["description"],
        "homepage": info["homepage"],
        "license": info["license"],
        "architecture": architecture,
        "bin": [[bin_filename, info["binary"]]],
        "checkver": {
            "github": f"https://github.com/{repo}",
        },
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }
    return json.dumps(bucket, indent=2, ensure_ascii=False) + "\n"
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 33 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): add Scoop Bucket template rendering"
```

---

### Task 8: Main Orchestration and Full Pipeline

**Files:**
- Modify: `scripts/generate.py`
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Write integration test for the full pipeline (mocked)**

Add to `tests/test_generate.py`:

```python
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py::TestFullPipeline -v`
Expected: FAIL — `AttributeError: module 'generate' has no attribute 'process_package'`

- [ ] **Step 3: Implement process_package and update main()**

Add to `scripts/generate.py` (update the `main()` function as well):

```python
def process_package(pkg, cache_dir, verbose=False):
    """Process a single package: fetch release, compute hashes, render templates.

    Args:
        pkg: Package dict from packages/*.json.
        cache_dir: Path to the .cache directory.
        verbose: Print detailed progress.

    Returns:
        Tuple of (formula_content, bucket_content).
        Either may be None if the package lacks assets for that format.
    """
    name = pkg["name"]
    repo = pkg["repo"]
    token = os.environ.get("GITHUB_TOKEN")

    if verbose:
        print(f"  Fetching latest release for {repo}...")

    version, all_assets, checksum_assets = fetch_latest_release(repo, token)
    if verbose:
        print(f"  Latest: v{version} ({len(all_assets)} assets)")

    # Match assets per platform
    platforms = {}  # platform_key -> {url, sha256}
    windows = {}    # arch_key -> {url, hash, filename}

    PLATFORM_KEYS = [
        "linux_amd64", "linux_arm64",
        "darwin_amd64", "darwin_arm64",
        "windows_amd64", "windows_arm64",
    ]

    for plat_key in PLATFORM_KEYS:
        pattern = pkg.get("asset_pattern", {}).get(plat_key)
        if not pattern:
            continue
        asset = match_asset(all_assets, pattern)
        if not asset:
            print(f"  [warn] {name}: no asset matching '{pattern}' for {plat_key}")
            continue

        url = asset["browser_download_url"]
        filename = asset["name"]

        # Get SHA256
        sha = get_cached_hash(cache_dir, name, version, filename)
        if sha:
            if verbose:
                print(f"  [cache hit] {filename}")
        else:
            sha = get_sha256_for_asset(
                url, filename, all_assets, checksum_assets, cache_dir, name, version, verbose
            )

        platforms[plat_key] = {"url": url, "sha256": sha}

        # Collect Windows assets for bucket
        if plat_key.startswith("windows_"):
            arch_key = "64bit" if "amd64" in plat_key else "arm64"
            windows[arch_key] = {"url": url, "hash": sha, "filename": filename}

    # Render Formula (needs at least one macOS or Linux platform)
    darwin_linux = {k: v for k, v in platforms.items() if not k.startswith("windows_")}
    formula = None
    if darwin_linux:
        formula_info = {
            "name": name,
            "description": pkg["description"],
            "homepage": pkg["homepage"],
            "license": pkg["license"],
            "binary": pkg["binary"],
            "version": version,
            "platforms": darwin_linux,
        }
        formula = render_formula(formula_info)
    else:
        print(f"  [warn] {name}: no macOS/Linux assets, skipping Formula")

    # Render Bucket (needs at least one Windows platform)
    bucket = None
    if windows:
        bucket_info = {
            "name": name,
            "repo": repo,
            "description": pkg["description"],
            "homepage": pkg["homepage"],
            "license": pkg["license"],
            "binary": pkg["binary"],
            "version": version,
            "windows": windows,
        }
        bucket = render_bucket(bucket_info)
    else:
        print(f"  [warn] {name}: no Windows assets, skipping Bucket")

    return formula, bucket


def get_sha256_for_asset(url, filename, all_assets, checksum_assets, cache_dir, pkg_name, version, verbose):
    """Get SHA256 for an asset, trying checksum files first, then downloading.

    Returns:
        Hex SHA256 string.
    """
    # Try to find hash from checksum files in the release
    for cksum_asset in checksum_assets:
        cksum_url = cksum_asset["browser_download_url"]
        if verbose:
            print(f"  Trying checksum file: {cksum_asset['name']}")
        try:
            body = http_get(cksum_url)
            content = body.decode("utf-8", errors="replace")
            sha = parse_checksum_file(content, filename)
            if sha:
                if verbose:
                    print(f"  [checksum hit] {filename} = {sha}")
                write_cache(cache_dir, pkg_name, version, filename, sha)
                return sha
        except Exception:
            continue

    # Fallback: download and compute
    if verbose:
        print(f"  Downloading {filename} to compute SHA256...")
    import tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix=f"_{filename}") as tmp:
        tmp_path = tmp.name
        body = http_get(url)
        tmp.write(body)
    try:
        sha = compute_sha256(tmp_path)
        write_cache(cache_dir, pkg_name, version, filename, sha)
        return sha
    finally:
        os.unlink(tmp_path)


def main():
    args = parse_args()

    # Resolve paths relative to script location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_dir = os.path.dirname(script_dir)
    packages_dir = os.path.join(repo_dir, "packages")
    formula_dir = os.path.join(repo_dir, "Formula")
    bucket_dir = os.path.join(repo_dir, "bucket")
    cache_dir = os.path.join(repo_dir, ".cache")

    # Load packages
    pkgs = load_packages(packages_dir, only=args.only or None)
    if not pkgs:
        print("[error] No packages found.")
        sys.exit(1)

    print(f"Processing {len(pkgs)} package(s)...")

    has_warnings = False

    for pkg in pkgs:
        name = pkg["name"]
        print(f"\n[{name}]")

        try:
            formula, bucket = process_package(pkg, cache_dir, verbose=args.verbose)
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_warnings = True
            continue

        if formula is None and bucket is None:
            has_warnings = True
            continue

        if args.dry_run:
            if formula:
                print(f"\n--- Formula/{name}.rb ---")
                print(formula)
            if bucket:
                print(f"\n--- bucket/{name}.json ---")
                print(bucket)
        else:
            if formula:
                os.makedirs(formula_dir, exist_ok=True)
                path = os.path.join(formula_dir, f"{name}.rb")
                with open(path, "w", encoding="utf-8") as f:
                    f.write(formula)
                print(f"  -> Formula/{name}.rb")

            if bucket:
                os.makedirs(bucket_dir, exist_ok=True)
                path = os.path.join(bucket_dir, f"{name}.json")
                with open(path, "w", encoding="utf-8") as f:
                    f.write(bucket)
                print(f"  -> bucket/{name}.json")

    print(f"\nDone. Processed {len(pkgs)} package(s).")
    if has_warnings:
        print("Some packages had warnings (see above).")
        sys.exit(2)


if __name__ == "__main__":
    main()
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd F:/code/tribucket && python -m pytest tests/test_generate.py -v`
Expected: PASS — all 34 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(generate): implement full pipeline — process_package and main orchestration"
```

---

### Task 9: CI Integration

**Files:**
- Modify: `.github/workflows/validate.yml`

- [ ] **Step 1: Add dry-run step to CI**

Add the following step to `.github/workflows/validate.yml` after the existing "Check Bucket hash not empty" step:

```yaml
      - name: Verify generate script (dry-run)
        run: python scripts/generate.py --dry-run --skip-hash
```

- [ ] **Step 2: Verify the YAML is valid**

Run: `python -c "import yaml; yaml.safe_load(open('.github/workflows/validate.yml'))"` (or visually inspect)
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/validate.yml
git commit -m "ci: add generate.py dry-run validation step"
```

---

### Task 10: Update Documentation

**Files:**
- Modify: `README.md`
- Modify: `CONTRIBUTING.md`

- [ ] **Step 1: Update README.md**

In `README.md`, make these changes:

1. Remove the note `> **注意**: Homebrew Formula 和 Scoop Bucket 目前仅覆盖 **ccx**，其余包请使用 Shell 脚本安装。后续会逐步补充。`

2. In the Homebrew section, replace `仅支持 ccx，其余包请使用 Shell 脚本安装。` with a brief note that formulas are auto-generated:
```markdown
所有收录的软件包均有对应的 Homebrew Formula。
```

3. In the Scoop section, replace `仅支持 ccx，其余包请使用 Shell 脚本安装。` with:
```markdown
所有收录的软件包均有对应的 Scoop manifest。
```

4. In the "添加新软件" section, update step 2-3:
```markdown
2. 在 `packages/` 下新建 `<name>.json`，填入 GitHub 仓库和 asset 匹配规则
3. 运行 `python scripts/generate.py --only <name>` 自动生成 Formula 和 Bucket
4. 提交 PR
```

- [ ] **Step 2: Update CONTRIBUTING.md**

Add a section after "添加新软件" step 3:

```markdown
### 自动生成 Formula 和 Bucket

运行生成脚本以从 `packages/*.json` 自动创建 Homebrew Formula 和 Scoop manifest：

```bash
# 生成全部
python scripts/generate.py

# 只生成某个包
python scripts/generate.py --only <name>

# 预览（不写文件）
python scripts/generate.py --dry-run

# 跳过 SHA256 计算（快速迭代模板）
python scripts/generate.py --skip-hash
```

设置 `GITHUB_TOKEN` 环境变量可提升 API 速率限制。
```

- [ ] **Step 3: Commit**

```bash
git add README.md CONTRIBUTING.md
git commit -m "docs: update README and CONTRIBUTING for auto-generated Formula/Bucket"
```

---

### Task 11: Manual Verification

**Files:** None (verification only)

- [ ] **Step 1: Run the generator for a single package in dry-run mode**

Run: `cd F:/code/tribucket && python scripts/generate.py --only ccx --dry-run --verbose`
Expected: Output shows `Formula/ccx.rb` and `bucket/ccx.json` content matching the existing hand-written files (version, URLs, hashes may differ if a new release is out).

- [ ] **Step 2: Run the generator for all packages**

Run: `cd F:/code/tribucket && python scripts/generate.py --verbose`
Expected: All 17 packages processed. Formula/ and bucket/ populated. Some warnings for packages with unusual asset patterns are acceptable.

- [ ] **Step 3: Compare generated ccx.rb with the original hand-written one**

Run: `cd F:/code/tribucket && git diff Formula/ccx.rb`
Expected: Structural similarity. Differences in version/sha256 are expected if a new release was published.

- [ ] **Step 4: Run all tests**

Run: `cd F:/code/tribucket && python -m pytest tests/ -v`
Expected: All tests pass.

- [ ] **Step 5: Verify CI dry-run works locally**

Run: `cd F:/code/tribucket && python scripts/generate.py --dry-run --skip-hash`
Expected: Exits 0, prints template previews without errors.

- [ ] **Step 6: Final commit (if any fixups needed)**

If manual verification revealed issues, fix them and commit:
```bash
git add -A
git commit -m "fix(generate): address issues found during manual verification"
```
