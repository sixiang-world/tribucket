"""Generators for various package manager formats."""

from .homebrew import generate_homebrew
from .scoop import generate_scoop
from .shell import generate_shell

__all__ = ["generate_homebrew", "generate_scoop", "generate_shell"]