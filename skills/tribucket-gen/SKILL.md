# tribucket-gen — 为 tribucket 仓库快速生成 packages/*.json 定义文件

## 用途

给定一个 GitHub 仓库链接，自动分析其 Release 资产命名规律，生成符合 tribucket 规范的 `packages/<name>.json` 定义文件。

## 核心流程

```
用户给出 repo URL
       │
       ▼
  ① 获取最新 Release 资产列表
       │
       ▼
  ② 模板匹配：能否套用已知命名模式？
       │
    ┌──┴──┐
    YES   NO
    │     │
    ▼     ▼
  ③a 模板  ③b AI 分析
  快速生成  智能生成
    │     │
    └──┬──┘
       ▼
  ④ 输出 packages/<name>.json
```

## 步骤详解

### ① 获取 Release 资产

```bash
SKILL_DIR="$(dirname "$(readlink -f "$0")")"  # 或直接用 skill 目录路径
bash "$SKILL_DIR/fetch_release.sh" <owner/repo>
```

输出 JSON 包含：version, tag, assets（每个带 name/url/platform 猜测）, summary。

如果需要认证，用 GitHub Token：`bash fetch_release.sh <owner/repo> YOUR_TOKEN`

### ② 模板匹配

拿到 assets 列表后，对照 `templates.json` 中的 6 种已知模式逐一匹配。

**匹配方法**：取 `linux_amd64` 平台的资产名（最常见），用 detect 正则判断。

**6 种模板（按频率排序）**：

| ID | 描述 | 示例资产名 |
|---|---|---|
| `simple-hyphen` | `{name}-linux-amd64.tar.gz` | cosign-linux-amd64 |
| `rust-triple-prefix` | `{name}-x86_64-unknown-linux-gnu.tar.gz` | starship-x86_64-unknown-linux-gnu.tar.gz |
| `simple-x64` | `{name}-linux-x64.tar.gz` | claude-linux-x64.tar.gz |
| `rust-triple-bare` | `x86_64-unknown-linux-gnu.tar.gz` (无前缀) | x86_64-unknown-linux-gnu.tar.gz |
| `underscore-version` | `{name}_{ver}_linux_x86_64.tar.gz` | lazygit_0.41_linux_x86_64.tar.gz |
| `go-style` | `{name}_linux_amd64` (无版本无后缀) | wgcf_linux_amd64 |

### ③a 模板快速生成

匹配到模板后，按模板规则填充 6 个平台的 `asset_pattern`。

**关键变量**：
- `{name}`：包名（小写）
- `{libc}`：从实际资产名中提取（musl 或 gnu，多数是 gnu）
- `{version}`：从资产名中提取的版本号（如果模板需要）

**特殊处理**：
- 如果某个平台的资产不存在，填 `"NO_MATCH"`
- 注意 `.exe` 结尾的是裸二进制，不是压缩包
- 注意 `.tar.zst`（如 ollama）需要识别

### ③b AI 智能生成

当模板无法匹配时，AI 需要：

1. **观察所有资产名**，找出命名规律
2. **提取模式**：前缀、分隔符、平台标识、架构标识、后缀
3. **推断 6 个平台的 pattern**，缺失的填 `"NO_MATCH"`
4. **注意 glob `*` 的使用**：当版本号嵌入文件名时，用 `*` 代替版本段

**AI 判断时的常见陷阱**：
- `x64` = `amd64` = `x86_64`（都是同一个架构）
- `arm64` = `aarch64`
- 有些项目 macOS 只发 universal binary（如 ollama 的 `darwin.tgz`），darwin_amd64 和 darwin_arm64 用同一个 pattern
- 有些项目 Windows 只发 `.exe` 裸文件（如 jq）
- 有些项目不发 Windows ARM64

### ④ 输出格式

生成的 JSON 必须严格符合此 schema：

```json
{
  "name": "包名（小写，连字符分隔）",
  "repo": "owner/repo",
  "description": "一句话描述，英文",
  "binary": "可执行文件名（不含 .exe）",
  "license": "SPDX identifier，如 MIT, Apache-2.0",
  "homepage": "https://github.com/owner/repo 或项目官网",
  "asset_pattern": {
    "linux_amd64": "匹配模式或 NO_MATCH",
    "linux_arm64": "匹配模式或 NO_MATCH",
    "darwin_amd64": "匹配模式或 NO_MATCH",
    "darwin_arm64": "匹配模式或 NO_MATCH",
    "windows_amd64": "匹配模式或 NO_MATCH",
    "windows_arm64": "匹配模式或 NO_MATCH"
  }
}
```

**asset_pattern 匹配规则**（来自 generate.py 的 `match_asset` 函数）：
1. 先尝试**子串匹配**（`pattern in asset_name`）
2. 再尝试 **glob 匹配**（`fnmatch(asset_name, f"*{pattern}*")`）
3. 所以 pattern 可以是：
   - 精确后缀：`x86_64-unknown-linux-gnu.tar.gz`
   - 带通配符：`fzf-*-linux_amd64.tar.gz`
   - 简单子串：`linux-amd64`

**最佳实践**：
- pattern 越短越好，但必须能唯一匹配目标平台的资产
- 优先用后缀匹配（如 `linux-amd64.tar.gz`），避免用 `*` 前缀
- 如果 Release 中有 checksum 文件（SHA256SUMS 等），在 description 或注释中提及

**大小写敏感**：
- `match_asset` 的子串匹配和 glob 匹配都是大小写敏感的
- 有些项目用大写平台名：`Linux`、`Darwin`、`Windows`（如 charmbracelet/vhs）
- 有些项目用小写：`linux`、`darwin`、`windows`（大多数项目）
- pattern 必须与实际资产名的大小写完全一致
- 当大小写不确定时，用 `*` 通配符代替平台名部分：如 `*_Linux_x86_64.tar.gz`

**可选字段**（仅在特殊情况下添加）：
```json
{
  "download_url": { ... },
  "version": "1.2.3",
  "install_type": "directory"
}
```
- `download_url`：当软件不在 GitHub Release 发布时（如 go.dev、elastic.co）
- `version`：使用 download_url 时必填
- `install_type`：默认 `"binary"`，JDK 类目录型软件用 `"directory"`

## 完整示例

### 输入
```
帮我收录 https://github.com/BurntSushi/ripgrep
```

### AI 执行
1. `bash fetch_release.sh BurntSushi/ripgrep`
2. 看到资产：`ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz` 等
3. 匹配模板 `rust-triple-bare`（无前缀，直接是 target triple）
4. 生成定义文件

### 输出
写入 `packages/ripgrep.json`（注意这是 tribucket 仓库内的路径）

## 工具位置

- **模板库**: `<skill_dir>/templates.json`
- **Release 抓取脚本**: `<skill_dir>/fetch_release.sh`
- **tribucket 仓库**: `/home/work/.openclaw/workspace/tribucket/`
- **已有定义文件**: `/home/work/.openclaw/workspace/tribucket/packages/`
- **生成器**: `/home/work/.openclaw/workspace/tribucket/scripts/generate.py`

## 验证

生成后可以运行：
```bash
cd /home/work/.openclaw/workspace/tribucket
python3 scripts/generate.py --check-assets --only <name>
```

这会验证 asset_pattern 是否能匹配到最新 Release 的资产。