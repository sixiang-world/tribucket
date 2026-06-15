# 更新日志

## v3.6.1 — Bug fixes (code review)

根据全量代码审查报告修复了 7 个真实问题（含 2 个高优先级 BUG）：

### 高优先级
- **list.ts**: 悬空符号链接(dangling symlink)检测逻辑反转 — 检查的是链接自身而非目标，导致检测永远不触发
- **self-update.ts**: `latest` 变量可能为 `undefined`，导致版本比较异常和输出显示 "undefined"

### 中优先级
- **update.ts**: SIGINT handler 是模块级共享变量，`--all` 并发更新时后一个 handler 覆盖前一个
- **clean.ts**: catch 块中 `unlinkSync` 无错误处理，可能抛出未捕获异常
- **uninstall.ts**: symlink 目标路径使用 `startsWith` 比较不精确，可能误匹配
- **archive.ts**: PowerShell 命令路径未转义单引号，存在注入风险
- **admin/sync.js**: 认证比较使用普通字符串比较（非 timing-safe），改为恒定时间比较

### 低优先级
- **check.ts**: JSON.parse 错误被静默吞掉，添加日志记录
- **download.ts**: URL 无路径时文件名提取可能返回域名
- **mirror.ts**: `String.replace` 只替换首个匹配，改用 `replaceAll`
- **update.ts**: config key 使用不一致，统一为一致的 key 解析

## v3.6.0 — Release/Debug 双构建模式

CI 流水线现在同时构建 release 和 debug 两种二进制，debug 版本内置始终开启的详细日志（`VERBOSE=1`），方便问题排查。

- **编译时常量 `DEBUG_BUILD`**：通过 Bun 的 `--define DEBUG_BUILD=true` 注入，零运行时开销
- **`VERBOSE` 行为优化**：debug 构建始终为 `true`，release 构建兜底到 `TRIBUCKET_VERBOSE` 环境变量
- **自更新识别**：debug 二进制运行时自动匹配 `-debug` 后缀的发布资源，不会错误地更新为 release 版本
- **全平台覆盖**：GitHub Actions + CNB 两种 CI 流水线均为 5 个平台（linux amd64/arm64、darwin amd64/arm64、windows amd64）构建 debug 二进制
- **`package.json` 新增 `build:debug` 脚本**：本地也可编译 debug 版本
- **类型安全**：`declare const DEBUG_BUILD` 抽到 `src/env.d.ts`，避免跨文件重复声明

## v3.5.0 — CLI 用户体验大修

全面提升交互体验，下载 / 检查 / 更新每一步都有更好的反馈。

- **下载进度条升级**：新增 `ProgressBar` 类，TTY 环境实时渲染进度条 `[====>]` + 速度 MB/s + ETA 估算
  - 非 TTY 环境（管道/重定向）输出逐行进度，不再完全静默
- **交互确认提示**：`uninstall`、`install --force`、`update --all` 等破坏性操作前弹出 `[y/N]` 确认
  - 非 TTY 环境自动跳过，`--force` / `--yes` 参数可跳过确认
- **`info` 命令重构**：提取为独立模块，所有标签 i18n 化，新增 `--json` 输出和运行时版本检测
- **并发操作实时进度**：`check --all` 和 `update --all` 时实时显示 `→ Checking packages... (3/12)`
- **i18n 补全**：修复 SIGINT 消息、update restore 消息等 4 处硬编码英文
- **代码清理**：修复 code review 发现的 5 个遗留问题（无用导入、死代码等）

## v3.4.0 — 数据文件迁移到 EdgeOne KV（节省构建额度）

数据文件（packages/Formula/bucket）不再打包到 `dist/`，改为存入 EdgeOne KV，由 Edge Function 运行时服务。从此 packages 更新不再触发 EdgeOne 构建，只做 KV 同步。

- **`website/build.ts` 大幅简化**：不再复制 packages/Formula/bucket 到 `dist/`，构建产物仅含 `index.html` + `styles/main.css`
- **新增 `functions/` Edge Function 目录**（5 个文件）：
  - `functions/api/packages.js` — 返回全量包元数据 JSON（网站包列表用）
  - `functions/packages/[[default]].js` — 服务 `/packages/<name>.json`（CLI install 用）
  - `functions/Formula/[[default]].js` — 服务 `/Formula/<name>.rb`（Homebrew tap 用）
  - `functions/bucket/[[default]].js` — 服务 `/bucket/<name>.json`（Scoop + CLI check 用）
  - `functions/admin/sync.js` — 受保护的 KV 写入端点（CI 同步用）
- **新增 `scripts/kv-sync.py`**：CI 中读取本地 packages/Formula/bucket，批量 POST 到 `/admin/sync` 写入 KV
- **包列表改为运行时 fetch**：网站 JS 在页面加载时请求 `/api/packages`，不再构建时内联
- **KV 键命名**：全部使用 `tri_` 前缀（`tri_packages_idx`、`tri_p_<name>`、`tri_f_<name>`、`tri_b_<name>`），避免与其他数据冲突
- **新增环境变量**：`ADMIN_SYNC_SECRET`（CI 同步密钥）、`ADMIN_SYNC_KEY`（EdgeOne 环境变量）
- **CI 更新**：`generate.yml` 在 Formula/bucket 生成后自动执行 `kv-sync.py` 同步到 KV
- **`AGENTS.md`** 更新为新的架构文档，新增 EdgeOne Pages 配置说明与已知问题

## v3.3.0 — 软件源网站（EdgeOne 部署）

将软件源 + 项目介绍部署为一个静态网站（tribucket.hunluan.space），网页与 Formula/bucket 同站托管。

- **新增 `website/` 静态网站构建系统**：`website/build.ts`（Bun 脚本）读取 `packages/*.json` + `CHANGELOG.md`，注入 `website/templates/index.html` 模板，生成纯静态 HTML，无需前端框架
- **网页内容**：Hero + 版本徽章、安装指南（Homebrew / Scoop / CLI / 一键脚本 四个 Tab，命令一键复制）、可搜索的软件包列表（107 个包实时过滤）、CLI 命令参考表、更新日志
- **简洁技术文档风格**：`website/styles/main.css`，白底、响应式布局、移动端友好
- **产物结构**：`dist/` 下同时包含 `index.html`（网页）、`Formula/*.rb`（Homebrew tap）、`bucket/*.json`（Scoop bucket）、`styles/main.css`，部署到边缘函数后 `tribucket.hunluan.space` 提供「网页 + 软件源」一体化访问
- **新增 `npm run build:web` / `bun run website/build.ts`**：构建命令，CI 可直接调用
- **新增 `edgeone.json`**：EdgeOne 边缘部署配置（构建命令 `npm run build:web`、输出目录 `dist`、Node 22.11.0），含缓存与安全响应头策略（主页 5 分钟短缓存，Formula/bucket 1 小时 must-revalidate，CSS 一年强缓存；X-Frame-Options/X-Content-Type-Options/Referrer-Policy 安全头）
- **更新日志独立化**：从 README 迁出到独立的 `CHANGELOG.md`，README 仅保留链接。`website/build.ts` 直接解析 `CHANGELOG.md` 的 `## vX.Y.Z` 条目（自动过滤文档 H1 标题，解析 `**加粗**` 与版本 tag）
- **`.gitignore` 新增 `dist/`**（构建产物不入库）

## v3.2.5 — Bugfix

- **修复安装版本永远为 `0.0.0`（根因）**：`install.ts` 中 `const version` 阻止了从 release tag 提取版本号的赋值，改为 `let version`。`tribucket.json` 中 `version` 和 `fallback_version` 现在正确写入真实版本号
- **修复 SHA256 验证重试风暴**：校验和文件下载（best-effort 操作）不再使用 5 次重试刷屏，改为单次尝试且静默模式
- **`httpGet` 新增 `silent` 选项**：`silent: true` 时重试只写 `log()` 不写 `status()`，适合 best-effort 调用
- **`install.sh` 仅在非 Windows 平台生成**

## v3.2.4 — 中文日志 + 网络错误诊断

- **中文日志本地化**：自动检测系统语言（`LANG`/`LC_ALL`/`LANGUAGE` 环境变量），中文环境自动切换为中文输出（`→ 正在解析包: ccx`、`→ 下载完成: 29.2 MB` 等）。支持 `TRIBUCKET_LANG=en|zh` 强制覆盖
- **网络错误详情**：`Network error` 重试提示现在显示错误代码（如 `ECONNREFUSED`、`ETIMEDOUT`），方便诊断网络问题。完整错误信息可通过 `TRIBUCKET_VERBOSE=1` 查看
- **修复安装版本为 `0.0.0`**：当包定义无 `version` 字段时，安装后不再显示 `0.0.0`，而是从 GitHub release tag 中提取真实版本号

## v3.2.3 — CLI 用户体验优化（进度提示 + 启动加速）

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

## v3.2.1 — 测试覆盖补齐 + dry-run 修复

扩大跨平台测试覆盖面（Windows + Linux 各 12+ 项端到端场景），修复发现的一个 bug：

- **修复** `update <name> --dry-run` 崩溃（`checkPackage` 未传 options，解引用 `options.localOnly` 报 TypeError）
- **新增覆盖**：`--proxy`、`--mirror direct/auto`、`install --dir/--force`、`update --no-backup`、系统目录防护（`/usr`/`/etc`/`C:\Windows`）、`update --dry-run`、`NO_COLOR`、文件锁（acquire/release/stale PID/live PID）、损坏 config 降级、`clean` 清理 stale、`info` —— Windows 与 Linux 双端全绿。

## v3.2.0 — 跨平台稳定性大修

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
