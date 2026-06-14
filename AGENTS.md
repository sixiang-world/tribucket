# AGENTS.md

## Project Overview

tribucket is a cross-platform package repository. The **Bun/TypeScript (v2)** version is the active CLI — compiled to a single binary via `bun build --compile`.

- **v2 (Bun/TypeScript)**: `src/` — complete CLI, single binary, no runtime deps
- **v1 (Python)**: Archived at `archive/python-v1/` — historical reference only

Package definitions live in `packages/*.json` (single source of truth) and generate `Formula/*.rb` + `bucket/*.json`.

## Critical Rules

1. **Never edit** `Formula/*.rb` or `bucket/*.json` directly — they're auto-generated  
2. All package changes go into `packages/*.json`  
3. Set `GITHUB_TOKEN` for higher API rate limits (5000 req/hr vs 60)  
4. Set `HTTPS_PROXY` / `ALL_PROXY` for GitHub downloads from China (e.g., `http://127.0.0.1:7897`)

## Quick Commands

```bash
bun install                                     # Install dependencies
bun build src/index.ts --compile --outfile tribucket  # Build binary
bun run src/index.ts --help                    # Run CLI
bun test                                        # Run TypeScript tests (16 passing)
cp tribucket ~/.tribucket/bin/tribucket         # Install binary
```

## Architecture

### Data Flow
```
packages/*.json  →  [generator]  →  Formula/*.rb (Homebrew)
                                →  bucket/*.json (Scoop)
```

### TypeScript Source Structure
```
src/
├── index.ts              # CLI entry point (Commander.js)
├── types.ts              # Shared TypeScript interfaces
├── version.ts            # VERSION constant
├── commands/             # CLI commands
│   ├── install.ts        # Package installation
│   ├── update.ts         # Package updates
│   ├── uninstall.ts      # Remove packages
│   ├── check.ts          # Version detection
│   ├── list.ts           # List tracked packages
│   ├── track.ts          # Track/untrack packages
│   ├── config.ts         # Configuration management
│   ├── self-update.ts    # Self-update binary
│   └── clean.ts          # Clean stale entries
├── engine/               # Core logic
│   ├── version.ts        # Version detection (spawnSync)
│   ├── mirror.ts         # Multi-provider mirror with TTL cache
│   ├── download.ts       # Download with resume, progress, proxy support
│   └── lock.ts           # Atomic file locking
├── config/               # Configuration (~/.tribucket/)
│   ├── paths.ts          # Path constants
│   ├── store.ts          # Atomic JSON read/write
│   └── cache.ts          # Version and mirror cache
└── utils/                # Utilities
    ├── http.ts           # HTTP client with retry, proxy, rate limit
    ├── archive.ts        # Archive extraction with zip-slip protection
    ├── sha256.ts         # SHA256 computation (fs-based, works in compiled binary)
    ├── log.ts            # Logging with symbols and NO_COLOR support
    ├── platform.ts       # Platform detection (OS_ARCH format)
    ├── find.ts           # Recursive file search for binary matching
    ├── concurrent.ts     # Concurrent task runner
    └── cleanup.ts        # Temp directory cleanup
```

### Key Design Decisions
- **Security**: Block system directories (`/`, `/usr`, `/bin`, `/etc`, `/var`, `/tmp`)
- **Path traversal**: `realpathSync` to resolve symlinks before validation
- **Config**: `~/.tribucket/config.json` with atomic writes (tmp + rename)
- **Mirror**: Multi-provider with TTL cache, auto-probe, fallback chain
- **Version detection**: Priority: `binary --version` → `config.json` → `tributable.json` → `"unknown"`
- **Archive security**: Recursive zip-slip validation; single top-level dir unwrapped
- **File locking**: Atomic lock via `wx` flag with PID stale-process detection
- **Proxy**: Supports `HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` env vars for all HTTP(S) requests and downloads (uses Bun's native `proxy` option)
- **NO_COLOR support**: `sym()` utility with automatic ASCII fallback
- **SHA256**: Uses `fs.readSync` in chunks with `Bun.CryptoHasher` (not `Bun.CryptoHasher.hash(Bun.file(...))` which fails in compiled binaries)

## Known Gotchas

1. **SHA256 in compiled binaries**: `Bun.CryptoHasher.hash('sha256', Bun.file(path))` throws "File blob cannot be used here" in compiled mode. Must use `new Bun.CryptoHasher('sha256')` with manual `fs.readSync` + `hasher.update()` in chunks.

2. **Proxy for downloads**: `engine/download.ts` and `utils/http.ts` both read `HTTPS_PROXY` / `ALL_PROXY` env vars. Without a proxy, GitHub release downloads time out from China.

3. **Raw binary downloads**: When a downloaded file is a raw binary (not tar.gz/zip), install.ts copies it to the extract dir using the package's `binary` name (not hardcoded `'binary'`). This ensures `findBinary()` can find it.

4. **non-empty directory**: If a target dir exists and is non-empty, the install refuses unless `--force` is used.

## CLI Commands

### install
```bash
tribucket install <name> [--dir <path>] [--link] [--force] [--mirror <mode>]
```
- `--dir`: Install directory (default: cwd)
- `--link`: Create symlink in `~/.tribucket/bin/`
- `--force`: Overwrite existing installation (bypasses non-empty dir check)
- `--mirror`: Mirror mode (`auto`, `cn`, `direct`)

### update
```bash
tribucket update [name] [--all] [--force] [--dry-run] [--mirror <mode>] [--no-backup]
```
- `--all`: Update all tracked packages (concurrent)
- `--force`: Force re-download
- `--dry-run`: Show what would be updated

### check
```bash
tribucket check [targets...] [--all] [--refresh] [--local-only] [--json]
```

### list
```bash
tribucket list [--json] [--sort <key>] [--check]
```

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

### uninstall
```bash
tribucket uninstall <name>
```

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
2. Run the generator (see scripts/generate.py in archive)
3. Commit with conventional format

## Testing

```bash
bun test                                          # TypeScript tests
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
| `HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` | Proxy configuration (used by all HTTP requests and downloads) |

## Platform Keys

Use these in `asset_pattern`:
- `linux_amd64`, `linux_arm64`
- `darwin_amd64`, `darwin_arm64`
- `windows_amd64`, `windows_arm64`
- Value `"NO_MATCH"` means unsupported on that platform
