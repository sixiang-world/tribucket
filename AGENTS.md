# AGENTS.md

## Project Overview

tribucket 是 Issue 驱动的多软件源聚合仓库：`packages/*.json`（唯一数据源）→ tribucket_gen 引擎 → `Formula/*.rb`（Homebrew）+ `bucket/*.json`（Scoop）。贡献走 Issue 表单流水线（提交 → 机器人生成 → 作者 confirm → 单 commit 入库）。

- 引擎是 Python 3.9+ 包（仅标准库，零第三方依赖），也可脱离本仓库独立使用（`uvx --from git+... tribucket-gen ...`，或作为 [skill](skills/tribucket-gen/SKILL.md) 装进 AI Agent）
- 旧架构（tribucket CLI、网站、KV 分发链路）已归档下线，代码在 `archive/cli-v2/`，仅作历史参考

## Critical Rules

1. **绝不手工编辑** `Formula/*.rb`、`bucket/*.json` —— 全部由 `python -m tribucket_gen render` 生成
2. 包变更只进 `packages/*.json`（维护者手工路径）或 Issue 流水线（社区路径）
3. `templates.json` 权威源在 `skills/tribucket-gen/templates.json`，引擎与 skill 共享，不得再复制副本；`tribucket_gen/templates.json` 是随 wheel 分发的 vendored 副本（安装成包后 `skills/` 不存在时兜底），与权威源的字节一致性由 `tests/test_draft.py::test_vendored_templates_in_sync` 守护，不要手改副本
4. `GITHUB_TOKEN` 提升 API 限额；`HTTPS_PROXY` / `HTTP_PROXY` / `ALL_PROXY` 代理支持（`release.http_get` 走 urllib 环境代理，`download_file` 传 token header）
5. 渲染逻辑只有一份（`tribucket_gen/render/`），Issue 入库与 cron 每日更新共用同一条 render 路径 —— 不要在 CI 脚本里另写生成逻辑

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
├── issue-draft.yml          #   Issue opened/edited → 解析表单 → draft → validate → 评论 + drafted 标签
├── issue-confirm.yml        #   作者回复 @tribucket-bot confirm → 重校验 → 单 commit 入库
├── generate.yml             #   每日 cron + packages/** push → render → 自动 commit
├── validate.yml             #   push/PR → schema + sha256 非空 + render dry-run + check
└── mirror-sync.yml          #   push → 全量镜像到 CNB

.github/ISSUE_TEMPLATE/
├── package-submission.yml   #   包提交表单（仓库 URL / 包名 / 一句话描述 / binary 名称 / license / 备注）
└── config.yml

skills/tribucket-gen/        # AI Agent skill（SKILL.md + templates.json 权威源 + fetch_release.sh）
tests/                       # pytest 单元测试；fixture 定义在 tests/fixtures/packages/
packages/  Formula/  bucket/ # 数据：唯一数据源 / 渲染产物（勿手改）
archive/cli-v2/              # 归档：旧 tribucket CLI（TypeScript，编译单文件二进制）—— 仅历史参考
archive/python-v1/           # 归档：v1 Python CLI —— 仅历史参考
pyproject.toml               # 控制台脚本 tribucket-gen + wheel package-data（templates.json）
```

## Issue 提交流水线

### 表单字段（package-submission.yml）

| 字段 | 必填 | 说明 |
|------|------|------|
| `仓库 URL` | ✅ | `https://github.com/owner/repo`（正则校验，`.git` 后缀自动剥除） |
| `包名` | ❌ | 留空则用仓库名（sanitize 为 `^[a-z0-9][a-z0-9-]*$`） |
| `一句话描述` | ✅ | 写入 Formula 与 bucket |
| `binary 名称` | ❌ | 留空则用包名 |
| `license` | ❌ | 留空则从 GitHub API 自动探测（SPDX） |
| `备注` | ❌ | 仅人工阅读，不进定义 |

### issue-draft.yml（on: issues opened/edited；body 含 `### 仓库 URL` 才触发）

1. **解析表单**（按 `### <label>` 分节；失败 → 评论提示，**不关 Issue**，作者编辑后自动重跑）
2. **Rate limit**：同一作者已有 >3 个含表单的 open Issue → 评论 + 关闭（上限 3）
3. **draft**：`python -m tribucket_gen draft <repo> --json --out` —— rc=0 继续；rc=1（网络/临时错误）→ 评论提示稍后编辑重试；rc=2（无已知模板）→ 评论 + `needs-manual` 标签 + 关闭
4. **validate**：`validate draft.json` 不过 → 贴出全部错误，作者编辑重试
5. **成功**：贴生成的定义 JSON + 加 `drafted` 标签，提示作者回复 `@tribucket-bot confirm`

### issue-confirm.yml（on: issue_comment created）

守卫（全部满足才跑）：评论者 == Issue 作者（author-only）&& 评论体精确等于 `@tribucket-bot confirm`（`==`，非子串）&& 非 PR && 有 `drafted` 标签且无 `processing` 标签。

流程：`drafted` → `processing` → 重新解析表单 → **重 draft + 重 validate**（服务端复核，不信任 Issue 内容）→ `render --only <name>` → **单 commit** `pkg: add <name> (via #N)` 写入 `packages/<name>.json` + `Formula/<name>.rb` + `bucket/<name>.json` → 关 Issue 并贴 commit SHA。中途失败 → 评论 + 恢复 `drafted` 状态。

### 安全机制（6 条）

1. **Author-only confirm**：只有 Issue 作者本人的评论能触发入库
2. **精确口令匹配**：评论体整体 `==` `@tribucket-bot confirm`，防止口令夹带在长文本里被误触发
3. **服务端复核**：confirm 时重新 draft + validate，绝不直接采用 Issue/评论中的定义文本
4. **asset_pattern 永不由用户输入**：完全由 draft 从模板 + 真实 Release 资产推导
5. **包名白名单**：`^[a-z0-9][a-z0-9-]*$`（draft sanitize + validate 双重校验），杜绝路径注入与 Ruby/JSON 断行
6. **仓库级 commit 串行化**：issue-confirm.yml 与 generate.yml 共用 `concurrency: package-commits`（cancel-in-progress: false），confirm 提交与 cron 渲染不会在 push 上互相冲撞

残余风险（已接受）：作者 confirm 一个指向自己仓库 Release 的恶意包 —— 定义生成自其自己仓库的资产，流水线无法区分。处置方式：revert 入库 commit 即完成下架（删 `packages/<name>.json` 及对应渲染产物）。

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
- **draft**：repo → 定义草稿。**退出码语义：0 成功；1 通用/网络错误；2 无已知模板**（CI 由此分流 needs-manual）
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
py -m pytest tests/ -q        # 123 passed, 3 skipped
```

- 全部单元测试**无网络**：GitHub 交互经 `fetcher` / `meta_fetcher` 参数注入（monkeypatch），fixture 定义放在 `tests/fixtures/packages/`
- `test_draft.py`：模板匹配、alias-rescue 双规则、退出码映射、**vendored templates 字节一致守护**
- `test_render_registry.py`：注册表与渲染输出；`test_validate.py`：schema + ≥2 平台规则；`test_checkver.py` / `test_checkver_fix.py`：版本探测三模式及其回归修复；`test_generate.py`：核心渲染流程

## CI

- **generate.yml**：cron `17 5 * * *`（每日 05:17 UTC）+ push 到 main 的 `packages/**` + workflow_dispatch。跑 `python -m tribucket_gen render`，有变更则自动提交 `chore: update Formula/Bucket (...)`（正文逐包列版本变化）。concurrency `package-commits`（与 issue-confirm 串行）
- **issue-draft.yml / issue-confirm.yml**：见「Issue 提交流水线」
- **validate.yml**（未改动）：push/PR 触发（packages/Formula/bucket/workflows 路径）→ JSON schema + 必填字段检查 → Formula sha256 非空 → bucket hash 非空 → `render --dry-run --skip-hash` → `check`
- **mirror-sync.yml**（未改动）：push 到 main → 全量镜像到 CNB
- **无 release 流水线**：release.yml / .cnb.yml 已删除 —— 本仓库只产出软件源定义，不分发自身二进制

## Adding a Package（维护者手工路径）

社区路径走 Issue 表单（见 README「提交新包」），机器人全自动。维护者手工路径用于模板覆盖不到、需要人工判断的包：

1. 编辑 `packages/<name>.json`：必填 `name` / `repo` / `description` / `binary` / `license` / `homepage` + `asset_pattern`（6 平台全键：`linux_amd64` `linux_arm64` `darwin_amd64` `darwin_arm64` `windows_amd64` `windows_arm64`，不支持的平台填 `"NO_MATCH"`，不要省略键）
2. `python -m tribucket_gen render --only <name>`（可先 `--dry-run` 预览）生成 Formula + bucket，SHA256 自动计算
3. `python -m tribucket_gen validate packages/<name>.json` 自检
4. 三个文件一起提交（conventional commit，如 `pkg: add <name>`）

`asset_pattern` 取值：完整资产名 / 含 `*` 的 glob / 平台尾巴子串（如 `x86_64-pc-windows-msvc.zip`）均可 —— match_asset 两级匹配会命中 `bat-v0.26.1-x86_64-pc-windows-msvc.zip` 这样的真实资产。

## Common Bug Patterns

| 模式 | 说明 | 正确做法 |
|------|------|---------|
| **tag v 前缀假设** | Release tag 是项目自定义的（`v1.2.3`、`jq-1.8.1`、`15.1.0` 都存在） | 版本号 = tag 去掉前导 `v`（`release.parse_release` 的 `lstrip("v")`）；下载 URL 用资产真实 URL，不要自己拼 `v`；scoop autoupdate 推导已同时处理 `v1.2.3` 与 `1.2.3` |
| **asset_pattern 不是字面文件名** | pattern 是对真实资产列表的匹配（substring→glob），写平台尾巴子串即可 | 别写太宽的子串 —— 第一个子串命中即返回，可能匹配到错误资产 |
| **Windows .exe** | Release 直接发布裸 exe 时，匹配不会自动补全后缀 | asset_pattern 必须带 `.exe` 后缀；portable 渲染（`render_bat`）会对 binary 末尾自动补 `.exe` |
| **403 不重试** | `release.http_get` 对 HTTP 403 立即抛出（视为限额/禁止），不做退避重试 | 提升限额靠 `GITHUB_TOKEN`，不要把 403 当瞬时错误处理 |
| **GBK 控制台** | Windows 默认代码页无法编码 ✓/❌/⚠️ 等符号 | 引擎已在非 UTF-8 stdout 上 `reconfigure(encoding="utf-8")`；新增输出不要绕过这一假设（别在模块 import 之前打印非 ASCII） |
