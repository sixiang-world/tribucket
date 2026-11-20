# AGENTS.md

## Project Overview

tribucket v4.1 Maintenance Edition 是以 Windows Scoop 为主的个人软件源，同时保留 Homebrew 兼容。`packages/*.json` 是唯一数据源，由 `tribucket_gen` 生成 `bucket/*.json` 和 `Formula/*.rb`。包定义由维护者在本地维护，可用 Codex 协助。公开 Issue 收包流程已停用。

- 引擎是 Python 3.9+ 包（仅标准库，零第三方依赖），也可脱离本仓库独立使用（`uvx --from git+... tribucket-gen ...`，或作为 [skill](skills/tribucket-gen/SKILL.md) 装进 AI Agent）
- 旧架构（tribucket CLI、网站、KV 分发链路）已归档下线，代码在 `archive/cli-v2/`，仅作历史参考

## Critical Rules

1. **绝不手工编辑** `Formula/*.rb`、`bucket/*.json` —— 全部由 `python -m tribucket_gen render` 生成
2. 收录 Scoop 官方 `main`、`extras`、`java` 尚未收录的软件。按清单文件名和上游来源核对是否重复。改包先改 `packages/*.json`，下架时同时删除对应的定义、Scoop 清单和 Formula
3. `templates.json` 权威源在 `skills/tribucket-gen/templates.json`，引擎与 skill 共享，不得再复制副本；`tribucket_gen/templates.json` 是随 wheel 分发的 vendored 副本（安装成包后 `skills/` 不存在时兜底），与权威源的字节一致性由 `tests/test_draft.py::test_vendored_templates_in_sync` 守护，不要手改副本
4. `GITHUB_TOKEN` 提升 API 限额；`HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` 代理支持（`release.http_get` 走 urllib 环境代理，`download_file` 传 token header）
5. 本地维护与 CI 共用 `tribucket_gen/render/` 的渲染逻辑

## Repository Layout

```
tribucket_gen/               # 生成引擎（Python 3.9+，仅标准库）
├── __init__.py              #   __version__
├── __main__.py              #   CLI 入口：render / check / draft / validate
├── release.py               #   GitHub Release 抓取 + HTTP 层（重试、403 快速失败、aria2 下载 + urllib 兜底）
├── assets.py                #   match_asset（substring→glob）、checksum 资产识别、check_asset_patterns
├── hashing.py               #   SHA256 计算、checksum 文件解析、.cache/ 哈希缓存
├── checkver.py              #   版本探测：URL 提取（零配置）/ checkver 对象（jsonpath+regex+replace）/ "github"
├── core.py                  #   load_packages / resolve_package / process_package（4 元组兼容 API）
├── draft.py                 #   repo → 包定义草稿（模板评分 + alias rescue）
├── validate.py              #   定义校验（schema + 在线资产匹配，≥2 平台规则）
├── templates.json           #   vendored 副本（wheel 分发；权威源在 skills/tribucket-gen/）
└── render/                  #   可插拔渲染层
    ├── __init__.py          #     Ctx 数据类 + RENDERERS 注册表 + render_all
    ├── homebrew.py          #     Formula/<name>.rb
    ├── scoop.py             #     bucket/<name>.json（含 autoupdate URL 推导）
    └── portable.py          #     portable/<name>/（可选，--portable 触发）

.github/workflows/
├── generate.yml             #   每日 cron + packages/** push → render → 自动 commit
├── validate.yml             #   push/PR → schema + sha256 非空 + render dry-run + check
└── mirror-sync.yml          #   push → 全量镜像到 CNB

skills/tribucket-gen/        # AI Agent skill（SKILL.md + templates.json 权威源 + fetch_release.sh）
tests/                       # pytest 单元测试；fixture 定义在 tests/fixtures/packages/
packages/  Formula/  bucket/ # 数据：唯一数据源 / 渲染产物（勿手改）
archive/cli-v2/              # 归档：旧 tribucket CLI（TypeScript，编译单文件二进制）—— 仅历史参考
archive/python-v1/           # 归档：v1 Python CLI —— 仅历史参考
pyproject.toml               # 控制台脚本 tribucket-gen + wheel package-data（templates.json）
```

## 引擎命令

```bash
python -m tribucket_gen render [--only NAME ...] [--skip-hash] [--dry-run] [--portable] [--portable-dir DIR] [--verbose]
python -m tribucket_gen check
python -m tribucket_gen draft <owner/repo> [--name N] [--description D] [--binary B] [--license SPDX] [--homepage URL] [--templates PATH] [--json] [--out PATH]
python -m tribucket_gen validate <file|-> [--json] [--offline] [--packages-dir DIR]
python -m tribucket_gen --version
```

- **render**：packages/*.json → Formula/bucket。download_url 包的新版本自动写回 `packages/<name>.json`；`--dry-run` 只打印不写盘；`--skip-hash` 跳过 SHA256（快速迭代）
- **check**：全库 asset_pattern 对最新 Release 体检（✅ 全中 / ⚠️ 部分缺失 / ❌ 零匹配）
- **draft** 生成定义草稿。退出码 `0` 表示成功，`1` 表示通用或网络错误，`2` 表示无匹配模板
- **validate**：定义校验（schema + 在线资产匹配）。退出码 0/1；`-` 从 stdin 读；`--offline` 跳过在线检查
- render/check 必须在仓库根目录运行（依赖 `packages/`）；draft/validate 可独立运行
- `pyproject.toml` 安装后另有等价控制台脚本 `tribucket-gen`

## 设计决定

- **match_asset 两级匹配**（`assets.py`）：先子串（`pattern in asset_name`），再 glob（`fnmatch(name, "*"+pattern+"*")`）——不是旧版的 literal→glob→suffix 三级匹配。pattern 本身可含 `*`（fnmatch 语义）。注意第一个子串命中即返回，pattern 别写得太宽
- **版本不入 pattern**：模板 match_rule 中的 `{name}_{version}` / `{version}` 一律展开为 `*`，生成的 pattern 因此跨版本稳定，cron 更新永不改写 pattern
- **templates.json 权威源**在 `skills/tribucket-gen/`；draft 的查找顺序：skills/ 权威源 → 包内 vendored 副本（wheel/uvx 安装场景）。文档结构：`templates`（detect 正则 + match_rule + frequency）、`platform_aliases`（分隔符边界的别名匹配，防 `win-arm64` 误中 `dar*win-arm64*`）、`archive_formats`
- **draft 的 alias-rescue 规则**（`draft.build_asset_pattern`）：两段式 —— 先按模板规则逐平台匹配（权威），规则没命中的平台再用 platform_aliases 兜底（rescue，记录真实命中的资产名）。**被 rule 认领过的资产对 rescue 不可见**（防双重认领：`apple-darwin` 别名会把 darwin_amd64 规则已认领的资产错拉给 darwin_arm64）；**rescue 与 rescue 之间共享资产允许**（universal darwin 构建：两平台 rescue 同一文件）。生成的 pattern 匹配不到真实资产 → `NO_MATCH`（宁缺勿错）
- **registry 可插拔 renderer**：`render/__init__.py` 的 `RENDERERS` 注册表（`@register("homebrew")`），`render_all(pkg, ctx, targets)` 按目标名分发。新增 winget/AUR/Nix 只需写一个渲染模块并注册，core 与 CI 零改动
- **process_package 4 元组兼容 API**：`(formula, bucket, changed_version, new_urls)` —— generate.py 时代的调用形态保持不变
- **validate 的 ≥2 平台规则**：非 `NO_MATCH` 平台中至少 2 个能在最新 Release 匹配到资产，否则报错（`MIN_MATCHED_PLATFORMS = 2`），防止零产出/近零产出包入库
- **两条解析路径产物同构**：GitHub Release 路径与 download_url 路径都归一到 `Ctx` dataclass（version/repo/platforms/windows/is_download_url/changed_version/new_urls），渲染层不感知来源差异

## Testing

```bash
python -m pytest tests/ -q
```

- 全部单元测试**无网络**：GitHub 交互经 `fetcher` / `meta_fetcher` 参数注入（monkeypatch），fixture 定义放在 `tests/fixtures/packages/`
- `test_draft.py`：模板匹配、alias-rescue 双规则、退出码映射、**vendored templates 字节一致守护**
- `test_render_registry.py`：注册表与渲染输出；`test_validate.py`：schema + ≥2 平台规则；`test_checkver.py`：版本探测；`test_generate.py`：核心渲染流程

## CI

- **generate.yml** 每日 05:17 UTC 运行，推送 `packages/**` 到 `main` 或手动触发也会运行。执行 `python -m tribucket_gen render`，有变更时自动提交
- **validate.yml** 在包数据、产物或工作流变更时检查定义、产物的哈希和最新 Release 的资产匹配，并试跑 `render --dry-run --skip-hash`
- **mirror-sync.yml** 在推送 `main` 或手动触发时将分支和标签同步到 CNB

## Adding a Package

在仓库根目录执行。可让 Codex 按同样的步骤操作，并使用仓库的 [tribucket-gen 技能](skills/tribucket-gen/SKILL.md) 检查 Release 资产。

1. 核对 Scoop 官方三个桶里的包名和上游来源。用 `python -m tribucket_gen draft owner/repo --name example-tool --out example-tool.json` 在 `packages/` 之外起草定义。无匹配模板时，可参考现有定义，根据真实 Release 资产编写
2. 审阅定义。必填 `name`、`repo`、`description`、`binary`、`license`、`homepage` 和 `asset_pattern`。`asset_pattern` 保留 `linux_amd64`、`linux_arm64`、`darwin_amd64`、`darwin_arm64`、`windows_amd64`、`windows_arm64` 六个键，缺失的平台填 `"NO_MATCH"`
3. 运行 `python -m tribucket_gen validate example-tool.json`，通过后将定义移入 `packages/`。先校验再移入，因为 `validate` 会检查同名包是否已存在
4. 运行 `python -m tribucket_gen render --only example-tool` 生成 Scoop 清单和可用的 Formula，SHA256 由引擎计算。检查产物并与定义一起提交，例如 `pkg: add example-tool`

`asset_pattern` 取值：完整资产名 / 含 `*` 的 glob / 平台尾巴子串（如 `x86_64-pc-windows-msvc.zip`）均可 —— match_asset 两级匹配会命中 `bat-v0.26.1-x86_64-pc-windows-msvc.zip` 这样的真实资产。

## Common Bug Patterns

| 模式 | 说明 | 正确做法 |
|------|------|---------|
| **tag v 前缀假设** | Release tag 是项目自定义的（`v1.2.3`、`jq-1.8.1`、`15.1.0` 都存在） | 版本号 = tag 去掉前导 `v`（`release.parse_release` 的 `lstrip("v")`）；下载 URL 用资产真实 URL，不要自己拼 `v`；scoop autoupdate 推导已同时处理 `v1.2.3` 与 `1.2.3` |
| **asset_pattern 不是字面文件名** | pattern 是对真实资产列表的匹配（substring→glob），写平台尾巴子串即可 | 别写太宽的子串 —— 第一个子串命中即返回，可能匹配到错误资产 |
| **Windows .exe** | Release 直接发布裸 exe 时，匹配不会自动补全后缀 | asset_pattern 必须带 `.exe` 后缀；portable 渲染（`render_bat`）会对 binary 末尾自动补 `.exe` |
| **403 不重试** | `release.http_get` 对 HTTP 403 立即抛出（视为限额/禁止），不做退避重试 | 提升限额靠 `GITHUB_TOKEN`，不要把 403 当瞬时错误处理 |
| **GBK 控制台** | Windows 默认代码页无法编码 ✓/❌/⚠️ 等符号 | 引擎已在非 UTF-8 stdout 上 `reconfigure(encoding="utf-8")`；新增输出不要绕过这一假设（别在模块 import 之前打印非 ASCII） |
