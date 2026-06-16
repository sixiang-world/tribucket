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
11. **KV key restriction**: EdgeOne KV keys must match `^[0-9a-zA-Z_]{1,512}$`. Package names with hyphens (`ripgrep-all`) are stored as `tri_p_ripgrep_all`, `tri_f_ripgrep_all`, `tri_b_ripgrep_all` — the conversion happens in both the Edge Functions and `kv-sync.py`.

12. **Edge Function routing**: `functions/*/[[default]].js` catch-all routes only intercept requests matching their directory prefix. Other routes (e.g. `/`, `/styles/*`) fall through to EdgeOne Pages' static file serving from `dist/`. This is why `functions/` does NOT need to embed static files.

13. **Admin sync auth**: The `/admin/sync` endpoint reads the expected token from `context.env.ADMIN_SYNC_KEY` (set in EdgeOne Pages console). The CI sends `Authorization: Bearer <secret>` where `<secret>` matches this value. The secret is stored as `ADMIN_SYNC_SECRET` in GitHub Secrets.

14. **functions/ is committed**: Unlike `dist/`, the `functions/` directory IS tracked in git because EdgeOne Pages needs it to detect Edge Functions during deployment. Regenerate them only when the routing logic changes.

## CLI Commands

### install
```bash
tribucket install <name> [--dir <path>] [--link] [--force] [--mirror <mode>]
```
- `--dir`: Install directory (default: cwd)
- `--link`: Create symlink in `~/.tribucket/bin/`
- `--force`: Overwrite existing installation (bypasses non-empty dir check, prompts for confirmation)
- `--mirror`: Mirror mode (`auto`, `cn`, `direct`)

### update
```bash
tribucket update [name] [--all] [--force] [--dry-run] [--mirror <mode>] [--no-backup]
```
- `--all`: Update all tracked packages (concurrent, with confirmation prompt)
- `--force`: Force re-download
- `--dry-run`: Show what would be updated

### check
```bash
tribucket check [targets...] [--all] [--refresh] [--local-only] [--json]
```
- Concurrent check shows live progress: `→ Checking packages... (3/12)`

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
tribucket info <name> [--json]
```
- Shows package details with i18n labels
- `--json`: JSON output
- Runtime version detection via binary --version

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
tribucket uninstall <name> [--force]
```
- `--force`: Skip confirmation prompt

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
   `asset_pattern` values are resolved against the real GitHub release asset
   list (literal exact match → glob `*` → pure-suffix match), so any of these
   work: a full asset name, a glob like `fzf-*-linux_amd64.tar.gz`, or a bare
   platform tail like `x86_64-pc-windows-msvc.zip`. Use `"NO_MATCH"` for
   unsupported platforms.
2. Run the generator: `python scripts/generate.py --only <name>` (produces `Formula/<name>.rb` + `bucket/<name>.json`; CI runs this automatically on `packages/**` changes and after each release)
3. Commit with conventional format

## Testing

```bash
bun test                                          # TypeScript CLI tests (src/__tests__)
bun test src/__tests__/utils.test.ts              # Utility/mirror/version tests
bun test src/__tests__/config.test.ts             # Config store tests
bun test src/__tests__/download.test.ts            # Download resume (206/200) tests
python -m pytest tests/test_generate.py          # Generator tests (Python)
python -m pytest tests/test_checkver.py          # Checkver tests (Python)
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `GITHUB_TOKEN` | Increase API rate limit (5000 req/hr vs 60) |
| `TRIBUCKET_HOME` | Override config directory (default: `~/.tribucket`) |
| `TRIBUCKET_VERBOSE` | Enable debug logging (`1` to enable) |
| `TRIBUCKET_LANG` | Force language (`en` or `zh`; auto-detects from system locale by default) |
| `NO_COLOR` | Disable colored output |
| `HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` | Proxy configuration (used by all HTTP requests and downloads) |
| `ADMIN_SYNC_SECRET` | CI: Bearer token for POST /admin/sync (set in GitHub Secrets) |
| `TRIBUCKET_SITE` | CI: Override sync target URL (default: https://tribucket.hunluan.space) |

## EdgeOne Pages Configuration

The EdgeOne Pages project must have:

1. **KV namespace** created and bound with variable name **`TRIBUCKET_KV`** (global, not `context.env`)
2. **Environment variable** **`ADMIN_SYNC_KEY`** set (the shared secret used to authenticate CI sync requests)
3. **Build settings**: `npm run build:web` as build command, `./dist` as output directory, Node 22.11.0
4. **Functions directory**: `functions/` is auto-detected by EdgeOne Pages. No additional config needed.

## Platform Keys

Use these in `asset_pattern`:
- `linux_amd64`, `linux_arm64`
- `darwin_amd64`, `darwin_arm64`
- `windows_amd64`, `windows_arm64`
- Value `"NO_MATCH"` means unsupported on that platform

---

## Release Workflow

### Version Bump → Tag → Release

```
Step 1: Bump version
  - Edit src/version.ts  → VERSION = 'X.Y.Z'
  - Edit VERSION file    → X.Y.Z
  - Edit package.json    → "version": "X.Y.Z"
  - Edit packages/tribucket.json → "version": "X.Y.Z"

Step 2: Update CHANGELOG.md
  - Add ## vX.Y.Z — Title heading at top
  - Categorize changes: 🚀 新功能 / 🔴 Bug 修复 / 🟡 质量改进 / ⚙️ 变更 / 📝 调查结论
  - Verify website build parses it: bun run website/build.ts

Step 3: Commit & push
  - git add -A && git commit -m "feat: vX.Y.Z ..."
  - git push origin main

Step 4: Tag & release
  - git tag vX.Y.Z && git push origin vX.Y.Z
  - This triggers:
    1. GitHub Actions release.yml → builds 5 platforms → creates GitHub Release (with CHANGELOG注入)
    2. CNB .cnb.yml tag_push → builds 5 platforms → creates CNB Release
    3. generate.yml (via workflow_run) → regenerates Formula/bucket → syncs to EdgeOne KV

Step 5: Post-release verification
  - GitHub Release page: 5 binaries + sha256sums.txt + Release Notes
  - CNB Release page: same artifacts
  - KV sync: curl https://tribucket.hunluan.space/api/packages.json | head
  - Website: https://tribucket.hunluan.space shows new version
  - CLI: tribucket self-update detects new version
```

### Version Sources (must stay in sync)

| File | Field |
|------|-------|
| `src/version.ts` | `export const VERSION = '...'` |
| `package.json` | `"version"` |
| `VERSION` (root) | plain text |
| `packages/tribucket.json` | `"version"` |
| Git tag | `vX.Y.Z` |

---

## CI Architecture Overview

Three CI pipelines work together for release + data sync:

```
                    ┌──────────────────────────────────────┐
                    │  1. release.yml (GitHub Actions)      │
                    │     Trigger: v* tag / workflow_dispatch│
                    │     Does: bun build --compile ×5      │
                    │     Output: GitHub Release (5 binaries │
                    │       + debug variants + SHA256)       │
                    └──────────────┬───────────────────────┘
                                   │ workflow_run (on success)
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. generate.yml (GitHub Actions)                                │
│     Trigger: packages/** push / cron 6h / release done          │
│     Does: python generate.py → git commit → kv-sync.py          │
│     Output: Updated Formula/ + bucket/ → EdgeOne KV             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  3. .cnb.yml (CNB 云原生构建)                                    │
│     Trigger: v* tag (tag_push) / web_trigger (manual)           │
│     Does: bun build --target ×10 (5 platforms × release+debug)  │
│     Output: CNB Release + Release Notes (CHANGELOG 注入)         │
└─────────────────────────────────────────────────────────────────┘
```

Key points:
- **Dual CI release strategy**: Both GH Actions and CNB build on tag push — either one succeeding is sufficient for a valid release. This provides redundancy for China network conditions.
- **generate.yml** is triggered by three sources: changes to `packages/`, 6-hour cron (for upstream version bumps), and after release.yml completes.
- **kv-sync.py** runs at the end of generate.yml, writing `tri_packages_idx` last for atomic index updates.

---

## Adding a Package (Full Reference)

### 5-Step Flow

```bash
# 1. Create package definition
touch packages/<name>.json

# 2. Edit JSON (see field reference below)
#    - For GitHub Release source: repo + asset_pattern
#    - For custom download URL: version + download_url [+ checkver + autoupdate]

# 3. Generate Formula + Bucket
python scripts/generate.py --only <name>

# 4. Local verification
tribucket install <name>

# 5. Commit
git add packages/<name>.json Formula/<name>.rb bucket/<name>.json
git commit -m "pkg: add <name>"
```

### Package JSON Field Reference

**GitHub Release source (standard):**

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `name` | ✅ | string | Package name, matches filename |
| `repo` | ✅ | string | GitHub `owner/repo` |
| `description` | ✅ | string | One-line description |
| `binary` | ✅ | string | Executable name after install |
| `license` | ✅ | string | SPDX license identifier |
| `homepage` | ✅ | string | Project URL |
| `asset_pattern` | ✅ | object | `{ platform: pattern }` — 6 platforms or `NO_MATCH` |

**Custom download source (non-GitHub Release):**

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `version` | ✅ | string | Current version (required when `download_url` exists) |
| `download_url` | ❌ | object | `{ platform: url }` — direct download URLs |
| `checkver` | ❌ | string\|object | `"github"` or object with `url`/`jsonpath`/`regex`/`replace` |
| `autoupdate` | ❌ | object | `{ platform: url_template }` — with `${version}` / named groups |

### checkver Configuration

```json
{
  "checkver": {
    "url": "https://api.example.com/version",
    "jsonpath": "$.version",
    "regex": "(?P<ver>\\d+\\.\\d+\\.\\d+)",
    "replace": "${ver}"
  }
}
```

- `"checkver": "github"` — auto-detect from repo's GitHub API (default behavior, can omit)
- `jsonpath`: minimal JSONPath resolver supports `$.key`, `$[0].key`, `$.a.b.c`
- `regex`: supports named capture groups `(?P<name>...)`
- `replace`: default `"${1}"` if not specified

### autoupdate URL Templates

```json
{
  "autoupdate": {
    "linux_amd64": "https://example.com/dl/go${ver}.linux-amd64.tar.gz",
    "windows_amd64": "https://example.com/dl/go${ver}.windows-amd64.zip"
  }
}
```

Supports `${version}` (full version from checkver) and named capture group variables `${name}`.

### Platform Coverage Rules

- All 6 platform keys must be present: `linux_amd64`, `linux_arm64`, `darwin_amd64`, `darwin_arm64`, `windows_amd64`, `windows_arm64`
- Use `"NO_MATCH"` for explicitly unsupported platforms (don't omit the key)
- `asset_pattern` matching: literal exact match → glob (`*`) → pure-suffix match (see mirror.ts)

---

## Code Review Checklist (Project-Specific)

### Every PR must pass these checks:

```
### Functional
- [ ] New packages: `python scripts/generate.py --only <name>` runs without error
- [ ] New packages: `tribucket install <name>` completes successfully
- [ ] CLI changes: all existing commands still work (install/update/check/list/info/track/untrack/config/clean)
- [ ] Error paths produce user-visible messages (status()), not silent failures or bare throws

### i18n
- [ ] All new user-visible strings defined in `utils/locale.ts` (both EN and ZH)
- [ ] No hardcoded English strings in command files
- [ ] locale.ts keys follow naming convention: `error_*` for errors, `confirm_*` for prompts, etc.

### Cross-Platform
- [ ] Windows: `.exe` suffix handled via `binaryFileName()` / `resolveBinaryPath()`
- [ ] Windows: `accessSync(X_OK)` NOT used for version detection
- [ ] Linux: `--no-absolute-names` NOT passed to tar
- [ ] Paths use `path.join()` not string concatenation
- [ ] System directory protection handles both `/usr` (POSIX) and `C:\Windows` (Windows)

### Compilation
- [ ] `bun build src/index.ts --compile --outfile /dev/null` succeeds (or temp path on Windows)
- [ ] No `Bun.file()` usage (doesn't work in compiled binary)
- [ ] No `import.meta.dir` usage (use `fileURLToPath(import.meta.url)` instead)

### Security
- [ ] Path traversal protection via `realpathSync` + `startsWith` check
- [ ] No `..` acceptance in user-provided paths without resolution
- [ ] No command injection vectors (shell commands use arrays, not string interpolation)
- [ ] Constant-time comparison for auth tokens (admin/sync.js)

### CI
- [ ] Changes to `release.yml` reflected in `.cnb.yml` (or vice versa) for shared build stages
- [ ] CHANGELOG.md updated if user-facing behavior changed

### Tests
- [ ] `bun test` passes (21 tests)
- [ ] New functionality has corresponding test coverage
```

---

## Common Bug Patterns (Historical Reference)

Patterns from past code reviews that frequently recur:

| Pattern | Example | Fix |
|---------|---------|-----|
| **Commander --json shadow** | `opts.json` is `undefined` | Use `program.optsWithGlobals().json` |
| **const vs let for version** | `const version` prevents update from release tag | Use `let version` |
| **GitHub tag v prefix assumption** | Hardcoding `v` in download URL | Use raw `tag_name`, templates use `{tag}` |
| **Bun.file() in compiled binary** | `Bun.CryptoHasher.hash('sha256', Bun.file(p))` | Manual `fs.readSync` + `hasher.update()` |
| **Empty archive handling** | No check for `entries.length === 0` | Guard with early return / error |
| **TOCTOU lock race** | `existsSync → unlinkSync → writeFileSync` | Use atomic `wx` flag only |
| **SIGINT shared state** | Multiple SIGINT handlers overwrite each other | Use module-level flag, not `process.exit()` |
| **KV key hyphens** | `tri_p_ripgrep-all` (invalid) | Convert `-` to `_` in key names |
| **403 misidentified as rate-limit** | All 403 retried unnecessarily | Check `X-RateLimit-Remaining: 0` header |
| **status() vs log() misuse** | Debug info shown to all users | User progress → `status()`; debug → `log()` (verbose only) |

---

## Development Workflow

### Branch Naming

```
feat/<short-desc>     # New feature (e.g. feat/resume-download)
fix/<short-desc>      # Bug fix (e.g. fix/json-shadow)
pkg/<name>            # New package (e.g. pkg/bat)
docs/<desc>           # Documentation
chore/<desc>          # CI/build/tooling
refactor/<desc>       # Refactoring
```

### Commit Message Convention

```
type(scope): brief description

- Use conventional commits: feat / fix / docs / refactor / perf / test / chore / pkg
- Scope is optional: (install), (mirror), (ci), etc.
- Body explains motivation, not what (code is self-documenting)
```

### PR Lifecycle

```
1. Create branch from main
2. Make changes + commit (conventional commits)
3. Run bun test (must pass)
4. Run python scripts/generate.py --dry-run (if packages changed)
5. Push → CI runs automatically
6. Create PR with description + test evidence
7. Self-review against checklist above
8. Merge to main (squash merge recommended)
```
