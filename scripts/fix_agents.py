#!/usr/bin/env python3
"""Fix the truncated AGENTS.md by appending missing sections."""
with open('AGENTS.md', 'r') as f:
    lines = f.readlines()

# Keep up to line 204 (end of gotcha 10)
keep = ''.join(lines[:204])

rest = """11. **KV key restriction**: EdgeOne KV keys must match `^[0-9a-zA-Z_]{1,512}$`. Package names with hyphens (`ripgrep-all`) are stored as `tri_p_ripgrep_all`, `tri_f_ripgrep_all`, `tri_b_ripgrep_all` — the conversion happens in both the Edge Functions and `kv-sync.py`.

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
"""

with open('AGENTS.md', 'w') as f:
    f.write(keep + rest)

print('AGENTS.md fixed successfully')
