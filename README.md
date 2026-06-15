# tribucket

**tri** (三合一) + **bucket** (包仓库) = 多种安装方式，一个仓库。

一个通用的跨平台软件包仓库，每个软件同时提供：
- **Homebrew** (macOS / Linux)
- **Scoop** (Windows)
- **Shell 脚本** (任意平台兜底)
- **便携包** (v2 — 自包含的可移植软件包)

v2 新增轻量级 **tribucket CLI**，可跟踪、检测、更新所有通过它安装的便携软件。

## 更新日志

### v3.2.5 — Bugfix

- **修复安装版本永远为 `0.0.0`（根因）**：`install.ts` 中 `const version` 阻止了从 release tag 提取版本号的赋值，改为 `let version`。`tribucket.json` 中 `version` 和 `fallback_version` 现在正确写入真实版本号
- **修复 SHA256 验证重试风暴**：校验和文件下载（best-effort 操作）不再使用 5 次重试刷屏，改为单次尝试且静默模式
- **`httpGet` 新增 `silent` 选项**：`silent: true` 时重试只写 `log()` 不写 `status()`，适合 best-effort 调用
- **`install.sh` 仅在非 Windows 平台生成**

### v3.2.4 — 中文日志 + 网络错误诊断

- **中文日志本地化**：自动检测系统语言（`LANG`/`LC_ALL`/`LANGUAGE` 环境变量），中文环境自动切换为中文输出（`→ 正在解析包: ccx`、`→ 下载完成: 29.2 MB` 等）。支持 `TRIBUCKET_LANG=en|zh` 强制覆盖
- **网络错误详情**：`Network error` 重试提示现在显示错误代码（如 `ECONNREFUSED`、`ETIMEDOUT`），方便诊断网络问题。完整错误信息可通过 `TRIBUCKET_VERBOSE=1` 查看
- **修复安装版本为 `0.0.0`**：当包定义无 `version` 字段时，安装后不再显示 `0.0.0`，而是从 GitHub release tag 中提取真实版本号

### v3.2.3 — CLI 用户体验优化（进度提示 + 启动加速）

大幅改善 CLI 交互反馈，用户执行 install/update 时每一步都有可见提示，不再长时间无响应黑屏：

- **新增 `status()` 输出原语**：`src/utils/log.ts` 新增始终可见的 `status(msg)` 函数（带 `→` 前缀），与 verbose-only 的 `log()` 分离
- **Install 逐步提示**：`→ Resolving package → Fetching latest release → Testing mirrors → Downloading → Verifying checksum → Extracting → ✓ Installed`，每一步清晰可见
- **Update 逐步提示**：与 install 一致，增加 `→ Fetching latest release for <name>` 和 `→ Using mirror/direct download` 提示
- **下载进度条增强**：进度条增加文件名显示；下载开始和完成时显示 `→ Downloading...` / `→ Download complete: X MB`
- **镜像选择可视化**：`→ Testing mirrors...` + `→ Mirror selected: hunluan (120ms)`，用户知道正在探测和选择了哪个镜像
- **HTTP 重试可见**：网络错误/限流/服务器 5xx 重试时显示 `→ Rate limited/Server error/Network error, retrying (2/5)...`
- **启动加速**：`cleanupOldTmp()` 改为 `setImmediate()` 后台执行，不再阻塞命令启动

补齐 `engine/download.ts` 续传逻辑的端到端验证（此前仅做代码 review）：

- **新增覆盖** `src/__tests__/download.test.ts`：起本地 HTTP 服务器（完整实现 RFC 7233 Range），实测两条续传分支：
  - **206 + append**：截断文件到一半 → `downloadFile` 发送 `Range: bytes=N-` → 服务器返回 206 → 追加剩余字节 → 最终 SHA256 与完整下载一致；同时断言服务器确实收到 Range 头且响应 206（避免用代理信号冒充实测）
  - **200 fallback**：服务器忽略 Range（模拟 raw.githubusercontent.com 行为）→ 重写整个文件 → SHA256 仍一致
- **测试总数** 19 → 21，全套通过

### v3.2.1 — 测试覆盖补齐 + dry-run 修复

扩大跨平台测试覆盖面（Windows + Linux 各 12+ 项端到端场景），修复发现的一个 bug：

- **修复** `update <name> --dry-run` 崩溃（`checkPackage` 未传 options，解引用 `options.localOnly` 报 TypeError）
- **新增覆盖**：`--proxy`、`--mirror direct/auto`、`install --dir/--force`、`update --no-backup`、系统目录防护（`/usr`/`/etc`/`C:\Windows`）、`update --dry-run`、`NO_COLOR`、文件锁（acquire/release/stale PID/live PID）、损坏 config 降级、`clean` 清理 stale、`info` —— Windows 与 Linux 双端全绿。

### v3.2.0 — 跨平台稳定性大修

经 Windows + Linux (WSL Ubuntu 24.04) 双平台完整实测，修复 12 个阻断/高风险 bug：

- **下载 URL**：不再硬编码 `v` 版本前缀，使用 release 的原始 tag（修复 jq `jq-1.8.1`、ripgrep `15.1.0` 等 404）
- **资源解析**：`asset_pattern` 现在对真实 release 资源列表做匹配（字面量 / glob `*` / 后缀），`fzf-*`、`x86_64-pc-windows-msvc.zip` 等模式均能解析
- **Linux 解压**：移除 GNU tar 不支持的 `--no-absolute-names`（之前导致所有 tar 包解压崩溃）
- **Windows 二进制**：安装时自动补 `.exe` 后缀；版本检测使用 `resolveBinaryPath` 探测 `.exe`
- **`--json` 输出**：修复被全局同名选项遮蔽的问题（`check --json` / `list --json` 现输出正确 JSON）
- **`--all`**：按包名而非 repo key 迭代，修复 `check/update --all` 的路径误判
- **版本比较**：`versionFromTag` 从任意 tag 提取可比较的版本号；缓存读取自愈归一化
- **网络韧性**：HTTP 重试 3→5 次 + jitter 退避，403/429 限流也重试
- **更新后校验**：版本探测带重试，Windows 跳过不可靠的 `X_OK`，不再误报 `Version mismatch`
- 清理仓库根目录误建的 `NUL` 文件并加入 `.gitignore`

测试：单元测试 21/21 通过；Linux 端到端 12/12；Windows 端到端 9/9。

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

## 当前收录

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
│   ├── utils/                  # http / archive / sha256 / platform / find / log / concurrent / cleanup
│   └── __tests__/              # 单元测试 (21 个)
├── packages/                   # 软件包元数据 (单一事实来源)
├── Formula/                    # Homebrew formulas (自动生成，勿手改)
├── bucket/                     # Scoop manifests (自动生成，勿手改)
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
