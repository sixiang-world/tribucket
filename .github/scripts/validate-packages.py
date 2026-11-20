"""Offline package and artifact checks shared by GitHub Actions workflows."""

import json
import re
import subprocess
import sys
from pathlib import Path


SHA256 = r"[0-9a-fA-F]{64}"


def valid_hash(value):
    return isinstance(value, str) and re.fullmatch(SHA256, value) is not None


def main():
    errors = []
    for path in sorted(Path("packages").glob("*.json")):
        result = subprocess.run(
            [sys.executable, "-m", "tribucket_gen", "validate", "--offline", str(path)],
            capture_output=True, encoding="utf-8", errors="replace",
        )
        if result.returncode:
            errors.append(f"{path}: {(result.stderr or result.stdout).strip()}")

    for path in sorted(Path("Formula").glob("*.rb")):
        declarations = re.findall(r"^[ \t]*sha256\b(.*)$", path.read_text(encoding="utf-8"), re.M)
        if not declarations or not all(re.fullmatch(rf'\s+"{SHA256}"\s*', line) for line in declarations):
            errors.append(f"{path}: missing or invalid sha256")

    for path in sorted(Path("bucket").glob("*.json")):
        try:
            manifest = json.loads(path.read_text(encoding="utf-8"))
        except ValueError as e:
            errors.append(f"{path}: {e}")
            continue
        architecture = manifest.get("architecture") if isinstance(manifest, dict) else None
        if not isinstance(architecture, dict) or not architecture or not all(
            isinstance(entry, dict) and valid_hash(entry.get("hash"))
            for entry in architecture.values()
        ):
            errors.append(f"{path}: missing or invalid architecture hash")

    for error in errors:
        print(error, file=sys.stderr)
    if errors:
        return 1
    print("Package definitions, Formula hashes, and Bucket manifests passed offline validation.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
