"""Mirror provider system with TTL cache and fallback."""
import os
import time
import urllib.request

from tribucket.config import load_json, save_json, mirror_cache_path, mirror_config_path
from tribucket.utils import log


DEFAULT_PROVIDERS = [
    {
        "name": "hunluan",
        "template": "https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/v{version}/{asset}",
        "test_url": "https://gh.do.hunluan.space/",
    },
]


def build_direct_url(repo, version, asset):
    """Build a direct GitHub download URL."""
    return f"https://github.com/{repo}/releases/download/v{version}/{asset}"


def build_mirror_url(template, repo, version, asset):
    """Build a mirror download URL from template."""
    return template.format(repo=repo, version=version, asset=asset)


def test_provider(provider, timeout=3):
    """Test if a mirror provider is reachable. Returns (ok, latency_ms)."""
    test_url = provider.get("test_url", "")
    if not test_url:
        return False, 0

    start = time.monotonic()
    try:
        req = urllib.request.Request(test_url, method="HEAD")
        req.add_header("User-Agent", "tribucket/2.0")
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            latency = int((time.monotonic() - start) * 1000)
            return resp.status < 400, latency
    except Exception:
        latency = int((time.monotonic() - start) * 1000)
        return False, latency


def select_provider(mirror_mode="auto"):
    """Select the best available mirror provider.

    Returns (provider_name, template) or ("direct", None) for direct access.
    """
    if mirror_mode == "direct":
        return "direct", None

    # cn mode: force mirror, skip direct test
    if mirror_mode == "cn":
        user_config = load_json(mirror_config_path(), {})
        providers = user_config.get("providers", DEFAULT_PROVIDERS)
        # Pick first available provider
        for p in providers:
            ok, _ = test_provider(p)
            if ok:
                return p["name"], p.get("template")
        # Fallback to first provider even if not tested
        if providers:
            return providers[0]["name"], providers[0].get("template")
        return "direct", None

    # Load user config
    user_config = load_json(mirror_config_path(), {})
    force = user_config.get("force")

    if force:
        if force == "direct":
            return "direct", None
        providers = user_config.get("providers", DEFAULT_PROVIDERS)
        for p in providers:
            if p["name"] == force:
                return p["name"], p.get("template")
        log(f"Force provider '{force}' not found, falling back to auto")

    # Check cache
    cache = load_json(mirror_cache_path(), {})
    selected = cache.get("selected")
    checked_at = cache.get("checked_at", "")
    ttl = cache.get("ttl_seconds", 3600)

    if selected and checked_at:
        try:
            from datetime import datetime, timezone, timedelta
            dt = datetime.fromisoformat(checked_at)
            if datetime.now(timezone.utc) - dt < timedelta(seconds=ttl):
                log(f"Mirror (cached): {selected}")
                if selected == "direct":
                    return "direct", None
                providers = user_config.get("providers", DEFAULT_PROVIDERS)
                for p in providers:
                    if p["name"] == selected:
                        return p["name"], p.get("template")
        except (ValueError, TypeError):
            pass

    # Probe providers
    providers = user_config.get("providers", DEFAULT_PROVIDERS)
    results = {}
    for p in providers:
        ok, latency = test_provider(p)
        results[p["name"]] = {"ok": ok, "latency_ms": latency}
        log(f"Mirror probe: {p['name']} = {'OK' if ok else 'FAIL'} ({latency}ms)")

    # Also test direct
    direct_ok, direct_latency = _test_direct()
    results["direct"] = {"ok": direct_ok, "latency_ms": direct_latency}
    log(f"Mirror probe: direct = {'OK' if direct_ok else 'FAIL'} ({direct_latency}ms)")

    # Select fastest available
    best_name = None
    best_latency = float("inf")
    for name, result in results.items():
        if result["ok"] and result["latency_ms"] < best_latency:
            best_name = name
            best_latency = result["latency_ms"]

    if not best_name:
        best_name = "direct"

    # Save cache
    _save_mirror_cache(best_name, results)

    if best_name == "direct":
        return "direct", None

    for p in providers:
        if p["name"] == best_name:
            return p["name"], p.get("template")

    return "direct", None


def resolve_download_url(repo, version, asset, mirror_mode="auto"):
    """Resolve the best download URL for an asset.

    Returns (url, provider_name).
    """
    provider_name, template = select_provider(mirror_mode)

    if provider_name == "direct" or not template:
        return build_direct_url(repo, version, asset), "direct"

    url = build_mirror_url(template, repo, version, asset)
    return url, provider_name


def _test_direct(timeout=3):
    """Test direct GitHub access."""
    start = time.monotonic()
    try:
        req = urllib.request.Request("https://github.com", method="HEAD")
        req.add_header("User-Agent", "tribucket/2.0")
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            latency = int((time.monotonic() - start) * 1000)
            return resp.status < 400, latency
    except Exception:
        latency = int((time.monotonic() - start) * 1000)
        return False, latency


def _save_mirror_cache(selected, probe_results):
    """Save mirror probe results to cache."""
    from datetime import datetime, timezone
    cache = {
        "checked_at": datetime.now(timezone.utc).isoformat(),
        "ttl_seconds": 3600,
        "providers": probe_results,
        "selected": selected,
    }
    save_json(mirror_cache_path(), cache)
