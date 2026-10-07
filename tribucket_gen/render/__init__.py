"""Pluggable render targets.

Each registered renderer takes (pkg, ctx) and returns {relative_path: content}.
Add a new target (winget/AUR/Nix) by writing a module and registering it —
engine and CI need no changes.
"""
from dataclasses import dataclass, field

from . import homebrew, scoop


@dataclass
class Ctx:
    version: str
    repo: str
    platforms: dict            # platform_key -> {url, sha256}
    windows: dict              # arch_key ("64bit"|"arm64") -> {url, hash, filename}
    is_download_url: bool
    changed_version: str = None  # version when changed (download_url write-back), else None
    new_urls: dict = None


RENDERERS = {}


def register(target):
    def deco(fn):
        RENDERERS[target] = fn
        return fn
    return deco


@register("homebrew")
def render_homebrew(pkg, ctx):
    darwin_linux = {k: v for k, v in ctx.platforms.items() if not k.startswith("windows_")}
    if not darwin_linux:
        print(f"  [warn] {pkg['name']}: no macOS/Linux assets, skipping Formula")
        return {}
    info = {
        "name": pkg["name"],
        "description": pkg["description"],
        "homepage": pkg["homepage"],
        "license": pkg["license"],
        "binary": pkg["binary"],
        "version": ctx.version,
        "platforms": darwin_linux,
    }
    return {f"Formula/{pkg['name']}.rb": homebrew.render_formula(info)}


@register("scoop")
def render_scoop(pkg, ctx):
    if not ctx.windows:
        print(f"  [warn] {pkg['name']}: no Windows assets, skipping Bucket")
        return {}
    info = {
        "name": pkg["name"],
        "repo": ctx.repo,
        "description": pkg["description"],
        "homepage": pkg["homepage"],
        "license": pkg["license"],
        "binary": pkg["binary"],
        "version": ctx.version,
        "windows": ctx.windows,
    }
    return {f"bucket/{pkg['name']}.json": scoop.render_bucket(info, is_download_url=ctx.is_download_url)}


def render_all(pkg, ctx, targets=("homebrew", "scoop")):
    outputs = {}
    for t in targets:
        outputs.update(RENDERERS[t](pkg, ctx))
    return outputs
