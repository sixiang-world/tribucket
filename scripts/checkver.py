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
