# tribucket 转型开发计划

> 从「收录别人的包」到「帮项目方一键发布到所有平台」

## 1. 现状分析

### 当前架构

```
tribucket 仓库（中心化）
├── packages/*.json     ← 107 个包的定义（tribucket 维护）
├── Formula/*.rb        ← 自动生成的 Homebrew Formula
├── bucket/*.json       ← 自动生成的 Scoop Manifest
├── scripts/generate.py ← 生成器
├── src/                ← CLI（安装/更新/生命周期管理）
└── website/            ← 软件源网站
```

**问题**：
- tribucket 是**消费者**——收录别人的包，维护成本高，107 个包的版本追踪是持续劳动
- CLI 在重复造轮子——安装/更新功能和 Homebrew/Scoop 重叠
- 项目方无法自助——想被 tribucket 收录必须提 PR 到这个仓库

### 转型方向

**tribucket 变成一个工具**——项目方在自己的仓库里用 tribucket，一键生成 Homebrew Formula、Scoop Manifest、install 脚本等多格式分发文件。

```
项目方自己的仓库
├── .tribucket.yaml          ← 项目方自己维护的定义文件
├── Formula/<name>.rb        ← tribucket generate 生成
├── bucket/<name>.json       ← tribucket generate 生成
└── scripts/install.sh       ← tribucket generate 生成
```

**tribucket 仓库本身**变成：
- 生成器工具的源码仓库
- 已知使用 tribucket 的项目索引（类似 awesome-list）
- GitHub Action / CI 工具的发布渠道

---

## 2. 目标架构

```
tribucket (工具)
│
├── tribucket CLI
│   └── generate 子命令：读取定义 → 输出多格式文件
│
├── .tribucket.yaml（项目方仓库中的配置文件）
│   └── 定义：包名、仓库、描述、资产模式、目标格式
│
├── 生成引擎（Python / 均可）
│   ├── Homebrew Formula
│   ├── Scoop Manifest
│   ├── Shell install 脚本
│   └── 可扩展：AUR / Nix / WinGet
│
├── GitHub Action
│   └── tribucket/generate@v1：CI 中自动运行
│
└── tribucket.hunluan.space
    └── 从"软件源"变为"tribucket 项目展示页 + 文档站"
```

---

## 3. 核心变更清单

### 3.1 定义文件格式：`packages/*.json` → `.tribucket.yaml`

**现状**：定义文件放在 tribucket 仓库的 `packages/` 目录下。
**目标**：定义文件放在**项目方自己的仓库根目录**。

格式从 JSON 改为 YAML（更易手写），但保留 JSON 兼容。

```yaml
# .tribucket.yaml
name: my-tool
repo: owner/my-tool
description: "A fantastic CLI tool"
binary: my-tool
license: MIT
homepage: https://github.com/owner/my-tool

# 资产匹配模式（从 GitHub Release 自动检测，或手动指定）
asset_pattern:
  linux_amd64: "my-tool-linux-amd64.tar.gz"
  linux_arm64: "my-tool-linux-arm64.tar.gz"
  darwin_amd64: "my-tool-darwin-amd64.tar.gz"
  darwin_arm64: "my-tool-darwin-arm64.tar.gz"
  windows_amd64: "my-tool-windows-amd64.zip"
  windows_arm64: "NO_MATCH"

# 生成目标（可选，默认全部）
targets:
  - homebrew      # 生成 Formula/*.rb
  - scoop         # 生成 bucket/*.json
  - shell         # 生成 scripts/install.sh

# 自动检测（可选，省略 asset_pattern 时使用）
auto_detect: true  # 从最新 Release 自动推断 asset_pattern
```

**变更范围**：
- 新增 YAML 解析（Python 标准库 `yaml` 或用 JSON 兼容模式）
- `generate.py` 改为读取 `.tribucket.yaml` 而非 `packages/*.json`
- 保留 `packages/*.json` 的读取作为 fallback（兼容现有 107 个包）

### 3.2 生成器重构：`scripts/generate.py` → 独立工具

**现状**：`generate.py` 是 tribucket 仓库内部脚本，路径硬编码为 `packages/` → `Formula/` → `bucket/`。
**目标**：生成器可以作为独立工具在**任何仓库**中运行。

```
generate.py 重构：
├── 输入：.tribucket.yaml（或 --config 指定路径）
├── 输出：--output-dir 指定目录（默认当前目录）
├── 格式：--target homebrew,scoop,shell（默认全部）
└── 模式：
    ├── tribucket generate          # 读取定义，生成文件
    ├── tribucket generate --detect # 自动检测 Release 资产，推断 pattern
    ├── tribucket generate --check  # 验证 pattern 是否匹配
    └── tribucket generate --dry-run # 预览输出
```

**关键改造**：
1. 解耦路径：不再硬编码 `Formula/`、`bucket/`，改为可配置输出目录
2. 解耦输入：支持 `.tribucket.yaml` + `packages/*.json` 双模式
3. 新增 `--detect` 模式：自动从 GitHub Release 推断 asset_pattern
4. 新增 `--check` 模式：验证 pattern 有效性（现有 `--check-assets` 的升级版）

### 3.3 CLI 瘦身：砍掉安装/更新，保留生成

**现状**：CLI 有 install/uninstall/update/check/list/track/clean/self-update 共 9 个命令。
**目标**：CLI 只保留与"生成定义"相关的功能。

**保留**：
- `tribucket generate` — 生成多格式文件
- `tribucket detect` — 自动检测 Release 资产并推断 pattern
- `tribucket check` — 验证 pattern 有效性
- `tribucket init` — 交互式创建 `.tribucket.yaml`

**砍掉**（不重复造轮子）：
- `install` / `uninstall` / `update` / `list` / `track` / `clean` — 用 Homebrew/Scoop/手动管理
- `self-update` — 用包管理器更新 tribucket 自身
- `config` — 配置通过 `.tribucket.yaml` 管理

**CLI 技术栈**：保留 Bun/TypeScript，编译为单文件二进制。

### 3.4 GitHub Action

创建 `action.yml`，让项目方在 CI 中自动运行：

```yaml
# 项目方的 .github/workflows/release.yml
- name: Generate package manager definitions
  uses: sixiang-world/tribucket/generate@v1
  with:
    config: .tribucket.yaml
    targets: homebrew,scoop,shell
    push: true  # 自动生成并提交
```

**Action 功能**：
1. 读取 `.tribucket.yaml`
2. 调用生成引擎
3. 可选：自动提交生成的文件到仓库
4. 可选：自动创建 Homebrew tap PR（如果项目方配置了 tap 仓库）

### 3.5 网站转型

**现状**：`tribucket.hunluan.space` 是一个软件源列表页。
**目标**：变成 tribucket 工具的文档站 + 使用 tribucket 的项目展示。

```
tribucket.hunluan.space/
├── /                   # 首页：tribucket 是什么，一行命令开始
├── /docs               # 文档：配置格式、CLI 用法、GitHub Action
├── /projects           # 展示：使用 tribucket 的开源项目
└── /api/packages/*     # 保留：现有的包元数据 API（给已有的 tribucket CLI 用户）
```

### 3.6 现有 107 个包的迁移

**策略**：不删除，但不再主动维护。

1. 现有 `packages/*.json` 继续保留，作为"tribucket 收录的项目"索引
2. `generate.yml` workflow 保留，但降低频率（从 6 小时改为每天）
3. 新增一个 `tribucket-projects.yml` 文件，记录使用 tribucket 的外部项目
4. 长期：鼓励项目方迁移到自己的 `.tribucket.yaml`，从 tribucket 索引中移除

---

## 4. 文件变更清单

### 新增

| 文件 | 说明 |
|------|------|
| `.tribucket.example.yaml` | 配置文件示例 |
| `docs/configuration.md` | 配置格式完整文档 |
| `docs/quickstart.md` | 快速开始指南 |
| `docs/github-action.md` | GitHub Action 使用文档 |
| `action.yml` | GitHub Action 定义 |
| `src/commands/init.ts` | CLI init 命令 |
| `src/commands/detect.ts` | CLI detect 命令 |
| `src/commands/generate.ts` | CLI generate 命令（从现有逻辑重构） |
| `src/config/loader.ts` | 统一配置加载（YAML + JSON） |
| `tribucket-projects.yml` | 使用 tribucket 的外部项目索引 |

### 修改

| 文件 | 变更 |
|------|------|
| `scripts/generate.py` | 解耦路径，支持 `.tribucket.yaml` 输入 |
| `src/index.ts` | 砍掉 install/update 等命令，只保留 generate/detect/check/init |
| `README.md` | 重写：从"软件源列表"变为"工具文档" |
| `CONTRIBUTING.md` | 重写：从"添加包到 tribucket"变为"使用 tribucket 的指南" |
| `website/build.ts` | 改为生成文档站 + 项目展示页 |
| `website/templates/index.html` | 重写为工具介绍页 |
| `.github/workflows/generate.yml` | 降低频率 |
| `edgeone.json` | 更新构建命令 |

### 删除（归档）

| 文件 | 说明 |
|------|------|
| `src/commands/install.ts` | 移到 `archive/removed-commands/` |
| `src/commands/uninstall.ts` | 同上 |
| `src/commands/update.ts` | 同上 |
| `src/commands/list.ts` | 同上 |
| `src/commands/track.ts` | 同上 |
| `src/commands/clean.ts` | 同上 |
| `src/commands/self-update.ts` | 同上 |
| `src/commands/config.ts` | 同上 |
| `src/engine/download.ts` | 不再需要下载引擎 |
| `src/engine/lock.ts` | 不再需要锁文件 |
| `src/engine/mirror.ts` | 不再需要镜像切换 |
| `src/config/paths.ts` | 不再需要安装路径管理 |
| `src/config/store.ts` | 不再需要本地状态存储 |
| `src/utils/archive.ts` | 不再需要解压 |
| `archive/python-v1/` | 已归档的 v1，可以删除 |

---

## 5. 开发阶段

### Phase 1：配置与检测（核心基础）

**目标**：定义文件格式 + 自动检测能力

1. 设计 `.tribucket.yaml` schema（兼容现有 `packages/*.json` 字段）
2. 实现配置加载器 `src/config/loader.ts`（YAML + JSON 双模式）
3. 实现 `tribucket detect` 命令（从 GitHub Release 推断 asset_pattern）
4. 改造 `scripts/generate.py` 支持 `.tribucket.yaml` 输入
5. 写 `tribucket-quickstart.md`

**产出**：项目方可以在自己仓库里放一个 `.tribucket.yaml`，跑 `tribucket generate` 生成 Formula + Manifest。

### Phase 2：CLI 重构

**目标**：精简 CLI，只保留生成相关命令

1. 新增 `tribucket init`（交互式创建配置文件）
2. 新增 `tribucket generate`（读取配置，输出文件）
3. 新增 `tribucket check`（验证 pattern）
4. 砍掉 install/update/track 等命令
5. 精简依赖：移除 download、archive、mirror 等模块

**产出**：CLI 从"包管理器"变为"定义文件生成器"，二进制体积大幅缩小。

### Phase 3：GitHub Action + CI

**目标**：项目方可以在 CI 中自动运行 tribucket

1. 编写 `action.yml`
2. 编写 Action 使用文档
3. 测试：在示例项目中配置 Action
4. 发布到 GitHub Marketplace

**产出**：项目方 `uses: sixiang-world/tribucket/generate@v1` 即可自动更新 Formula/Manifest。

### Phase 4：文档站 + 项目展示

**目标**：tribucket.hunluan.space 从软件源变为工具文档站

1. 重写 website 模板为文档站
2. 编写完整文档（配置参考、CLI 参考、最佳实践）
3. 添加"使用 tribucket 的项目"展示页
4. 保留旧 API 端点（`/packages/*.json`、`/bucket/*.json`）的兼容

**产出**：一个像样的产品文档站。

### Phase 5：格式扩展

**目标**：支持更多包管理器格式

1. AUR PKGBUILD 生成
2. Nix expression 生成
3. WinGet manifest 生成
4. `.deb` / `.rpm` spec 生成（可选，复杂度高）

---

## 6. 技术决策

| 决策点 | 选择 | 理由 |
|--------|------|------|
| 配置格式 | YAML（兼容 JSON） | YAML 更易手写，JSON 作为 fallback |
| CLI 语言 | 保留 Bun/TypeScript | 已有编译为单文件的能力，跨平台好 |
| 生成器语言 | 保留 Python | generate.py 已经成熟，改动量小 |
| 是否保留现有 107 包 | 保留但不维护 | 作为测试用例和索引，不主动删除 |
| 是否保留下载/安装能力 | 完全砍掉 | 不重复造轮子，Homebrew/Scoop/手动各管各的 |
| GitHub Action 语言 | Docker / composite | 灵活性最高，可复用 Python 生成器 |

---

## 7. 成功指标

| 指标 | 目标（6 个月） |
|------|---------------|
| 外部项目使用 tribucket | ≥ 10 个 |
| GitHub Action 使用量 | ≥ 50 次 |
| 支持的输出格式 | ≥ 4 种（Homebrew / Scoop / Shell / AUR） |
| 文档完整度 | 配置参考 + CLI 参考 + 快速开始 + 最佳实践 |
| CLI 二进制体积 | < 5MB（当前约 50MB） |

---

## 8. 风险与应对

| 风险 | 应对 |
|------|------|
| 现有用户（tribucket CLI 安装用户）流失 | 旧 API 保留兼容，README 说明迁移路径 |
| 项目方不愿意在自己仓库加配置文件 | 提供 `tribucket init` 一键生成 + GitHub Action 零配置方案 |
| GoReleaser 加了类似功能 | tribucket 聚焦"分发"而非"构建"，和 GoReleaser 互补而非竞争 |
| YAML 解析增加依赖 | Python 标准库支持 JSON；TypeScript 用 `js-yaml`（轻量） |

---

## 9. 与 OpenClaw Skill 的关系

已创建的 `tribucket-gen` skill（`.openclaw/skills/tribucket-gen/`）是**开发阶段的辅助工具**：

- 用 `fetch_release.sh` 快速分析新项目的 Release 资产
- 用 `templates.json` 的 7 种模板快速匹配已知模式
- 用 SKILL.md 的流程指导 AI 生成定义文件

这个 skill 在转型后仍然有用：
- 项目方可以用它快速生成初始的 `.tribucket.yaml`
- tribucket 维护者可以用它审核外部项目提交的定义文件
- 它是 `tribucket detect` 命令的"离线 AI 版"