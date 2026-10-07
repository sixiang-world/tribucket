"""CLI entry: python -m tribucket_gen <command>."""
import argparse
import sys

from . import __version__


def build_parser():
    p = argparse.ArgumentParser(prog="tribucket_gen", description="tribucket generator engine")
    p.add_argument("--version", action="version", version=__version__)
    return p


def main(argv=None):
    args = build_parser().parse_args(argv)
    return 0


if __name__ == "__main__":
    sys.exit(main())
