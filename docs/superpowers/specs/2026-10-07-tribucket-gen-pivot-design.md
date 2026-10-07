# tribucket 转型设计：从 CLI 包管理器到 Issue 驱动的多软件源聚合仓库

- 日期：2026-10-07
- 状态：已与维护者逐段确认（方案 A，单 commit 入库修订版）
- 前置文档：`docs/superpowers/specs/2026-05-29-generate-formula-bucket-design.md`（生成器原始设计）

## 背景与动机

tribucket 目前是三件事的合体：Bun/TS CLI（`src/`）、包数据（`packages/` + 生成的 `Formula/`、`bucket/`）、以及一套 EdgeOne 分发基础设施（website/KV/Edge Functions/kv-sync）。维护者的负担主要来自 CLI 功能迭代和分发链路，而仓库的实际价值集中在**包数据 + 生成器**上。

转型方向：砍掉 CLI 与分发链路，把仓库重塑为**社区软件源提交中心**——外部贡献者通过填一份 GitHub Issue 表单提交新包，CI 自动分析 Release 资产、生成包定义、校验、并在提交者确认后原子入库；同时 `skills/tribucket-gen` 保持独立可用，供他人给自己的仓库生成软件源。

## 目标

1. 仓库只剩：`packages/` 数据 + `tribucket_gen` Python 引擎 + Issue 自动化 + 独立 skill
2. 新包贡献路径：填 Issue 表单 → CI 生成草稿 → 提交者评论确认 → 单 commit 原子入库（`packages/*.json` + `Formula/*.rb` + `bucket/*.json`）
3. `tribucket_gen` 引擎可插拔 renderer（本期实现 homebrew/scoop/portable，未来格式只加模块）
4. skill 独立可用（拷走自包含；也可通过 `uvx --from git+...` 拉起完整引擎）
5. Homebrew/Scoop 现有用户零感知（tap/bucket 数据与安装方式不变）

## 非目标（本期不做）

- winget / AUR / Nix 等新 renderer（架构预留，不实现）
- PyPI 发布（`uvx --from git+` 已覆盖独立使用场景）
- GitHub Pages 包目录（README 即目录）
- 任何 CLI 复活或兼容承诺

## 已确认的关键决策

| 决策点 | 结论 |
|--------|------|
| 转型方案 | A：演进式——generate.py 重构为引擎 + 新增 Issue 自动化层（不重写语言） |
| 旧设施 | CLI、网站、EdgeOne KV、Edge Functions、kv-sync 全部归档下线 |
| 审批模型 | 提交者确认后全自动入库（无维护者点击环节） |
| 提交体验 | 极简 Issue 表单 + CI 自动生成定义（提交者不写 asset_pattern） |
| 入库方式 | 单 commit 原子带上定义 + Formula + bucket（修订：放弃双 commit） |
| 目标格式 | 本期 Homebrew + Scoop（+portable 脚本），renderer 可插拔 |

## ① 仓库重构

**归档（移入 `archive/`）：**

| 源 | 目标 |
|----|------|
| `src/`（含 `src/__tests__/`） | `archive/cli-v2/` |
| `docs/architecture-v2.md` | `archive/cli-v2/` |

**删除：**

| 文件/目录 | 原因 |
|-----------|------|
| `website/` | 网站下线 |
| `functions/` | Edge Functions 下线 |
| `edgeone.json` | EdgeOne 配置下线 |
| `scripts/kv-sync.py` | KV 同步下线 |
| `.github/workflows/release.yml` | CLI 二进制发布 |
| `.cnb.yml` | CNB 构建配置（CLI 出二进制；仓库镜像不受影响） |
| `package.json`（及 bun.lock 等若存在） | bun 工具链随 CLI 退场 |
| `VERSION` | 引擎版本改由 `pyproject.toml` 承载 |
| `scripts/`（generate.py 包化移入 `tribucket_gen/`、kv-sync.py 删除后清空） | 目录随之移除 |
| `packages/tribucket.json` | CLI 已归档，自托管定义无意义；存量 brew/scoop 用户停留在最后版本 |

**保留：**

- `packages/`、`Formula/`、`bucket/`——核心数据，继续作为 tap/bucket
- `tests/`（pytest，95 个测试）——导入语句随包化调整（去掉 `sys.path` hack）
- `CHANGELOG.md`——继续记录仓库级变更
- `CLAUDE.md`——随 AGENTS.md 同步重写
- `.github/workflows/validate.yml`——包定义校验，与新模型契合，保留（本期不改其内联逻辑，后续可切换为调用 `tribucket_gen validate`）
- `.github/workflows/mirror-sync.yml`——CNB 仓库镜像与 CLI 无关，保留为国内访问 tap/bucket 的只读镜像（维护者可否决）

## ② tribucket_gen 引擎

`scripts/generate.py`（1126 行）重构为 Python 包，**逻辑搬移与重新分组，不重写**。依旧仅标准库，目标 Python 3.9+。

```
tribucket_gen/
├── __init__.py
├── __main__.py        # python -m tribucket_gen 入口（argparse 子命令）
├── release.py         # 搬移：http_get / _build_opener / fetch_latest_release / parse_release
├── assets.py          # 搬移：match_asset / infer_asset_format / is_checksum_asset / check_asset_patterns
├── hashing.py         # 搬移：compute_sha256 / parse_checksum_file / 缓存读写
├── draft.py           # 新增：repo → release 资产分析 → templates.json 模板匹配 → 包定义草稿
├── validate.py        # 新增：定义校验（规则见③）
└── render/
    ├── __init__.py    # 渲染器注册表 + 统一接口
    ├── homebrew.py    # 搬移：render_formula
    ├── scoop.py       # 搬移：render_bucket
    └── portable.py    # 搬移：render_install_sh / render_bat / generate_portable
pyproject.toml         # 包元数据 + [project.scripts] tribucket-gen + pytest 配置
```

**Renderer 接口**：`render(pkg, ctx) -> dict[输出文件相对路径, 文件内容]`。注册表 `{"homebrew": ..., "scoop": ..., "portable": ...}`；新增格式 = 新增一个模块 + 注册一行，引擎与 CI 不改。

**命令面**（替代 `python scripts/generate.py`）：

```bash
python -m tribucket_gen render [--only NAME | --all] [--skip-hash] [--dry-run]
python -m tribucket_gen draft <owner/repo> [--name N] [--description D] [--binary B]
                                          [--license L] [--homepage H] [--json] [--out FILE]
python -m tribucket_gen validate <file|->  [--json]
python -m tribucket_gen check              # 全库 asset_pattern 体检（现有功能）
```

**`templates.json` 权威源**：保留在 `skills/tribucket-gen/templates.json`。理由：skill 独立拷贝时自带数据自包含；引擎只在仓库内（CI/本地 clone）运行，跨目录读取路径稳定。`draft.py` 从该路径加载。skill 与引擎共享同一份数据，新增命名模板时两边的匹配行为自动一致。

## ③ Issue 提交流水线

### Issue 表单（`.github/ISSUE_TEMPLATE/package-submission.yml`）

| 字段 | 必填 | 说明 |
|------|------|------|
| 仓库 URL | ✅ | 校验 `github.com/owner/repo` 格式 |
| 包名 | ❌ | 默认取 repo 名；`^[a-z0-9][a-z0-9-]*$` |
| 一句话描述 | ✅ | 唯一自由文本；入库前做控制字符清洗与引号转义 |
| binary 名称 | ❌ | 默认取 repo 名 |
| license | ❌ | 缺省时 CI 经 GitHub API 自动探测（`license.spdx_id`） |
| 备注 | ❌ | 平台限制等特殊说明 |

### Workflow 1：`issue-draft.yml`

触发：`issues: [opened, edited]`（仅处理 body 含表单特有标记的 Issue——判定方式：body 中存在固定标题 `### 仓库 URL`；其他 Issue 一律忽略）。

1. 解析表单字段（GitHub Issue 表单在 body 中呈现为 `### 字段名\n\n值` 结构）
2. `tribucket_gen draft` 生成包定义草稿（含 asset_pattern 平台推断）
3. `tribucket_gen validate` 在线校验（资产模式必须匹配真实 Release）
4. bot 评论：生成的 JSON + 校验报告 + 确认指引；打 `drafted` 标签
5. 失败：评论具体原因，等待提交者修改 Issue（`edited` 自动重跑，per-issue 并发组防抖）
6. 限流：每用户同时最多 3 个进行中的提交 Issue

### Workflow 2：`issue-confirm.yml`（单 commit 原子入库）

触发：`issue_comment: [created]`。

1. 守卫：评论精确等于 `@tribucket-bot confirm`（非子串匹配）；评论者 == Issue 作者；Issue 带 `drafted` 标签且无 `processing` 标签
2. 加 `processing` 标签（防并发重复提交）
3. 从 Issue 当前内容重新 draft + 全量重新校验（**绝不信任草稿时的状态**——release 可能已变、包可能已被别人提交）
4. `tribucket_gen render --only <name>` 现场渲染 Formula + bucket
5. 一个 commit 提交三个文件：`packages/<name>.json`、`Formula/<name>.rb`、`bucket/<name>.json`；committer 为 `github-actions[bot]`，消息格式 `pkg: add <name> (via #<ISSUE_NUM>)`
6. bot 评论成功 + 关闭 Issue（completed）；校验失败则评论原因 + 摘掉 `processing`

渲染代码只有一份（`tribucket_gen/render/`），入库（issue-confirm）与更新（generate.yml cron）是同一代码的两个触发入口，无漂移。

### 安全机制

1. 确认口令仅限 **Issue 作者本人**触发；路人评论无效
2. 口令**精确匹配**，防止评论正文偶然包含触发词
3. confirm 时**服务端全量重新校验**；文件路径全部由代码构造，绝不拼接 Issue 原始字符串
4. 提交者**永远不写 asset_pattern**——模式由 CI 从真实 Release 资产生成，注入面最小化；描述字段清洗控制字符并转义引号
5. 包名白名单正则；重名（与现有 `packages/*.json` 冲突）拒绝
6. 仓库级 `concurrency: package-commits`（cancel-in-progress: false），多个确认串行提交
7. 残余风险（已知并接受）：提交者可自确认注入指向恶意二进制的定义。缓解：名称/描述/renderer 输出均受控，恶意性集中在 Release 资产 URL，而 URL 来自其自有的公开 GitHub 仓库——攻击者只能"污染自己仓库的包"。维护者可通过 `git revert` 单 commit 快速下架

### `generate.yml` 职责（收窄后）

- 触发：`packages/**` push、cron（**6h → 24h**，降低提交噪音）、release 完成触发移除（无 release 了）
- 职责：全量检查上游新版本 → 重渲染变更包 → commit（现状逻辑，删 kv-sync 步骤，调用路径改 `python -m tribucket_gen`）

## ④ skill 独立化

1. `skills/tribucket-gen/` 保持可独立拷贝（`fetch_release.sh` + `templates.json` + `SKILL.md`）
2. `templates.json` 为唯一权威源（见②）
3. `pyproject.toml` 的 `[project.scripts]` 提供 `tribucket-gen` 命令，独立用户无需 PyPI 发布即可用完整引擎：
   ```bash
   uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen render --only <name>
   ```
4. `SKILL.md` 更新：写明两条独立使用路径——① 纯 skill（fetch_release.sh + 模板匹配出定义，手写自己 tap 的人）；② `uvx` 拉起完整引擎（draft/validate/render 全流程）；同时去除对已归档 CLI 的引用

## ⑤ CI 与文档

| 文件 | 动作 |
|------|------|
| `.github/workflows/release.yml` | 删除 |
| `.cnb.yml` | 删除 |
| `.github/workflows/generate.yml` | 改造：删 kv-sync；cron 6h→24h；调用 `python -m tribucket_gen` |
| `.github/workflows/issue-draft.yml` | 新增 |
| `.github/workflows/issue-confirm.yml` | 新增 |
| `.github/ISSUE_TEMPLATE/package-submission.yml` + `config.yml` | 新增 |
| `.github/workflows/validate.yml` | 保留不动 |
| `.github/workflows/mirror-sync.yml` | 保留不动 |
| `README.md` | 重写：新定位、brew/scoop 安装、Issue 提交指南、独立使用说明 |
| `AGENTS.md` / `CLAUDE.md` | 重写：对齐新架构 |
| `CONTRIBUTING.md` | 重写：以 Issue 提交流程为主体 |
| `CHANGELOG.md` | 记录本次转型 |
| `pyproject.toml` | 新增 |

## 测试策略

- **单元测试**（pytest，现有 95 个继续通过 + 新增）：
  - `draft.py`：以 fixture Release JSON 驱动（复用 `tests/fixtures/` 模式），覆盖 6 种模板命中/未命中/多平台推断/表单字段覆盖默认值
  - `validate.py`：表驱动——缺字段、平台键不全、资产不匹配、重名、包名非法、描述含控制字符
  - `render/`：搬移后现有断言不变；注册表接口新增格式快照测试
- **workflow 测试**：GitHub Actions 无法完全本地验证；合并后以真实 Issue 走一遍端到端（提交 → 草稿评论 → confirm → 单 commit → 关闭）作为验收
- **手动验收**：`uvx --from git+... tribucket-gen draft <repo>` 在干净环境可用

## 手工后续步骤（git 之外）

1. EdgeOne Pages 控制台断开/删除项目（避免对已删除的 `edgeone.json` 继续构建）；`tribucket.hunluan.space` 随之失效
2. GitHub 仓库 description/website 字段更新为新定位
3. 合并后在真实 Issue 上做一次端到端验收

## 未来扩展（记录，不实现）

- 新 renderer：winget manifest / AUR PKGBUILD / Nix（加模块 + 注册即可）
- `tribucket_gen validate` 替换 `validate.yml` 的内联 bash 校验
- 若独立用户增长，考虑正式发布 PyPI
