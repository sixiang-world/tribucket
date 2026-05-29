# tribucket

**tri** (三合一) + **bucket** (包仓库) = 三种安装方式，一个仓库。

一个通用的跨平台软件包仓库，每个软件同时提供：
- **Homebrew** (macOS / Linux)
- **Scoop** (Windows)
- **Shell 脚本** (任意平台兜底)

## 当前收录

| 软件 | 描述 | GitHub |
|------|------|--------|
| axonhub | Open-source AI Gateway — call 100+ LLMs with failover and load balancing | [looplj/axonhub](https://github.com/looplj/axonhub) |
| bat | A cat(1) clone with syntax highlighting and Git integration | [sharkdp/bat](https://github.com/sharkdp/bat) |
| ccx | Claude / Codex / Gemini API Proxy and Gateway | [BenedictKing/ccx](https://github.com/BenedictKing/ccx) |
| claude-code | Claude Code — agentic coding tool by Anthropic | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| codewhale | DeepSeek + MiMo coding agent in terminal | [Hmbown/CodeWhale](https://github.com/Hmbown/CodeWhale) |
| delta | A syntax-highlighting pager for git, diff, and grep output | [dandavison/delta](https://github.com/dandavison/delta) |
| eza | A modern replacement for ls | [eza-community/eza](https://github.com/eza-community/eza) |
| fd | A simple, fast and user-friendly alternative to find | [sharkdp/fd](https://github.com/sharkdp/fd) |
| fzf | Command-line fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf) |
| gh | GitHub CLI — GitHub from the command line | [cli/cli](https://github.com/cli/cli) |
| goose | Open-source AI agent by Block — extensible, runs in terminal | [block/goose](https://github.com/block/goose) |
| lsd | The next gen ls command (LSDeluxe) | [Peltoche/lsd](https://github.com/Peltoche/lsd) |
| ollama | Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs | [ollama/ollama](https://github.com/ollama/ollama) |
| ripgrep | Recursively search directories for a regex pattern (rg) | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) |
| ruff | An extremely fast Python linter and formatter | [astral-sh/ruff](https://github.com/astral-sh/ruff) |
| uv | An extremely fast Python package installer and resolver | [astral-sh/uv](https://github.com/astral-sh/uv) |
| zoxide | A smarter cd command — tracks your most used directories | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) |

> **注意**: Homebrew Formula 和 Scoop Bucket 目前仅覆盖 **ccx**，其余包请使用 Shell 脚本安装。后续会逐步补充。

## 安装方式

### Homebrew (macOS / Linux)

仅支持 ccx，其余包请使用 Shell 脚本安装。

```bash
brew tap sixiang-world/tribucket
brew install ccx
```

### Scoop (Windows)

仅支持 ccx，其余包请使用 Shell 脚本安装。

```powershell
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install ccx
```

### 脚本兜底 (任意平台)

支持所有收录的软件包，将 `<package>` 替换为上方表格中的软件名（如 `bat`、`fzf`、`ollama` 等）。

**Linux / macOS：**
```bash
# 安装到当前目录
curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash -s <package>

# 安装到指定目录
curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | INSTALL_DIR=/usr/local/bin bash -s <package>
```

**Windows (PowerShell)：**
```powershell
irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1 | iex -ArgumentList <package>
```

**Windows (CMD)：**
```cmd
install.bat <package>
```

### 更新 / 卸载

脚本安装后会在安装目录**自动生成** `update.sh` / `update.ps1` 和 `uninstall.sh` / `uninstall.ps1`：
```bash
./update.sh ccx        # 更新到最新版
./uninstall.sh ccx     # 卸载
```

## 项目结构

```
tribucket/
├── README.md
├── CONTRIBUTING.md        # 贡献指南
├── VERSION                # 仓库版本
├── Formula/               # Homebrew formulas (目前仅 ccx)
│   └── ccx.rb
├── bucket/                # Scoop manifests (目前仅 ccx)
│   └── ccx.json
├── packages/              # 软件包元数据 (核心，共 17 个)
│   ├── axonhub.json
│   ├── bat.json
│   ├── ccx.json
│   ├── ...
│   └── zoxide.json
└── scripts/               # 通用安装脚本
    ├── install.sh         # Linux / macOS 安装
    ├── install.ps1        # Windows PowerShell 安装
    └── install.bat        # Windows CMD 入口 (调用 install.ps1)
```

> `update.sh` / `uninstall.sh` / `update.ps1` / `uninstall.ps1` 由安装脚本在安装目录自动生成，不在仓库中。

## 添加新软件

1. 在 `packages/` 下新建 `<name>.json`，填入 GitHub 仓库和 asset 匹配规则
2. （可选）在 `Formula/` 下新建 `<name>.rb` (Homebrew formula)
3. （可选）在 `bucket/` 下新建 `<name>.json` (Scoop manifest)
4. 提交 PR

`packages/<name>.json` 格式：
```json
{
  "name": "tool-name",
  "repo": "owner/repo",
  "description": "一句话描述",
  "binary": "binary-name",
  "license": "MIT",
  "homepage": "https://github.com/owner/repo",
  "asset_pattern": {
    "linux_amd64": "keyword-in-asset-filename",
    "linux_arm64": "keyword-in-asset-filename",
    "darwin_amd64": "keyword-in-asset-filename",
    "darwin_arm64": "keyword-in-asset-filename",
    "windows_amd64": "keyword-in-asset-filename.exe",
    "windows_arm64": "keyword-in-asset-filename.exe"
  }
}
```

## License

MIT
