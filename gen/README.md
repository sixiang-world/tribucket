# tribucket generator (gen)

独立的定义文件生成器 CLI。从 `.tribucket.yaml` 生成 Homebrew Formula、Scoop Manifest、Shell 安装脚本。

## 快速开始

```bash
# 1. 创建配置文件
python -m gen init owner/repo

# 2. 编辑 .tribucket.yaml（填写 description、license 等）

# 3. 生成
python -m gen generate

# 或者一步到位：自动检测 + 生成
python -m gen detect owner/repo --generate .tribucket.yaml
python -m gen generate
```

## 命令

### `gen init [repo]`

创建 `.tribucket.yaml` 配置文件。

```bash
python -m gen init https://github.com/charmbracelet/glow
python -m gen init owner/repo -o .tribucket.yaml
python -m gen init owner/repo --force  # 覆盖已有文件
```

### `gen generate`

从 `.tribucket.yaml` 生成多格式定义文件。

```bash
python -m gen generate                           # 生成全部格式
python -m gen generate --target homebrew,scoop   # 只生成指定格式
python -m gen generate --dry-run                 # 预览不写文件
python -m gen generate -c path/to/config.yaml    # 指定配置文件
python -m gen generate -o dist/                  # 输出到指定目录
```

输出结构：
```
Formula/<Name>.rb     # Homebrew Formula
bucket/<name>.json    # Scoop Manifest
scripts/install.sh    # Shell 安装脚本
```

### `gen detect <repo>`

从 GitHub Release 自动检测 asset_pattern。

```bash
python -m gen detect owner/repo                  # 打印检测报告
python -m gen detect owner/repo --json           # 同时输出 JSON
python -m gen detect owner/repo -g .tribucket.yaml  # 检测并生成配置
```

### `gen check`

验证 `.tribucket.yaml` 的 asset_pattern 是否能匹配最新 Release。

```bash
python -m gen check                              # 使用自动检测的配置
python -m gen check -c path/to/config.yaml       # 指定配置文件
```

## 配置文件格式

```yaml
name: my-tool                    # 必填：包名
repo: owner/my-tool              # 必填：GitHub 仓库
description: "A great tool"      # 必填：描述
binary: my-tool                  # 必填：可执行文件名
license: MIT                     # 必填：SPDX 协议标识
homepage: https://example.com    # 可选：默认为 repo URL

# 资产匹配模式（二选一）
auto_detect: true                # 自动从 Release 推断
# 或手动指定：
asset_pattern:
  linux_amd64: "my-tool-linux-amd64.tar.gz"
  linux_arm64: "my-tool-linux-arm64.tar.gz"
  darwin_amd64: "my-tool-darwin-amd64.tar.gz"
  darwin_arm64: "my-tool-darwin-arm64.tar.gz"
  windows_amd64: "my-tool-windows-amd64.zip"
  windows_arm64: "NO_MATCH"

# 输出目标（可选，默认全部）
targets:
  - homebrew
  - scoop
  - shell
```

## 与现有 CLI 的关系

| | gen（新） | src/（现有） |
|---|---|---|
| **用途** | 生成定义文件 | 安装/更新软件 |
| **输入** | `.tribucket.yaml` | `packages/*.json` |
| **输出** | Formula / Manifest / install.sh | 本地二进制 |
| **技术栈** | Python | Bun/TypeScript |
| **使用方** | 项目 maintainer | 终端用户 |

两个 CLI 完全独立，互不影响。