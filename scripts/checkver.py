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
_VERSION_PATTERN = re_module.compile(r'(\d+\.\d+\.\d+(?:\.\d+)*)')


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
    else:
        expr = "." + expr  # "version" → ".version" so the tokenizer can match

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

    # Zero-config mode: no checkver field
    if "checkver" not in pkg:
        urls = [v for v in pkg["download_url"].values() if v and v != "NO_MATCH"]
        if urls:
            ver = extract_version_from_url(urls[0])
            if ver:
                return ver, {"version": ver}
        return hardcoded, {"version": hardcoded}

    checkver_cfg = pkg["checkver"]

    # "github" shortcut
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

    # Object mode
    url = checkver_cfg.get("url")
    if not url:
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
