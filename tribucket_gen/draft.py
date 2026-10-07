"""Draft a packages/*.json definition from a GitHub repo's latest release.

Deterministic template matching against skills/tribucket-gen/templates.json
(the canonical template data, shared with the standalone skill).
"""
import json
import re
from pathlib import Path

from .assets import match_asset
from .release import fetch_latest_release, http_get

DEFAULT_TEMPLATES_PATH = Path(__file__).resolve().parent.parent / "skills" / "tribucket-gen" / "templates.json"

# 模板文件查找顺序：repo clone / CI / editable 安装读 skills/ 权威源；
# 安装成 wheel（uvx）后 skills/ 不存在，回退到随包分发的 vendored 副本
# （Task 2 的 package-data 已配置；两份文件的一致性由 test_vendored_templates_in_sync 守护）。
_TEMPLATE_CANDIDATES = (
    DEFAULT_TEMPLATES_PATH,
    Path(__file__).resolve().parent / "templates.json",
)

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]

NAME_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")


class DraftError(Exception):
    """kind: "no-template" (needs-manual in CI → exit 2) or "generic" (→ exit 1)."""

    def __init__(self, message, assets=None, kind="generic"):
        super().__init__(message)
        self.assets = assets or []
        self.kind = kind


def sanitize_name(raw):
    n = re.sub(r"[^a-z0-9-]+", "-", (raw or "").lower()).strip("-")
    return n


def clean_text(s):
    """Strip control chars and double quotes (they break .rb/.json interpolation)."""
    return re.sub(r"[\x00-\x1f\x7f\"]", "", (s or "")).strip()


def load_template_doc(path=None):
    """Load the full templates.json document (templates + platform_aliases)."""
    if path:
        p = Path(path)
    else:
        p = next((c for c in _TEMPLATE_CANDIDATES if c.exists()), None)
        if p is None:
            raise DraftError(
                "templates.json not found; looked in:\n" + "\n".join(str(c) for c in _TEMPLATE_CANDIDATES)
            )
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def load_templates(path=None):
    if path:
        return load_template_doc(path)["templates"]
    return load_template_doc()["templates"]


def _name_regex(name):
    variants = {re.escape(name), re.escape(name.replace("-", "_")), re.escape(name.replace("-", ""))}
    return "(?:" + "|".join(sorted(variants, key=len, reverse=True)) + ")"


def _compile_detect(detect_re, name):
    r = detect_re.replace("{name_pattern}", _name_regex(name))
    r = r.replace("{libc}", r"(?:gnu|musl)")
    r = r.replace("{version}", r"[\w.]+")
    return re.compile(r)


def score_template(tpl, assets, name):
    score = 0
    for det in tpl.get("detect", {}).values():
        rx = _compile_detect(det, name)
        if any(rx.search(a["name"]) for a in assets):
            score += 1
    return score


def choose_template(templates, assets, name, alt_names=()):
    """Pick the best-matching template.

    Scoring tries every candidate name (the package name plus e.g. the repo
    basename) — a display-name override (--name "Cosign Tool" → cosign-tool)
    must not blind detection when the release assets are prefixed with the
    project's real name.
    """
    names = [name] + [n for n in alt_names if n and n != name]
    scored = [
        (max(score_template(t, assets, n) for n in names), t.get("frequency", 0), t)
        for t in templates
    ]
    scored = [s for s in scored if s[0] > 0]
    if not scored:
        raise DraftError(
            "no known template matches this repo's release assets",
            assets=[a["name"] for a in assets],
            kind="no-template",
        )
    scored.sort(key=lambda x: (x[0], x[1]), reverse=True)
    return scored[0][2]


def detect_libc(assets):
    return "musl" if any("musl" in a["name"] for a in assets) else "gnu"


def _alias_hit(assets, alias):
    """Match a platform alias against asset names with separator boundaries.

    Plain substring matching is too loose — e.g. the alias ``win-arm64`` is a
    substring of ``cosign-darwin-arm64`` (dar*win-arm64*) and would mislabel a
    darwin asset as windows_arm64. Require the alias to sit between separators
    (start/end of name, or a non-alphanumeric char on each side).
    """
    rx = re.compile(r"(?<![A-Za-z0-9])" + re.escape(alias) + r"(?![A-Za-z0-9])")
    for a in assets:
        if rx.search(a["name"]):
            return a
    return None


def build_asset_pattern(tpl, name, assets, aliases=None, alt_names=()):
    """Build asset_pattern from the template's match_rule.

    Pass 1 (authoritative): rule-derived pattern per platform, tried with each
    candidate name; records the exact asset each rule matched (rule_claimed).
    Pass 2 (rescue): platforms whose rule matched nothing try platform aliases
    (the rule's extension/format can differ from the real assets, e.g. bare
    ``cosign-linux-amd64`` vs ``{name}-linux-amd64.tar.gz``); the rescue
    records the exact matched asset name, never a guess.

    A rescue never re-claims an asset already matched by another platform's
    RULE — otherwise the ``apple-darwin`` alias would pull the x86_64 asset the
    darwin_amd64 rule already claimed into darwin_arm64 (wrong-but-matching).
    Sharing an asset between two RESCUES is still allowed (universal darwin
    builds: per-arch rules match nothing, both platforms rescue the same file).
    生成的 pattern 若匹配不到任何真实资产 → NO_MATCH（宁缺勿错）.
    """
    libc = detect_libc(assets)
    names = [name] + [n for n in alt_names if n and n != name]
    pattern = {}
    rule_claimed = set()
    rescueable = []
    for plat in PLATFORM_KEYS:
        rule = tpl.get("match_rule", {}).get(plat)
        if not rule or rule == "NO_MATCH":
            pattern[plat] = "NO_MATCH"
            continue
        pat = None
        for n in names:
            cand = rule.replace("{name}_{version}", "*").replace("{version}", "*")
            cand = cand.replace("{name}", n).replace("{libc}", libc)
            hit = match_asset(assets, cand)
            if hit:
                pat = cand
                rule_claimed.add(hit["name"])
                break
        if pat is None:
            rescueable.append(plat)
            pattern[plat] = None  # filled by the rescue pass
        else:
            pattern[plat] = pat
    for plat in rescueable:
        pat = None
        for alias in (aliases or {}).get(plat, []):
            hit = _alias_hit(assets, alias)
            if hit and hit["name"] not in rule_claimed:
                pat = hit["name"]
                break
        # 生成的 pattern 若匹配不到任何真实资产 → NO_MATCH（宁缺勿错）
        pattern[plat] = pat if (pat and match_asset(assets, pat)) else "NO_MATCH"
    return pattern


def fetch_repo_meta(repo, token=None):
    """Fetch repo description + license spdx_id from GitHub API."""
    body = http_get(f"https://api.github.com/repos/{repo}", token=token)
    data = json.loads(body)
    lic = (data.get("license") or {}).get("spdx_id")
    license_id = lic if lic and lic not in ("NOASSERTION", "UNKNOWN", "OTHER") else "Unknown"
    return {"description": (data.get("description") or "").strip(), "license": license_id}


def draft(repo, name=None, description=None, binary=None, license_id=None,
          homepage=None, templates_path=None, fetcher=None, meta_fetcher=None,
          token=None):
    """Build a packages/*.json dict from the repo's latest release.

    Returns (pkg_dict, notes). Raises DraftError when no template matches.
    """
    repo = repo.strip().removesuffix(".git")
    if not re.match(r"^[\w.-]+/[\w.-]+$", repo):
        raise DraftError(f"invalid repo: {repo!r}")

    fetcher = fetcher or fetch_latest_release
    version, all_assets, _checksums = fetcher(repo, token=token)
    if not all_assets:
        raise DraftError(f"no release assets found for {repo} (v{version})")

    doc = load_template_doc(templates_path)
    templates = doc["templates"]
    aliases = doc.get("platform_aliases", {})
    repo_base = sanitize_name(repo.split("/")[-1])
    pkg_name = sanitize_name(name) or repo_base
    if not pkg_name or not NAME_RE.match(pkg_name):
        raise DraftError(f"invalid package name: {pkg_name!r}")

    tpl = choose_template(templates, all_assets, pkg_name, alt_names=(repo_base,))
    asset_pattern = build_asset_pattern(tpl, pkg_name, all_assets, aliases=aliases, alt_names=(repo_base,))
    if all(v == "NO_MATCH" for v in asset_pattern.values()):
        raise DraftError(
            f"template {tpl['id']} matched detect but produced zero usable patterns",
            assets=[a["name"] for a in all_assets],
        )

    meta = {"description": "", "license": "Unknown"}
    if (description is None or license_id is None) and meta_fetcher is None:
        meta = fetch_repo_meta(repo, token=token)
    elif meta_fetcher is not None:
        meta = meta_fetcher(repo)

    pkg = {
        "name": pkg_name,
        "repo": repo,
        "description": clean_text(description) or clean_text(meta["description"]) or f"{pkg_name} CLI tool",
        "binary": clean_text(binary) or pkg_name,
        "license": license_id or meta["license"],
        "homepage": homepage or f"https://github.com/{repo}",
        "asset_pattern": asset_pattern,
    }
    notes = [f"template: {tpl['id']}", f"release: v{version}"]
    return pkg, notes
