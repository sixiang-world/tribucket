# AGENTS.md

## Project Overview

tribucket is a cross-platform package repository. The **Bun/TypeScript (v2)** version is the active CLI — compiled to a single binary via `bun build --compile`.

- **v2 (Bun/TypeScript)**: `src/` — complete CLI, single binary, no runtime deps
- **Generator (Python)**: `scripts/generate.py` — build tool that turns `packages/*.json` into `Formula/*.rb` (Homebrew) + `bucket/*.json` (Scoop). Self-contained (stdlib only). Run by CI on `packages/**` changes and after each release.
- **v1 (Python CLI)**: Archived at `archive/python-v1/` — historical reference only (the CLI migrated to Bun; the generator stays Python)

Package definitions live in `packages/*.json` (single source of truth) and generate `Formula/*.rb` + `bucket/*.json`.

## Critical Rules

1. **Never edit** `Formula/*.rb` or `bucket/*.json` directly — they're auto-generated  
2. All package changes go into `packages/*.json`  
3. Set `GITHUB_TOKEN` for higher API rate limits (5000 req/hr vs 60)  
4. Set `HTTPS_PROXY` / `ALL_PROXY` for GitHub downloads from China (e.g., `http://127.0.0.1:7897`)
5. **Never edit** `dist/*` directly — it is the build output of `website/build.ts` (gitignored). Edit `website/templates/index.html` + `website/build.ts` and rebuild
6. **Never edit** `functions/*` directly unless you know what you're doing — they are EdgeOne Pages Edge Functions that serve data from EdgeOne KV (see Edge Functions section below)
7. **Changelog lives in `CHANGELOG.md`** (not README). The website builder parses `## vX.Y.Z` headings from it

## Quick Commands

```bash
bun install                                     # Install dependencies
bun build src/index.ts --compile --outfile tribucket  # Build binary
bun run src/index.ts --help                    # Run CLI
bun test                                        # Run TypeScript tests (21 passing)
npm run build:web                              # Build static website → dist/ (Bun script)
python scripts/generate.py --only <name>        # Regenerate Formula/bucket for a package
cp tribucket ~/.tribucket/bin/tribucket         # Install binary
```

## Architecture

### Data Flow
```
packages/*.json  →  [generator]  →  Formula/*.rb (Homebrew)
                                →  bucket/*.json (Scoop)
                                        ↓
              [kv-sync.py] (CI)          ↓
                    ┌────────────────────┘
                    ↓  POST /admin/sync
              EdgeOne KV  ───────────────────────┐
              (p_<name>, f_<name>, b_<name>,      │
               tri_packages_idx)                      │
                    ↑                             │
              [Edge Functions]                    │
              (functions/  directory)              │
                    │                             │
  ┌───────────────┼───────────────┐               │
  │               │               │               │
  ↓               ↓               ↓               ↓
/api/packages  /packages/      /bucket/        /Formula/
.json           <name>.json    <name>.json     <name>.rb
  │               │               │               │
  │               │               │               │
  └── website     └── CLI         └── CLI         └── Homebrew
      JS fetch        install         check           tap
                      pkg def         version

[website/build.ts]  →  dist/  (deployed to tribucket.hunluan.space)
                         ├── index.html + styles/
                         └── (no packages/Formula/bucket — served via KV)

CLI software source priority (unchanged):
  tribucket.hunluan.space  →  GitHub (raw / API)
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
    ├── http.ts           # HTTP client with retry (5x, jittered backoff), proxy, rate limit
    ├── locale.ts         # Minimal i18n: auto-detect language, t(key, vars) for localized strings
    ├── archive.ts        # Archive extraction with zip-slip protection (no --no-absolute-names)
    ├── sha256.ts         # SHA256 computation (fs-based, works in compiled binary)
    ├── log.ts            # Logging: verbose `log()`, always-visible `status()`, `error()`, symbols + NO_COLOR
    ├── platform.ts       # Platform detection + resolveBinaryPath/binaryFileName (.exe handling)
    ├── find.ts           # Recursive file search for binary matching
    ├── software-source.ts # Software source priority: tribucket.hunluan.space → GitHub
    ├── concurrent.ts     # Concurrent task runner
    └── cleanup.ts        # Temp directory cleanup
```

### Static Website (tribucket.hunluan.space)

```
website/
├── build.ts                # Bun build script: reads VERSION + CHANGELOG.md,
│                           #   injects into template, outputs dist/
├── templates/
│   └── index.html          # HTML template with {{VERSION}}/{{PACKAGES_JSON}}/{{CHANGELOG}} placeholders
└── styles/
    └── main.css            # Clean tech-doc style (responsive, NO_COLOR-friendly)

dist/                       # Build output (gitignored, deployed to EdgeOne)
├── index.html              # Landing page (hero + install tabs + searchable package list + CLI ref + changelog)
└── styles/main.css
# Note: packages/Formula/bucket are NOT in dist/ — they are served at runtime
#       from EdgeOne KV via Edge Functions (see functions/ directory below).

functions/                  # EdgeOne Pages Edge Functions (committed, auto-detected)
├── api/
│   └── packages.js         # GET /api/packages.json  — returns package index from KV
├── packages/
│   └── [[default]].js      # GET /packages/<n>.json  — serves package JSON from KV
├── Formula/
│   └── [[default]].js      # GET /Formula/<n>.rb     — serves Formula text from KV
├── bucket/
│   └── [[default]].js      # GET /bucket/<n>.json   — serves bucket JSON from KV
└── admin/
    └── sync.js             # POST /admin/sync        — writes batch data to KV (auth required)

KV key mapping (all keys prefixed with `tri_` to avoid collisions):
  tri_packages_idx  →  full package index JSON array  ←─ /api/packages.json
  tri_p_<name>      →  package definition JSON        ←─ /packages/<name>.json
  tri_f_<name>      →  Formula .rb text               ←─ /Formula/<name>.rb
  tri_b_<name>      →  bucket JSON                    ←─ /bucket/<name>.json
  (hyphens in <name> are converted to underscores for KV key compatibility)

edgeone.json                # EdgeOne edge-deploy config (build command, output dir, cache + security headers)

scripts/
└── kv-sync.py              # CI script: reads local packages/Formula/bucket, POSTs to /admin/sync
```

- **Build flow**: `npm run build:web` → `website/build.ts` → wipes `dist/`, reads `src/version.ts` for VERSION, parses `CHANGELOG.md` (`## vX.Y.Z` entries, H1 filtered out, `**bold**` → `<strong>`), injects into template, copies `styles/` to `dist/`. **No packages/Formula/bucket copy** — those are served at runtime from EdgeOne KV.
- **No framework**: pure static HTML/CSS/JS. Package list is fetched from `/api/packages.json` at page load; search filtering is client-side JS in `index.html`.
- **Template placeholders**: `{{VERSION}}`, `{{PACKAGES_JSON}}`, `{{CHANGELOG}}` — replaced verbatim by `build.ts`. Note: `{{PACKAGES_JSON}}` is injected as `[]` (empty) at build time; the real data comes from the runtime API fetch.
- **Changelog parser**: splits on `\n## `, filters chunks whose first line doesn't start with a version (`/^v?\d/i`) — this drops the `# 更新日志` H1 and any non-version sections.
- **KV sync**: When packages/Formula/bucket change, the CI pipeline runs `scripts/kv-sync.py` which POSTs all data to the protected `/admin/sync` endpoint. The Edge Function verifies the Bearer token (from `ADMIN_SYNC_KEY` env var) and writes to KV. The `tri_packages_idx` key is written last so readers never see a partially-updated index.

### Key Design Decisions
- **Security**: Block system directories (`/`, `/usr`, `/bin`, `/etc`, `/var`, `/tmp`)
- **Path traversal**: `realpathSync` to resolve symlinks before validation
- **Config**: `~/.tribucket/config.json` with atomic writes (tmp + rename)
- **Mirror**: Multi-provider with TTL cache, auto-probe, fallback chain. Provider templates use `{tag}` (raw release tag_name, verbatim) — never inject a `v` prefix, since tags are project-specific (`v1.2.3`, `jq-1.8.1`, `15.1.0`). Legacy `{version}` (tag with a single leading `v` stripped) is supported for backward compat.
- **Asset resolution** (`mirror.resolveAssetName`): `asset_pattern` values are matched against the real GitHub release asset list — literal exact match → glob (`*`) → pure-suffix match. This handles both glob patterns (`fzf-*-windows_amd64.zip`) and bare platform tails (`x86_64-pc-windows-msvc.zip`).
- **Version detection** (`engine/version.detectVersion`): Priority: `binary --version` (with bounded retry, X_OK check skipped on Windows) → `config.json` → `tributable.json` → `"unknown"`.
- **Version comparison** (`engine/version.versionFromTag`): extracts a comparable version core (`major.minor[.patch]`) from any tag, so local-vs-remote comparison works for project-specific tag formats. Cached remote versions are normalized on read so stale pre-fix values self-heal.
- **Windows binary paths** (`utils/platform.resolveBinaryPath`/`binaryFileName`): the `binary` field is the bare name (e.g. `rg`); on Windows we append `.exe` both when probing (`resolveBinaryPath`) and when installing/copying (`binaryFileName`).
- **Archive security**: Recursive zip-slip validation (post-extraction validator); single top-level dir unwrapped. We do NOT pass `--no-absolute-names` to tar (it is not supported by GNU tar and crashed Linux extraction).
- **File locking**: Atomic lock via `wx` flag with PID stale-process detection
- **Proxy**: Supports `HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` env vars for all HTTP(S) requests and downloads (uses Bun's native `proxy` option)
- **NO_COLOR support**: `sym()` utility with automatic ASCII fallback
- **Status output** (`utils/log.ts`): `status(msg)` prints always (to stderr, with `→` prefix); `log(msg)` is verbose-only (`TRIBUCKET_VERBOSE=1`). Use `status()` for user-visible step-by-step progress (install/update flow); `log()` for debug diagnostics.
- **i18n** (`utils/locale.ts`): Minimal localization system. Detects system language via `LANG`/`LC_ALL`/`LC_MESSAGES`/`LANGUAGE` env vars (falls back to English). Supports `TRIBUCKET_LANG=en|zh` to force a language. All user-visible strings use `t(key, vars)` from locale.ts — never hardcode English in command files. The translation table covers ~80 entries covering all CLI output.
- **Network error details** (`utils/http.ts`): On retry, `status()` shows the error code (e.g. `ECONNREFUSED`, `ETIMEDOUT`); full error details (message + cause) are logged to the verbose channel (`TRIBUCKET_VERBOSE=1`). Supports `silent` option — when `true`, retries only write to `log()` not `status()` (used by best-effort calls like SHA256 checksum fetch).
- **SHA256 best-effort** (`utils/sha256.ts`): `findSha256FromRelease` uses `retries: 1, silent: true` — checksum file download is non-critical and should not spam retry messages or block installation.
- **Version mutability** (`commands/install.ts`): The `version` variable must be `let` (not `const`) so it can be updated from the GitHub release tag when `pkg.version` is absent. The extracted version flows into `config.packages[key].version` and `tribucket.json`'s `version` / `fallback_version` fields.
- **Startup cleanup**: `cleanupOldTmp()` runs via `setImmediate()` to avoid blocking command startup
- **HTTP resilience** (`utils/http.httpGet`): 5 retries with full-jitter exponential backoff; retries on 403/429 rate-limiting, not just 5xx.
- **--json output** (`index.ts`): read via `program.optsWithGlobals()` (not `this`), because the actions are arrow functions and a program-level `--json` would otherwise shadow the command-level option.
- **SHA256**: Uses `fs.readSync` in chunks with `Bun.CryptoHasher` (not `Bun.CryptoHasher.hash(Bun.file(...))` which fails in compiled binaries)
- **Download resume**: `engine/download.ts` sends `Range: bytes=N-` when a partial file exists; HTTP 206 → appends remainder, HTTP 200 → rewrites. Tested end-to-end via local HTTP server (`src/__tests__/download.test.ts`) with full RFC 7233 Range support — not relying on external CDN behavior (many CDNs advertise `Accept-Ranges` but ignore Range headers).
- **Software source priority** (`utils/software-source.ts`): CLI fetches package definitions and version info from `tribucket.hunluan.space` first, falls back to GitHub sources — avoiding GitHub API rate limits (60 req/hr without token). Two functions:
  - `fetchPackageDef(name)` → `tribucket.hunluan.space/packages/<name>.json` → `raw.githubusercontent.com/.../packages/<name>.json`. Used by `install.ts`.
  - `fetchRemoteVersion(name, repo)` → `tribucket.hunluan.space/bucket/<name>.json` (version field) → `api.github.com/repos/<repo>/releases/latest`. Used by `check.ts` and `update.ts`. Prerelease packages skip the bucket path and go directly to GitHub API. Update also short-circuits: if the software-source version matches local, the GitHub API call for asset resolution is skipped entirely.

## Known Gotchas

1. **SHA256 in compiled binaries**: `Bun.CryptoHasher.hash('sha256', Bun.file(path))` throws "File blob cannot be used here" in compiled mode. Must use `new Bun.CryptoHasher('sha256')` with manual `fs.readSync` + `hasher.update()` in chunks.

2. **Proxy for downloads**: `engine/download.ts` and `utils/http.ts` both read `HTTPS_PROXY` / `ALL_PROXY` env vars. Without a proxy, GitHub release downloads time out from China.

3. **Raw binary downloads**: When a downloaded file is a raw binary (not tar.gz/zip), install.ts/update.ts copy it to the extract dir using `binaryFileName(pkg.binary)` (e.g. `jq` on Unix, `jq.exe` on Windows) and chmod +x. Never use a hardcoded `'binary'` name — `findBinary()` would fail to locate it (esp. on Linux, where the executable bit matters).

4. **Release tags are project-specific**: Do NOT assume a `v` prefix. `buildDirectUrl`/`buildMirrorUrl` use the raw `tag_name` verbatim (e.g. `jq-1.8.1`, `15.1.0`, `v1.2.3`). For version *comparison*, use `versionFromTag()` to extract the version core.

5. **`asset_pattern` is not a literal filename**: it is resolved against the actual release asset list (literal / glob `*` / suffix match). A pattern like `x86_64-pc-windows-msvc.zip` matches the real asset `bat-v0.26.1-x86_64-pc-windows-msvc.zip`.

6. **Windows `.exe`**: `existsSync`/`spawnSync` do NOT try PATHEXT. Use `resolveBinaryPath(dir, binary)` to probe (appends `.exe` if the bare file is missing) and `binaryFileName(binary)` when writing.

7. **Commander `--json` shadowing**: the program defines a global `--json`; command-level `opts.json` is `undefined` in Commander v15. Read it via `program.optsWithGlobals().json`.

8. **`--all` keys**: `config.packages` is keyed by repo (e.g. `koalaman/shellcheck`), which contains `/`. Iterate by `package.name` (not the repo key) so downstream code does not misread the key as a filesystem path.

9. **non-empty directory**: If a target dir exists and is non-empty, the install refuses unless `--force` is used.

10. **`accessSync(X_OK)` is unreliable on Windows**: `detectVersion` skips the X_OK gate on Windows and only treats it as authoritative on POSIX.

11. **KV key restriction**: EdgeOne KV keys must match `^[0-9a-zA-Z_]{1,512}# AGENTS.md

