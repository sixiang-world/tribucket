#!/usr/bin/env python3
"""Delegation shim — the implementation moved to tribucket_gen/checkver.py.

This module replaces itself in sys.modules with tribucket_gen.checkver, so
`import checkver` (e.g. from tests) transparently yields the real
implementation module. That keeps attribute patching such as
monkeypatch.setattr(checkver, "http_get", ...) working against the functions
that actually run, with zero changes for existing importers.
"""
import os as _os
import sys as _sys

_sys.path.insert(0, _os.path.dirname(_os.path.dirname(_os.path.abspath(__file__))))

import tribucket_gen.checkver as _impl

# Swap this shim module for the real implementation module.
_sys.modules[__name__] = _impl
