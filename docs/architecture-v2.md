# tribucket v2 架构规划

> 当前版本: 0.1.0 → 目标版本: 2.0.0
>
> tribucket v1 聚焦「三合一包仓库」——一份 packages/*.json 自动生成
> Homebrew Formula + Scoop manifest + 安装脚本。
>
> v2 在此基础上扩展一个 **轻量化便携软件包管理器**：全局 CLI 跟踪管理安装的便携软件，
> 每个便携包自身是完整的自治单元，内置自检、更新能力。

---

## 目录

- [v2 目标](#v2-目标)
- [核心设计原则](#核心设计原则)
- [整体架构](#整体架构)
- [模块详解](#模块详解)
  - [全局 CLI — `tribucket`](#全局-cli--tribucket)
  - [便携包模板 — `packages/<name>/`](#便携包模板--packagesname)
  - [检测引擎 — `lib/check.sh`](#检测引擎--libchecksh)
  - [更新引擎 — `lib/update.sh`](#更新引擎--libupdatesh)
  - [镜像加速 — `lib/mirror.sh`](#镜像加速--libmirrorsh)
  - [全局跟踪 — `lib/track.sh`](#全局跟踪--libtracksh)
- [Package 元数据格式 — `tribucket.json`](#package-元数据格式--tribucketjson)
- [能力矩阵](#能力矩阵)
- [实施路线](#实施路线)

---

## v2 目标

1. **全局包管理器** — `tribucket` CLI 放在 PATH 中，能跟踪、检测、更新所有通过它安装的便携软件
2. **自治便携包** — 每个便携软件的文件夹自身就是一个完整的更新单元，内置 `install.sh` + `tribucket.json`，不依赖全局 CLI 也能自检和更新
3. **三合一兜底** — v1 的 Homebrew / Scoop / Shell 安装方式继续维护，v2 的便携包是第四种安装形态
4. **镜像加速** — 国内 IP 自动走 gh.do.hunluan.space 镜像，aria2 多连接加速
5. **通知驱动** — 不主动轮询，wxpush 通知触发人工检查，`tribucket check` / `tribucket update` 响应式操作

---

## 核心设计原则

- **每个便携包自治**：包的文件夹就是它的一切，拿走到任何机器都能自检、自更新
- **全局 CLI 是聚合器**：通过 `~/.tribucket/config` 记录已跟踪的包路径，代理调用各包的检测/更新逻辑
- **查远程优先，本地缓存兜底**：版本检测先跑 `--version`，拿不到再读 `tribucket.json` 中的静态版本号
- **原地替换**：更新就是下载新版 → 解压 → 覆盖旧文件，不做版本目录软链（与 feat/symlink-versioned-update 分支的方案不同）

---

## 整体架构

```
tribucket/                          ← 仓库根目录
│
├── bin/
│   └── tribucket                   ← 全局 CLI 入口（Shell 脚本）
│       ~/.tribucket/config          ← 全局跟踪配置（用户机器上）
│       ~/.tribucket/cache/          ← SHA256 / 上次检查时间等缓存
│
├── lib/                             ← 共享引擎（Shell 函数库）
│   ├── check.sh                     — 检测引擎
│   ├── update.sh                    — 下载替换引擎
│   ├── mirror.sh                    — 镜像判断 + aria2 加速
│   └── track.sh                     — 全局跟踪管理
│
├── packages/                        ← 便携包模板（每个包一个子目录）
│   └── go-wxpush/
│       ├── go-wxpush.exe            ← 便携软件本体
│       ├── install.sh               ← 自包含安装/更新入口
│       ├── tribucket.json           ← 包元数据
│       ├── cmd/
│       │   └── tribucket-update.bat ← Windows CMD 入口
│       └── pwsh/
│           └── tribucket-update.ps1 ← PowerShell 入口
│
├── scripts/                         ← v1 延续（packages/*.json 生成器）
│   ├── generate.py
│   ├── checkver.py
│   └── install.sh / install.ps1 / install.bat
│
├── Formula/                         ← v1 延续（自动生成的 Homebrew）
├── bucket/                          ← v1 延续（自动生成的 Scoop）
│
└── docs/                            ← 文档
    └── architecture-v2.md           ← 本文件
```

---

## 模块详解

### 全局 CLI — `tribucket`

安装在 PATH 中的入口脚本。业务逻辑委托给 `lib/` 中的引擎。

**命令集：**

| 命令 | 功能 | 依赖 |
|------|------|------|
| `tribucket track <name> <path>` | 录入便携包位置到 `~/.tribucket/config` | track.sh |
| `tribucket untrack <name>` | 从配置中移除 | track.sh |
| `tribucket list` | 列出所有已跟踪的包 | track.sh |
| `tribucket check [name]` | 检测指定/全部已跟踪包的信息和版本 | check.sh |
| `tribucket check <path>` | 检测指定路径的工具（不依赖跟踪配置） | check.sh |
| `tribucket update <name>` | 更新指定包（读跟踪配置 → 找包路径 → 执行更新） | update.sh |

**`~/.tribucket/config` 格式：**

```ini
# 一个便携包一行
go-wxpush=/usr/local/bin/go-wxpush
ccx=/home/user/apps/ccx
```

---

### 便携包模板 — `packages/<name>/`

每个便携包是一个自治单元，结构固定：

```
go-wxpush/
├── go-wxpush.exe          # 可执行文件（或解压后的二进制）
├── install.sh             # ✅ 核心——自包含安装/更新/检测
├── tribucket.json         # ✅ 元数据——描述这个包是什么
├── cmd/
│   └── tribucket-update.bat   # Windows 用户双击/Cmd 执行更新
└── pwsh/
    └── tribucket-update.ps1   # PowerShell 入口
```

**`install.sh` 职责：**
- 检测已安装版本的版本（`--version` → fallback json）
- 查远程 GitHub Release 最新版本
- 判断是否需要更新
- 下载 → 解压 → 替换自身
- 支持 `--mirror cn` 参数走镜像

**cmd / pwsh 入口：**
- 只是 `install.sh` 的壳，适配 Windows 执行环境
- cmd 里调 `install.sh`（假设有 Git Bash 或 WSL，或改用 bat 实现同等逻辑）
- pwsh 里直接实现 PowerShell 版检测+更新逻辑

---

### 检测引擎 — `lib/check.sh`

**检测流程：**

```
输入：工具路径 / 包名
  │
  ├─ 优先：跑 <binary> --version（或指定 flags）
  │     └─ 解析 stdout，提取版本号
  │
  └─ 回退：读 tribucket.json 的 version 字段
        └─ 显示静态版本号（标记为「缓存版本」）
  │
  ├─ 查远程（GitHub Releases API）
  │     └─ 获取最新发布版本 tag
  │
  └─ 输出对比结果：
       本地 v1.2.3  vs  远程 v1.2.5  →  有更新！
       本地 v1.2.3  vs  远程 v1.2.3  →  已是最新
```

**版本号解析策略（由 tribucket.json 声明）：**

```json
{
  "version_check": {
    "cli_flags": ["--version"],
    "parse_regex": "v?(\\d+\\.\\d+\\.\\d+)",
    "fallback_version": "1.2.3"
  }
}
```

- `cli_flags`：优先尝试的 CLI 参数列表（会逐个尝试直到有输出）
- `parse_regex`：从 CLI 输出中提取版本号的正则
- `fallback_version`：如果 binary 不存在或不可执行，fallback 到 json 里记录的版本

---

### 更新引擎 — `lib/update.sh`

**更新流程：**

```
输入：已跟踪的包名 或 便携包路径
  │
  ├─ 分辨目标平台（linux_amd64 / windows_amd64 / darwin_arm64 ...）
  ├─ 镜像判断（mirror.sh）
  │     ├─ 国内 IP → 替换下载 URL 为 gh.do.hunluan.space 镜像
  │     └─ 海外 IP → 直连 GitHub Releases
  ├─ 下载
  │     ├─ aria2 可用 → aria2 -x 4 多连接加速
  │     └─ 无 aria2 → curl / wget
  ├─ 校验（可选 SHA256）
  ├─ 解压（tar.gz / zip / 裸 binary）
  ├─ 备份旧文件（<binary>.bak）
  └─ 覆盖安装
       └─ 更新 ~/.tribucket/config 中的版本记录（如有）
```

---

### 镜像加速 — `lib/mirror.sh`

**逻辑：**

```
if 国内 IP（curl -s myip.ipip.net 或 ip.sb 判断）:
    if 有 aria2:
        URL → gh.do.hunluan.space/...   # 镜像替换
        aria2c -x 4 -s 4 <URL>
    else:
        URL → gh.do.hunluan.space/...
        curl -L <URL>
else:
    curl -L <URL>  直连 GitHub
```

- 支持 `--mirror cn` 强制走镜像 / `--mirror auto` 自动判断
- 镜像 URL 格式：`https://gh.do.hunluan.space/https://github.com/...`
- aria2 检测：`command -v aria2c`

---

### 全局跟踪 — `lib/track.sh`

**职责：**

| 操作 | 行为 |
|------|------|
| `track <name> <path>` | 检查 path 是否存在 → 写入 `~/.tribucket/config` |
| `untrack <name>` | 从 config 中移除该行 |
| `list` | 逐行读取 config，对每个包调 check.sh 显示状态 |
| `get_path <name>` | 从 config 查路径（供 update.sh 调用） |

---

## Package 元数据格式 — `tribucket.json`

每个便携包根目录下必须包含此文件。

```json
{
  "name": "go-wxpush",
  "version": "1.5.2",
  "repo": "sixiang-world/go-wxpush",
  "description": "WeChat push notification utility",
  "binary": "go-wxpush",
  "homepage": "https://github.com/sixiang-world/go-wxpush",
  "license": "MIT",

  "version_check": {
    "cli_flags": ["--version"],
    "parse_regex": "v?(\\d+\\.\\d+\\.\\d+)",
    "fallback_version": "1.5.2"
  },

  "asset_pattern": {
    "linux_amd64": "go-wxpush_*_linux_amd64.tar.gz",
    "linux_arm64": "go-wxpush_*_linux_arm64.tar.gz",
    "darwin_amd64": "go-wxpush_*_darwin_amd64.tar.gz",
    "darwin_arm64": "go-wxpush_*_darwin_arm64.tar.gz",
    "windows_amd64": "go-wxpush_*_windows_amd64.zip",
    "windows_arm64": "NO_MATCH"
  },

  "mirror": {
    "enabled": true,
    "template": "https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/v{version}/{asset}"
  }
}
```

**字段说明：**

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | ✅ | 软件名，也是便携文件夹名 |
| `version` | ✅ | 当前版本（fallback 用） |
| `repo` | ✅ | GitHub 仓库 `owner/repo` |
| `description` | ✅ | 一句话描述 |
| `binary` | ✅ | 可执行文件名 |
| `homepage` | | 项目主页 |
| `license` | ✅ | 开源协议 |
| `version_check.cli_flags` | | 优先尝试的 CLI 参数（默认 `["--version"]`） |
| `version_check.parse_regex` | | 从 CLI 输出取版本号的正则 |
| `version_check.fallback_version` | | 读不到 CLI 时的兜底版本号 |
| `asset_pattern` | ✅ | 各平台 Release asset 匹配规则 |
| `mirror.enabled` | | 是否走镜像（默认 true） |
| `mirror.template` | | 镜像 URL 模板（含 `{repo}` `{version}` `{asset}` 占位符） |

---

## 能力矩阵

| 场景 | 入口 | 检测 | 更新 |
|------|------|------|------|
| 在便携包文件夹里 | `./install.sh` | ✅ 读 tribucket.json → check engine | ✅ update engine |
| 在 cmd 里 | `cmd\tribucket-update.bat` | ✅ bat 调 check | ✅ bat 调 update |
| 在 pwsh 里 | `pwsh\tribucket-update.ps1` | ✅ powershell 版 check | ✅ powershell 版 update |
| 全局 PATH 任意位置 | `tribucket check go-wxpush` | ✅ 从 config 找路径 → check engine | — |
| 全局 PATH 任意位置 | `tribucket update go-wxpush` | — | ✅ 从 config 找路径 → update engine |
| 任意文件路径 | `tribucket check /path/to/binary` | ✅ 直接分析文件 | — |

---

## 实施路线

### Phase 1 — 引擎骨架

- [ ] 建立 `lib/` 目录，实现 `check.sh`（本地 `--version` 检测 + 远程 GitHub API 版本比对）
- [ ] 实现 `mirror.sh`（IP 判断 + URL 替换 + aria2 检测）
- [ ] 实现 `update.sh`（下载 → 解压 → 替换）
- [ ] 实现 `track.sh`（config 读写）
- [ ] `bin/tribucket` 入口脚本，串联各引擎

### Phase 2 — 便携包模板

- [ ] 定义 `tribucket.json` schema + 校验脚本
- [ ] 选定一个包（如 go-wxpush）制作完整的便携包模板
- [ ] 验证自治更新：文件夹内 `install.sh` 自检+更新
- [ ] cmd / pwsh 入口兼容

### Phase 3 — 全局集成

- [ ] `tribucket track` ←→ 便携包 `install.sh` 联动（安装时自动 track）
- [ ] `tribucket list` 显示所有已跟踪包的状态（名称 ↔ 路径 ↔ 版本 ↔ 远程版本）
- [ ] 镜像加速端到端验证（国内 VPS 实测）

### Phase 4 — 选装 & 文档

- [ ] 生成 `packages/*/tribucket.json` 的脚手架脚本
- [ ] 更新 README.md 说明 v2 架构
- [ ] 示例：如何创建自己的便携包
- [ ] 版本号升到 2.0.0

---

## 不做的事（明确排除）

| 项目 | 原因 |
|------|------|
| ❌ 多机情报共享 | 用户已明确排除 |
| ❌ 客户端定期轮询检查 | 通知驱动，不主动轮询 |
| ❌ 版本目录软链切换 | 原地替换，不做 symlink 管理 |
| ❌ 包依赖解析 | 每个包独立，不处理依赖树 |
| ❌ 包卸载/清理 | 便携软件删除文件夹即卸载 |
