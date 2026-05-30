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
