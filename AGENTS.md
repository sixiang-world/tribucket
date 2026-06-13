# AGENTS.md

## Project Overview

tribucket is a cross-platform package repository with two implementations:
- **v1 (Python)**: `lib/tribucket/` — original CLI engine
- **v2 (Bun/TypeScript)**: `src/` — complete rewrite, single binary via `bun build --compile`

Both generate from `packages/*.json` (single source of truth) → `Formula/*.rb` + `bucket/*.json` + `portable/<name>/`.

## Critical Rules

1. **Never edit** `Formula/*.rb`, `bucket/*.json`, or `portable/<name>/` directly — they're auto-generated
2. All package changes go into `packages/*.json`, then run `python3 scripts/generate.py`
3. Set `GITHUB_TOKEN` for higher API rate limits (5000 req/hr vs 60)

## Quick Commands

### Python (v1)
```bash
python3 scripts/generate.py                    # Generate all Formula + Bucket
python3 scripts/generate.py --only <name>      # Single package
python3 scripts/generate.py --portable         # Generate portable templates
python3 -m pytest tests/ -v                    # Run tests (152 passing)
python3 -m pytest tests/ -v -k "not TestCheckverIntegration"  # Skip known failures
```

### Bun/TypeScript (v2)
```bash
bun install                                     # Install dependencies
bun build src/index.ts --compile --outfile tribucket  # Build binary
bun run src/index.ts --help                    # Run CLI
```

## Architecture

### Data Flow
```
packages/*.json  →  scripts/generate.py  →  Formula/*.rb (Homebrew)
                                          →  bucket/*.json (Scoop)
                                          →  portable/<name>/ (portable templates)
```

### v2 TypeScript Structure
```
src/
├── index.ts              # CLI entry point (Commander.js)
├── types.ts              # Shared TypeScript interfaces
├── commands/             # CLI commands (install, update, check, etc.)
├── engine/               # Core logic (version detection, mirror, download, lock)
├── config/               # Configuration management (~/.tribucket/)
└── utils/                # Utilities (HTTP, SHA256, archive extraction)
```

### Key Design Decisions
- **Security**: Always use `execFileSync` (not `execSync`) to prevent command injection
- **Path validation**: Block installation to system directories (`/`, `/usr`, `/bin`, `/etc`, `/var`, `/tmp`)
- **Config**: `~/.tribucket/config.json` with atomic writes (tmp + rename)
- **Mirror**: Multi-provider with TTL cache, auto-probe, fallback chain
- **Version detection**: Priority chain: `binary --version` → `config.json` → `tributable.json` → `"unknown"`

## Adding a Package

1. Create `packages/<name>.json` with required fields:
   ```json
   {
     "name": "package-name",
     "repo": "owner/repo",
     "description": "Package description",
     "binary": "binary-name",
     "license": "MIT",
     "homepage": "https://github.com/owner/repo",
     "asset_pattern": {
       "linux_amd64": "pattern-*_linux_amd64",
       "darwin_arm64": "pattern-*_darwin_arm64",
       "windows_amd64": "pattern-*_windows_amd64.exe"
     }
   }
   ```
2. Run `python3 scripts/generate.py --only <name>`
3. Run `python3 -m pytest tests/ -v`
4. Commit with conventional format (feat/fix/chore/docs/test/ci)

## Testing

```bash
# Python tests
python3 -m pytest tests/ -v

# Specific test files
python3 -m pytest tests/test_generate.py -v   # Generator tests (67)
python3 -m pytest tests/test_tribucket.py -v   # Engine tests (25)
python3 -m pytest tests/test_integration.py -v # Integration tests (18)
```

Tests use `pytest` with `monkeypatch` for HTTP mocking and `tmp_path` fixtures.

## Bun/TypeScript Development

```bash
# Install dependencies
bun install

# Run in development mode
bun run src/index.ts --help

# Build binary
bun build src/index.ts --compile --outfile tribucket

# Test installation
./tribucket install ccx --dir ~/tools
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `GITHUB_TOKEN` | Increase API rate limit |
| `TRIBUCKET_HOME` | Override config directory (default: `~/.tribucket`) |
| `TRIBUCKET_VERBOSE` | Enable debug logging (`1` to enable) |

## Platform Keys

Use these in `asset_pattern` and `download_url`:
- `linux_amd64`, `linux_arm64`
- `darwin_amd64`, `darwin_arm64`
- `windows_amd64`, `windows_arm64`
- Value `"NO_MATCH"` means unsupported on that platform
