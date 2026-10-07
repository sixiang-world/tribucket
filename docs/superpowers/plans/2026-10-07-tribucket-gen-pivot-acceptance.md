# Post-Merge Acceptance Checklist — tribucket-gen pivot (v4.0.0)

Manual verification for the maintainer after merging `feat/tribucket-gen-pivot` to `main` and pushing.
Local battery (pytest 115 passed / 3 skipped, asset-pattern check) already run — see
`.superpowers/sdd/2026-10-07-tribucket-gen-pivot/task-13-report.md` for local findings.

## 1. GitHub Console Operations (post-push)

- [ ] **EdgeOne Pages disconnect** — In the EdgeOne Pages console, disconnect/delete the project bound to this repo (it would try to build against the deleted `edgeone.json`).
  Expected: no new deploy attempts on push; `tribucket.hunluan.space` is confirmed offline/taken down.
- [ ] **Repo metadata update** — Settings → General: set description to `Issue-driven multi-source package hub — one template → Homebrew + Scoop`; clear the Website field (or point it at a README anchor).
  Expected: repo sidebar shows the new description; Website field no longer references the retired site.
- [ ] **Workflow permissions** — Settings → Actions → General → Workflow permissions: select **"Read and write"**.
  Expected: setting saved; the confirm pipeline's GITHUB_TOKEN can push a commit to `main`.
- [ ] **Branch protection check** — If `main` has branch protection rules, allow `github-actions[bot]` to push directly (or confirm no protection exists).
  Expected: fully-automatic package ingestion (bot commit to `main`) is not blocked by protection rules.

## 2. Real-Issue End-to-End (after a real package submission via the issue form)

- [ ] **Draft pipeline** — Submit a real, not-yet-collected small tool via the package issue form.
  Expected: issue-draft.yml runs parse → draft → validate; the issue receives a draft comment and the `drafted` label.
- [ ] **Confirm pipeline (same account)** — Reply `@tribucket-bot confirm` from the issue author account.
  Expected: issue-confirm.yml runs processing → render; exactly one commit adding the three files lands on `main`; the issue is closed.
- [ ] **Install check** — After generate/sync, run `brew install shisheng820/tribucket/<name>` (or the equivalent Scoop install).
  Expected: the package installs and the binary runs.
- [ ] **Negative: non-author confirm** — Have a different account reply `@tribucket-bot confirm` on a drafted issue.
  Expected: no action (no commit, no issue close).
- [ ] **Negative: non-drafted issue** — Reply `@tribucket-bot confirm` on an issue that was never labeled `drafted`.
  Expected: no action.
- [ ] **Negative: substring trap** — Reply a message containing the phrase as a substring, e.g. `请 @tribucket-bot confirm 一下`.
  Expected: no action (comment matching is exact, not substring).

## 3. Final Confirmations

- [ ] **Commit chain** — `git log --oneline` on `main` shows the complete pivot commit chain (engine, workflows, docs, version bump) merged intact.
  Expected: all transformation-related commits present, no conflicts or dropped changes.
- [ ] **CHANGELOG top entry** — `CHANGELOG.md` starts with the v4.0.0 pivot entry.
  Expected: `## v4.0.0` is the top version heading.
- [ ] **Repo root cleanliness** — No `scripts/`, `website/`, `functions/`, `package.json`, or `VERSION` at the repository root.
  Expected: root contains only the Python package layout (`tribucket_gen/`, `packages/`, `Formula/`, `bucket/`, `tests/`, `skills/`, docs, configs).
