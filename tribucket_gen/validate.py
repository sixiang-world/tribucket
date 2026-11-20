"""Validate packages/*.json definitions (schema + online asset resolution)."""
import re
from pathlib import Path

NAME_RE = re.compile(r"^[A-Za-z][A-Za-z0-9-]*$")
REPO_RE = re.compile(r"^[\w.-]+/[\w.-]+$")

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]
REQUIRED_FIELDS = ["name", "repo", "description", "binary", "license", "homepage"]
STRING_FIELDS = ["name", "repo", "description", "binary", "license", "homepage"]
MIN_MATCHED_PLATFORMS = 2


def validate_definition(pkg, packages_dir=None, fetch_release=None, token=None, *, definition_path=None):
    """Return (errors, warnings). fetch_release(repo) -> (version, assets, checksums)."""
    errors, warnings = [], []
    if not isinstance(pkg, dict):
        return ["definition is not a JSON object"], []

    for f in REQUIRED_FIELDS:
        if not pkg.get(f):
            errors.append(f"missing required field: {f}")

    name = pkg.get("name", "") or ""
    valid_name = isinstance(name, str) and NAME_RE.fullmatch(name)
    if name and not valid_name:
        errors.append(f"invalid name {name!r}: must match {NAME_RE.pattern}")

    repo = pkg.get("repo", "") or ""
    if repo and (not isinstance(repo, str) or not REPO_RE.fullmatch(repo)):
        errors.append(f"invalid repo {repo!r}: expected owner/repo")

    for f in STRING_FIELDS:
        v = pkg.get(f)
        if v and not isinstance(v, str):
            errors.append(f"field {f!r} must be a string")
        elif isinstance(v, str) and (re.search(r"[\x00-\x1f\x7f]", v) or '"' in v or "#{" in v):
            errors.append(
                f"field {f!r} contains forbidden characters (control chars, double quotes, or Ruby interpolation)"
            )

    ap = pkg.get("asset_pattern")
    if not isinstance(ap, dict):
        errors.append("asset_pattern must be an object")
    else:
        for k in PLATFORM_KEYS:
            if k not in ap:
                errors.append(f"asset_pattern missing platform key: {k}")
        for k, pattern in ap.items():
            if k not in PLATFORM_KEYS:
                errors.append(f"unknown platform key: {k}")
            if not isinstance(pattern, str) or not pattern:
                errors.append(f"asset_pattern[{k}] must be a non-empty string")

    if packages_dir and valid_name:
        directory = Path(packages_dir).resolve()
        source = Path(definition_path).resolve() if definition_path else None
        filename = f"{name}.json"
        if source and source.parent == directory and source.name != filename:
            errors.append(f"definition filename must be {filename!r}")
        if directory.is_dir() and any(
            path.name.casefold() == filename.casefold() and path != source
            for path in directory.iterdir()
        ):
            errors.append(f"package {name!r} already exists in packages/")

    if not errors and fetch_release is not None:
        try:
            _, assets, _ = fetch_release(repo)
        except Exception as e:
            warnings.append(f"could not fetch release for {repo}: {e}")
            return errors, warnings
        from .assets import match_asset
        matched = 0
        for k in PLATFORM_KEYS:
            pat = ap.get(k)
            if not pat or pat == "NO_MATCH":
                continue
            if match_asset(assets, pat):
                matched += 1
            else:
                errors.append(f"asset_pattern[{k}] {pat!r} matches no asset in latest release")
        if matched < MIN_MATCHED_PLATFORMS:
            errors.append(
                f"only {matched} platform(s) match — package would produce zero or near-zero output"
            )
    return errors, warnings
