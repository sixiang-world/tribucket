# tribucket-gen 转型实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 tribucket 从"CLI 包管理器"转型为"Issue 驱动的多软件源聚合仓库"：CLI/网站/KV 归档下线，`generate.py` 重构为 `tribucket_gen` Python 包（含 draft/validate 新能力），新增 Issue 表单 → 自动生成 → 提交者确认 → 单 commit 入库的流水线。

**Architecture:** 演进式重构——现有 1126 行 `scripts/generate.py` 按职责搬移为 `tribucket_gen/` 包（网络层/资产层/哈希层/编排层/渲染层），渲染器注册表提供可插拔扩展点；新增 `draft.py`（Release 资产 → templates.json 模板匹配 → 包定义）与 `validate.py`（定义校验）；两个新 GitHub Actions workflow 实现 Issue 提交流水线；skill 保持独立可拷贝。

**Tech Stack:** Python 3.9+（仅标准库）、pytest、GitHub Actions、GitHub Issue Forms、bash（skill）

**Spec:** `docs/superpowers/specs/2026-10-07-tribucket-gen-pivot-design.md`（本计划从 spec 出发；spec 与计划一起阅读）

## Global Constraints

- Python 3.9+，**仅标准库**（禁止引入任何第三方运行时依赖；pytest 仅 dev 用）
- 每个任务结束前 `python -m pytest tests/ -q` 必须全绿（当前 95 个测试：test_generate 69 + test_checkver 23 + test_checkver_fix 3[skip]）
- 单元测试禁止真实网络访问——一律用 fixture + 注入 fetcher / monkeypatch `http_get`
- **绝不手工编辑** `Formula/*.rb`、`bucket/*.json`
- `templates.json` 唯一权威源在 `skills/tribucket-gen/templates.json`，不得复制副本
- 仓库约定 URL：`github.com/shisheng820/tribucket`
- 开发机是 Windows：包代码用 `os.path`/`pathlib`，不要写 POSIX-only 代码
- Conventional commits（feat/fix/chore/refactor/docs/test/pkg）
- 渲染输出必须与现有 `generate.py` 逐字节一致（搬移不重写）——由现有测试保证

## 计划期发现（相对 spec 的补充，不改变 spec 决策）

1. `scripts/` 里除 generate.py/kv-sync.py/checkver.py 外还有 CLI 安装器（`install.sh`、`install.ps1`、`bootstrap.sh`、`bootstrap.ps1`、`tribucket-completion.bash`）和一次性批量迁移脚本 `add_packages.py`——全部随 CLI 归档到 `archive/cli-v2/scripts/`（spec 的"bun 工具链随 CLI 退场"同理覆盖）
2. `scripts/checkver.py`（266 行，process_package 依赖）一并移入包：`tribucket_gen/checkver.py`
3. 新增 `tribucket_gen/core.py` 承载编排函数（load_packages/resolve_package/render_package/process_package）——spec 模块列表缺少编排层
4. Issue 流水线的 draft 是**纯模板匹配**（确定性、可测试）；无模板命中 → 关 Issue + `needs-manual` 标签由维护者处理。AI 兜底只存在于独立 skill 场景
5. `process_package` 保留为 tuple 签名的稳定便利 API（内部走 resolve_package + registry 渲染），3 个 pipeline 测试零改动通过

## 最终文件结构

```
tribucket_gen/
├── __init__.py          # __version__
├── __main__.py          # CLI: render / check / draft / validate 子命令
├── release.py           # _build_opener, http_get, _has_aria2, download_file, fetch_latest_release, parse_release
├── assets.py            # CHECKSUM_PATTERNS, match_asset, is_checksum_asset, infer_asset_format, check_asset_patterns
├── hashing.py           # cache_key_path, get_cached_hash, write_cache, compute_sha256, parse_checksum_file, get_sha256_for_asset
├── checkver.py          # checkver.py 原样搬移（run_checkver, apply_autoupdate, in_place_replace, ...）
├── core.py              # load_packages, resolve_package, process_package, PLATFORM_KEYS
├── draft.py             # 新增: load_templates, draft, DraftError, ...
├── validate.py          # 新增: validate_definition, ...
└── render/
    ├── __init__.py      # Ctx, REGISTRY, register, render_homebrew, render_scoop, render_all
    ├── homebrew.py      # class_name_from, render_formula
    ├── scoop.py         # autoupdate_url, render_bucket
    └── portable.py      # infer_install_type, derive_tribucket_json, render_install_sh, render_bat, generate_portable
pyproject.toml           # 包元数据 + [project.scripts] tribucket-gen + pytest 配置
.github/
├── ISSUE_TEMPLATE/package-submission.yml + config.yml
├── workflows/{generate.yml(改), issue-draft.yml(新), issue-confirm.yml(新), validate.yml(不动), mirror-sync.yml(不动)}
archive/cli-v2/          # src/, docs/architecture-v2.md, scripts/安装器们
README.md / AGENTS.md / CONTRIBUTING.md / CHANGELOG.md   # 重写
删除: website/ functions/ edgeone.json VERSION package.json packages/tribucket.json scripts/(整目录) .cnb.yml release.yml
```

---

### Task 1: 归档 CLI 与安装脚本，删除分发链路

**Files:**
- Move: `src/` → `archive/cli-v2/src/`；`docs/architecture-v2.md` → `archive/cli-v2/`；`scripts/install.sh`、`scripts/install.ps1`、`scripts/bootstrap.sh`、`scripts/bootstrap.ps1`、`scripts/tribucket-completion.bash`、`scripts/add_packages.py` → `archive/cli-v2/scripts/`
- Delete: `website/`、`functions/`、`edgeone.json`、`scripts/kv-sync.py`、`.github/workflows/release.yml`、`.cnb.yml`、`package.json`、`VERSION`、`packages/tribucket.json`
- Modify: `.github/workflows/generate.yml`（最小补丁：删 kv-sync 步骤与 workflow_run 触发，防 main 中间态坏死）

**Interfaces:**
- Produces: 干净的仓库基线（只剩 packages/Formula/bucket + 生成器 + tests + skill），后续任务在此之上工作
- 注意：`scripts/generate.py` 与 `scripts/checkver.py` 本任务**不动**（tests 仍经 sys.path 导入它们，Task 5 才退役）

- [ ] **Step 1: 归档**

```bash
mkdir -p archive/cli-v2/scripts
git mv src archive/cli-v2/src
git mv docs/architecture-v2.md archive/cli-v2/architecture-v2.md
git mv scripts/install.sh scripts/install.ps1 scripts/bootstrap.sh scripts/bootstrap.ps1 scripts/tribucket-completion.bash scripts/add_packages.py archive/cli-v2/scripts/
```

在 `archive/cli-v2/README.md` 写入两行说明：

```markdown
# tribucket CLI v2 (Bun/TypeScript) — 已归档

2026-10 起仓库转型为 Issue 驱动的多软件源聚合仓库，CLI 不再维护。
安装器脚本（install.sh 等）与批量迁移脚本 add_packages.py 一并归档于此。
```

- [ ] **Step 2: 删除分发链路**

```bash
git rm -r website functions edgeone.json scripts/kv-sync.py \
  .github/workflows/release.yml .cnb.yml package.json VERSION packages/tribucket.json
```

（若存在 `bun.lock` / `bun.lockb` 一并 `git rm`。）

- [ ] **Step 3: generate.yml 最小补丁**

删除文件末尾整个步骤块与 workflow_run 触发块：

```yaml
# 删除 on: 下的整个 workflow_run 块：
#   workflow_run:
#     workflows: ["Build & Release"]
#     types: [completed]

# 删除文件末尾：
#      - name: Sync to EdgeOne KV
#        run: python -u scripts/kv-sync.py
#        env:
#          ADMIN_SYNC_SECRET: ${{ secrets.ADMIN_SYNC_SECRET }}
#          TRIBUCKET_SITE: https://tribucket.hunluan.space
```

同时删除 job 级 `if:` 中对 workflow_run 的条件（`if:` 整块删掉，或简化为不设 if）。cron 本任务保持 6h 不变（Task 5 改）。

- [ ] **Step 4: 验证**

```bash
python -m pytest tests/ -q     # 95 个测试应全绿（95 passed, 3 skipped 属正常计数方式）
ls scripts/                    # 只剩 generate.py checkver.py
```

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore: archive CLI v2 and remove website/KV distribution stack"
```

---

### Task 2: pyproject.toml 与 tribucket_gen 包骨架

**Files:**
- Create: `pyproject.toml`、`tribucket_gen/__init__.py`、`tribucket_gen/__main__.py`

**Interfaces:**
- Produces: 可运行的 `python -m tribucket_gen --help`；`[project.scripts]` 入口 `tribucket-gen`（Task 11 uvx 路径依赖它）；pytest `pythonpath` 配置（Task 3+ 测试导入依赖）

- [ ] **Step 1: 写 pyproject.toml**

```toml
[build-system]
requires = ["setuptools>=61"]
build-backend = "setuptools.build_meta"

[project]
name = "tribucket-gen"
version = "2.0.0"
description = "One package template -> Homebrew Formula + Scoop bucket (+ pluggable targets)"
readme = "README.md"
requires-python = ">=3.9"
license = { text = "MIT" }

[project.scripts]
tribucket-gen = "tribucket_gen.__main__:main"

[tool.pytest.ini_options]
pythonpath = ["."]
testpaths = ["tests"]
```

- [ ] **Step 2: 写包骨架**

`tribucket_gen/__init__.py`:

```python
"""tribucket_gen — packages/*.json -> Homebrew Formula + Scoop bucket generator engine."""

__version__ = "2.0.0"
```

`tribucket_gen/__main__.py`（占位骨架，Task 5 补全子命令）:

```python
"""CLI entry: python -m tribucket_gen <command>."""
import argparse

from . import __version__


def build_parser():
    p = argparse.ArgumentParser(prog="tribucket_gen", description="tribucket generator engine")
    p.add_argument("--version", action="version", version=__version__)
    return p


def main(argv=None):
    args = build_parser().parse_args(argv)
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

（骨架期 `main` 不引用 args 会有 lint 噪音——Task 5 会重写整个文件，占位即可。）

- [ ] **Step 3: 验证**

```bash
python -m tribucket_gen --help     # 打印 usage，退出码 0
python -m pytest tests/ -q         # 全绿（不受影响）
```

- [ ] **Step 4: Commit**

```bash
git add pyproject.toml tribucket_gen/
git commit -m "feat(gen): add tribucket_gen package skeleton with pyproject"
```

---

### Task 3: 搬移网络层、资产层、哈希层、checkver 进包

**Files:**
- Create: `tribucket_gen/release.py`、`tribucket_gen/assets.py`、`tribucket_gen/hashing.py`、`tribucket_gen/checkver.py`
- Move from: `scripts/generate.py`（函数清单见下）与 `scripts/checkver.py`
- Modify: `scripts/generate.py`（顶部加委托导入，删除已搬移的函数体）
- Test: 现有 tests 零改动应全绿（generate.py 显式再导出）

**Interfaces:**
- Produces（后续任务依赖的确切名字与签名，全部从 generate.py 原样搬移）:
  - `release.py`: `_build_opener()`, `http_get(url, token=None, retries=5, timeout=30)`, `_has_aria2()`, `download_file(url, dest_path, token=None, verbose=False)`, `fetch_latest_release(repo, token=None)`, `parse_release(release_json)`（generate.py:80-205）
  - `assets.py`: `CHECKSUM_PATTERNS`, `match_asset(assets, pattern)`, `is_checksum_asset(name)`, `infer_asset_format(asset_pattern)`, `check_asset_patterns(pkgs)`（generate.py:27-28, 52-68, 632-650, 958-1017）
  - `hashing.py`: `cache_key_path`, `get_cached_hash`, `write_cache`, `compute_sha256`, `parse_checksum_file`, `get_sha256_for_asset`（generate.py:208-245, 394-431）
  - `checkver.py`: `scripts/checkver.py` 整文件原样搬移

- [ ] **Step 1: 建四个模块并搬移函数**

按上面清单把函数**逐字**从 `scripts/generate.py` 剪切到对应新模块（连同 docstring；generate.py:22-24 的 stdout reconfigure 块与 `CHECKSUM_PATTERNS` 常量处理：reconfigure 块复制到每个有 print 的模块顶部不必要——只在 `check_asset_patterns` 所在的 assets.py 与 release.py 顶部保留一份即可；`CHECKSUM_PATTERNS` 归 assets.py）。

模块内相互导入：

```python
# tribucket_gen/assets.py
from fnmatch import fnmatch
from .release import fetch_latest_release   # check_asset_patterns 需要

# tribucket_gen/hashing.py
import hashlib, os, tempfile, urllib.error, http.client
from .release import http_get, download_file

# tribucket_gen/core 相关后续任务处理；本任务不动 process_package
```

`checkver.py` 搬移后把内部对 `generate` 的引用（若有）改为相对导入或参数传递——搬移时检查：它当前是独立模块（无 generate 导入），仅 process_package 反向 `from checkver import ...`，因此**只需原样移动**。

- [ ] **Step 2: generate.py 顶部加委托导入**

在 `scripts/generate.py` 顶部（reconfigure 块之后）加入，并**删除已搬移的函数体**：

```python
import os as _os
import sys as _sys
_sys.path.insert(0, _os.path.dirname(_os.path.dirname(_os.path.abspath(__file__))))

from tribucket_gen.release import (  # noqa: E402,F401
    _build_opener, http_get, _has_aria2, download_file, fetch_latest_release, parse_release,
)
from tribucket_gen.assets import (  # noqa: E402,F401
    CHECKSUM_PATTERNS, match_asset, is_checksum_asset, infer_asset_format, check_asset_patterns,
)
from tribucket_gen.hashing import (  # noqa: E402,F401
    cache_key_path, get_cached_hash, write_cache, compute_sha256, parse_checksum_file,
    get_sha256_for_asset,
)
import tribucket_gen.checkver as _checkver_mod  # noqa: E402
from tribucket_gen.checkver import run_checkver, apply_autoupdate, in_place_replace  # noqa: E402,F401
```

注意：process_package 内部的 `from checkver import run_checkver, ...` 行（generate.py:476）改为直接使用模块级已导入的名字（删除该行局部 import）。

- [ ] **Step 3: 验证测试全绿（零改动）**

```bash
python -m pytest tests/ -q
```

Expected: 全绿。关键点：tests monkeypatch `generate.http_get`（test_generate.py:418 等）依然生效——process_package 仍在 generate.py 中引用模块级 `http_get` 名字，而该名字经 from-import 绑定在 generate 命名空间，monkeypatch 替换的正是这个绑定。

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "refactor(gen): move release/assets/hashing/checkver layers into tribucket_gen package"
```

---

### Task 4: 渲染层搬移 + 注册表 + process_package 重构

**Files:**
- Create: `tribucket_gen/render/__init__.py`、`render/homebrew.py`、`render/scoop.py`、`render/portable.py`、`tribucket_gen/core.py`
- Move from: `scripts/generate.py`
- Modify: `scripts/generate.py`（继续委托）、`tribucket_gen/render/portable.py` 内两处过时文案

**Interfaces:**
- Consumes: Task 3 的 release/assets/hashing 模块
- Produces:
  - `render/homebrew.py`: `class_name_from(name)`, `render_formula(info)`（generate.py:248-315 原样）
  - `render/scoop.py`: `autoupdate_url(url, version)`, `render_bucket(info, is_download_url=False)`（generate.py:318-391 原样）
  - `render/portable.py`: `infer_install_type(pkg)`, `derive_tribucket_json(pkg, version=None)`, `render_install_sh(pkg, tribucket_json)`, `render_bat(pkg)`, `generate_portable(pkg, output_dir, dry_run=False, verbose=False)`（generate.py:653-919 原样，除 Step 3 的两处文案）
  - `render/__init__.py`: `Ctx` dataclass、`RENDERERS` 注册表、`render_all(pkg, ctx, targets=("homebrew","scoop")) -> dict[str, str]`
  - `core.py`: `PLATFORM_KEYS`, `load_packages(packages_dir, only=None)`, `ResolveResult`, `resolve_package(pkg, cache_dir, skip_hash=False, verbose=False) -> ResolveResult|None`, `process_package(pkg, cache_dir, skip_hash=False, verbose=False)`（tuple 兼容 API）
  - **渲染输出逐字节不变**——由现有 95 个测试保证（含 3 个 pipeline 测试）

- [ ] **Step 1: 搬移三个纯渲染模块**

homebrew.py / scoop.py 函数逐字搬移。portable.py 搬移时改两处过时文案：

```python
# render_install_sh 内（原 generate.py:736）：
f"# Do not edit — regenerate with: python -m tribucket_gen render --only {name}",
# 原两处 CLI 安装提示（原 generate.py:772-773 与 800-801）改为指向 GitHub Releases：
'echo "tribucket CLI has been archived. Running in standalone mode."',
...
f'echo "Or update manually from: https://github.com/{repo}/releases"',
# （即删除指向 scripts/install.sh 的 curl 管道安装提示；保留 standalone fallback 逻辑本身）
# render_bat 内注释（原 generate.py:833）：
"REM Auto-generated by tribucket_gen — do not edit",
```

- [ ] **Step 2: 写 render/__init__.py 注册表**

```python
"""Pluggable render targets.

Each registered renderer takes (pkg, ctx) and returns {relative_path: content}.
Add a new target (winget/AUR/Nix) by writing a module and registering it —
engine and CI need no changes.
"""
from dataclasses import dataclass, field

from . import homebrew, scoop


@dataclass
class Ctx:
    version: str
    repo: str
    platforms: dict            # platform_key -> {url, sha256}
    windows: dict              # arch_key ("64bit"|"arm64") -> {url, hash, filename}
    is_download_url: bool
    changed_version: str = None  # version when changed (download_url write-back), else None
    new_urls: dict = None


RENDERERS = {}


def register(target):
    def deco(fn):
        RENDERERS[target] = fn
        return fn
    return deco


@register("homebrew")
def render_homebrew(pkg, ctx):
    darwin_linux = {k: v for k, v in ctx.platforms.items() if not k.startswith("windows_")}
    if not darwin_linux:
        print(f"  [warn] {pkg['name']}: no macOS/Linux assets, skipping Formula")
        return {}
    info = {
        "name": pkg["name"],
        "description": pkg["description"],
        "homepage": pkg["homepage"],
        "license": pkg["license"],
        "binary": pkg["binary"],
        "version": ctx.version,
        "platforms": darwin_linux,
    }
    return {f"Formula/{pkg['name']}.rb": homebrew.render_formula(info)}


@register("scoop")
def render_scoop(pkg, ctx):
    if not ctx.windows:
        print(f"  [warn] {pkg['name']}: no Windows assets, skipping Bucket")
        return {}
    info = {
        "name": pkg["name"],
        "repo": ctx.repo,
        "description": pkg["description"],
        "homepage": pkg["homepage"],
        "license": pkg["license"],
        "binary": pkg["binary"],
        "version": ctx.version,
        "windows": ctx.windows,
    }
    return {f"bucket/{pkg['name']}.json": scoop.render_bucket(info, is_download_url=ctx.is_download_url)}


def render_all(pkg, ctx, targets=("homebrew", "scoop")):
    outputs = {}
    for t in targets:
        outputs.update(RENDERERS[t](pkg, ctx))
    return outputs
```

- [ ] **Step 3: 写 core.py（resolve_package + 兼容 process_package）**

把 generate.py:434-626 的 process_package **逻辑逐字**拆为两半：

```python
# tribucket_gen/core.py
"""Orchestration: load packages, resolve release context, render outputs."""
import os

from .release import fetch_latest_release
from .assets import match_asset
from .hashing import get_cached_hash, get_sha256_for_asset
from .render import Ctx, render_all

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]


def load_packages(packages_dir, only=None):
    # generate.py:30-49 原样搬移
    ...


class ResolveResult:
    def __init__(self, version, repo, platforms, windows, is_download_url,
                 changed_version=None, new_urls=None):
        self.version = version
        self.repo = repo
        self.platforms = platforms
        self.windows = windows
        self.is_download_url = is_download_url
        self.changed_version = changed_version
        self.new_urls = new_urls


def resolve_package(pkg, cache_dir, skip_hash=False, verbose=False):
    """Fetch latest release / run checkver, match assets, compute hashes.

    generate.py process_package 的取数半段逐字搬移：
      - download_url 分支（generate.py:465-538）返回 ResolveResult(
            version=latest_version, ..., is_download_url=True,
            changed_version=(latest_version if version_changed else None),
            new_urls=new_download_urls_for_writeback)
        'version' 缺失的报错分支（原 466-470 行）返回 None
      - GitHub release 分支（原 540-586）返回 ResolveResult(
            version=version, ..., is_download_url=False)
    """
    ...(原逻辑，platforms/windows 收集不变)...


def process_package(pkg, cache_dir, skip_hash=False, verbose=False):
    """Tuple 兼容 API：返回 (formula, bucket, changed_version, new_urls)。"""
    ctx = resolve_package(pkg, cache_dir, skip_hash=skip_hash, verbose=verbose)
    if ctx is None:
        return None, None, None, None
    outputs = render_all(pkg, ctx)
    formula = outputs.get(f"Formula/{pkg['name']}.rb")
    bucket = outputs.get(f"bucket/{pkg['name']}.json")
    return formula, bucket, ctx.changed_version, ctx.new_urls
```

（`resolve_package` 内 `from checkver import ...` 改为 `from .checkver import run_checkver, apply_autoupdate, in_place_replace`。）

- [ ] **Step 4: generate.py 委托收窄**

generate.py 删除 class_name_from/render_formula/autoupdate_url/render_bucket/infer_install_type/derive_tribucket_json/render_install_sh/render_bat/generate_portable/process_package/load_packages 函数体，改从包导入：

```python
from tribucket_gen.core import load_packages, process_package, PLATFORM_KEYS  # noqa: E402,F401
from tribucket_gen.render.homebrew import class_name_from, render_formula  # noqa: E402,F401
from tribucket_gen.render.scoop import autoupdate_url, render_bucket  # noqa: E402,F401
from tribucket_gen.render.portable import (  # noqa: E402,F401
    infer_install_type, derive_tribucket_json, render_install_sh, render_bat, generate_portable,
)
```

（main/parse_args 留在 generate.py 到 Task 5。）

- [ ] **Step 5: 验证**

```bash
python -m pytest tests/ -q
```

Expected: 全绿。3 个 pipeline 测试（test_process_package_basic / test_download_url_package_with_checkver / test_download_url_package_zero_config）现走 resolve_package + registry 渲染路径，断言不变应通过。若 `sha256 "aaa111"` 之类断言失败，检查 Ctx.platforms 传递是否丢失 checksum-file 命中路径。

- [ ] **Step 6: 注册表单测（新文件）**

`tests/test_render_registry.py`:

```python
"""Tests for the pluggable render registry."""
import json

from tribucket_gen.render import Ctx, render_all


PKG = {
    "name": "tool", "repo": "o/r", "description": "A test tool", "binary": "tool",
    "license": "MIT", "homepage": "https://github.com/o/r",
}


def _ctx():
    return Ctx(
        version="1.0.0", repo="o/r",
        platforms={
            "linux_amd64": {"url": "u1", "sha256": "a"},
            "darwin_arm64": {"url": "u2", "sha256": "b"},
            "windows_amd64": {"url": "u3", "sha256": "c"},
        },
        windows={"64bit": {"url": "u3", "hash": "c", "filename": "tool.exe"}},
        is_download_url=False,
    )


def test_render_all_outputs_both_targets():
    out = render_all(PKG, _ctx())
    assert set(out) == {"Formula/tool.rb", "bucket/tool.json"}
    assert "class Tool < Formula" in out["Formula/tool.rb"]
    assert json.loads(out["bucket/tool.json"])["version"] == "1.0.0"


def test_no_windows_assets_skips_bucket():
    ctx = _ctx()
    ctx.windows = {}
    out = render_all(PKG, ctx)
    assert set(out) == {"Formula/tool.rb"}
```

```bash
python -m pytest tests/test_render_registry.py -q   # PASS
python -m pytest tests/ -q                          # 全绿
```

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "refactor(gen): move renderers behind pluggable registry; split process_package into resolve+render"
```

---

### Task 5: 新 CLI（__main__.py）+ scripts/ 退役 + generate.yml 定稿

**Files:**
- Modify: `tribucket_gen/__main__.py`（完整重写）
- Modify: `tests/test_generate.py`、`tests/test_checkver.py`、`tests/test_checkver_fix.py`（导入切换）
- Delete: `scripts/generate.py`、`scripts/checkver.py`（scripts/ 目录消失）
- Modify: `.github/workflows/generate.yml`（定稿）

**Interfaces:**
- Consumes: Task 3/4 的全部包模块
- Produces（Task 6/7/9/10/11 依赖的命令面）:

```text
python -m tribucket_gen render [--only NAME]... [--skip-hash] [--dry-run] [--verbose] [--portable] [--portable-dir DIR]
python -m tribucket_gen check
python -m tribucket_gen draft <owner/repo> [--name N] [--description D] [--binary B] [--license L] [--homepage H] [--templates PATH] [--json] [--out FILE]
python -m tribucket_gen validate <file|-> [--json] [--packages-dir DIR] [--offline]
```

（Task 5 只实现 render/check；draft/validate 子命令在 Task 6/7 各自追加。）

- [ ] **Step 1: 重写 __main__.py**

```python
"""CLI entry: python -m tribucket_gen <command>."""
import argparse
import json
import os
import sys
import urllib.error

from . import __version__
from .assets import check_asset_patterns
from .core import load_packages, process_package
from .render.portable import generate_portable

# Windows GBK console cannot encode the ✓/❌/⚠️ symbols used below
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf8"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


def _repo_root():
    root = os.getcwd()
    if not os.path.isdir(os.path.join(root, "packages")):
        print("[error] run from the repository root (packages/ not found)")
        sys.exit(1)
    return root


def build_parser():
    p = argparse.ArgumentParser(
        prog="tribucket_gen",
        description="Generate Homebrew Formula and Scoop bucket from packages/*.json",
    )
    p.add_argument("--version", action="version", version=__version__)
    sub = p.add_subparsers(dest="command", required=True)

    r = sub.add_parser("render", help="Render Formula/*.rb and bucket/*.json from packages/*.json")
    r.add_argument("--only", action="append", default=[], help="single package (can repeat)")
    r.add_argument("--skip-hash", action="store_true", help="Skip SHA256 computation")
    r.add_argument("--dry-run", action="store_true", help="Print output, don't write files")
    r.add_argument("--verbose", action="store_true")
    r.add_argument("--portable", action="store_true", help="Also generate portable/<name>/")
    r.add_argument("--portable-dir", default=None)

    sub.add_parser("check", help="Validate asset_pattern of packages against latest releases")
    return p


def cmd_render(args):
    repo_dir = _repo_root()
    packages_dir = os.path.join(repo_dir, "packages")
    formula_dir = os.path.join(repo_dir, "Formula")
    bucket_dir = os.path.join(repo_dir, "bucket")
    cache_dir = os.path.join(repo_dir, ".cache")
    portable_dir = args.portable_dir or os.path.join(repo_dir, "portable")

    pkgs = load_packages(packages_dir, only=args.only or None)
    if not pkgs:
        print("[error] No packages found.")
        return 1

    has_errors = False
    for pkg in pkgs:
        name = pkg["name"]
        print(f"\n[{name}]")
        try:
            formula, bucket, new_version, new_urls = process_package(
                pkg, cache_dir, skip_hash=args.skip_hash, verbose=args.verbose
            )
        except urllib.error.URLError as e:
            print(f"  [warn] {name}: network error — {e}")
            continue
        except Exception as e:
            print(f"  [error] {name}: {e}")
            has_errors = True
            continue

        if formula is None and bucket is None:
            continue

        if new_version and not args.dry_run:
            pkg_path = os.path.join(packages_dir, f"{name}.json")
            try:
                with open(pkg_path, encoding="utf-8") as f:
                    pkg_data = json.load(f)
                pkg_data["version"] = new_version
                if new_urls:
                    pkg_data["download_url"] = new_urls
                with open(pkg_path, "w", encoding="utf-8") as f:
                    json.dump(pkg_data, f, indent=2, ensure_ascii=False)
                    f.write("\n")
                print(f"  -> packages/{name}.json (version → {new_version})")
            except Exception as e:
                print(f"  [warn] {name}: failed to write back version: {e}")

        if args.dry_run:
            if formula:
                print(f"\n--- Formula/{name}.rb ---")
                print(formula)
            if bucket:
                print(f"\n--- bucket/{name}.json ---")
                print(bucket)
            if args.portable:
                generate_portable(pkg, portable_dir, dry_run=True, verbose=args.verbose)
        else:
            if formula:
                os.makedirs(formula_dir, exist_ok=True)
                with open(os.path.join(formula_dir, f"{name}.rb"), "w", encoding="utf-8") as f:
                    f.write(formula)
                print(f"  -> Formula/{name}.rb")
            if bucket:
                os.makedirs(bucket_dir, exist_ok=True)
                with open(os.path.join(bucket_dir, f"{name}.json"), "w", encoding="utf-8") as f:
                    f.write(bucket)
                print(f"  -> bucket/{name}.json")
            if args.portable:
                generate_portable(pkg, portable_dir, verbose=args.verbose)
                print(f"  -> portable/{name}/")

    print(f"\nDone. Processed {len(pkgs)} package(s).")
    if has_errors:
        print("Some packages had errors (see above).")
        return 2
    return 0


def cmd_check(args):
    repo_dir = _repo_root()
    pkgs = load_packages(os.path.join(repo_dir, "packages"))
    if not pkgs:
        print("[error] No packages found.")
        return 1
    print(f"Checking asset patterns for {len(pkgs)} package(s)...\n")
    ok = check_asset_patterns(pkgs)
    print(f"\n{'All patterns OK.' if ok else 'Some patterns have issues (see above).'}")
    return 0 if ok else 1


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.command == "render":
        return cmd_render(args)
    if args.command == "check":
        return cmd_check(args)
    return 1


if __name__ == "__main__":
    sys.exit(main())
```

（注意：保留原 generate.py main 中的 aria2 探测横幅可选——如需保留可调用 `release._has_aria2()` 打印一行，非必需。）

- [ ] **Step 2: 切换测试导入**

`tests/test_generate.py` 顶部：

```python
"""Tests for tribucket_gen (moved from scripts/generate.py)."""
import json
import hashlib
import pytest

from tribucket_gen.assets import (
    match_asset, is_checksum_asset, infer_asset_format, check_asset_patterns,
)
from tribucket_gen.core import load_packages, process_package, PLATFORM_KEYS
from tribucket_gen.release import http_get, fetch_latest_release, parse_release
from tribucket_gen.hashing import (
    compute_sha256, parse_checksum_file, get_cached_hash, write_cache,
    get_sha256_for_asset,
)
from tribucket_gen.render.homebrew import render_formula, class_name_from
from tribucket_gen.render.scoop import render_bucket, autoupdate_url
from tribucket_gen.render.portable import (
    render_install_sh, render_bat, generate_portable,
    derive_tribucket_json, infer_install_type,
)
```

然后机械替换：`sed -i 's/generate\.//g' tests/test_generate.py`（删除 `import generate` 行、删除原 sys.path 两行；`generate.parse_args` 的引用属于 Task Step 4 的重写类）。

`tests/test_checkver.py`：删 sys.path 两行，`import checkver` → `from tribucket_gen import checkver`。
`tests/test_checkver_fix.py`：同上替换 import（该文件整体 skip，仅保持可收集）。

- [ ] **Step 3: 重写 parser 相关测试**

TestParseArgs / TestParseArgsPortable 两个类替换为：

```python
class TestRenderArgs:
    def test_defaults(self):
        args = build_parser().parse_args(["render"])
        assert args.only == []
        assert args.skip_hash is False and args.dry_run is False and args.verbose is False

    def test_only_multiple(self):
        args = build_parser().parse_args(["render", "--only", "ccx", "--only", "bat"])
        assert args.only == ["ccx", "bat"]

    def test_flags(self):
        args = build_parser().parse_args(["render", "--skip-hash", "--dry-run", "--verbose"])
        assert args.skip_hash and args.dry_run and args.verbose

    def test_portable(self):
        args = build_parser().parse_args(["render", "--portable", "--portable-dir", "/tmp/x"])
        assert args.portable and args.portable_dir == "/tmp/x"

    def test_check_subcommand(self):
        args = build_parser().parse_args(["check"])
        assert args.command == "check"

    def test_requires_command(self):
        with pytest.raises(SystemExit):
            build_parser().parse_args([])
```

（`build_parser` 从 `tribucket_gen.__main__` 导入：`from tribucket_gen.__main__ import build_parser`。）

- [ ] **Step 4: 删除 scripts/，generate.yml 定稿**

```bash
git rm scripts/generate.py scripts/checkver.py
```

`.github/workflows/generate.yml` 定稿（完整文件）：

```yaml
name: Generate Formula & Bucket

on:
  push:
    branches: [main]
    paths: ['packages/**']
  schedule:
    - cron: '17 5 * * *'  # Daily at 05:17 UTC
  workflow_dispatch:

permissions:
  contents: write

jobs:
  generate:
    timeout-minutes: 45
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      - name: Install aria2
        run: sudo apt-get update -qq && sudo apt-get install -y -qq aria2

      - name: Generate Formula and Bucket
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: python -u -m tribucket_gen render

      - name: Check for changes
        id: diff
        run: |
          git diff --quiet Formula/ bucket/ packages/ && echo "changed=false" >> "$GITHUB_OUTPUT" || echo "changed=true" >> "$GITHUB_OUTPUT"

      - name: Commit and push
        if: steps.diff.outputs.changed == 'true'
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add Formula/ bucket/ packages/
          python3 - <<'PY'
          # ……此步骤内原有 commit-msg 生成 python 脚本**原样保留**（generate.yml:50-108），此处不重复
          PY
          git commit -F commit_msg.txt
          rm -f commit_msg.txt
          git pull --rebase origin main
          git push
```

（执行者从现文件复制 50-108 行的 python heredoc 原文，勿凭记忆重写。）

- [ ] **Step 5: 验证**

```bash
python -m pytest tests/ -q                                # 全绿
python -m tribucket_gen render --only bat --dry-run --skip-hash   # 需网络；打印 Formula/bat.rb 内容后不写文件
python -m tribucket_gen check --help                      # usage 正常
ls scripts/ 2>/dev/null || echo "scripts/ gone"
```

（dry-run 验证需要网络；若环境无网，用 `python -m tribucket_gen render --help` + pytest 覆盖即可，网络验证延后到 Task 13。）

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat(gen): new tribucket_gen CLI (render/check); retire scripts/; finalize generate.yml (daily cron)"
```

---

### Task 6: draft.py —— Release 资产 → 包定义（TDD）

**Files:**
- Create: `tribucket_gen/draft.py`
- Test: `tests/test_draft.py`
- Modify: `tribucket_gen/__main__.py`（追加 draft 子命令）

**Interfaces:**
- Consumes: `release.fetch_latest_release(repo, token=None) -> (version, assets, checksums)`；`assets.match_asset(assets, pattern)`；`skills/tribucket-gen/templates.json`（权威源）
- Produces（Task 9/10 workflow 依赖）:
  - `draft(repo, *, name=None, description=None, binary=None, license_id=None, homepage=None, templates_path=None, fetcher=None, meta_fetcher=None, token=None) -> (pkg_dict, notes)`；无模板命中抛 `DraftError(message, assets=[...])`
  - CLI `draft` 子命令退出码：0 成功；1 瞬时错误（网络/无效 repo）；2 无模板命中（needs-manual）
  - 输出 JSON 符合 packages/*.json schema（name/repo/description/binary/license/homepage/asset_pattern）

- [ ] **Step 1: 写失败测试**

`tests/test_draft.py`:

```python
"""Tests for tribucket_gen.draft — template matching from release assets."""
import json
import pytest

from tribucket_gen import draft as draft_mod
from tribucket_gen.draft import DraftError, draft, load_templates, sanitize_name


def asset(name):
    return {"name": name, "browser_download_url": f"https://github.com/o/r/releases/download/v1.0.0/{name}"}


def fake_fetcher(release_assets, version="1.0.0"):
    def _f(repo, token=None):
        return version, release_assets, []
    return _f


FAKE_META = {"description": "A cool tool", "license": "MIT"}


def meta_fetcher(repo):
    return FAKE_META


TEMPLATES = load_templates()  # 真实的 skills/tribucket-gen/templates.json


def test_sanitize_name():
    assert sanitize_name("My Tool") == "my-tool"
    assert sanitize_name("Rust_Grep!!") == "rust-grep"
    assert sanitize_name("") == ""


def test_rust_triple_bare_template():
    assets = [
        asset("ripgrep-14.1.1-x86_64-unknown-linux-gnu.tar.gz"),
        asset("ripgrep-14.1.1-aarch64-unknown-linux-gnu.tar.gz"),
        asset("ripgrep-14.1.1-x86_64-apple-darwin.tar.gz"),
        asset("ripgrep-14.1.1-aarch64-apple-darwin.tar.gz"),
        asset("ripgrep-14.1.1-x86_64-pc-windows-msvc.zip"),
        asset("templates.json"),
    ]
    pkg, notes = draft("o/ripgrep", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert pkg["name"] == "ripgrep"
    assert pkg["repo"] == "o/ripgrep"
    assert pkg["license"] == "MIT"
    assert pkg["asset_pattern"]["linux_amd64"] == "x86_64-unknown-linux-gnu.tar.gz"
    assert pkg["asset_pattern"]["darwin_arm64"] == "aarch64-apple-darwin.tar.gz"
    assert pkg["asset_pattern"]["windows_amd64"] == "x86_64-pc-windows-msvc.zip"


def test_simple_hyphen_template_and_name_override():
    assets = [
        asset("cosign-linux-amd64"), asset("cosign-linux-arm64"),
        asset("cosign-darwin-amd64"), asset("cosign-darwin-arm64"),
        asset("cosign-windows-amd64.exe"),
    ]
    pkg, _ = draft("o/cosign", name="Cosign Tool", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert pkg["name"] == "cosign-tool"
    assert pkg["asset_pattern"]["linux_amd64"] == "cosign-linux-amd64"
    assert pkg["asset_pattern"]["windows_arm64"] == "NO_MATCH"  # 资产不存在 → NO_MATCH


def test_underscore_version_uses_glob_for_version():
    assets = [
        asset("lazygit_0.41.0_linux_x86_64.tar.gz"),
        asset("lazygit_0.41.0_linux_arm64.tar.gz"),
        asset("lazygit_0.41.0_darwin_x86_64.tar.gz"),
        asset("lazygit_0.41.0_darwin_arm64.tar.gz"),
        asset("lazygit_0.41.0_windows_x86_64.zip"),
    ]
    pkg, _ = draft("o/lazygit", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    # 版本号嵌入文件名 → 用 * 代替 {name}_{version}，否则下个版本就失配
    assert pkg["asset_pattern"]["linux_amd64"] == "*_linux_x86_64.tar.gz"
    assert pkg["asset_pattern"]["windows_amd64"] == "*_windows_x86_64.zip"


def test_no_template_match_raises_with_assets():
    assets = [asset("totally-weird-bin")]
    with pytest.raises(DraftError) as e:
        draft("o/weird", fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert "totally-weird-bin" in str(e.value.assets)


def test_description_and_license_overrides_beat_meta():
    assets = [asset("tool-linux-amd64"), asset("tool-darwin-amd64")]
    pkg, _ = draft(
        "o/tool", description="My own desc", license_id="Apache-2.0",
        fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher,
    )
    assert pkg["description"] == "My own desc"
    assert pkg["license"] == "Apache-2.0"


def test_description_cleaned_of_control_chars():
    assets = [asset("tool-linux-amd64"), asset("tool-darwin-amd64")]
    pkg, _ = draft("o/tool", description="bad\x01desc\"quote",
                   fetcher=fake_fetcher(assets), meta_fetcher=meta_fetcher)
    assert "\x01" not in pkg["description"]
    assert '"' not in pkg["description"]
```

- [ ] **Step 2: 运行确认失败**

```bash
python -m pytest tests/test_draft.py -q
```

Expected: FAIL（ModuleNotFoundError: tribucket_gen.draft）

- [ ] **Step 3: 实现 draft.py**

```python
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

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]

NAME_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")


class DraftError(Exception):
    def __init__(self, message, assets=None):
        super().__init__(message)
        self.assets = assets or []


def sanitize_name(raw):
    n = re.sub(r"[^a-z0-9-]+", "-", (raw or "").lower()).strip("-")
    return n


def clean_text(s):
    """Strip control chars and double quotes (they break .rb/.json interpolation)."""
    return re.sub(r"[\x00-\x1f\x7f\"]", "", (s or "")).strip()


def load_templates(path=None):
    p = Path(path) if path else DEFAULT_TEMPLATES_PATH
    with open(p, encoding="utf-8") as f:
        return json.load(f)["templates"]


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


def choose_template(templates, assets, name):
    scored = [(score_template(t, assets, name), t.get("frequency", 0), t) for t in templates]
    scored = [s for s in scored if s[0] > 0]
    if not scored:
        raise DraftError(
            "no known template matches this repo's release assets",
            assets=[a["name"] for a in assets],
        )
    scored.sort(key=lambda x: (x[0], x[1]), reverse=True)
    return scored[0][2]


def detect_libc(assets):
    return "musl" if any("musl" in a["name"] for a in assets) else "gnu"


def build_asset_pattern(tpl, name, assets):
    libc = detect_libc(assets)
    pattern = {}
    for plat in PLATFORM_KEYS:
        rule = tpl.get("match_rule", {}).get(plat)
        if not rule or rule == "NO_MATCH":
            pattern[plat] = "NO_MATCH"
            continue
        pat = rule.replace("{name}_{version}", "*").replace("{version}", "*")
        pat = pat.replace("{name}", name).replace("{libc}", libc)
        # 生成的 pattern 若匹配不到任何真实资产 → NO_MATCH（宁缺勿错）
        pattern[plat] = pat if match_asset(assets, pat) else "NO_MATCH"
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

    templates = load_templates(templates_path)
    pkg_name = sanitize_name(name) or sanitize_name(repo.split("/")[-1])
    if not pkg_name or not NAME_RE.match(pkg_name):
        raise DraftError(f"invalid package name: {pkg_name!r}")

    tpl = choose_template(templates, all_assets, pkg_name)
    asset_pattern = build_asset_pattern(tpl, pkg_name, all_assets)
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
```

- [ ] **Step 4: 跑测试到绿**

```bash
python -m pytest tests/test_draft.py -q    # PASS
python -m pytest tests/ -q                 # 全绿
```

若 `test_rust_triple_bare_template` 失败于 windows_amd64 得到 NO_MATCH：检查 `_compile_detect` 的 `{name_pattern}` 替换——rust-triple-bare 的 detect 无 `{name_pattern}`（裸 triple），确认 `_name_regex` 只在有占位符时注入。

- [ ] **Step 5: 接入 CLI draft 子命令**

`tribucket_gen/__main__.py`：build_parser 的 sub 下追加（Task 5 的 build_parser 已有结构）：

```python
    d = sub.add_parser("draft", help="Draft a packages/*.json definition from a GitHub repo")
    d.add_argument("repo")
    d.add_argument("--name")
    d.add_argument("--description")
    d.add_argument("--binary")
    d.add_argument("--license", dest="license_id")
    d.add_argument("--homepage")
    d.add_argument("--templates", default=None, help="Override templates.json path")
    d.add_argument("--json", action="store_true", help="Print machine-readable JSON only")
    d.add_argument("--out", default=None, help="Write definition to this path")
```

main() 追加分支：

```python
    if args.command == "draft":
        return cmd_draft(args)
```

cmd_draft：

```python
def cmd_draft(args):
    from .draft import DraftError, draft
    try:
        pkg, notes = draft(
            args.repo, name=args.name, description=args.description,
            binary=args.binary, license_id=args.license_id, homepage=args.homepage,
            templates_path=args.templates,
        )
    except DraftError as e:
        is_no_template = "no known template" in str(e)
        print(f"[draft error] {e}", file=sys.stderr)
        for a in e.assets[:20]:
            print(f"  asset: {a}", file=sys.stderr)
        return 2 if is_no_template else 1
    except Exception as e:  # network etc.
        print(f"[draft error] {e}", file=sys.stderr)
        return 1
    if args.json or args.out:
        payload = json.dumps(pkg, indent=2, ensure_ascii=False) + "\n"
        if args.out:
            with open(args.out, "w", encoding="utf-8") as f:
                f.write(payload)
        else:
            print(payload, end="")
    else:
        print(json.dumps(pkg, indent=2, ensure_ascii=False))
        for n in notes:
            print(f"# {n}")
    return 0
```

测试：

```bash
python -m pytest tests/ -q
python -m tribucket_gen draft sharkdp/bat --json    # 需网络；输出 bat 的定义 JSON
```

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat(gen): draft subcommand — release assets to package definition via templates.json"
```

---

### Task 7: validate.py —— 定义校验（TDD）

**Files:**
- Create: `tribucket_gen/validate.py`
- Test: `tests/test_validate.py`
- Modify: `tribucket_gen/__main__.py`（追加 validate 子命令）

**Interfaces:**
- Consumes: `assets.match_asset`；fetcher 可注入（默认 `release.fetch_latest_release`）
- Produces（Task 9/10 workflow 依赖）:
  - `validate_definition(pkg, packages_dir=None, fetch_release=None, token=None) -> (errors: list[str], warnings: list[str])`
  - CLI `validate <file|-> [--json] [--packages-dir DIR] [--offline]`，退出码 0/1；`--json` 输出 `{"ok": bool, "errors": [...], "warnings": [...]}`

- [ ] **Step 1: 写失败测试**

`tests/test_validate.py`:

```python
"""Tests for tribucket_gen.validate."""
import pytest

from tribucket_gen.validate import validate_definition


def asset(name):
    return {"name": name, "browser_download_url": f"https://x/{name}"}


def fake_fetch(assets):
    def _f(repo, token=None):
        return "1.0.0", assets, []
    return _f


GOOD = {
    "name": "tool", "repo": "o/r", "description": "A tool",
    "binary": "tool", "license": "MIT", "homepage": "https://github.com/o/r",
    "asset_pattern": {
        "linux_amd64": "tool-linux-amd64.tar.gz", "linux_arm64": "NO_MATCH",
        "darwin_amd64": "tool-darwin-amd64.tar.gz", "darwin_arm64": "NO_MATCH",
        "windows_amd64": "tool-windows-amd64.exe", "windows_arm64": "NO_MATCH",
    },
}
RELEASE_ASSETS = [
    asset("tool-linux-amd64.tar.gz"), asset("tool-darwin-amd64.tar.gz"),
    asset("tool-windows-amd64.exe"),
]


def test_good_definition_passes(tmp_path):
    errs, warns = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=fake_fetch(RELEASE_ASSETS))
    assert errs == []
    assert warns == []


def test_missing_required_fields():
    errs, _ = validate_definition({"name": "x"}, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("repo" in e for e in errs) and any("description" in e for e in errs)


def test_invalid_name():
    pkg = dict(GOOD, name="Bad_Name")
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("invalid name" in e for e in errs)


def test_quote_in_description_rejected():
    pkg = dict(GOOD, description='has "quotes"')
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("control characters or double quotes" in e for e in errs)


def test_missing_platform_key():
    pkg = {**GOOD, "asset_pattern": {k: v for k, v in GOOD["asset_pattern"].items() if k != "linux_arm64"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("linux_arm64" in e for e in errs)


def test_pattern_matching_nothing_rejected():
    pkg = {**GOOD, "asset_pattern": {**GOOD["asset_pattern"], "linux_amd64": "nonexistent-*.tar.gz"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("matches no asset" in e for e in errs)


def test_too_few_matching_platforms_rejected():
    pkg = {**GOOD, "asset_pattern": {**GOOD["asset_pattern"],
           "darwin_amd64": "NO_MATCH", "windows_amd64": "NO_MATCH"}}
    errs, _ = validate_definition(pkg, fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("near-zero output" in e for e in errs)


def test_duplicate_name_rejected(tmp_path):
    (tmp_path / "tool.json").write_text("{}", encoding="utf-8")
    errs, _ = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=fake_fetch(RELEASE_ASSETS))
    assert any("already exists" in e for e in errs)


def test_network_error_becomes_warning():
    def boom(repo, token=None):
        raise RuntimeError("timeout")
    errs, warns = validate_definition(GOOD, fetch_release=boom)
    assert errs == [] and any("could not fetch release" in w for w in warns)


def test_offline_skips_online_check(tmp_path):
    errs, warns = validate_definition(GOOD, packages_dir=str(tmp_path), fetch_release=None)
    assert errs == [] and warns == []
```

- [ ] **Step 2: 运行确认失败**

```bash
python -m pytest tests/test_validate.py -q   # FAIL: ModuleNotFoundError
```

- [ ] **Step 3: 实现 validate.py**

```python
"""Validate packages/*.json definitions (schema + online asset resolution)."""
import os
import re

NAME_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")
REPO_RE = re.compile(r"^[\w.-]+/[\w.-]+$")

PLATFORM_KEYS = [
    "linux_amd64", "linux_arm64",
    "darwin_amd64", "darwin_arm64",
    "windows_amd64", "windows_arm64",
]
REQUIRED_FIELDS = ["name", "repo", "description", "binary", "license", "homepage"]
STRING_FIELDS = ["name", "repo", "description", "binary", "license", "homepage"]
MIN_MATCHED_PLATFORMS = 2


def validate_definition(pkg, packages_dir=None, fetch_release=None, token=None):
    """Return (errors, warnings). fetch_release(repo) -> (version, assets, checksums)."""
    errors, warnings = [], []
    if not isinstance(pkg, dict):
        return ["definition is not a JSON object"], []

    for f in REQUIRED_FIELDS:
        if not pkg.get(f):
            errors.append(f"missing required field: {f}")

    name = pkg.get("name", "") or ""
    if name and not NAME_RE.match(name):
        errors.append(f"invalid name {name!r}: must match ^[a-z0-9][a-z0-9-]*$")

    repo = pkg.get("repo", "") or ""
    if repo and not REPO_RE.match(repo):
        errors.append(f"invalid repo {repo!r}: expected owner/repo")

    for f in STRING_FIELDS:
        v = pkg.get(f)
        if isinstance(v, str) and (re.search(r"[\x00-\x1f\x7f]", v) or '"' in v):
            errors.append(f"field {f!r} contains control characters or double quotes")

    ap = pkg.get("asset_pattern")
    if not isinstance(ap, dict):
        errors.append("asset_pattern must be an object")
    else:
        for k in PLATFORM_KEYS:
            if k not in ap:
                errors.append(f"asset_pattern missing platform key: {k}")
        for k in ap:
            if k not in PLATFORM_KEYS:
                errors.append(f"unknown platform key: {k}")

    if packages_dir and name and os.path.exists(os.path.join(packages_dir, f"{name}.json")):
        errors.append(f"package {name!r} already exists in packages/")

    if ap and isinstance(ap, dict) and fetch_release is not None and repo and REPO_RE.match(repo):
        try:
            _, assets, _ = fetch_release(repo)
        except Exception as e:
            warnings.append(f"could not fetch release for {repo}: {e}")
            return errors, warnings
        from .assets import match_asset
        matched = 0
        for k in PLATFORM_KEYS:
            pat = ap.get(k)
            if not pat or pat == "NO_MATCH":
                continue
            if match_asset(assets, pat):
                matched += 1
            else:
                errors.append(f"asset_pattern[{k}] {pat!r} matches no asset in latest release")
        if matched < MIN_MATCHED_PLATFORMS:
            errors.append(
                f"only {matched} platform(s) match — package would produce zero or near-zero output"
            )
    return errors, warnings
```

- [ ] **Step 4: 跑测试到绿**

```bash
python -m pytest tests/test_validate.py -q   # PASS
python -m pytest tests/ -q
```

- [ ] **Step 5: 接入 CLI validate 子命令**

__main__.py build_parser 追加：

```python
    v = sub.add_parser("validate", help="Validate a package definition file")
    v.add_argument("file", help="Path to definition JSON, or '-' for stdin")
    v.add_argument("--json", action="store_true")
    v.add_argument("--packages-dir", default=None)
    v.add_argument("--offline", action="store_true", help="Skip online asset check")
```

main() 分支与实现：

```python
def cmd_validate(args):
    from .validate import validate_definition
    if args.file == "-":
        pkg = json.load(sys.stdin)
    else:
        with open(args.file, encoding="utf-8") as f:
            pkg = json.load(f)
    packages_dir = args.packages_dir or os.path.join(os.getcwd(), "packages")
    fetch = None
    if not args.offline:
        from .release import fetch_latest_release
        fetch = fetch_latest_release
    errors, warnings = validate_definition(pkg, packages_dir=packages_dir, fetch_release=fetch)
    if args.json:
        print(json.dumps({"ok": not errors, "errors": errors, "warnings": warnings},
                         ensure_ascii=False, indent=2))
    else:
        for e in errors:
            print(f"[error] {e}")
        for w in warnings:
            print(f"[warn] {w}")
        print("OK" if not errors else f"{len(errors)} error(s)")
    return 0 if not errors else 1
```

```bash
python -m pytest tests/ -q
```

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat(gen): validate subcommand — schema, online asset resolution, duplicate checks"
```

---

### Task 8: Issue 表单与 config

**Files:**
- Create: `.github/ISSUE_TEMPLATE/package-submission.yml`、`.github/ISSUE_TEMPLATE/config.yml`

**Interfaces:**
- Produces（Task 9 解析器依赖的**确切标题**）: `### 仓库 URL`、`### 包名`、`### 一句话描述`、`### binary 名称`、`### license`、`### 备注`；触发标记 = body 含 `### 仓库 URL`

- [ ] **Step 1: 写表单**

`.github/ISSUE_TEMPLATE/package-submission.yml`:

```yaml
name: 提交新软件包
description: 提交一个新包 —— CI 自动生成 Homebrew Formula 和 Scoop bucket
title: "[pkg] "
labels: ["submission"]
body:
  - type: markdown
    attributes:
      value: |
        填写基本信息即可，机器人会分析该仓库的最新 Release 并自动生成包定义。
        生成结果会以评论贴回本 Issue；**由提交者本人**回复 `@tribucket-bot confirm` 即可自动入库。
  - type: input
    id: repo
    attributes:
      label: 仓库 URL
      description: GitHub 仓库地址（需公开发布 Release）
      placeholder: https://github.com/owner/repo
    validations:
      required: true
  - type: input
    id: name
    attributes:
      label: 包名
      description: 留空则使用仓库名（小写字母、数字、连字符）
    validations:
      required: false
  - type: input
    id: description
    attributes:
      label: 一句话描述
      description: 英文一句话，将写入 Formula 与 bucket
    validations:
      required: true
  - type: input
    id: binary
    attributes:
      label: binary 名称
      description: 安装后的可执行文件名，留空则使用包名
    validations:
      required: false
  - type: input
    id: license
    attributes:
      label: license
      description: SPDX 标识（如 MIT、Apache-2.0），留空则从 GitHub 自动探测
    validations:
      required: false
  - type: textarea
    id: notes
    attributes:
      label: 备注
      description: 特殊说明（平台限制、特殊命名等）
    validations:
      required: false
```

`.github/ISSUE_TEMPLATE/config.yml`:

```yaml
blank_issues_enabled: false
contact_links:
  - name: 其他话题
    url: https://github.com/shisheng820/tribucket/discussions
    about: 非包提交的讨论请到 Discussions
```

- [ ] **Step 2: 验证并提交**

```bash
python -c "import yaml,sys; yaml.safe_load(open('.github/ISSUE_TEMPLATE/package-submission.yml',encoding='utf-8')); yaml.safe_load(open('.github/ISSUE_TEMPLATE/config.yml',encoding='utf-8')); print('yaml ok')" 2>/dev/null || python -m pytest tests/ -q  # yaml 模块缺失则跳过语法检查
python -m pytest tests/ -q
git add .github/ISSUE_TEMPLATE/
git commit -m "feat(ci): package submission issue form"
```

---

### Task 9: issue-draft.yml —— 草稿生成流水线

**Files:**
- Create: `.github/workflows/issue-draft.yml`

**Interfaces:**
- Consumes: Task 6 `draft` 子命令（退出码 0/1/2）、Task 7 `validate --json`、Task 8 表单标记
- Produces: Issue 上的草稿评论 + `drafted` 标签；失败路径的错误评论（rc=2 → `needs-manual` + 关闭）

- [ ] **Step 1: 写 workflow（完整文件）**

```yaml
name: Issue Draft

on:
  issues:
    types: [opened, edited]

permissions:
  contents: read
  issues: write

concurrency:
  group: issue-draft-${{ github.event.issue.number }}
  cancel-in-progress: true

jobs:
  draft:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    if: contains(github.event.issue.body, '### 仓库 URL')
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      - name: Ensure labels
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          gh label create drafted --color 0E8A16 --force
          gh label create processing --color FBCA04 --force
          gh label create needs-manual --color D93F0B --force

      - name: Parse submission form
        env:
          ISSUE_BODY: ${{ github.event.issue.body }}
        run: |
          python3 - <<'PY'
          import json, os, re
          body = os.environ["ISSUE_BODY"]
          fields = {}
          for chunk in body.split("\n### ")[1:]:
              lines = chunk.splitlines()
              key = lines[0].strip()
              val = "\n".join(lines[1:]).strip()
              if val in ("_No response_", ""):
                  val = ""
              fields[key] = val
          def need(label):
              v = fields.get(label, "").strip()
              if not v:
                  raise SystemExit(f"missing required field: {label}")
              return v
          data = {
              "repo": need("仓库 URL"),
              "name": fields.get("包名", ""),
              "description": need("一句话描述"),
              "binary": fields.get("binary 名称", ""),
              "license": fields.get("license", ""),
              "notes": fields.get("备注", ""),
          }
          m = re.match(r"^https://github\.com/([\w.-]+)/([\w.-]+)/?$", data["repo"])
          if not m:
              raise SystemExit(f"invalid repo URL: {data['repo']}")
          data["repo"] = m.group(1) + "/" + m.group(2)
          if data["repo"].endswith(".git"):
              data["repo"] = data["repo"][:-4]
          with open("form.json", "w", encoding="utf-8") as f:
              json.dump(data, f, ensure_ascii=False)
          PY

      - name: Rate limit (max 3 open submissions per user)
        env:
          GH_TOKEN: ${{ github.token }}
          AUTHOR: ${{ github.event.issue.user.login }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          COUNT=$(gh issue list --author "$AUTHOR" --state open --limit 100 --json body \
            | python3 -c 'import json,sys; print(sum(1 for i in json.load(sys.stdin) if "### 仓库 URL" in (i.get("body") or "")))')
          echo "open submissions by $AUTHOR: $COUNT"
          if [ "$COUNT" -gt 3 ]; then
            gh issue comment "$ISSUE_NUM" --body "提交过于频繁：你已有 $COUNT 个进行中的提交 Issue（上限 3）。请等待现有提交完成后再提交新包。"
            gh issue close "$ISSUE_NUM"
            exit 1
          fi

      - name: Draft package definition
        id: draft
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          set +e
          REPO=$(jq -r .repo form.json)
          ARGS=(draft "$REPO")
          N=$(jq -r '.name // empty' form.json);        [ -z "$N" ] || ARGS+=(--name "$N")
          D=$(jq -r '.description // empty' form.json); [ -z "$D" ] || ARGS+=(--description "$D")
          B=$(jq -r '.binary // empty' form.json);      [ -z "$B" ] || ARGS+=(--binary "$B")
          L=$(jq -r '.license // empty' form.json);     [ -z "$L" ] || ARGS+=(--license "$L")
          python3 -u -m tribucket_gen "${ARGS[@]}" --json --out draft.json 2> draft_err.txt
          rc=$?
          set -e
          echo "rc=$rc" >> "$GITHUB_OUTPUT"
          exit $rc

      - name: Handle no-template failure (rc=2)
        if: failure() && steps.draft.outputs.rc == '2'
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          {
            echo "❌ 无法自动生成包定义——该仓库的 Release 资产命名不在已知模板内。"
            echo '```'
            head -c 800 draft_err.txt
            echo '```'
            echo "已关闭本 Issue 并加 needs-manual 标签，由维护者人工处理。"
          } > comment.md
          gh issue comment "$ISSUE_NUM" --body-file comment.md
          gh issue edit "$ISSUE_NUM" --add-label needs-manual
          gh issue close "$ISSUE_NUM"

      - name: Handle transient failure (rc=1)
        if: failure() && steps.draft.outputs.rc == '1'
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          {
            echo "⚠️ 自动生成遇到临时错误（可能是网络或 GitHub API）："
            echo '```'
            head -c 400 draft_err.txt
            echo '```'
            echo "稍后编辑本 Issue 即会自动重试。"
          } > comment.md
          gh issue comment "$ISSUE_NUM" --body-file comment.md

      - name: Validate definition
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          python3 -u -m tribucket_gen validate draft.json --json > validate.json
          if [ "$(jq -r .ok validate.json)" != "true" ]; then
            {
              echo "❌ 校验未通过，请修改 Issue 后重新提交（编辑本 Issue 会自动重新生成）："
              echo
              jq -r '.errors[] | "- " + .' validate.json
            } > comment.md
            gh issue comment "$ISSUE_NUM" --body-file comment.md
            exit 1
          fi

      - name: Comment draft on issue
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          python3 - <<'PY' > comment.md
          import json
          pkg = json.load(open("draft.json", encoding="utf-8"))
          print("🤖 已根据最新 Release 资产自动生成包定义：")
          print()
          print("```json")
          print(json.dumps(pkg, indent=2, ensure_ascii=False))
          print("```")
          print()
          print("请检查以上定义。确认无误后，**由本 Issue 作者**回复 `@tribucket-bot confirm` 即可自动入库")
          print("（一次 commit 写入 `packages/<name>.json` + `Formula/<name>.rb` + `bucket/<name>.json`）。")
          print("如需修改，直接编辑本 Issue，机器人会重新生成。")
          PY
          gh issue comment "$ISSUE_NUM" --body-file comment.md
          gh issue edit "$ISSUE_NUM" --add-label drafted
```

- [ ] **Step 2: 静态验证**

```bash
python -m pytest tests/ -q
python -c "import yaml; yaml.safe_load(open('.github/workflows/issue-draft.yml', encoding='utf-8')); print('yaml ok')" 2>/dev/null || echo "yaml module unavailable — review manually"
git add .github/workflows/issue-draft.yml
git commit -m "feat(ci): issue draft workflow — auto-generate package definition from submission form"
```

---

### Task 10: issue-confirm.yml —— 确认入库流水线（单 commit）

**Files:**
- Create: `.github/workflows/issue-confirm.yml`

**Interfaces:**
- Consumes: Task 6/7 的 draft/validate、Task 5 的 render 子命令、Task 9 的表单解析逻辑
- Produces: 单 commit（`pkg: add <name> (via #<N>)`）包含 packages/<n>.json + Formula/<n>.rb + bucket/<n>.json；Issue 关闭

- [ ] **Step 1: 写 workflow（完整文件）**

```yaml
name: Issue Confirm

on:
  issue_comment:
    types: [created]

permissions:
  contents: write
  issues: write

concurrency:
  group: package-commits
  cancel-in-progress: false

jobs:
  confirm:
    runs-on: ubuntu-latest
    timeout-minutes: 45
    if: >-
      github.event.issue.pull_request == null &&
      github.event.comment.user.login == github.event.issue.user.login &&
      github.event.comment.body == '@tribucket-bot confirm'
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      - name: Install aria2
        run: sudo apt-get update -qq && sudo apt-get install -y -qq aria2

      - name: Check labels
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          LABELS="$(gh issue view "$ISSUE_NUM" --json labels -q '[.labels[].name] | join(",")')"
          echo "labels: $LABELS"
          case ",$LABELS," in
            *,drafted,*) ;;
            *) echo "issue is not in drafted state"; exit 1;;
          esac
          case ",$LABELS," in
            *,processing,*) echo "already processing"; exit 1;;
          esac

      - name: Mark processing
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: gh issue edit "$ISSUE_NUM" --remove-label drafted --add-label processing

      - name: Parse submission form
        env:
          ISSUE_BODY: ${{ github.event.issue.body }}
        run: |
          python3 - <<'PY'
          # 与 issue-draft.yml 的解析脚本**逐字相同**（form.json 输出），此处不重复
          PY

      - name: Re-draft and validate
        id: regen
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          set +e
          REPO=$(jq -r .repo form.json)
          ARGS=(draft "$REPO")
          N=$(jq -r '.name // empty' form.json);        [ -z "$N" ] || ARGS+=(--name "$N")
          D=$(jq -r '.description // empty' form.json); [ -z "$D" ] || ARGS+=(--description "$D")
          B=$(jq -r '.binary // empty' form.json);      [ -z "$B" ] || ARGS+=(--binary "$B")
          L=$(jq -r '.license // empty' form.json);     [ -z "$L" ] || ARGS+=(--license "$L")
          python3 -u -m tribucket_gen "${ARGS[@]}" --json --out draft.json 2> regen_err.txt
          rc=$?
          set -e
          if [ $rc -ne 0 ]; then
            gh issue comment ${{ github.event.issue.number }} --body "❌ 重新生成失败（Release 可能已变化）：$(head -c 300 regen_err.txt)"
            gh issue edit ${{ github.event.issue.number }} --remove-label processing --add-label drafted
            exit 1
          fi
          python3 -u -m tribucket_gen validate draft.json --json > validate.json
          if [ "$(jq -r .ok validate.json)" != "true" ]; then
            gh issue comment ${{ github.event.issue.number }} --body "❌ 确认时校验未通过：$(jq -r '.errors | join("; ")' validate.json)"
            gh issue edit ${{ github.event.issue.number }} --remove-label processing --add-label drafted
            exit 1
          fi

      - name: Render Formula and Bucket
        id: render
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          NAME=$(jq -r .name draft.json)
          echo "name=$NAME" >> "$GITHUB_OUTPUT"
          mkdir -p packages
          cp draft.json "packages/$NAME.json"
          python3 -u -m tribucket_gen render --only "$NAME"
          for f in "packages/$NAME.json" "Formula/$NAME.rb" "bucket/$NAME.json"; do
            [ -f "$f" ] && echo "artifact: $f"
          done
          [ -f "packages/$NAME.json" ] || { echo "packages/$NAME.json missing"; exit 1; }
          [ -f "Formula/$NAME.rb" ] || [ -f "bucket/$NAME.json" ] || { echo "no render output"; exit 1; }

      - name: Commit and push
        env:
          NAME: ${{ steps.render.outputs.name }}
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          for f in "packages/$NAME.json" "Formula/$NAME.rb" "bucket/$NAME.json"; do
            [ -f "$f" ] && git add "$f"
          done
          git diff --cached --quiet && { echo "nothing to commit"; exit 1; }
          git commit -m "pkg: add $NAME (via #${{ github.event.issue.number }})"
          git pull --rebase origin main
          git push

      - name: Close issue
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
          NAME: ${{ steps.render.outputs.name }}
        run: |
          SHA=$(git rev-parse --short HEAD)
          gh issue close "$ISSUE_NUM" --comment "✅ 已入库 \`$NAME\`（commit $SHA）。Homebrew/Scoop 用户即可通过本仓库 tap/bucket 安装。"

      - name: On failure — restore drafted state
        if: failure() && steps.regen.conclusion != 'skipped'
        env:
          GH_TOKEN: ${{ github.token }}
          ISSUE_NUM: ${{ github.event.issue.number }}
        run: |
          gh issue comment "$ISSUE_NUM" --body "❌ 入库流程失败（详见 Actions 日志）。已恢复 drafted 状态；排除问题后可再次回复 \`@tribucket-bot confirm\`。"
          gh issue edit "$ISSUE_NUM" --remove-label processing --add-label drafted
```

**执行者注意**：`Parse submission form` 步骤的 python heredoc 必须从 Task 9 的文件**逐字复制**（issue-draft.yml 的 `Parse submission form` 步骤全文）。

- [ ] **Step 2: 静态验证并提交**

```bash
python -m pytest tests/ -q
python -c "import yaml; yaml.safe_load(open('.github/workflows/issue-confirm.yml', encoding='utf-8')); print('yaml ok')" 2>/dev/null || echo "review manually"
git add .github/workflows/issue-confirm.yml
git commit -m "feat(ci): issue confirm workflow — validated single-commit package ingestion"
```

---

### Task 11: skill 独立化文档更新

**Files:**
- Modify: `skills/tribucket-gen/SKILL.md`

**Interfaces:**
- Consumes: Task 5 的 CLI 命令面、Task 6 的 draft
- Produces: 自包含 skill 文档（两条独立使用路径）；`templates.json` 权威源地位写明

- [ ] **Step 1: 更新 SKILL.md 的「工具位置」「验证」两节并新增「独立使用」**

删除原「工具位置」一节（含 `/home/work/.openclaw/workspace/tribucket/` 等硬编码路径），替换为：

```markdown
## 独立使用（不依赖 tribucket 仓库）

两条路径：

### 路径 A：纯 skill（只要包定义）
1. `bash fetch_release.sh <owner/repo>` 获取资产列表
2. 按 ②③ 节做模板匹配，手工产出 `packages/<name>.json`
3. 用到你自己维护的 Homebrew tap / Scoop bucket 里（Formula/bucket 的模板可参考 tribucket 仓库的
   `tribucket_gen/render/homebrew.py` 与 `render/scoop.py`，或让 AI 按其逻辑生成）

### 路径 B：uvx 拉起完整引擎（draft/validate/render 全流程）

```bash
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen draft <owner/repo> --json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen validate packages/<name>.json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen render --only <name>
```

## 工具位置

- **模板库（权威源）**: `<skill_dir>/templates.json` —— tribucket_gen 引擎的 draft 功能读取同一份文件
- **Release 抓取脚本**: `<skill_dir>/fetch_release.sh`
```

原「验证」一节替换为：

```markdown
## 验证

```bash
# 引擎方式（在 tribucket 仓库 clone 内）：
python3 -m tribucket_gen validate packages/<name>.json
# 或全库资产体检：
python3 -m tribucket_gen check
```
```

- [ ] **Step 2: 全文一致性检查并提交**

通读 SKILL.md，删除所有对 `scripts/generate.py`、`--check-assets` 旧旗标的引用（改为 `python -m tribucket_gen check`）。

```bash
git add skills/tribucket-gen/SKILL.md
git commit -m "docs(skill): standalone usage paths, engine-aligned commands, canonical templates.json"
```

---

### Task 12: README / AGENTS.md / CONTRIBUTING.md / CHANGELOG 重写

**Files:**
- Modify: `README.md`、`AGENTS.md`、`CONTRIBUTING.md`、`CHANGELOG.md`

**Interfaces:**
- Consumes: 最终架构（Task 1-11 的全部产出）
- Produces: 与新架构一致的文档（`CLAUDE.md` 是指向 AGENTS.md 的指针文件，内容 9 字节 `AGENTS.md`，不动）

- [ ] **Step 1: README.md 重写**

```markdown
# tribucket

Issue 驱动的多软件源聚合仓库：提交一个 GitHub 仓库，自动生成 **Homebrew Formula** 与 **Scoop bucket**。

## 安装软件

```bash
# Homebrew
brew install shisheng820/tribucket/<name>
# Scoop
scoop bucket add tribucket https://github.com/shisheng820/tribucket
scoop install <name>
```

全部可用包见 [`packages/`](packages/) 目录（107+ 个）。

## 提交新包

1. [打开一个包提交 Issue](https://github.com/shisheng820/tribucket/issues/new?template=package-submission.yml)，填几个基本字段（仓库 URL、一句话描述）
2. 机器人分析最新 Release 资产，自动生成包定义并贴回评论
3. 确认无误后回复 `@tribucket-bot confirm` —— 一次 commit 原子入库（定义 + Formula + bucket）

支持的资产命名模板见 [skills/tribucket-gen/templates.json](skills/tribucket-gen/templates.json)；不在模板内的仓库会转人工处理。

## 独立使用 tribucket-gen

不依赖本仓库，给自己维护的 tap/bucket 生成软件源：

```bash
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen draft <owner/repo> --json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen validate packages/<name>.json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen render --only <name>
```

（Python 3.9+，仅标准库。也可安装 [skill](skills/tribucket-gen/) 到你的 AI Agent。）

## 引擎命令（仓库内）

```bash
python -m tribucket_gen render [--only NAME] [--dry-run]   # 生成 Formula/bucket
python -m tribucket_gen check                              # 全库资产模式体检
python -m tribucket_gen draft <owner/repo> --json          # repo → 包定义草稿
python -m tribucket_gen validate <file>                    # 定义校验
```

上游新版本由 CI 每日自动跟进（cron）；详见 [AGENTS.md](AGENTS.md)。
```

- [ ] **Step 2: AGENTS.md 重写（关键结构，内容按此纲填充）**

新 AGENTS.md 必须包含且仅包含以下章节（删除全部 CLI/网站/KV/EdgeOne/i18n 等旧章节）：

```markdown
# AGENTS.md

## Project Overview
tribucket 是 Issue 驱动的多软件源聚合仓库：packages/*.json（唯一数据源）→ tribucket_gen 引擎
→ Formula/*.rb（Homebrew）+ bucket/*.json（Scoop）。贡献走 Issue 表单流水线。

## Critical Rules
1. 绝不手工编辑 Formula/*.rb、bucket/*.json
2. 包变更只进 packages/*.json（手工路径）或 Issue 流水线（社区路径）
3. templates.json 权威源在 skills/tribucket-gen/，引擎与 skill 共享，不得复制副本
4. GITHUB_TOKEN 提升 API 限额；HTTPS_PROXY/ALL_PROXY 支持代理
5. 渲染逻辑只有一份（tribucket_gen/render/），入库与 cron 更新共用

## Repository Layout
（tribucket_gen/ 模块树 + .github/workflows 清单 + skills/tribucket-gen + archive/cli-v2 说明）

## Issue 提交流水线
（表单字段 → issue-draft.yml：解析/rate-limit/draft/validate/评论+drafted 标签/rc=2 needs-manual；
issue-confirm.yml：守卫=作者本人+精确口令@tribucket-bot confirm+drafted 标签 → processing →
重 draft+重 validate → render --only → 单 commit 三文件 → 关 Issue；安全机制 6 条照 spec ③ 抄）

## 引擎命令
（Task 5/6/7 的四个子命令 + 退出码语义：draft 2=无模板）

## 设计决定
（match_asset 三级匹配；版本不入 pattern（{name}_{version}→*）；templates.json 权威源；
registry 可插拔 renderer；process_package tuple 兼容 API；validate 的 ≥2 平台规则）

## Testing
（python -m pytest tests/ -q；fixture 模式；无网络单元测试）

## CI
（generate.yml 每日 cron + packages/** push；validate.yml；mirror-sync.yml；无 release）

## Adding a Package（维护者手工路径）
（编辑 packages/<name>.json → python -m tribucket_gen render --only <name> → 提交；社区路径指向 Issue）

## Common Bug Patterns
（保留 generate 相关的：tag v 前缀假设、asset_pattern 非字面文件名、Windows .exe、KV/CLI 相关条目删除）
```

- [ ] **Step 3: CONTRIBUTING.md 重写**

```markdown
# Contributing

## 提交新包（推荐）
打开 [包提交 Issue](https://github.com/shisheng820/tribucket/issues/new?template=package-submission.yml)，
按表单填写即可，机器人全流程处理。见 README「提交新包」。

## 修引擎 / 改模板
1. Fork + 分支（feat/<desc>、fix/<desc>、chore/<desc>）
2. `python -m pytest tests/ -q` 必须全绿
3. 模板改动改 `skills/tribucket-gen/templates.json`（权威源）+ 补 `tests/test_draft.py` fixture
4. Conventional commits
5. PR 描述附测试证据
```

- [ ] **Step 4: CHANGELOG.md 新条目**

在文件顶部（`# 更新日志` H1 之后）插入：

```markdown
## v2.0.0 — 转型：Issue 驱动的多软件源聚合仓库

### ⚙️ 变更
- 仓库转型：tribucket CLI 与网站/KV 分发链路归档下线（CLI 移入 archive/cli-v2/，存量 brew/scoop 用户停留在最后版本）
- scripts/generate.py 重构为 tribucket_gen Python 包，新命令面：render / check / draft / validate
- 新增 Issue 提交流水线：表单 → 自动生成定义 → 提交者 confirm → 单 commit 原子入库
- generate.yml cron 6h → 24h，移除 EdgeOne KV 同步；release.yml / .cnb.yml 删除
- skills/tribucket-gen 支持独立使用（uvx --from git+...），templates.json 成为引擎与 skill 的共享权威源
```

- [ ] **Step 5: 验证与提交**

```bash
python -m pytest tests/ -q
grep -rn "EdgeOne\|kv-sync\|tribucket.hunluan.space\|Bun" README.md AGENTS.md CONTRIBUTING.md || echo "no stale refs"
git add README.md AGENTS.md CONTRIBUTING.md CHANGELOG.md
git commit -m "docs: rewrite for issue-driven multi-source hub architecture"
```

---

### Task 13: 端到端验收（人工清单，git 之外）

**Files:** 无代码改动；只做验证与控制台操作

- [ ] **Step 1: 本地全量验证**

```bash
python -m pytest tests/ -q                 # 全绿
python -m tribucket_gen check              # 需网络；107 包资产模式体检无 ❌
uvx --from git+file:///D:/coedspace/tribucket tribucket-gen --version   # 入口点可用（本地路径冒烟）
```

- [ ] **Step 2: push 后 GitHub 控制台操作**
  1. EdgeOne Pages 控制台：断开/删除该项目（避免对已删除的 edgeone.json 构建）；确认 `tribucket.hunluan.space` 可下线
  2. 仓库 Settings → General：description 改为 "Issue-driven multi-source package hub — one template → Homebrew + Scoop"；Website 字段清空或指向 README 锚点
  3. Settings → Actions → General：Workflow permissions 确认允许 "Read and write"（confirm 流水线需要 GITHUB_TOKEN 写 main）
  4. 若 main 设有分支保护，为 `github-actions[bot]` 放行或确认无保护（全自动入库依赖直接 push main）

- [ ] **Step 3: 真实 Issue 端到端**
  1. 用表单提交一个真实仓库（如未收录的小工具），观察 issue-draft.yml：解析 → draft → validate → 草稿评论 + `drafted` 标签
  2. 用**同一账号**回复 `@tribucket-bot confirm`，观察 issue-confirm.yml：processing → render → 单 commit（三文件）→ 关 Issue
  3. 验证 `brew install shisheng820/tribucket/<name>`（或 scoop）可用
  4. 反向用例：非作者回复 confirm（应无动作）；未 drafted 的 Issue 回复 confirm（应无动作）；子串陷阱如 "请 @tribucket-bot confirm 一下"（精确匹配应不触发）

- [ ] **Step 4: 收尾确认**
  - `git log --oneline`：转型相关 commit 链完整
  - CHANGELOG 顶部条目存在
  - 仓库根目录无 scripts/、website/、functions/、package.json、VERSION

---

## Self-Review 结论（已执行）

1. **Spec 覆盖**：spec ①→Task 1；②→Task 2-5（core.py/checkver.py 为 spec 模块列表的补充，见"计划期发现"）；③→Task 8-10；④→Task 2（entry point）+11；⑤→Task 1（部分）+5（generate.yml）+12；手工步骤→Task 13。spec"未来扩展"为非目标，无任务。
2. **占位符扫描**：Task 9/10 中"与逐字相同/此处不重复"指向的是**已完整给出的源**（Task 9 Step 1 全文、generate.yml:50-108 现文件原文），非未定义内容。
3. **类型一致性**：`Ctx` 字段（version/repo/platforms/windows/is_download_url/changed_version/new_urls）在 Task 4 定义与 Task 6 无耦合；`draft()` 返回 `(pkg, notes)` 与 cmd_draft 一致；`validate_definition` 返回 `(errors, warnings)` 与 cmd_validate 与 workflow 的 `.ok/.errors` JSON 键一致；draft CLI 退出码 0/1/2 与 Task 9 分支条件一致。
