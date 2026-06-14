# AGENTS.md

## Project Overview

tribucket is a cross-platform package repository providing multiple installation formats from a single source of truth:
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
python3 scripts/generate.py --dry-run          # Preview output without writing
python3 scripts/generate.py --skip-hash        # Skip SHA256 computation
python3 scripts/generate.py --check-assets     # Validate asset patterns
python3 -m pytest tests/ -v                    # Run tests (150 passing)
python3 -m pytest tests/ -v -k "not TestCheckverIntegration"  # Skip known failures
```

### Bun/TypeScript (v2)
```bash
bun install                                     # Install dependencies
bun build src/index.ts --compile --outfile tribucket  # Build binary
bun run src/index.ts --help                    # Run CLI
bun test                                        # Run TypeScript tests (16 passing)
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
├── version.ts            # VERSION constant (single source of truth)
├── commands/             # CLI commands (install, update, check, etc.)
│   ├── install.ts        # Package installation (path validation, symlink, SHA256)
│   ├── update.ts         # Package updates with backup/restore and file lock
│   ├── uninstall.ts      # Remove packages and clean up symlinks/backups
│   ├── check.ts          # Version detection and remote check (concurrent)
│   ├── list.ts           # List tracked packages (--check for version comparison)
│   ├── track.ts          # Track/untrack packages (with findRepoKey)
│   ├── config.ts         # Configuration management (list/get/set/unset)
│   ├── self-update.ts    # Self-update binary (platform-aware asset selection)
│   └── clean.ts          # Remove stale entries and dangling symlinks
├── engine/               # Core logic
│   ├── version.ts        # Version detection (spawnSync for stdout+stderr)
│   ├── mirror.ts         # Multi-provider mirror with TTL cache
│   ├── download.ts       # Download with resume, progress, and timeout
│   └── lock.ts           # Atomic file locking (wx flag) with PID stale check
├── config/               # Configuration management (~/.tribucket/)
│   ├── paths.ts          # Path constants
│   ├── store.ts          # Atomic JSON read/write (tmp + rename)
│   └── cache.ts          # Version and mirror cache
└── utils/                # Utilities
    ├── http.ts           # HTTP client with retry, proxy, and rate limit
    ├── archive.ts        # Archive extraction with zip-slip protection
    ├── sha256.ts         # SHA256 computation (Bun.CryptoHasher) + checksum file matching
    ├── log.ts            # Logging utilities with sym() symbols and NO_COLOR support
    ├── platform.ts       # Platform detection (OS_ARCH format)
    ├── find.ts           # Recursive file search with multi-strategy binary matching
    ├── concurrent.ts     # Concurrent task runner (Python ThreadPoolExecutor equivalent)
    └── cleanup.ts        # Temp directory cleanup
```

### v1 Python Structure
```
lib/tribucket/
├── __init__.py          # Version
├── __main__.py          # python -m tribucket entry
├── cli.py               # argparse CLI (11 commands)
├── config.py            # Path constants, atomic JSON read/write
├── utils.py             # HTTP, SHA256, platform detection, extract_archive
├── track.py             # config.json management (track/untrack/list)
├── check.py             # Version detection (cli→config→fallback chain)
├── mirror.py            # Multi-provider mirror with TTL cache
├── update.py            # Safe update (temp dir relay, backup, file lock)
└── install.py           # First-time install (fetch metadata, download, track)
```

### Key Design Decisions
- **Security**: Always use `execFileSync`/`spawnSync` (not `execSync`) to prevent command injection
- **Path validation**: Block installation to system directories (`/`, `/usr`, `/bin`, `/etc`, `/var`, `/tmp`)
- **Path traversal**: Use `realpathSync` to resolve symlinks before validation (matching Python v1)
- **Config**: `~/.tribucket/config.json` with atomic writes (tmp + rename), corruption warning to stderr
- **Mirror**: Multi-provider with TTL cache, auto-probe, fallback chain
- **Version detection**: Priority chain: `binary --version` → `config.json` → `tributable.json` → `"unknown"`
- **Archive security**: Recursive zip-slip validation for all archive types; single top-level dir unwrapped
- **File locking**: Atomic lock creation via `wx` flag with PID stale-process detection
- **Backup safety**: Remove stale backup dir before `cpSync` to prevent nesting errors
- **Config key lookup**: Use `findRepoKey()` to handle packages tracked under `owner/repo` keys
- **Concurrent operations**: `concurrentMap()` utility with configurable worker count (matches Python `ThreadPoolExecutor`)
- **NO_COLOR support**: `sym()` utility provides Unicode symbols with automatic ASCII fallback

## CLI Commands

### install
```bash
tribucket install <name> [--dir <path>] [--link] [--force] [--mirror <mode>]
```
- `--dir`: Install directory (default: cwd)
- `--link`: Create symlink in `~/.tribucket/bin/`
- `--force`: Overwrite existing installation
- `--mirror`: Mirror mode (`auto`, `cn`, `direct`)

### update
```bash
tribucket update [name] [--all] [--force] [--dry-run] [--mirror <mode>] [--no-backup]
```
- `--all`: Update all tracked packages (concurrent with 4 workers)
- `--force`: Force re-download
- `--dry-run`: Show what would be updated
- `--mirror`: Mirror mode
- `--no-backup`: Skip backup before update

### check
```bash
tribucket check [targets...] [--all] [--refresh] [--local-only] [--json]
```
- `--all`: Check all tracked packages (concurrent with 4 workers)
- `--refresh`: Force remote version check (bypass cache)
- `--local-only`: Skip remote check
- `--json`: JSON output

### list
```bash
tribucket list [--json] [--sort <key>] [--check]
```
- `--json`: JSON output
- `--sort`: Sort by `name` (default) or `status`
- `--check`: Run version detection for all packages

### track / untrack
```bash
tribucket track <name> [path]
tribucket untrack <name>
```

### info
```bash
tribucket info <name>
```

### config
```bash
tribucket config [list|get|set|unset] [key] [value]
```

### self-update
```bash
tribucket self-update
```

### clean
```bash
tribucket clean
```
Removes stale entries and dangling symlinks.

### uninstall
```bash
tribucket uninstall <name>
```
Remove a tracked package: deletes the install directory, symlinks, backups, and untracks the entry.

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

### Package Modes

**GitHub Release** — uses `repo` + `asset_pattern` to match release assets.

**Custom Download URL** — uses `download_url` + `version` fields for non-GitHub sources.

**Portable Package** — `portable/<name>/` contains `tribucket.json`, `install.sh`, `cmd/tribucket-update.bat`. Generated by `generate.py --portable`.

## Testing

### Python Tests
```bash
python3 -m pytest tests/ -v                      # Run all (150 passing)
python3 -m pytest tests/test_generate.py -v      # Generator tests (67)
python3 -m pytest tests/test_tribucket.py -v     # Engine tests (25)
python3 -m pytest tests/test_integration.py -v   # Integration tests (18)
python3 -m pytest tests/test_checkver.py -v      # Version detection (14)
```

Tests use `pytest` with `monkeypatch` for HTTP mocking and `tmp_path` fixtures.

### TypeScript Tests
```bash
bun test                                          # Run all (16 passing)
bun test src/__tests__/utils.test.ts              # Utility tests
bun test src/__tests__/config.test.ts             # Config tests
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `GITHUB_TOKEN` | Increase API rate limit (5000 req/hr vs 60) |
| `TRIBUCKET_HOME` | Override config directory (default: `~/.tribucket`) |
| `TRIBUCKET_VERBOSE` | Enable debug logging (`1` to enable) |
| `NO_COLOR` | Disable colored output |
| `HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` | Proxy configuration |

## Platform Keys

Use these in `asset_pattern` and `download_url`:
- `linux_amd64`, `linux_arm64`
- `darwin_amd64`, `darwin_arm64`
- `windows_amd64`, `windows_arm64`
- Value `"NO_MATCH"` means unsupported on that platform

## Key Scripts

- `scripts/generate.py` — main generator (templates, hashing, API calls, portable output)
- `scripts/checkver.py` — version detection for custom download sources
- `scripts/bootstrap.sh` — CLI bootstrap installer (curl | bash)
