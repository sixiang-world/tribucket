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
