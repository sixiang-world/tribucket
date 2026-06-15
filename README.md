# tribucket

**tri** (三合一) + **bucket** (包仓库) = 多种安装方式，一个仓库。

一个通用的跨平台软件包仓库，每个软件同时提供：
- **Homebrew** (macOS / Linux)
- **Scoop** (Windows)
- **Shell 脚本** (任意平台兜底)
- **便携包** (v2 — 自包含的可移植软件包)

v2 新增轻量级 **tribucket CLI**，可跟踪、检测、更新所有通过它安装的便携软件。

## 更新日志

详见 [CHANGELOG.md](CHANGELOG.md)。

## 快速开始

### 安装 tribucket CLI

```bash
# Homebrew (macOS / Linux)
brew install sixiang-world/tribucket/tribucket

# Scoop (Windows)
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install tribucket

# 一键安装
curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.sh | bash
```

### 安装软件包

```bash
# 通过 tribucket CLI
tribucket install ripgrep
tribucket install fzf

# 通过 Homebrew
brew tap sixiang-world/tribucket
brew install ripgrep

# 通过 Scoop
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install ripgrep
```

### 管理已安装的包

```bash
tribucket list                    # 列出所有已跟踪的包
tribucket check --all             # 检查是否有更新
tribucket update ripgrep          # 更新指定包
tribucket info ripgrep            # 查看包详情
tribucket clean                   # 清理过期条目
```

## 当前收录 / Available Packages

| 软件 | 描述 | GitHub |
|------|------|--------|
| CLIProxyAPI | CLI proxy API tool with wide platform support | [router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) |
| ProxyBridge | Network proxy interception tool | [InterceptSuite/ProxyBridge](https://github.com/InterceptSuite/ProxyBridge) |
| ast-grep | Structural search/replace using AST patterns | [ast-grep/ast-grep](https://github.com/ast-grep/ast-grep) |
| axonhub | Open-source AI Gateway — call 100+ LLMs with failover and load balancing | [looplj/axonhub](https://github.com/looplj/axonhub) |
| bat | A cat(1) clone with syntax highlighting and Git integration | [sharkdp/bat](https://github.com/sharkdp/bat) |
| bottom | Cross-platform graphical system monitor | [ClementTsang/bottom](https://github.com/ClementTsang/bottom) |
| cc-connect | Claude Code connectivity utility | [chenhg5/cc-connect](https://github.com/chenhg5/cc-connect) |
| ccx | Claude / Codex / Gemini API Proxy and Gateway | [BenedictKing/ccx](https://github.com/BenedictKing/ccx) |
| claude-code | Claude Code — agentic coding tool by Anthropic | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| codewhale | DeepSeek + MiMo coding agent in terminal | [Hmbown/CodeWhale](https://github.com/Hmbown/CodeWhale) |
| cosign | Container signing, verification, and storage | [sigstore/cosign](https://github.com/sigstore/cosign) |
| delta | A syntax-highlighting pager for git, diff, and grep output | [dandavison/delta](https://github.com/dandavison/delta) |
| deno | Modern runtime for JavaScript and TypeScript | [denoland/deno](https://github.com/denoland/deno) |
| duf | Better df alternative - disk usage/free utility | [muesli/duf](https://github.com/muesli/duf) |
| dust | More intuitive version of du (disk usage) | [bootandy/dust](https://github.com/bootandy/dust) |
| erdtree | Modern filesystem and disk usage visualizer | [solidiquis/erdtree](https://github.com/solidiquis/erdtree) |
| eza | A modern replacement for ls | [eza-community/eza](https://github.com/eza-community/eza) |
| fd | A simple, fast and user-friendly alternative to find | [sharkdp/fd](https://github.com/sharkdp/fd) |
| fzf | Command-line fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf) |
| gh | GitHub CLI — GitHub from the command line | [cli/cli](https://github.com/cli/cli) |
| glow | Render markdown on the CLI | [charmbracelet/glow](https://github.com/charmbracelet/glow) |
| go-wxpush | WeChat push notification utility | [hezhizheng/go-wxpush](https://github.com/hezhizheng/go-wxpush) |
| goose | Open-source AI agent by Block — extensible, runs in terminal | [block/goose](https://github.com/block/goose) |
| gping | Ping with a graph | [orf/gping](https://github.com/orf/gping) |
| helix | Post-modern modal text editor | [helix-editor/helix](https://github.com/helix-editor/helix) |
| hyperfine | Command-line benchmarking tool | [sharkdp/hyperfine](https://github.com/sharkdp/hyperfine) |
| jq | Lightweight command-line JSON processor | [jqlang/jq](https://github.com/jqlang/jq) |
| k9s | Terminal UI for managing Kubernetes clusters | [derailed/k9s](https://github.com/derailed/k9s) |
| lazygit | Simple terminal UI for git commands | [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit) |
| llmfit | LLM fitness evaluation tool | [AlexsJones/llmfit](https://github.com/AlexsJones/llmfit) |
| lsd | The next gen ls command (LSDeluxe) | [Peltoche/lsd](https://github.com/Peltoche/lsd) |
| mise | Polyglot runtime manager (asdf replacement) | [jdx/mise](https://github.com/jdx/mise) |
| neovim | Hyperextensible Vim-based text editor | [neovim/neovim](https://github.com/neovim/neovim) |
| ollama | Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs | [ollama/ollama](https://github.com/ollama/ollama) |
| octopus | Multi-platform CLI tool | [bestruirui/octopus](https://github.com/bestruirui/octopus) |
| opentofu | Open-source infrastructure as code tool (Terraform fork) | [opentofu/opentofu](https://github.com/opentofu/opentofu) |
| procs | Modern replacement for ps (process viewer) | [dalance/procs](https://github.com/dalance/procs) |
| quarkdown | Markdown-to-PDF/document engine | [iamgio/quarkdown](https://github.com/iamgio/quarkdown) |
| ripgrep | Recursively search directories for a regex pattern (rg) | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) |
| ruff | An extremely fast Python linter and formatter | [astral-sh/ruff](https://github.com/astral-sh/ruff) |
| sd | Intuitive find & replace CLI (sed alternative) | [chmln/sd](https://github.com/chmln/sd) |
| shellcheck | Static analysis tool for shell scripts | [koalaman/shellcheck](https://github.com/koalaman/shellcheck) |
| shfmt | Shell parser, formatter, and interpreter | [mvdan/sh](https://github.com/mvdan/sh) |
| starship | Cross-shell prompt customization | [starship/starship](https://github.com/starship/starship) |
| surrealdb | Scalable, distributed document-graph database | [surrealdb/surrealdb](https://github.com/surrealdb/surrealdb) |
| tree-sitter | Parser generator tool and incremental parsing library | [tree-sitter/tree-sitter](https://github.com/tree-sitter/tree-sitter) |
| uv | An extremely fast Python package installer and resolver | [astral-sh/uv](https://github.com/astral-sh/uv) |
| watchexec | Execute commands in response to file modifications | [watchexec/watchexec](https://github.com/watchexec/watchexec) |
| xh | Friendly and fast HTTP requests tool (HTTPie alternative) | [ducaale/xh](https://github.com/ducaale/xh) |
| yazi | Blazing fast terminal file manager | [sxyazi/yazi](https://github.com/sxyazi/yazi) |
| zellij | Terminal multiplexer with batteries included | [zellij-org/zellij](https://github.com/zellij-org/zellij) |
| zoxide | A smarter cd command — tracks your most used directories | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) |

## tribucket CLI 命令

```
tribucket install <name>       安装软件包
tribucket uninstall <name>     卸载软件包
tribucket update <name>        更新软件包
tribucket update --all         更新所有包
tribucket check [name...]      检查版本
tribucket list                 列出已跟踪的包
tribucket info <name>          查看包详情
tribucket track <name> <path>  跟踪已有的安装
tribucket clean                清理过期条目
tribucket self-update          更新 tribucket 自身
tribucket config list          查看配置
tribucket --version --json     输出版本信息 (JSON)
```

## 安装方式 (v1)

### Homebrew (macOS / Linux)

```bash
brew tap sixiang-world/tribucket
brew install ccx
```

### Scoop (Windows)

```powershell
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install ccx
```

### 脚本兜底 (任意平台)

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash -s <package>

# Windows PowerShell
irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1 | iex -ArgumentList <package>
```

### CNB 镜像仓库（中国大陆加速）

本仓库已自动镜像到 [cnb.cool](https://cnb.cool/shisheng820/tribucket)。

```powershell
# Scoop 使用 CNB 镜像
scoop bucket add tribucket https://cnb.cool/shisheng820/tribucket.git
```

```bash
# Homebrew 使用 CNB 镜像
brew tap shisheng820/tribucket https://cnb.cool/shisheng820/tribucket.git
```

## 项目结构

```
tribucket/
├── src/                        # v2 CLI (Bun/TypeScript，编译为单文件二进制)
│   ├── index.ts                # CLI 入口 (Commander.js)
│   ├── version.ts              # VERSION 常量
│   ├── commands/               # install / update / check / list / track / config / self-update / clean / uninstall
│   ├── engine/                 # version / mirror / download / lock
│   ├── config/                 # paths / store / cache
│   ├── utils/                  # http / locale / archive / sha256 / log / platform / find / software-source / concurrent / cleanup
│   └── __tests__/              # 单元测试 (21 个)
├── packages/                   # 软件包元数据 (单一事实来源)
├── Formula/                    # Homebrew formulas (自动生成，勿手改)
├── bucket/                     # Scoop manifests (自动生成，勿手改)
├── website/                    # 软件源网站源码 (Bun 脚本构建为静态站)
│   ├── build.ts                # 构建脚本：读 packages/*.json + CHANGELOG.md → dist/
│   ├── templates/index.html    # HTML 模板 (占位符注入)
│   └── styles/main.css         # 简洁技术文档风格
├── edgeone.json                # EdgeOne 边缘部署配置
├── archive/python-v1/          # v1 (Python) — 仅作历史参考
├── scripts/                    # bootstrap.sh / bootstrap.ps1 / install.sh / install.ps1 等
└── docs/
```

## 添加新软件

1. 在 `packages/` 下新建 `<name>.json`（`asset_pattern` 支持字面量 / glob `*` / 后缀三种匹配模式）
2. 运行生成器生成 Formula / Bucket
3. 运行 `bun test`
4. 提交 PR

## 开发

```bash
bun install                                          # 安装依赖
bun build src/index.ts --compile --outfile tribucket # 编译二进制
bun run src/index.ts --help                          # 运行 CLI
bun test                                             # 运行测试 (21 个)
```

**代理设置**（中国大陆访问 GitHub 必需）：
```bash
export HTTPS_PROXY=http://127.0.0.1:7897
export HTTP_PROXY=http://127.0.0.1:7897
# 或使用 CLI 参数
tribucket --proxy http://127.0.0.1:7897 install jq
```

**GitHub Token**（可选，提升 API 速率限制到 5000 次/小时）：
```bash
export GITHUB_TOKEN=你的token
```

## License

MIT
