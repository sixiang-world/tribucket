# checkver & autoupdate: 跨包管理器调研与 tribucket 设计方案

**日期:** 2026-05-31
**状态:** 已确认

## 调研摘要

对五大包管理器的版本检测机制进行了横向对比：

| 包管理器 | 检测方式数 | DSL | 核心优势 |
|----------|-----------|-----|---------|
| **Scoop** | 6 种 | JSON (PowerShell) | 命名捕获组、replace 模板、零配置 |
| **Homebrew Livecheck** | 5 种 | Ruby | strategy block 程序化能力最强 |
| **asdf / mise** | 1 种 | Shell | 极简，无 DSL |
| **AUR** | 1 种 | Shell | makepkg 自动解析 |
| **Chocolatey AU** | 1 种 | PowerShell | 功能完整但 verbose |

**关键发现：** Scoop 的 `checkver` 是 JSON 驱动的标杆，与 tribucket 的 JSON 原生格式最契合。命名捕获组 `(?<name>...)` 是其核心创新——允许从 URL 中同时提取多个片段并在 `autoupdate` 模板中独立引用。

## 设计决策

### 定位

checkver **仅服务于 `download_url` 路径**。GitHub Release 路径（有 `repo` + `asset_pattern`）继续通过 GitHub API 自动获取最新版，不受影响。

```
packages/<name>.json
  │
  ├─ 有 download_url？
  │   ├─ checkver 存在 → 运行 checkver 获取最新版本
  │   └─ checkver 不存在 → 从 download_url 中自动提取版本号（零配置）
  │
  └─ 无 download_url（GitHub Release 源）
      → fetch_latest_release(repo) 自动获取最新版 — 不变
```

### 模式选择: 纯声明式

不引入脚本/代码模式。命名捕获组 + jsonpath + regex 的组合足以覆盖 tribucket 已收录和可预见的全部 100+ 个包。出现极端 case 时回退到手动改 `version` 字段——成本可接受。

## 字段 Schema

### checkver

类型：`string "github"` 或 `object`。可选。

- **不存在** + 有 `download_url`：自动从 URL 提取版本号（零配置模式）
- **`"github"`**：使用 `repo` 字段调用 GitHub API 获取 latest tag
- **`object`**：自定义检测配置（见子字段）

### checkver.url

类型：`string`。版本检测 URL。默认：`download_url` 第一个有效值的来源页面（origin）。

### checkver.jsonpath

类型：`string`。JSONPath 表达式，作用于 API 返回的 JSON 响应。

示例：`"$[0].version"` — 取数组第一个元素的 `version` 字段。

### checkver.regex

类型：`string`。正则表达式，支持命名捕获组 `(?<name>...)` 和编号组 `(group)`。

示例：
- `"go([\\d.]+)"` — 捕获 "1.24.3"
- `"zulu(?<build>[\\d.]+)-ca-jdk(?<ver>[\\d.]+)"` — 同时捕获 build 和 ver

### checkver.replace

类型：`string`。版本号构造模板。默认 `"${1}"`（取第一个编号捕获组）。

示例：`"${major}.${minor}.${patch}-LTS"` 或 `"${ver}"`（命名捕获组）。

### autoupdate

类型：`object`。可选。各平台的 URL 模板。key 与 `download_url` 相同（6 个平台）。value 中可用 `${version}` 和所有命名捕获组 `${name}`。

仅当 `download_url` 中原位版本号替换不够用时才需要此字段。不存在时，生成器在 `download_url` 中原位搜索替换版本号字符串。

## 三种复杂度等级

### L1 — 零配置（~60% 的 download_url 包）

版本号直接嵌在 URL 路径中：

```json
{
  "name": "go",
  "repo": "golang/go",
  "version": "1.24.3",
  "download_url": {
    "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
  }
}
```

生成器自动以 `(\d+\.\d+\.\d+(?:[.\-]?[\w]+)?)` 从 URL 提取版本号。

### L2 — API + regex（~30%）

需要调 API 获取版本信息：

```json
{
  "name": "corretto-jdk21",
  "repo": "corretto/corretto-21",
  "version": "21.0.7.1.1",
  "download_url": { "..." },
  "checkver": {
    "url": "https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz",
    "jsonpath": "$.version",
    "regex": "([\\d.]+)"
  }
}
```

### L3 — 命名捕获组重建 URL（~10%）

版本号拆成多段，需要分别捕获并在 URL 模板中独立引用：

```json
{
  "name": "zulu-jdk21",
  "repo": "azul/zulu-builds",
  "version": "21.0.11",
  "download_url": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_x64.tar.gz"
  },
  "checkver": {
    "url": "https://api.azul.com/metadata/v1/zulu/packages/...",
    "jsonpath": "$.download_url",
    "regex": "zulu(?<build>[\\d.]+)-ca-jdk(?<ver>[\\d.]+)",
    "replace": "${ver}"
  },
  "autoupdate": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu${build}-ca-jdk${ver}-linux_x64.tar.gz"
  }
}
```

## 执行流程

```
process_package(pkg)
│
├─ 有 download_url？
│   │
│   ├─ 1. 检测最新版本
│   │   ├─ 有 checkver？
│   │   │   ├─ checkver == "github" → GitHub API → tag_name → strip v 前缀
│   │   │   └─ checkver 是 object：
│   │   │        GET checkver.url
│   │   │        → Content-Type: application/json → 自动 parse JSON
│   │   │          ├─ 有 jsonpath → 应用 JSONPath 取字段
│   │   │          └─ 无 jsonpath → 整个响应给 regex
│   │   │        → regex 匹配命名/编号捕获组
│   │   │        → replace 构造最终版本号（默认 ${1}）
│   │   │        → 失败 → 回退 version 字段
│   │   │
│   │   └─ 无 checkver → 从 download_url 第一个有效 URL 自动提取
│   │        正则: (\d+\.\d+\.\d+(?:[.\-]?[\w]+)?)
│   │        取所有匹配中最长的项 → 失败 → 回退 version 字段
│   │
│   ├─ 2. 构造新 URL
│   │   ├─ 有 autoupdate？
│   │   │   → 用 ${version}、${name} 替换对应占位符
│   │   └─ 无 autoupdate？
│   │       → 在 download_url 中原位搜索旧版本号 → 全局替换
│   │
│   └─ 3. 下载新 URL → 计算 SHA256 → 写 Formula/Bucket
│
└─ 无 download_url（GitHub Release 源）
    → 现有逻辑不变：fetch_latest_release() → 匹配 asset_pattern
```

### jsonpath 与 regex 的执行顺序

```
HTTP GET url → 响应
  ├─ Content-Type: application/json → 自动 parse JSON
  │   ├─ 有 jsonpath → 应用 JSONPath，得到中间值（可能是版本号也可能是 URL）
  │   └─ 无 jsonpath → 整个 JSON 作为字符串传给 regex
  └─ Content-Type 非 JSON → 原始文本
      └─ 直接传给 regex
```

regex 永远是最后一个提取步骤——因为 jsonpath 返回的值可能是 URL，版本号还嵌在 URL 里。

### 原位替换 vs autoupdate 模板

- **原位替换**（无 autoupdate）：在原始 download_url 中对旧版本号做 `string.replace(old_version, new_version)`。适合 node、go 等简单场景。
- **autoupdate 模板**（有 autoupdate）：用命名捕获组精确替换。适合 zulu 等 URL 中多段版本号需独立替换的场景。

## CI 集成

tribucket 已有每 6 小时触发的定时 CI。checkver 完成后流程：

```
GitHub Actions (schedule / workflow_dispatch)
│
├─ 1. checkout + Python env
├─ 2. python scripts/generate.py
│      ├─ GitHub Release 包：调 API 取最新版 → 有更新则生成
│      └─ download_url 包：运行 checkver → 有更新则：
│          ├─ 更新 packages/<name>.json 的 version 字段
│          ├─ 构造新 URL → 下载 → SHA256
│          └─ 写入 Formula/Bucket
├─ 3. git diff --exit-code → 无变更则退出
├─ 4. git add Formula/ bucket/ packages/
├─ 5. git commit -m "chore: update <N> package(s)"
└─ 6. git push
```

关键：**packages/*.json 中的 `version` 字段必须同步更新**，保证下次运行幂等。

## 错误处理

| 场景 | 行为 |
|------|------|
| checkver.url 不可达（DNS/超时） | warning → 回退 `version`，不阻塞其他包 |
| regex 不匹配 | warning → 回退 `version` |
| jsonpath 返回 null | warning → 跳过 jsonpath，原始文本直接进 regex |
| 新版本号与 version 相同 | 跳过，不更新 |
| SHA256 下载失败 | error → 该包跳过，其他包继续 |
| 原位替换找不到版本号 | error → 提示用户添加 `autoupdate` |

核心原则：**一个包失败不影响其他包**。CI 不会因为 checkver 问题整体挂掉。
