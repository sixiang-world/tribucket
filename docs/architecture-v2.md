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
- [数据流](#数据流)
- [整体架构](#整体架构)
- [模块详解](#模块详解)
  - [全局 CLI — `tribucket`](#全局-cli--tribucket)
  - [便携包模板 — `portable/<name>/`](#便携包模板--portablename)
  - [检测引擎 — `lib/tribucket/check.py`](#检测引擎--libtribucketcheckpy)
  - [更新引擎 — `lib/tribucket/update.py`](#更新引擎--libtribucketupdatepy)
  - [镜像加速 — `lib/tribucket/mirror.py`](#镜像加速--libtribucketmirrorpy)
  - [全局跟踪 — `lib/tribucket/track.py`](#全局跟踪--libtribuckettrackpy)
  - [安装引擎 — `lib/tribucket/install.py`](#安装引擎--libtribucketinstallpy)
- [Package 元数据格式 — `tribucket.json`](#package-元数据格式--tribucketjson)
- [全局配置](#全局配置)
- [能力矩阵](#能力矩阵)
- [Bootstrap 安装](#bootstrap-安装)
- [测试策略](#测试策略)
- [错误处理](#错误处理)
- [离线行为](#离线行为)
- [并发安全](#并发安全)
- [Python 版本要求](#python-版本要求)
- [环境变量](#环境变量)
- [退出码](#退出码)
- [CLI 体验细节](#cli-体验细节)
- [非 GitHub 源](#非-github-源)
- [实施路线](#实施路线)
- [不做的事（明确排除）](#不做的事明确排除)

---

## v2 目标

1. **全局包管理器** — `tribucket` CLI 放在 PATH 中，能安装、跟踪、检测、更新所有通过它管理的便携软件
2. **自治便携包** — 每个便携软件的文件夹自身就是一个完整的更新单元，内置 `install.sh` + `tribucket.json`，不依赖全局 CLI 也能自检和更新
3. **三合一兜底** — v1 的 Homebrew / Scoop / Shell 安装方式继续维护，v2 的便携包是第四种安装形态
4. **镜像加速** — 支持多镜像 provider 自动探测 + fallback，国内环境自动加速
5. **响应式操作** — `tribucket check` / `tribucket update` 手动触发，可选推送通知作为增强

---

## 核心设计原则

- **CLI 优先，自治兜底**：`install.sh` 优先委托给 tribucket CLI（获得备份、并发保护、断点续传等完整能力）。CLI 不可用时降级为 standalone 模式（只做版本检测，不做更新）
- **全局 CLI 是聚合器**：通过 `~/.tribucket/config.json` 记录已跟踪的包路径，提供更丰富的管理能力
- **Python 核心引擎**：CLI 的检测/更新/镜像/跟踪逻辑用 Python 实现，Shell 只做薄封装
- **安全更新**：下载和解压在临时目录完成，SHA256 校验通过后才替换，支持版本目录备份回滚
- **单一数据源**：`packages/*.json` 是唯一 source of truth，`tribucket.json` 和便携包模板由 `generate.py` 自动生成
- **原地替换**：更新就是下载新版 → 解压 → 覆盖旧文件，不做版本目录软链

---

## 数据流

```
                    packages/*.json
                   (唯一 source of truth)
                         │
                         ▼
                    generate.py
                   /     |      \
                  /      |       \
                 ▼       ▼        ▼
          Formula/*.rb  bucket/*.json  (构建产物，不提交 git)
                                    portable/<name>/
                                    ├── tribucket.json
                                    ├── install.sh
                                    └── cmd/tribucket-update.bat
```

`generate.py` 同时产出三种格式。v2 不废弃 v1，只是增加了便携包输出。

**运行时数据流（用户机器上）：**

```
~/.tribucket/
├── config.json              ← 已跟踪包的安装地图
├── cache/
│   ├── versions.json        ← 远程版本缓存（TTL）
│   └── mirror_status.json   ← 镜像探测缓存（TTL）
└── backup/
    └── <name>/
        └── <version>/       ← 更新前的备份
```

---

## 整体架构

```
tribucket/                          ← 仓库根目录
│
├── bin/
│   └── tribucket                   ← 全局 CLI 入口（Python 单文件脚本）
│
├── lib/
│   └── tribucket/                  ← Python 引擎包（CLI 内部使用）
│       ├── __init__.py
│       ├── __main__.py             ← python -m tribucket 入口
│       ├── cli.py                  ← argparse 命令定义 + 路由
│       ├── check.py                ← 版本检测引擎
│       ├── update.py               ← 下载/解压/替换引擎
│       ├── install.py              ← 首次安装引擎
│       ├── mirror.py               ← 镜像 provider + 探测
│       ├── track.py                ← 全局配置管理
│       ├── config.py               ← 路径常量（~/.tribucket/）
│       └── utils.py                ← 共享工具（http_get, compute_sha256 等）
│
├── packages/                        ← v1 数据源（*.json，不变）
│   ├── go-wxpush.json
│   ├── ripgrep.json
│   └── ...
│
├── portable/                        ← v2 便携包模板（generate.py 构建，不提交 git）
│   ├── go-wxpush/
│   │   ├── tribucket.json
│   │   ├── install.sh
│   │   └── cmd/tribucket-update.bat
│   └── ...
│
├── scripts/
│   ├── generate.py                  ← 生成 Formula + Bucket + portable
│   ├── checkver.py                  ← 版本检测
│   └── install.sh / install.ps1 / install.bat
│
├── Formula/                         ← v1 延续（自动生成的 Homebrew）
├── bucket/                          ← v1 延续（自动生成的 Scoop）
├── tests/                           ← pytest 测试套件
│
├── .gitignore                       ← portable/ 加入忽略
├── VERSION                          ← CLI 语义版本号
└── docs/
    └── architecture-v2.md           ← 本文件
```

---

## 模块详解

### 全局 CLI — `tribucket`

Python 单文件脚本，安装在 PATH 中。使用 argparse，零外部依赖。

**命令集：**

| 命令 | 功能 | 说明 |
|------|------|------|
| `tribucket install <name>` | 首次安装便携包 | 下载模板 + 二进制，自动 track |
| `tribucket uninstall <name>` | 卸载便携包 | 删除文件 + symlink + backup + config |
| `tribucket track <name> [path]` | 手动录入已存在的便携包 | 默认 path 为当前目录 |
| `tribucket untrack <name>` | 从配置中移除 | 只移除记录，不删文件 |
| `tribucket list` | 列出所有已跟踪的包 | 显示名称、版本、路径、状态 |
| `tribucket check [name\|path]` | 检测版本 | 本地 + 远程比对，支持 `--refresh` |
| `tribucket update <name>` | 更新指定包 | 下载 → 校验 → 替换 |
| `tribucket --version` | 显示版本号 | |
| `tribucket --help` | 显示帮助 | |

**`install` 参数：**

```bash
tribucket install <name> [options]
  --dir, -d <path>    安装目录（默认：当前工作目录）
  --link              安装后创建 symlink 到 ~/.tribucket/bin/
  --force             覆盖已存在的安装
  --mirror <mode>     镜像模式：auto / cn / direct
```

**`update` 参数：**

```bash
tribucket update <name> [options]
  --force             强制重新下载（忽略缓存）
  --mirror <mode>     镜像模式
  --no-backup         跳过备份
```

**`check` 参数：**

```bash
tribucket check [name|path ...] [options]
  --all               检查所有已跟踪的包
  --refresh           忽略版本缓存，强制查远程
  --local-only        只检查本地版本，不查远程
  --json              输出 JSON 格式
```

支持同时检查多个包：`tribucket check go-wxpush ripgrep`。`--all` 使用 4 个 worker 并发检查（~25s / 100 包）。

**`check <path>` — 裸二进制检测：**

```bash
tribucket check /usr/local/bin/rg [--repo BurntSushi/ripgrep]
```

- 无 `--repo`：只做本地版本检测（`--version`），不查远程
- 有 `--repo`：查指定 repo 的远程版本

**`list` 输出格式：**

```
$ tribucket list
Name          Version    Path                              Status
go-wxpush     1.5.2      /opt/tools/go-wxpush              ✓ latest
ccx           2.1.0      ~/projects/myapp/ccx              ⚠ 2.1.0 → 2.2.0
ripgrep       14.1.0     /usr/local/bin/rg                 ✓ latest
```

---

### 便携包模板 — `portable/<name>/`

每个便携包是一个自治单元。`portable/` 目录由 `generate.py` 构建产出，**不提交到 git**（加入 `.gitignore`）。

**便携包结构：**

```
go-wxpush/
├── install.sh                    ← ✅ 核心——tribucket CLI 代理 + standalone fallback
├── tribucket.json                ← ✅ 元数据——由 generate.py 自动生成
└── cmd/
    └── tribucket-update.bat      ← Windows CMD 入口
```

**`install.sh` 设计（tribucket CLI 优先）：**

`install.sh` 优先检测 tribucket CLI 是否可用，可用则委托（获得备份、并发保护、断点续传等完整能力）。CLI 不可用时降级为 standalone 模式（只做版本检测，不做更新）。

```
install.sh 的行为分支：
  tribucket CLI 可用：
    install.sh check   → tribucket check     （完整功能）
    install.sh update  → tribucket update    （完整功能，有备份）
    install.sh         → tribucket check     （默认行为）

  tribucket CLI 不可用：
    install.sh         → standalone mode（只检测，不更新）
    输出提示安装 tribucket CLI 以获得完整能力
```

这样**不再有两套独立的更新逻辑**。Shell fallback 只做版本检测，更新必须通过 tribucket CLI。消除了 Shell vs Python 行为不一致的问题。

**`.bat` 入口设计：**

cmd `.bat` 做基本检查和版本显示，不做更新（bat 无法做 JSON 解析和 HTTP 下载）：

```bat
@echo off
REM Auto-generated by generate.py — do not edit
SET SCRIPT_DIR=%~dp0
SET BINARY=%SCRIPT_DIR%go-wxpush.exe

if not exist "%BINARY%" (
    echo Error: %BINARY% not found.
    echo Please install with: tribucket install go-wxpush
    exit /b 1
)

"%BINARY%" --version
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to run %BINARY%
    exit /b 1
)

echo.
echo To update, run: tribucket update go-wxpush
```

> **注意**：Windows 用户更推荐使用全局 `tribucket` CLI（通过 Homebrew/Scoop 安装），而非便携包内的 .bat 入口。

---

### 检测引擎 — `lib/tribucket/check.py`

**检测流程：**

```
输入：工具路径 / 包名
  │
  ├─ 优先：跑 <binary> --version（或指定 flags）
  │     └─ 从 stdout/stderr 提取版本号（parse_regex）
  │
  └─ 回退：读 tribucket.json 的 version 字段
        └─ 显示静态版本号（标记为「缓存版本」）
  │
  ├─ 查远程（GitHub Releases API）← 可选，--refresh 时强制
  │     └─ 获取最新发布版本 tag
  │
  └─ 输出对比结果：
       本地 v1.2.3  vs  远程 v1.2.5  →  ⚠ 有更新
       本地 v1.2.3  vs  远程 v1.2.3  →  ✓ 已是最新
       本地 v1.2.3  vs  远程 ?       →  ? 离线，无法检测
```

**版本号解析策略（由 tribucket.json 声明）：**

```json
{
  "version_check": {
    "cli_flags": ["--version"],
    "parse_regex": "v?(\\d+\\.\\d+(?:\\.\\d+)?)",
    "output_stream": "stdout",
    "timeout": 5,
    "fallback_version": "1.5.2"
  }
}
```

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `cli_flags` | `["--version"]` | 逐个尝试，取第一个成功匹配 parse_regex 的结果 |
| `parse_regex` | `v?(\d+\.\d+(?:\.\d+)?)` | 从 CLI 输出提取版本号（支持两段如 `8.5` 和三段如 `1.2.3`） |
| `output_stream` | `"stdout"` | `"stdout"` / `"stderr"` / `"both"` |
| `timeout` | `5` | 命令超时秒数，防止 hang |
| `fallback_version` | — | binary 不存在或不可执行时的兜底版本 |

**版本检测优先级链：**

```
1. binary 存在且可执行 → 跑 cli_flags → parse_regex 提取版本
2. config.json 有版本记录 → 使用 config 版本
3. tribucket.json fallback_version → 使用 fallback 版本
4. 以上都没有 → "unknown"
```

输出中标注版本来源：`1.5.3 (cli)` / `2.1.0 (config)` / `1.5.2 (fallback)` / `unknown`

**远程版本缓存：**

```json
// ~/.tribucket/cache/versions.json
{
  "go-wxpush": {
    "remote_version": "1.5.3",
    "checked_at": "2026-06-12T10:00:00Z",
    "ttl_seconds": 3600
  }
}
```

- 默认 TTL 1 小时
- `tribucket check --refresh` 强制刷新
- `tribucket check --local-only` 跳过远程查询

---

### 更新引擎 — `lib/tribucket/update.py`

**更新流程（安全中转模式）：**

```
输入：已跟踪的包名
  │
  ├─ 1. 从 config.json 查路径
  ├─ 2. 读 portable/<name>/tribucket.json
  ├─ 3. 检测本地版本（--version → fallback）
  ├─ 4. 查远程版本（GitHub API，缓存优先）
  ├─ 5. 版本相同 → 跳过
  │
  ├─ 6. 镜像探测（TTL 缓存）
  ├─ 7. 下载到临时目录 /tmp/tribucket-xxx/
  ├─ 8. SHA256 校验（从 tribucket.json 或 checksum 文件获取）
  ├─ 9. 解压到临时目录
  ├─ 10. 验证可执行文件存在
  │
  ├─ 11. 备份当前版本到 ~/.tribucket/backup/<name>/<version>/
  ├─ 12. 移动新文件到位（替换）
  ├─ 13. 验证新版本（<binary> --version）
  │     ├─ 成功 → 删除备份
  │     └─ 失败 → 从备份恢复
  │
  └─ 14. 更新 config.json 中的版本记录
```

**关键设计：**

- 下载和解压都在临时目录完成，只有验证通过才替换
- 备份是版本目录（`.backup/<name>/<1.5.2>/`），支持多版本
- 失败时自动恢复，不需要用户手动干预

---

### 镜像加速 — `lib/tribucket/mirror.py`

**多 Provider + TTL 缓存 + fallback：**

```python
# 默认 provider（内置）
DEFAULT_PROVIDERS = [
    {
        "name": "hunluan",
        "template": "https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/v{version}/{asset}",
        "test_url": "https://gh.do.hunluan.space/",
    },
]
```

**探测流程：**

```
tribucket update go-wxpush
  │
  ├─ 检查 ~/.tribucket/cache/mirror_status.json
  │   ├─ 有缓存且未过期 → 直接用上次成功的 provider
  │   └─ 无缓存或已过期 ↓
  │
  ├─ 逐个探测 provider（串行，3s 超时）
  │   ├─ hunluan: OK (230ms)
  │   ├─ ghproxy: timeout
  │   └─ direct: OK (890ms)
  │
  ├─ 选择最快可用的 provider
  ├─ 缓存结果（TTL 1 小时）
  └─ 用选中的 provider 下载
```

**镜像缓存格式：**

```json
// ~/.tribucket/cache/mirror_status.json
{
  "checked_at": "2026-06-12T10:00:00Z",
  "ttl_seconds": 3600,
  "providers": {
    "hunluan": { "ok": true, "latency_ms": 230 },
    "ghproxy": { "ok": false, "error": "timeout" },
    "direct": { "ok": true, "latency_ms": 890 }
  },
  "selected": "hunluan"
}
```

**用户可配置（`~/.tribucket/mirror.json`）：**

```json
{
  "enabled": true,
  "providers": [
    {
      "name": "custom-mirror",
      "template": "https://my-mirror.example.com/https://github.com/{repo}/releases/download/v{version}/{asset}",
      "test_url": "https://my-mirror.example.com/"
    }
  ],
  "fallback": "direct",
  "force": null
}
```

- `force: "hunluan"` — 强制走某个 provider
- `force: "direct"` — 强制直连
- `force: null` — 自动探测

---

### 全局跟踪 — `lib/tribucket/track.py`

**`~/.tribucket/config.json` 格式：**

```json
{
  "packages": {
    "sixiang-world/go-wxpush": {
      "name": "go-wxpush",
      "path": "/opt/tools/go-wxpush",
      "version": "1.5.2",
      "installed_at": "2026-06-12T10:00:00Z",
      "linked": false
    },
    "BurntSushi/ripgrep": {
      "name": "ripgrep",
      "path": "/usr/local/bin/rg",
      "version": "14.1.0",
      "installed_at": "2026-06-10T08:30:00Z",
      "linked": true
    }
  }
}
```

- key 是 `owner/repo`（全局唯一）
- `name` 是显示名
- `linked` 记录是否创建了 symlink

**Stale entry 处理：**

`tribucket list` 和 `tribucket check` 遇到不存在的路径时：

```
$ tributex list
Name          Version    Path                              Status
go-wxpush     1.5.2      /opt/tools/go-wxpush              ✓ latest
ripgrep       ✗ not found /tmp/deleted/ripgrep              (stale entry)

? Found 1 stale entry. Remove? [y/N]
```

**Dangling symlink 检测：**

`list` 和 `check` 时检测悬空 symlink：

```
⚠ Found 1 dangling symlink: ~/.tribucket/bin/go-wxpush → /opt/tools/go-wxpush/go-wxpush
  → Run 'tribucket untrack go-wxpush' to clean up
```

**`uninstall` 清理流程：**

1. 删除便携包目录
2. 删除 symlink（`~/.tribucket/bin/<binary>`）
3. 删除备份（`~/.tribucket/backup/<name>/`）
4. 从 config.json 移除
5. 检查是否有其他包共享同一路径（避免误删）

---

### 安装引擎 — `lib/tribucket/install.py`

**`tribucket install` 流程：**

```
tribucket install go-wxpush
  │
  ├─ 1. 查 config.json 是否已安装
  │     ├─ 已存在 → 报错提示用 update 或 --force
  │     └─ 未安装 ↓
  │
  ├─ 2. 从 tribucket 仓库 GitHub API 获取 packages/go-wxpush.json
  │     └─ 实时获取，不需要更新 tribucket CLI
  │
  ├─ 3. 用内置模板渲染便携包文件
  │     ├── tribucket.json（从 packages/*.json 派生 + 默认值）
  │     ├── install.sh（模板渲染，变量替换）
  │     └── cmd/tribucket-update.bat
  │
  ├─ 4. 写入目标目录（当前工作目录/<name>/ 或 --dir 指定）
  │
  ├─ 5. 识别当前平台，匹配 asset_pattern
  │
  ├─ 6. 镜像探测 + 下载二进制
  │
  ├─ 7. SHA256 校验
  │
  ├─ 8. 解压到便携包目录
  │
  ├─ 9. chmod +x（Unix）
  │
  ├─ 10. 验证 <binary> --version 成功
  │
  ├─ 11. --link 时创建 symlink: ~/.tribucket/bin/<binary> → <path>/<binary>
  │
  ├─ 12. 写入 config.json（自动 track）
  │
  └─ 13. 输出安装结果
```

**安装目录安全检查：**

```python
FORBIDDEN_DIRS = ["/", "/usr", "/bin", "/sbin", "/etc", "/var", "/tmp"]

def validate_install_dir(target_dir):
    # 拒绝系统目录
    if target_dir in FORBIDDEN_DIRS or any(target_dir.startswith(p + "/") for p in FORBIDDEN_DIRS):
        print(f"Error: Refusing to install into system directory: {target_dir}")
        sys.exit(1)
    # 拒绝 ~/.tribucket/ 内（避免循环引用）
    if target_dir.startswith(os.path.expanduser("~/.tribucket/")):
        print(f"Error: Cannot install into tribucket's own directory.")
        sys.exit(1)
    # 目标已存在且非空
    if os.path.exists(target_dir) and os.listdir(target_dir):
        print(f"Error: Directory not empty: {target_dir}")
        print(f"Tip: Use --force to overwrite.")
        sys.exit(1)
```

**`--dir` 和 `--link` 交互：**

| `--dir` | `--link` | 行为 |
|---------|----------|------|
| 默认（`$(pwd)`） | 默认（不 link） | 装在当前目录，提示加 PATH |
| 默认 | `--link` | 装在当前目录 + symlink 到 `~/.tribucket/bin/` |
| 指定路径 | 默认 | 装在指定路径，提示加 PATH |
| 指定路径 | `--link` | 装在指定路径 + symlink |

安装完成后，如果没用 `--link`，自动提示：

```
Installed: ~/projects/myapp/ripgrep/rg
Not in PATH. Options:
  1. Add to PATH:  export PATH="$PWD/ripgrep:$PATH"
  2. Reinstall with symlink:  tribucket install ripgrep --link
```

**安装后的目录结构（用户机器上）：**

```
# 用户在 /opt/tools/ 下安装
/opt/tools/go-wxpush/
├── go-wxpush               ← 二进制
├── tribucket.json           ← 元数据
├── install.sh               ← 自包含更新脚本
└── cmd/
    └── tribucket-update.bat

# ~/.tribucket/（全局）
~/.tribucket/
├── config.json              # 已跟踪包的安装地图
├── bin/
│   └── go-wxpush → /opt/tools/go-wxpush/go-wxpush   # symlink（如果 --link）
├── cache/
│   ├── versions.json
│   └── mirror_status.json
└── backup/
    └── go-wxpush/
        └── 1.5.2/           ← 更新前的备份
```

---

## Package 元数据格式 — `tribucket.json`

每个便携包根目录下必须包含此文件。**由 `generate.py` 从 `packages/*.json` 自动生成，禁止手动编辑。**

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
    "parse_regex": "v?(\\d+\\.\\d+(?:\\.\\d+)?)",
    "output_stream": "stdout",
    "timeout": 5,
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

  "asset_format": {
    "linux_amd64": "tar.gz",
    "linux_arm64": "tar.gz",
    "darwin_amd64": "tar.gz",
    "darwin_arm64": "tar.gz",
    "windows_amd64": "zip"
  },

  "install_type": "binary",

  "mirror": {
    "enabled": true
  }
}
```

**字段来源：**

| 字段 | 来自 | 说明 |
|------|------|------|
| `name` | `packages/*.json` | 软件名 |
| `version` | `generate.py`（checkver 回写） | 当前版本（fallback 用，运行时由 config.json 管理） |
| `repo` | `packages/*.json` | GitHub 仓库 |
| `description` | `packages/*.json` | 一句话描述 |
| `binary` | `packages/*.json` | 可执行文件名（`install_type=directory` 时为相对路径如 `bin/java`） |
| `homepage` | `packages/*.json` | 项目主页 |
| `license` | `packages/*.json` | 开源协议 |
| `version_check` | `generate.py` 默认值 | 版本检测配置 |
| `version_check.include_prerelease` | `false` | 是否跟踪 pre-release 版本 |
| `asset_pattern` | `packages/*.json` | 各平台 asset 匹配 |
| `asset_format` | `generate.py` 推断 | 从 asset filename 后缀推断 |
| `install_type` | `packages/*.json` 或推断 | `"binary"`（默认）或 `"directory"` |
| `download_url` | `packages/*.json`（可选） | 非 GitHub 源的直接下载 URL |
| `mirror` | `generate.py` 默认值 | 镜像配置 |

**`install_type` 说明：**

| 值 | 行为 | 适用场景 |
|----|------|----------|
| `"binary"` | 只提取 `binary` 指定的单个文件 | ripgrep, fzf, go-wxpush 等 |
| `"directory"` | 解压整个 archive 到便携包目录 | JDK, Go, Node 等多文件包 |

`generate.py` 自动推断：包名以 `*-jdk*`, `graalvm-*` 开头时默认为 `directory`，其他默认为 `binary`。可在 `packages/*.json` 中显式声明覆盖。

**版本同步策略：**

`tribucket.json` 的 `version` 字段是**生成时的静态 fallback 值**，运行时不修改。`tribucket update` 后的版本记录写入 `~/.tribucket/config.json`。

```
tribucket.json version = 生成时版本（fallback，不随更新变化）
config.json version    = 实际安装版本（update 时更新）
```

检测逻辑：本地版本取 `binary --version` 输出，fallback 时取 `config.json version`，最后取 `tribucket.json version`。

---

## 全局配置

**`~/.tribucket/mirror.json`（镜像配置）：**

```json
{
  "enabled": true,
  "providers": [
    {
      "name": "hunluan",
      "template": "https://gh.do.hunluan.space/https://github.com/{repo}/releases/download/v{version}/{asset}",
      "test_url": "https://gh.do.hunluan.space/"
    }
  ],
  "fallback": "direct",
  "force": null
}
```

**`~/.tribucket/config.json` 全局设置：**

```json
{
  "settings": {
    "default_install_dir": null,
    "auto_link": false
  },
  "packages": { ... }
}
```

- `default_install_dir`：`tribucket install` 不带 `--dir` 时使用（默认 `$(pwd)`）
- `auto_link`：是否默认创建 symlink

可通过 `tribucket config set <key> <value>` 修改。

**GitHub API 获取包元数据：**

`tribucket install` 从 tribucket 仓库获取 `packages/*.json`：

```
GET https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages/{name}.json
```

直接返回 JSON，无需解码。

**GitHub Token：**

通过环境变量 `GITHUB_TOKEN` 传递，提升 API 限流（60 → 5000 次/小时）。

---

## 能力矩阵

| 场景 | 入口 | 检测 | 更新 | 备份 |
|------|------|------|------|------|
| 便携包文件夹 + tribucket CLI | `./install.sh check/update` | ✅ 委托 tribucket | ✅ 委托 tribucket | ✅ |
| 便携包文件夹 standalone | `./install.sh` | ✅ Shell 检测 | ❌ 需要 CLI | ❌ |
| cmd 里 | `cmd\tribucket-update.bat` | ✅ 运行 binary | ❌ 不支持 | — |
| 全局 PATH | `tribucket check <name>` | ✅ Python 引擎 | — | — |
| 全局 PATH | `tribucket update <name>` | — | ✅ Python 引擎 | ✅ |
| 全局 PATH | `tribucket install <name>` | ✅ | ✅ 首次安装 | — |
| 任意路径 | `tribucket check /path/to/binary` | ✅ 直接分析 | — | — |

---

## Bootstrap 安装

tribucket 自身支持三种安装方式：

### Homebrew（推荐）

```bash
brew install sixiang-world/tribucket/tribucket
```

### Scoop（Windows）

```bash
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install tribucket
```

### curl 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash
```

`scripts/install.sh`（v2 版本）逻辑：

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO="sixiang-world/tribucket"
INSTALL_DIR="${TRIBUCKET_INSTALL_DIR:-$HOME/.tribucket}"

# 1. 创建 ~/.tribucket/ 目录结构
mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/cache" "$INSTALL_DIR/backup"

# 2. 下载 tribucket CLI（Python 单文件）
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/bin/tribucket" \
    -o "$INSTALL_DIR/bin/tribucket"
chmod +x "$INSTALL_DIR/bin/tribucket"

# 3. 提示用户加 PATH
echo ""
echo "tribucket installed to: $INSTALL_DIR/bin/tribucket"
echo ""
echo "Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
echo "  export PATH=\"$INSTALL_DIR/bin:\$PATH\""
```

**安装方式选择：**

| 方式 | 适用场景 |
|------|----------|
| Homebrew | macOS / Linux 长期使用 |
| Scoop | Windows 长期使用 |
| curl | 快速试用、CI/CD 环境 |

---

## 测试策略

复用 v1 的 pytest 框架。测试优先级：

### P0 — 核心功能

| 测试文件 | 测试点 |
|----------|--------|
| `test_check.py` | 版本解析正则、`--version` 输出解析、fallback 逻辑、timeout |
| `test_track.py` | config.json 读写、list 输出格式、stale entry 处理 |

### P1 — 更新/镜像

| 测试文件 | 测试点 |
|----------|--------|
| `test_update.py` | URL 构建、临时目录→替换流程、SHA256 校验、备份恢复 |
| `test_mirror.py` | URL 模板填充、provider 探测（mock HTTP）、TTL 缓存、fallback |

### P2 — CLI/生成

| 测试文件 | 测试点 |
|----------|--------|
| `test_cli.py` | argparse 参数解析、命令路由、帮助信息 |
| `test_generate.py`（扩展） | tribucket.json 派生、install.sh 模板渲染、asset_format 推断 |

### P3 — 集成

| 测试文件 | 测试点 |
|----------|--------|
| `test_integration.py` | 端到端：mock GitHub API → install → check → update → uninstall |

### Mock 策略

```python
# mock GitHub API
monkeypatch.setattr("lib.tribucket.utils.http_get", mock_github_api_response)

# mock 文件系统
monkeypatch.setattr("lib.tribucket.mirror.test_provider", lambda p: True)

# mock 下载（不真实下载）
monkeypatch.setattr("lib.tribucket.update.download_file", mock_download_to_tmp)
```

---

## 错误处理

**统一错误输出格式：**

```
Error: [category] message
  → suggestion
```

**错误场景：**

| 场景 | 类别 | 处理方式 |
|------|------|----------|
| GitHub API 404 | `not-found` | 包名错误或仓库不存在 |
| GitHub API 403 | `rate-limit` | 提示设置 GITHUB_TOKEN |
| 下载失败 | `network` | 重试 3 次，指数退避，支持断点续传 |
| SHA256 不匹配 | `integrity` | 删除下载文件，报错退出 |
| 解压失败 | `archive` | 删除临时目录，报错退出 |
| 磁盘空间不足 | `disk` | 预检查可用空间 |
| 二进制不可执行 | `permission` | `chmod +x` 后再验证 |
| config.json 损坏 | `config` | 尝试备份恢复，或重新初始化 |
| 路径不存在 | `stale` | 列出时标记，建议 untrack |
| 并发更新冲突 | `locked` | 文件锁保护 |
| Python < 3.8 | `runtime` | 提示升级 Python |
| symlink 悬空 | `stale-link` | list/check 时检测并提示 |
| 包已安装 | `exists` | 提示用 update 或 --force |
| 系统目录 | `forbidden` | 拒绝安装到 /、/usr、/tmp 等 |
| Ctrl+C 中断 | — | 保留临时文件，提示重跑续传 |

**离线降级：**

`tribucket check` 在无网络时只显示本地版本，远程标记为 `?`，不报错。

---

## 离线行为

| 命令 | 有网络 | 无网络 |
|------|--------|--------|
| `tribucket list` | ✅ 正常 | ✅ 正常（只读本地） |
| `tribucket check` | ✅ 本地+远程 | ⚠️ 只本地，远程标记 `?` |
| `tribucket check --local-only` | ✅ 正常 | ✅ 正常 |
| `tribucket update` | ✅ 正常 | ❌ 需要网络 |
| `tribucket install` | ✅ 正常 | ❌ 需要网络 |
| `tribucket track` | ✅ 正常 | ✅ 正常（纯本地） |
| `tribucket untrack` | ✅ 正常 | ✅ 正常（纯本地） |
| `tribucket uninstall` | ✅ 正常 | ✅ 正常（纯本地） |

---

## 并发安全

两个终端同时 `tribucket update <name>` 会冲突。用文件锁保护：

```python
import fcntl, contextlib

@contextlib.contextmanager
def lock_package(name):
    lock_path = os.path.join(config_dir(), "locks", f"{name}.lock")
    os.makedirs(os.path.dirname(lock_path), exist_ok=True)
    with open(lock_path, "w") as f:
        try:
            fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
            yield
        except BlockingIOError:
            print(f"Error: Another update for '{name}' is in progress.")
            sys.exit(1)
        finally:
            fcntl.flock(f, fcntl.LOCK_UN)
```

Windows 上检查 lock 文件 PID 是否存活（无需真正的文件锁）。

**断点续传：**

下载中断后，支持 HTTP Range 头续传。下载文件命名为 `download.tmp`，完成后 rename。中断后提示用户重新运行同一命令。

**Ctrl+C 中断处理：**

```python
import signal
def handle_interrupt(signum, frame):
    print("\nInterrupted. Partial download saved. Run same command to resume.")
    sys.exit(130)
signal.signal(signal.SIGINT, handle_interrupt)
```

中断后保留临时文件（支持续传），不自动清理。

---

## Python 版本要求

最低要求 **Python 3.8**。CLI 头部加版本检查：

```python
#!/usr/bin/env python3
import sys
if sys.version_info < (3, 8):
    print("Error: tribucket requires Python 3.8 or later.")
    sys.exit(1)
```

---

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `GITHUB_TOKEN` | — | GitHub API token（60 → 5000 次/小时） |
| `HTTP_PROXY` | — | HTTP 代理 |
| `HTTPS_PROXY` | — | HTTPS 代理 |
| `TRIBUCKET_VERBOSE` | `0` | 详细日志（`1` 启用） |
| `TRIBUCKET_HOME` | `~/.tribucket` | tribucket 数据目录 |
| `TRIBUCKET_INSTALL_DIR` | — | bootstrap 安装目录 |

`TRIBUCKET_HOME` 允许用户把所有数据放在自定义位置（如 `$HOME/.config/tribucket`）。

---

## 退出码

| 退出码 | 含义 |
|--------|------|
| 0 | 成功 |
| 1 | 一般错误（网络、校验、权限等） |
| 2 | 用法错误（参数不正确） |
| 3 | 包不存在 |
| 4 | 包已安装（重复安装） |
| 5 | 包未安装（重复卸载） |
| 6 | 版本已是最新（update 时无需更新） |
| 7 | 网络不可达 |

---

## CLI 体验细节

**JSON 输出（脚本集成）：**

```bash
$ tribucket list --json
{"packages": {"sixiang-world/go-wxpush": {"name": "go-wxpush", "version": "1.5.2", ...}}}

$ tribucket check --all --json
{"go-wxpush": {"local": "1.5.2", "remote": "1.5.3", "status": "outdated"}, ...}
```

**`status` 字段值**：`"latest"` | `"outdated"` | `"unknown"`（离线） | `"error"`

**非交互模式**：`tribucket update` 默认直接更新（不确认）。`--dry-run` 只看不改。

**`--no-color` / `--plain`**：纯文本输出，无符号。

**`--version` JSON**：`tribucket --version --json` 输出 `{"version": "2.0.0", "python": "3.11.4", "platform": "linux_amd64"}`

**stderr 分离**：正常输出到 stdout，错误和警告到 stderr。

**`tribucket info <name>`**：显示包的完整元数据（repo、license、asset_pattern、version_check 配置等）。

**`tribucket config list/get/set/unset`**：全局设置管理。

**`tribucket self-update`**：从 GitHub 下载最新版 `bin/tribucket` 替换自身。

**`tribucket update --all`**：批量更新所有已跟踪包，4 workers 并发。

**`tribucket update --dry-run`**：显示会更新到什么版本，不实际执行。

**`tribucket list --sort status`**：有更新的排前面。

**Shell completion**：手写 bash completion 脚本，零依赖。安装时提示 source。

**`tribucket.json` 版本格式**：默认 regex `v?(\d+\.\d+(?:\.\d+)?)`，支持两段和三段版本号。特殊工具在 `packages/*.json` 中覆盖。

**Pre-release**：默认只关注 stable release。`version_check.include_prerelease: true` 可启用。

**SHA256 校验**：checksum 可用时强制校验，不可用时警告但继续。`--no-verify` 可显式跳过。

**大文件进度**：下载时显示进度条（stdlib 实现，零依赖）。

**临时文件清理**：启动时清理超过 24 小时的 `/tmp/tribucket-*/` 目录。

**文件权限**：CLI、install.sh、二进制文件 `0o755`，tribucket.json `.bat` `0o644`。

---

## 非 GitHub 源

`tribucket.json` 支持可选的 `download_url` 字段，用于非 GitHub 来源：

```json
{
  "name": "terraform",
  "version": "1.7.5",
  "download_url": {
    "linux_amd64": "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip",
    "darwin_arm64": "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_darwin_arm64.zip"
  }
}
```

当 `download_url` 存在时，跳过 GitHub Release API，直接下载。`generate.py` 从 `packages/*.json` 的 `download_url` 字段派生。

---

## 实施路线

### Phase 0 — 基础设施

- [ ] 定义 `packages/*.json` → `portable/` 的生成规则
- [ ] `generate.py` 新增便携包输出能力（`portable/<name>/` 目录）
- [ ] `tribucket.json` schema 定义 + 校验
- [ ] 选 go-wxpush 做第一个端到端验证
- [ ] `.gitignore` 加入 `portable/`

### Phase 1 — Python 引擎核心

- [ ] `lib/tribucket/` Python 包结构
- [ ] `check.py` — 版本检测（`--version` 解析 + fallback + 远程查询 + 缓存）
- [ ] `update.py` — 更新流程（下载 → 临时目录 → SHA256 → 解压 → 替换 → 备份/恢复）
- [ ] `mirror.py` — 镜像 provider + TTL 缓存探测
- [ ] `track.py` — config.json 读写 + stale 处理
- [ ] `install.py` — 首次安装（模板渲染 + 二进制下载 + track）

### Phase 2 — CLI 入口

- [ ] `bin/tribucket` — Python 单文件脚本，argparse 命令路由
- [ ] 命令实现：install, uninstall, track, untrack, list, check, update
- [ ] `scripts/install.sh` — bootstrap 安装脚本（v2 版本）

### Phase 3 — 便携包模板 + Windows

- [ ] `portable/<name>/install.sh` 自动生成（内嵌 Shell 逻辑）
- [ ] `portable/<name>/cmd/tribucket-update.bat` 自动生成
- [ ] Windows 端到端验证

### Phase 4 — 文档 + 发布

- [ ] 更新 README.md 说明 v2 架构
- [ ] 示例：如何创建自己的便携包
- [ ] 版本号升到 2.0.0

---

## 不做的事（明确排除）

| 项目 | 原因 |
|------|------|
| ❌ 多机情报共享 | 需要后端服务，复杂度爆炸 |
| ❌ 客户端定期轮询检查 | 响应式操作，可选推送通知 |
| ❌ 版本目录软链切换 | 安全中转 + 原地替换 |
| ❌ 包依赖解析 | 每个包独立，不处理依赖树 |
| ❌ 包卸载/清理 | `tribucket uninstall` 处理，不需要额外清理工具 |
| ❌ 多用户支持 | `~/.tribucket/` 是 per-user 的，不做系统级全局安装 |
| ❌ 包签名/信任链 | 不做 GPG 签名验证（GitHub release 不提供，成本高） |
| ❌ 回滚到任意历史版本 | 只备份上一个版本，不做版本历史管理 |
| ❌ PowerShell .ps1 入口 | 便携包只提供 install.sh + .bat，Windows 用户推荐全局 CLI |
