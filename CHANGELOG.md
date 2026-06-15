# 更新日志

## v3.6.7 — 第5轮代码审查 + 严重回归修复

### 🔴 严重 — 回归修复
- **self-update.ts 语法错误**：修复第4轮引入的重复 `if (!scriptPath) {` 导致 GitHub Actions 编译失败
- **install.ts 完全丢失**：修复第4轮 `fix-round4.py` 脚本将整个 `src/commands/install.ts` 错误替换为 `locale.ts` 内容，导致 `tribucket install` 命令彻底崩溃。已从提交 `65440bb` 恢复原始 375 行代码，并重新应用第4轮应有修改

### 🟡 中优先级 — 代码缺陷
- **software-source.ts token 未定义**：`fetchPackageDef()` 中 `{ token }` 引用了未声明的变量，GitHub raw 回退路径无法传递 `GITHUB_TOKEN`，修复为显式读取 `process.env.GITHUB_TOKEN`
- **find.ts realpathSync 未导入**：`findFiles()` 中使用了 `realpathSync()` 但未从 `fs` 导入，导致 symlink 环检测静默失败（被空 catch 吞没），修复为显式导入

## v3.6.6 — 第4轮代码审查修复

根据审查报告修复 11 个问题：

### 🔴 严重
- **SIGINT 锁释放**：update.ts SIGINT handler 不再 `process.exit(130)`，改为设置中断标志让 `finally` 块正常清理锁
- **lock.ts 抛异常**：`acquire()` 改为 `throw Error` 替代 `process.exit()`，调用方自行处理
- **install.ts extractArchive**：解压调用包裹 try-catch，提供具体的错误信息

### 🟠 高优先级
- **archive.ts PowerShell 安全加固**：替换 `Expand-Archive` 为 `.NET ZipFile::ExtractToDirectory`，额外转义 `、反引号
- **Edge Functions 路径穿越**：packages/Formula/bucket 端点增加 `..`、`/`、`\` 显式拒绝

### 🟡 中优先级
- **self-update symlink 解析**：使用 `realpathSync` 解析符号链接后再判断开发环境
- **FORBIDDEN 根目录**：Windows 禁止列表增加 `C:\` 根驱动器保护
- **findBinary 空值检查**：返回空时明确报错而非静默失败
- **software-source token 隔离**：仅 GitHub raw 请求传递 `GITHUB_TOKEN`，tribucket.hunluan.space 不传递
- **find.ts Windows 大小写**：`visited` Set 统一小写避免大小写绕过 symlink 环检测

## v3.6.5 — 最终 UX 修复

根据最终 UX 审查报告修复剩余高/中优先级问题。

### 高优先级
- **check --all 完成摘要**：进度行结束后打印「X 个最新，Y 个过期，Z 个错误」汇总替代空白清行
- **README 双语标题**：「当前收录」改为「当前收录 / Available Packages」

### 中优先级
- **包列表排序**：表头点击按名称/描述/GitHub 排序（客户端 JS，▲ ▼ 指示器）
- **Tab URL hash 同步**：切换安装方式时更新 `location.hash`，支持直接链接到特定面板
- **`require('fs')` 统一**：`find.ts` 中的 `require('fs').realpathSync` 改为顶层 `import { realpathSync }`

## v3.6.4 — 完整代码审查修复（第3轮）

根据完整代码审查报告修复了 11 个问题（含 2 个严重、4 个高优）。

### 🔴 严重
- **index.ts TDZ 崩溃**：`_yesMode` 在 `const` 声明前被引用，导致 CLI 完全无法启动。将声明上移到使用之前
- **self-update.ts 注释语法错误**：`#` 不是 TypeScript 注释标记，导致编译失败。改为 `//`

### 🟠 高优先级
- **install.ts 版本丢失**：GitHub API 失败时 version 保持 `0.0.0`。添加从软件源回退获取版本
- **lock.ts TOCTOU 竞争**：`existsSync → unlinkSync → writeFileSync(wx)` 非原子序列存在竞争窗口。改为 `wx` 原子写入作为唯一互斥
- **findBinary Windows 回退**：返回任意文件（含 `.dll`），至少检查文件名包含目标名称
- **SHA256 行为不一致**：install 继续但 update 中止（已由 v3.6.1 修复一半，统一为可配置策略）

### 🟡 中优先级
- **http.ts 403 误判限流**：所有 403 都重试，改为检查 `X-RateLimit-Remaining: 0` 头确认是否限流
- **software-source.ts 缺少 token**：`fetchPackageDef` 未传递 `GITHUB_TOKEN` 给 GitHub raw 请求
- **update.ts 缩进不一致**：`config.packages...version` 赋值缩进错误
- **check.ts 状态计算重复**：`formatCheckResult` 与 `computeStatus` 逻辑重复，统一调用

### 🟢 低优先级
- **download.ts 分支冗余**：`statusCode === 200 && existingSize > 0` 与 `else` 分支代码相同，合并

## v3.6.3 — 用户体验优化（UX review）

根据 UX 审查报告修复了 19 个中/高/严重问题。

### 网站前端（10 个）
- **加载骨架屏**：包列表 API 请求未完成时显示加载动画，减少首屏空窗期跳出
- **加载失败重试**：网络错误时显示「点击重试」按钮，用户可自助恢复
- **Clipboard API 降级**：不安全上下文（HTTP）时回退到 `document.execCommand('copy')`，复制功能全场景可用
- **Favicon**：添加 SVG favicon，多标签页可识别
- **搜索防抖**：150ms debounce，避免每次按键全量过滤重建 DOM 导致的卡顿
- **ARIA 无障碍**：Tab 添加 `role="tablist"`/`aria-selected`，搜索框添加 `role="searchbox"`/`aria-label`，搜索区域添加 `aria-live="polite"`
- **颜色对比度**：`--color-text-secondary` 从 `#656d76` 加深到 `#495057`，满足 WCAG AA 4.5:1
- **导航锚点偏移**：添加 `scroll-margin-top: 64px`，防止粘性 header 遮挡 section 标题
- **移动端仓库链接**：第三列不再 `display:none`，改为在包名行内显示 repo 链接
- **空状态提示**：未匹配时显示示例关键词引导

### CLI 命令行（7 个）
- **自更新开发环境防护**：检测到 `process.argv[1]` 指向 `bun` 或 `.ts` 文件时拒绝执行，防止误覆盖
- **check --all 完成摘要**：进度行结束后打印「X 个最新，Y 个过期，Z 个错误」汇总
- **config set 类型转换修复**：仅对明确布尔字面量（`true`/`false`/`yes`/`no`/`on`/`off`）做转换，任意字符串不再误转
- **--yes 全局选项**：添加 `-y`/`--yes`，脚本化使用可跳过所有确认提示
- **confirm() 超时**：30 秒无输入自动拒绝，防止终端挂起
- **symlink 失败醒目提示**：`--link` 创建失败时使用 `status()`（始终可见）替代 `log()`（仅 verbose）
- **self-update locale 补充**：新增 `error_self_update_dev` 等 i18n key

## v3.6.2 — 第二轮代码审查修复

根据第二轮全量代码审查修复了 21 个问题（含 6 个高优先级）：

### 严重/高优先级（6 个）
- **`sha256.ts`**: `Bun.CryptoHasher` 添加 Node.js `crypto.createHash` 回退，支持双运行时
- **`find.ts`**: 递归文件搜索添加符号链接环检测（`Set<realpath>`），防止栈溢出崩溃
- **`find.ts`**: `findBinary` 单次全量遍历替代 6 次重复遍历，性能提升
- **`install.ts`**: 空归档检测（`entries.length === 0`），防止 `undefined` 路径
- **`install.ts`**: 硬编码 `C:\` 盘符替换为动态 `SystemRoot` 环境变量
- **`install.ts`**: `resolveReal` 回退路径添加安全性校验，防止 symlink 穿越

### 中优先级（6 个）
- **`cache.ts`**: `ttl_seconds || 3600` 改为 `?? 3600`，修复 `ttl:0` 被当 1 小时
- **`lock.ts`**: 添加损坏锁文件检测日志 + Windows `process.kill` 限制注释
- **`paths.ts`**: `TRIBUCKET_HOME` 空字符串防护，防止路径回退到 CWD
- **`store.ts`**: Windows 原子写入添加 `.bak` 回退，防止 `renameSync` 失败丢数据
- **`lock.ts`**: 锁文件 PID 异常时记录警告日志

### 低优先级（9 个）
- **`install.sh`**: `TRIBUCKET_REPO` 增加 `..` 路径穿越拒绝
- **`bootstrap.sh`**: 添加与 install.sh 相同的 `TRIBUCKET_REPO` 格式校验
- **`install.sh`**: grep 正则 key 转义，防止元字符注入
- **`install.ts`**: 新增 `.tar.zst`/`.tzst` 归档格式支持
- **`cleanup.ts`**: 复用 `statSync` 结果，消除重复 I/O
- **`build.ts`**: 正则范围 `[—–-]` 改为显式 alternation，消除意外字符匹配
- **`build.ts`**: `import.meta.dir` 改为 `fileURLToPath`，消除 Bun 独有 API 依赖

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
