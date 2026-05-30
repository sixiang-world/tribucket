# checkver & autoupdate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement version detection (checkver) and automatic URL construction (autoupdate) for `download_url` packages, enabling CI to auto-update packages without manual version bumps.

**Architecture:** Extract checkver logic into a separate `scripts/checkver.py` module with clean function interfaces. `generate.py` calls into it during `process_package()`. No external dependencies — a minimal JSONPath parser is included inline. `(?<name>...)` regex syntax from Scoop/PCRE is auto-converted to Python's `(?P<name>...)` for compatibility.

**Tech Stack:** Python 3 stdlib (`re`, `json`, `urllib`), no additional pip packages.

---

## File Structure

| File | Action | Responsibility |
|------|--------|---------------|
| `scripts/checkver.py` | **Create** | Version detection, JSONPath resolution, URL construction |
| `scripts/generate.py` | **Modify** | Call checkver in `process_package()`, update `render_bucket()`, write-back `version` to packages/*.json |
| `tests/test_checkver.py` | **Create** | Unit tests for checkver module |
| `tests/test_generate.py` | **Modify** | Update existing tests that pass through checkver |
| `CONTRIBUTING.md` | **Modify** | Document new checkver/autoupdate fields |

---

### Task 1: Create checkver module — URL version extraction

**Files:**
- Create: `scripts/checkver.py`
- Create: `tests/test_checkver.py`

- [ ] **Step 1: Write tests for `extract_version_from_url`**

```python
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m pytest tests/test_checkver.py -v`
Expected: FAIL with "module 'checkver' has no attribute 'extract_version_from_url'"

- [ ] **Step 3: Implement `extract_version_from_url`**

```python
"""Version detection and automatic URL construction for tribucket packages.

Supports three modes:
  1. Zero-config: auto-extract version from download_url
  2. checkver object: url + jsonpath + regex + replace
  3. checkver "github": GitHub API latest release tag
"""
import json
import os
import re as re_module
import urllib.request


# Match semver-like patterns in URLs: 1.2.3, v1.2.3, 2025.3.0, 21.0.7.1.1
_VERSION_PATTERN = re_module.compile(r'(\d+\.\d+\.\d+(?:[.\-]?[\w]+)?)')


def extract_version_from_url(url):
    """Extract a version string from a download URL.

    Returns the longest match of digits.digits.digits... in the URL,
    or None if no plausible version is found.
    """
    matches = _VERSION_PATTERN.findall(url)
    if not matches:
        return None
    # Pick the longest match — avoids matching partial segments like "21.0"
    return max(matches, key=len)
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m pytest tests/test_checkver.py::TestExtractVersionFromUrl -v`
Expected: all 5 tests PASS

- [ ] **Step 5: Commit**

```bash
git add scripts/checkver.py tests/test_checkver.py
git commit -m "feat(checkver): add extract_version_from_url helper"
```

---

### Task 2: Add JSONPath resolver

**Files:**
- Modify: `scripts/checkver.py`
- Modify: `tests/test_checkver.py`

- [ ] **Step 1: Write tests for `resolve_jsonpath`**

Append to `tests/test_checkver.py`:

```python
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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m pytest tests/test_checkver.py::TestResolveJsonpath -v`
Expected: FAIL

- [ ] **Step 3: Implement `resolve_jsonpath`**

Append to `scripts/checkver.py`:

```python
# Minimal JSONPath tokenizer: splits on .field and [index]
_JSONPATH_TOKEN = re_module.compile(r'\.([a-zA-Z_]\w*)|\[(\d+)\]')


def resolve_jsonpath(data, expr):
    """Resolve a minimal JSONPath expression against `data`.

    Supports a subset of JSONPath:
      $.field          — dict key access
      $.field.sub      — nested dict
      $[0].field       — array index then dict
      $.field[1].sub   — mixed

    Returns the resolved value or None if any step fails.
    """
    if expr.startswith("$"):
        expr = expr[1:]

    current = data

    for field, index in _JSONPATH_TOKEN.findall(expr):
        if field:
            if isinstance(current, dict):
                current = current.get(field)
            else:
                return None
        elif index:
            idx = int(index)
            if isinstance(current, list) and 0 <= idx < len(current):
                current = current[idx]
            else:
                return None
        if current is None:
            return None

    return current
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m pytest tests/test_checkver.py::TestResolveJsonpath -v`
Expected: all 7 tests PASS

- [ ] **Step 5: Commit**

```bash
git add scripts/checkver.py tests/test_checkver.py
git commit -m "feat(checkver): add minimal JSONPath resolver"
```

---

### Task 3: Add regex normalization and checkver runner

**Files:**
- Modify: `scripts/checkver.py`
- Modify: `tests/test_checkver.py`

- [ ] **Step 1: Write tests for `run_checkver`**

Append to `tests/test_checkver.py`:

```python
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
        assert captures["version"] == "21.0.11"  # always set

    def test_jsonpath_then_regex(self, monkeypatch):
        """jsonpath extracts a field, then regex extracts version from it."""
        fake_json = json.dumps({"download_url": "https://cdn.x/zulu21.50.19-ca-jdk21.0.11.tar.gz"})

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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m pytest tests/test_checkver.py::TestRunCheckver -v`
Expected: FAIL

- [ ] **Step 3: Add `http_get` import and implement `run_checkver`**

First, add the import at the top of `scripts/checkver.py`. We need `http_get` from generate.py. To avoid circular imports, define a wrapper:

Append to `scripts/checkver.py`:

```python
# Re-export http_get from generate to avoid duplicating retry/proxy logic.
# Imported lazily to break circular dependency.
_http_get = None


def _get_http():
    global _http_get
    if _http_get is None:
        from generate import http_get as hg
        _http_get = hg
    return _http_get


def http_get(url, token=None, retries=3):
    """Thin wrapper for testability — delegates to generate.http_get."""
    return _get_http()(url, token=token, retries=retries)


def _normalize_regex(pattern):
    """Convert PCRE-style (?<name>...) to Python-style (?P<name>...)."""
    return re_module.sub(r'\(\?<(\w+)>', r'(?P<\1>', pattern)


def run_checkver(pkg):
    """Detect the latest version of a download_url package.

    Args:
        pkg: Package dict from packages/*.json. Must have 'version' and
             'download_url'. May optionally have 'checkver'.

    Returns:
        (version, captures) where:
          - version is the detected version string
          - captures is a dict of {name: value} including at least
            {"version": version} for use in autoupdate templates.
    """
    hardcoded = pkg.get("version", "")

    # ── Zero-config mode: no checkver field ──────────────────────
    if "checkver" not in pkg:
        urls = [v for v in pkg["download_url"].values() if v and v != "NO_MATCH"]
        if urls:
            ver = extract_version_from_url(urls[0])
            if ver:
                return ver, {"version": ver}
        return hardcoded, {"version": hardcoded}

    checkver_cfg = pkg["checkver"]

    # ── "github" shortcut ─────────────────────────────────────────
    if checkver_cfg == "github":
        try:
            repo = pkg.get("repo", "")
            if not repo:
                return hardcoded, {"version": hardcoded}
            url = f"https://api.github.com/repos/{repo}/releases/latest"
            body = http_get(url)
            data = json.loads(body)
            version = data["tag_name"].lstrip("v")
            return version, {"version": version}
        except Exception:
            return hardcoded, {"version": hardcoded}

    # ── Object mode ───────────────────────────────────────────────
    url = checkver_cfg.get("url")
    if not url:
        # Default: use origin page of first valid download_url
        urls = [v for v in pkg["download_url"].values() if v and v != "NO_MATCH"]
        if urls:
            from urllib.parse import urlparse
            parsed = urlparse(urls[0])
            url = f"{parsed.scheme}://{parsed.netloc}"

    # 1. Fetch
    try:
        body = http_get(url)
        content = body.decode("utf-8", errors="replace")
    except Exception as e:
        print(f"  [warn] checkver: failed to fetch {url}: {e}")
        return hardcoded, {"version": hardcoded}

    # 2. JSONPath
    jsonpath_expr = checkver_cfg.get("jsonpath")
    if jsonpath_expr:
        try:
            data = json.loads(content)
            extracted = resolve_jsonpath(data, jsonpath_expr)
            if extracted is None:
                print(f"  [warn] checkver: jsonpath '{jsonpath_expr}' returned null")
                return hardcoded, {"version": hardcoded}
            content = str(extracted)
        except json.JSONDecodeError:
            print("  [warn] checkver: response is not valid JSON, using raw text")

    # 3. Regex
    regex = checkver_cfg.get("regex")
    if not regex:
        return content.strip(), {"version": content.strip()}

    pattern = _normalize_regex(regex)
    match = re_module.search(pattern, content)
    if not match:
        print(f"  [warn] checkver: regex '{regex}' did not match response")
        return hardcoded, {"version": hardcoded}

    captures = match.groupdict()  # named groups: {name: value}

    if not captures:
        # Numbered groups: {1: group1, 2: group2, ...}
        captures = {str(i): g for i, g in enumerate(match.groups(), 1)}

    # 4. Replace template
    replace_tmpl = checkver_cfg.get("replace", "${1}")
    version = replace_tmpl
    for name, value in captures.items():
        version = version.replace(f"${{{name}}}", value)

    captures["version"] = version
    return version, captures
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m pytest tests/test_checkver.py::TestRunCheckver -v`
Expected: all 7 tests PASS

- [ ] **Step 5: Run all checkver tests together**

Run: `python -m pytest tests/test_checkver.py -v`
Expected: all 3 test classes PASS (19 tests total)

- [ ] **Step 6: Commit**

```bash
git add scripts/checkver.py tests/test_checkver.py
git commit -m "feat(checkver): add run_checkver with jsonpath + regex + replace"
```

---

### Task 4: Add autoupdate URL construction

**Files:**
- Modify: `scripts/checkver.py`
- Modify: `tests/test_checkver.py`

- [ ] **Step 1: Write tests for URL construction functions**

Append to `tests/test_checkver.py`:

```python
class TestUrlConstruction:
    def test_in_place_replace(self):
        urls = {
            "linux_amd64": "https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-x64.tar.gz",
            "darwin_arm64": "https://nodejs.org/dist/v22.15.0/node-v22.15.0-darwin-arm64.tar.gz",
            "windows_amd64": "NO_MATCH",
        }
        result = checkver.in_place_replace(urls, "22.15.0", "22.16.0")
        assert "22.16.0" in result["linux_amd64"]
        assert "22.15.0" not in result["linux_amd64"]
        assert "22.16.0" in result["darwin_arm64"]
        assert result["windows_amd64"] == "NO_MATCH"

    def test_in_place_replace_not_found(self):
        urls = {"linux_amd64": "https://x/tool-1.0.tar.gz"}
        result = checkver.in_place_replace(urls, "2.0", "3.0")
        assert result["linux_amd64"] == "https://x/tool-1.0.tar.gz"  # unchanged

    def test_apply_autoupdate_with_version(self):
        urls = {
            "linux_amd64": "https://go.dev/dl/go${version}.linux-amd64.tar.gz",
            "linux_arm64": "https://go.dev/dl/go${version}.linux-arm64.tar.gz",
        }
        result = checkver.apply_autoupdate(urls, "1.25.0", {"version": "1.25.0"})
        assert result["linux_amd64"] == "https://go.dev/dl/go1.25.0.linux-amd64.tar.gz"
        assert result["linux_arm64"] == "https://go.dev/dl/go1.25.0.linux-arm64.tar.gz"

    def test_apply_autoupdate_with_named_captures(self):
        urls = {
            "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu${build}-ca-jdk${ver}-linux_x64.tar.gz",
        }
        captures = {"build": "21.52.17", "ver": "21.0.15", "version": "21.0.15"}
        result = checkver.apply_autoupdate(urls, "21.0.15", captures)
        expected = "https://cdn.azul.com/zulu/bin/zulu21.52.17-ca-jdk21.0.15-linux_x64.tar.gz"
        assert result["linux_amd64"] == expected
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m pytest tests/test_checkver.py::TestUrlConstruction -v`
Expected: FAIL

- [ ] **Step 3: Implement URL construction functions**

Append to `scripts/checkver.py`:

```python
def in_place_replace(download_urls, old_version, new_version):
    """Replace old version string with new version in all URLs.

    Returns a new dict with updated URLs. Prints a warning if the
    old version string is not found in a URL.
    """
    result = {}
    for platform, url in download_urls.items():
        if url == "NO_MATCH" or not url:
            result[platform] = url
            continue
        new_url = url.replace(old_version, new_version)
        if new_url == url:
            print(f"  [warn] in-place replace: old version '{old_version}' "
                  f"not found in {platform} URL, please add autoupdate field")
        result[platform] = new_url
    return result


def apply_autoupdate(autoupdate_tmpl, version, captures):
    """Apply autoupdate templates to construct new download URLs.

    Args:
        autoupdate_tmpl: Dict of platform -> URL template with ${var} placeholders.
        version: The detected version string.
        captures: Dict of variable -> value from checkver (includes 'version').

    Returns:
        Dict of platform -> concrete URL.
    """
    result = {}
    for platform, tmpl in autoupdate_tmpl.items():
        if tmpl == "NO_MATCH" or not tmpl:
            result[platform] = tmpl
            continue
        url = tmpl
        for name, value in captures.items():
            url = url.replace(f"${{{name}}}", value)
        result[platform] = url
    return result
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m pytest tests/test_checkver.py::TestUrlConstruction -v`
Expected: all 4 tests PASS

- [ ] **Step 5: Commit**

```bash
git add scripts/checkver.py tests/test_checkver.py
git commit -m "feat(checkver): add in_place_replace and apply_autoupdate URL construction"
```

---

### Task 5: Integrate checkver into process_package

**Files:**
- Modify: `scripts/generate.py`

- [ ] **Step 1: Add checkver integration to the download_url branch of `process_package`**

Locate the `download_url` branch (line 361-401 in generate.py). Replace the version handling with checkver logic.

**Before** (lines 361-373):
```python
    if "download_url" in pkg:
        # ── Custom download URL path ──────────────────────────────────
        version = pkg.get("version")
        if not version:
            print(f"  [error] {name}: 'download_url' present but 'version' field is missing")
            return None, None

        repo = pkg.get("repo", "")
        download_urls = pkg["download_url"]

        if verbose:
            print(f"  Using custom download URLs (v{version})")
```

**After**:
```python
    if "download_url" in pkg:
        # ── Custom download URL path ──────────────────────────────────
        hardcoded_version = pkg.get("version")
        if not hardcoded_version:
            print(f"  [error] {name}: 'download_url' present but 'version' field is missing")
            return None, None

        repo = pkg.get("repo", "")
        download_urls = pkg["download_url"]

        # 1. Run checkver to detect latest version
        from checkver import run_checkver, apply_autoupdate, in_place_replace
        try:
            latest_version, captures = run_checkver(pkg)
        except Exception as e:
            print(f"  [warn] {name}: checkver error: {e}, using hardcoded version")
            latest_version = hardcoded_version
            captures = {"version": hardcoded_version}

        if latest_version is None:
            latest_version = hardcoded_version
            captures = {"version": hardcoded_version}

        # 2. Construct new URLs if version changed
        if latest_version != hardcoded_version:
            if verbose:
                print(f"  Version: {hardcoded_version} → {latest_version}")

            if "autoupdate" in pkg:
                download_urls = apply_autoupdate(
                    pkg["autoupdate"], latest_version, captures
                )
            else:
                download_urls = in_place_replace(
                    pkg["download_url"], hardcoded_version, latest_version
                )

        version = latest_version

        if verbose:
            print(f"  Using download URLs (v{version})")
```

- [ ] **Step 2: Update `process_package` to return the new version and download_urls for write-back**

Modify the `process_package` function signature and return value. The function currently returns `(formula, bucket)`. Change to return `(formula, bucket, new_version, new_download_urls)` — where `new_version` and `new_download_urls` are `None` if unchanged.

At the end of the download_url branch, before the common rendering section:

```python
        # Track whether version changed for write-back
        version_changed = (latest_version != hardcoded_version)
        new_download_urls_for_writeback = download_urls if version_changed else None
```

And for the GitHub release branch, set these to None:

```python
    else:
        # ── GitHub release API path ───────────────────────────────────
        version_changed = False
        new_download_urls_for_writeback = None
        # ... rest of existing code ...
```

At the return statement (currently `return formula, bucket`), change to:

```python
    return formula, bucket, \
           (latest_version if version_changed else None), \
           new_download_urls_for_writeback
```

- [ ] **Step 3: Update call site in `main()` to handle write-back**

In `main()` (around line 537), after `process_package` returns:

```python
        try:
            formula, bucket, new_version, new_urls = process_package(
                pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose
            )
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_errors = True
            continue

        if formula is None and bucket is None:
            continue

        # Write back updated version to packages/*.json
        if new_version and not args.dry_run:
            pkg_path = os.path.join(packages_dir, f"{name}.json")
            try:
                with open(pkg_path, encoding="utf-8") as f:
                    pkg_data = json.load(f)
                pkg_data["version"] = new_version
                if new_urls:
                    pkg_data["download_url"] = new_urls
                with open(pkg_path, "w", encoding="utf-8") as f:
                    json.dump(pkg_data, f, indent=2, ensure_ascii=False)
                    f.write("\n")
                print(f"  -> packages/{name}.json (version → {new_version})")
            except Exception as e:
                print(f"  [warn] {name}: failed to write back version: {e}")

        # ... existing dry-run and file-writing logic ...
```

- [ ] **Step 4: Run existing tests to check for regressions**

Run: `python -m pytest tests/test_generate.py -v`
Expected: existing tests may fail due to changed return value of `process_package`

- [ ] **Step 5: Update `test_generate.py` tests for new return value**

In `tests/test_generate.py`, find `TestFullPipeline::test_process_package_basic` (line 366). Update the call and assertion:

```python
        formula, bucket, new_version, new_urls = generate.process_package(
            pkg, cache_dir, verbose=False
        )

        assert "class Tool < Formula" in formula
        assert 'version "1.0.0"' in formula
        assert 'sha256 "aaa111"' in formula

        bucket_parsed = json.loads(bucket)
        assert bucket_parsed["version"] == "1.0.0"
        assert bucket_parsed["architecture"]["64bit"]["hash"] == "eee555"

        # GitHub release packages don't trigger write-back
        assert new_version is None
        assert new_urls is None
```

- [ ] **Step 6: Run all tests**

Run: `python -m pytest tests/ -v`
Expected: all tests PASS

- [ ] **Step 7: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat: integrate checkver into process_package with version write-back"
```

---

### Task 6: Update render_bucket for download_url packages

**Files:**
- Modify: `scripts/generate.py`

- [ ] **Step 1: Update `render_bucket` to accept download_url flag**

The current `render_bucket` hardcodes `checkver.github`. For download_url packages, we need different checkver and autoupdate sections.

Modify `render_bucket` to accept an `is_download_url` parameter:

```python
def render_bucket(info, is_download_url=False):
    """Render a Scoop Bucket .json file from package info.

    Args:
        info: Dict with keys: name, repo, description, homepage, license,
              binary, version, windows (dict of arch_key -> {url, hash, filename}).
        is_download_url: If True, use the download_url checkver pattern
                         instead of the default GitHub checkver.
    """
    w = info["windows"]
    repo = info.get("repo", "")

    architecture = {}
    autoupdate_arch = {}

    for arch_key in ("64bit", "arm64"):
        if arch_key in w:
            entry = w[arch_key]
            architecture[arch_key] = {
                "url": entry["url"],
                "hash": entry["hash"],
            }
            if is_download_url:
                autoupdate_arch[arch_key] = {
                    "url": entry["url"],
                }
            else:
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
        "autoupdate": {
            "architecture": autoupdate_arch,
        },
    }

    if is_download_url:
        # Download_url packages: omit checkver since Scoop's PowerShell-based
        # checkver can't be auto-generated from Python regex/jsonpath config.
        # Scoop will use the hardcoded version; users configure checkver manually.
        pass
    else:
        bucket["checkver"] = {
            "github": f"https://github.com/{repo}",
        }

    return json.dumps(bucket, indent=2, ensure_ascii=False) + "\n"
```

- [ ] **Step 2: Update call site in `process_package`**

In the bucket rendering section of `process_package` (~line 470), pass `is_download_url=True` for download_url packages:

```python
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
        bucket = render_bucket(bucket_info, is_download_url=("download_url" in pkg))
```

- [ ] **Step 3: Update `TestBucketRendering` tests**

In `tests/test_generate.py`, update the `TestBucketRendering` class:

```python
class TestBucketRendering:
    def test_render_bucket_basic(self):
        # ... existing test setup ...
        result = generate.render_bucket(info)  # default: GitHub mode
        parsed = json.loads(result)
        assert parsed["checkver"] == {"github": "https://github.com/BenedictKing/ccx"}

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
        result = generate.render_bucket(info, is_download_url=True)
        parsed = json.loads(result)
        # Download_url packages omit checkver (Scoop uses hardcoded version)
        assert "checkver" not in parsed
        assert "autoupdate" in parsed
```

- [ ] **Step 4: Run tests**

Run: `python -m pytest tests/ -v`
Expected: all tests PASS

- [ ] **Step 5: Commit**

```bash
git add scripts/generate.py tests/test_generate.py
git commit -m "feat(bucket): use download_url checkver pattern for non-GitHub packages"
```

---

### Task 7: Integration test — full pipeline with mock

**Files:**
- Modify: `tests/test_generate.py`

- [ ] **Step 1: Add integration test for download_url + checkver path**

Append to `tests/test_generate.py`:

```python
class TestCheckverIntegration:
    def test_download_url_package_with_checkver(self, tmp_path, monkeypatch):
        """Full pipeline: download_url package with checkver detects new version."""
        fake_checkver_response = json.dumps({"version": "2.0.0"})

        def mock_http_get(url, token=None, retries=3):
            if "api.example.com" in url:
                return fake_checkver_response.encode()
            # For SHA256 download, return a small binary
            return b"fake-binary-content"

        monkeypatch.setattr(generate, "http_get", mock_http_get)

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
        formula, bucket, new_version, new_urls = generate.process_package(
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
        def mock_http_get(url, token=None, retries=3):
            return b"fake-binary-content"

        monkeypatch.setattr(generate, "http_get", mock_http_get)

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
        formula, bucket, new_version, new_urls = generate.process_package(
            pkg, cache_dir, verbose=False
        )

        # Version from URL matches hardcoded — no update triggered
        assert 'version "1.24.3"' in formula
        assert new_version is None  # no change
        assert new_urls is None
```

- [ ] **Step 2: Run integration tests**

Run: `python -m pytest tests/test_generate.py::TestCheckverIntegration -v`
Expected: both tests PASS

- [ ] **Step 3: Run full test suite**

Run: `python -m pytest tests/ -v`
Expected: all tests PASS

- [ ] **Step 4: Commit**

```bash
git add tests/test_generate.py
git commit -m "test: add integration tests for checkver pipeline"
```

---

### Task 8: Update documentation

**Files:**
- Modify: `CONTRIBUTING.md`

- [ ] **Step 1: Update the checkver and download_url section in CONTRIBUTING.md**

Replace the existing "自定义下载源" section (around lines 44-73) with the new comprehensive field documentation:

```markdown
**自定义下载源（非 GitHub Release）：**

| 字段 | 必填 | 说明 |
|------|------|------|
| `version` | **是** | 当前软件版本号（`download_url` 存在时必填） |
| `download_url` | 否 | 各平台的下载 URL（见下方说明） |
| `checkver` | 否 | 版本检测配置（与 `download_url` 配合使用） |
| `autoupdate` | 否 | URL 模板（当原地替换版本号不够用时） |

当 `download_url` 存在时，生成器直接使用该 URL 和 `version` 字段，不走 GitHub API。

**零配置（推荐）：**

如果 `download_url` 本身包含版本号，无需任何额外配置，生成器会自动提取：

```json
{
  "version": "1.24.3",
  "download_url": {
    "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
  }
}
```

**checkver 完整配置：**

```json
{
  "version": "21.0.11",
  "download_url": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_x64.tar.gz"
  },
  "checkver": {
    "url": "https://api.azul.com/metadata/v1/zulu/packages/latest",
    "jsonpath": "$.download_url",
    "regex": "zulu(?P<build>[\\d.]+)-ca-jdk(?P<ver>[\\d.]+)",
    "replace": "${ver}"
  },
  "autoupdate": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu${build}-ca-jdk${ver}-linux_x64.tar.gz"
  }
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| `checkver` | string 或 object | `"github"` = 用 repo 的 GitHub API；object = 自定义 |
| `checkver.url` | string | 版本检测 URL（默认：download_url 第一个有效值的 origin） |
| `checkver.jsonpath` | string | JSONPath 表达式，如 `"$[0].version"` |
| `checkver.regex` | string | 正则，支持命名捕获组 `(?P<name>...)` |
| `checkver.replace` | string | 版本号构造模板，默认 `"${1}"` |
| `autoupdate` | object | 各平台 URL 模板，支持 `${version}` 和命名捕获组 `${name}` |

- `download_url` 的 key 与 `asset_pattern` 相同（6 个平台）
- 不支持的平台填 `"NO_MATCH"`
- 如果 URL 中版本号出现多段且需独立替换，请使用 `autoupdate`
- 命名捕获组使用 Python 语法 `(?P<name>...)`
```

- [ ] **Step 2: Commit**

```bash
git add CONTRIBUTING.md
git commit -m "docs: document checkver and autoupdate fields in CONTRIBUTING"
```

---

### Task 9: End-to-end manual verification

**Files:**
- None (verification only)

- [ ] **Step 1: Create a test package with checkver for dry-run verification**

Create `packages/checkver-test.json`:

```json
{
  "name": "checkver-test",
  "repo": "test/checkver-test",
  "version": "1.0.0",
  "description": "Temporary test package for checkver verification",
  "binary": "test",
  "license": "MIT",
  "homepage": "https://example.com",
  "asset_pattern": {
    "linux_amd64": "NO_MATCH",
    "linux_arm64": "NO_MATCH",
    "darwin_amd64": "NO_MATCH",
    "darwin_arm64": "NO_MATCH",
    "windows_amd64": "NO_MATCH",
    "windows_arm64": "NO_MATCH"
  },
  "download_url": {
    "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
  },
  "checkver": {
    "url": "https://go.dev/dl/?mode=json",
    "jsonpath": "$[0].version",
    "regex": "go([\\d.]+)"
  }
}
```

- [ ] **Step 2: Run dry-run to verify checkver works**

```bash
python scripts/generate.py --only checkver-test --dry-run --verbose
```

Expected: prints the latest Go version detected via API, renders Formula and Bucket output

- [ ] **Step 3: Clean up test package**

```bash
rm packages/checkver-test.json
```

- [ ] **Step 4: Verify existing packages still generate correctly**

```bash
python scripts/generate.py --only go --dry-run 2>&1 | head -20
```

Expected: renders Formula with correct version, no errors

- [ ] **Step 5: Commit cleanup**

```bash
git status  # should be clean
```

---

## Verification Checklist

After all tasks are complete:

1. **Unit tests**: `python -m pytest tests/ -v` — all tests pass
2. **Dry run**: `python scripts/generate.py --only go --dry-run` — renders without errors
3. **Zero-config**: A package with `download_url` but no `checkver` auto-extracts version
4. **API checkver**: A package with `checkver.url` + `jsonpath` + `regex` detects latest version
5. **Fallback**: When checkver URL is unreachable, gracefully falls back to hardcoded version
6. **Write-back**: Running with actual download (no `--dry-run`) updates `packages/<name>.json` version
