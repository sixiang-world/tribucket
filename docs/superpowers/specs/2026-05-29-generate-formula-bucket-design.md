# Design: Automated Formula & Bucket Generation

**Date**: 2026-05-29
**Status**: Draft
**Author**: brainstorming session

## Problem

tribucket has 17 packages defined in `packages/*.json` with a standardized schema. The shell install scripts (`install.sh`, `install.ps1`, `install.bat`) are fully automated — they read the JSON at runtime and work for all packages. However, Homebrew Formula and Scoop Bucket files are manually maintained and only cover `ccx`. Adding a new package requires hand-writing both files, which is error-prone and doesn't scale.

**Goal**: A single build script that reads `packages/*.json`, fetches the latest release metadata from GitHub, and auto-generates `Formula/*.rb` and `bucket/*.json` for all packages.

## Solution

A Python script `scripts/generate.py` that serves as the single build step to produce all Homebrew and Scoop artifacts from the canonical `packages/*.json` definitions.

## Data Flow

```
packages/*.json  ──→  scripts/generate.py  ──→  Formula/*.rb
    (metadata)              │                    bucket/*.json
                           │
                           ├─ GitHub API  (latest release, version, assets)
                           └─ SHA256SUMS / download  (per-asset hashes)
```

### Step-by-step

1. **Enumerate packages**: Scan `packages/` for all `.json` files. Filter by `--only` if specified.
2. **Fetch release info**: For each package, call `GET https://api.github.com/repos/{owner}/{repo}/releases/latest` to get the version tag and assets list.
3. **Match assets**: Use the `asset_pattern` from the package JSON to match each platform's asset URL via substring or glob.
4. **Compute SHA256** (see SHA256 Strategy below).
5. **Render Formula**: Populate the Homebrew Formula template with version, URLs, and SHA256 hashes. Write to `Formula/<name>.rb`.
6. **Render Bucket**: Populate the Scoop Bucket template with version, URL, hash, and autoupdate config. Write to `bucket/<name>.json`.
7. **Report**: Print a summary of what was generated/updated/skipped/failed.

## CLI Interface

```
python scripts/generate.py [OPTIONS]

Options:
  --only <name>     Generate for a single package only (can repeat)
  --skip-hash       Skip SHA256 computation (reuse existing hashes in output files)
  --dry-run         Print generated content to stdout, don't write files
  --verbose         Print detailed progress (API calls, cache hits, etc.)
```

### Examples

```bash
# Generate all packages
python scripts/generate.py

# Generate only ccx and bat
python scripts/generate.py --only ccx --only bat

# Quick iteration on template changes (no downloads)
python scripts/generate.py --skip-hash

# Preview without writing
python scripts/generate.py --dry-run
```

## Template: Homebrew Formula

```ruby
class {ClassName} < Formula
  desc "{description}"
  homepage "{homepage}"
  version "{version}"
  license "{license}"

  on_macos do
    on_arm do
      url "{darwin_arm64_url}"
      sha256 "{darwin_arm64_sha256}"
    end
    on_intel do
      url "{darwin_amd64_url}"
      sha256 "{darwin_amd64_sha256}"
    end
  end

  on_linux do
    on_arm do
      url "{linux_arm64_url}"
      sha256 "{linux_arm64_sha256}"
    end
    on_intel do
      url "{linux_amd64_url}"
      sha256 "{linux_amd64_sha256}"
    end
  end

  def install
    bin.install Dir["{binary}*"].first => "{binary}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/{binary} --version 2>&1", 1)
  end
end
```

**ClassName derivation**: Capitalize first letter of each hyphen-separated segment, remove hyphens. Examples:
- `ccx` → `Ccx`
- `claude-code` → `ClaudeCode`
- `ripgrep` → `Ripgrep`

**Platform handling**: If a platform has no asset in `asset_pattern`, that `on_*` block is omitted from the formula. At least macOS or Linux must have one asset, otherwise the formula is skipped with a warning.

## Template: Scoop Bucket

```json
{
  "version": "{version}",
  "description": "{description}",
  "homepage": "{homepage}",
  "license": "{license}",
  "architecture": {
    "64bit": {
      "url": "{windows_amd64_url}",
      "hash": "{windows_amd64_sha256}"
    },
    "arm64": {
      "url": "{windows_arm64_url}",
      "hash": "{windows_arm64_sha256}"
    }
  },
  "bin": [["{windows_amd64_asset_filename}", "{binary}"]],
  "checkver": {
    "github": "https://github.com/{repo}"
  },
  "autoupdate": {
    "architecture": {
      "64bit": {
        "url": "https://github.com/{repo}/releases/download/v$version/{windows_amd64_asset_filename}"
      },
      "arm64": {
        "url": "https://github.com/{repo}/releases/download/v$version/{windows_arm64_asset_filename}"
      }
    }
  }
}
```

**`bin` field**: The first element is the filename of the downloaded asset (as it appears in the release). For `.zip` files, this is the archive name; for bare `.exe` files, it's the `.exe` name. The second element is the alias (`binary` from the package JSON).

**`autoupdate.url` derivation**: Take the actual download URL, replace the version segment with `$version`. The script identifies the version segment by matching `v{version}` or `{version}` in the URL path. If it can't determine the pattern, it logs a warning and the autoupdate section may need manual editing.

**Platform filtering**: Only Windows assets (`windows_amd64`, `windows_arm64`) are included. If neither exists, the bucket file is skipped with a warning.

## SHA256 Strategy

Priority order for obtaining SHA256 hashes:

### 1. Checksum file in release assets (preferred)

Check the release's assets for files named:
- `SHA256SUMS`, `sha256sums.txt`, `checksums.txt`
- `<asset-filename>.sha256`

If found, parse the file and extract the hash for the target asset. This requires zero downloads of the actual assets.

### 2. Download and compute (fallback)

If no checksum file exists, download each platform's asset and compute `hashlib.sha256()` locally.

### 3. Cache layer

To avoid re-downloading on repeated runs:
- Cache directory: `.cache/` (gitignored) at the repo root.
- Cache key: `{package-name}/{version}/{asset-filename}.sha256`
- Cache hit: if the `.sha256` file exists and matches the current version, skip download.
- Cache miss: download, compute, write `.sha256` file.

### `--skip-hash` behavior

When `--skip-hash` is passed, the script reads existing SHA256 values from the current `Formula/*.rb` and `bucket/*.json` files (parsing them with regex). If a file doesn't exist yet, the hash is left as `""` (empty) — the CI validation will catch it.

## Error Handling

### GitHub API rate limiting

- Unauthenticated: 60 requests/hour (17 packages = 17 requests, sufficient for most cases).
- If `GITHUB_TOKEN` environment variable is set, use it for 5000 requests/hour.
- On 403 rate limit response: print remaining limit, suggest setting `GITHUB_TOKEN`, exit with code 1.

### Missing platforms

If a platform has no matching asset in the release:
- **Formula**: Omit that `on_*` block. Warn if fewer than 2 platforms are available.
- **Bucket**: Omit that architecture. Warn if neither `windows_amd64` nor `windows_arm64` exists; skip bucket generation for this package.

### Asset pattern mismatch

If the `asset_pattern` for a platform doesn't match any release asset:
- Print error with the expected pattern and the available asset names.
- Skip that platform; continue with others.
- Exit code 2 (partial success) if any package had skipped platforms.

### Network failures

- Retry up to 3 times with exponential backoff for transient HTTP errors (5xx, timeouts).
- Print the failing URL and error message.
- Continue with other packages; report failures at the end.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | All packages generated successfully |
| 1 | Fatal error (API rate limit, no packages found, template error) |
| 2 | Partial success (some packages had warnings or skipped platforms) |

## CI Integration

Add a validation step to `.github/workflows/validate.yml`:

```yaml
- name: Verify generate script (dry-run)
  run: python scripts/generate.py --dry-run --skip-hash
```

This ensures the template rendering logic doesn't break without requiring actual downloads.

## File Changes Summary

| Action | File | Description |
|--------|------|-------------|
| Create | `scripts/generate.py` | The generation script (main deliverable) |
| Modify | `Formula/*.rb` (×17) | Auto-generated formulas for all packages |
| Modify | `bucket/*.json` (×17) | Auto-generated Scoop manifests for all packages |
| Modify | `.gitignore` | Add `.cache/` directory |
| Modify | `.github/workflows/validate.yml` | Add dry-run validation step |
| Modify | `README.md` | Remove "仅支持 ccx" notes, update instructions |
| Modify | `CONTRIBUTING.md` | Document the generate workflow |

## Non-Goals

- **Automated CI publishing**: This script generates files; it does not auto-push to Homebrew taps or Scoop buckets. That's a separate concern.
- **Support for non-GitHub sources**: All current packages are GitHub-hosted. Supporting GitLab, custom registries, etc. is out of scope.
- **Version pinning**: The script always targets the latest release. Users who want older versions can use the shell scripts directly.
