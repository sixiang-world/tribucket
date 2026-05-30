# Contributing to tribucket

## 添加新软件

1. Fork 本仓库
2. 在 `packages/` 下新建 `<name>.json`，格式参考已有文件
3. 运行 `python scripts/generate.py --only <name>` 自动生成 Formula 和 Bucket
4. 提交 PR

### 自动生成 Formula 和 Bucket

运行生成脚本以从 `packages/*.json` 自动创建 Homebrew Formula 和 Scoop manifest：

```bash
# 生成全部
python scripts/generate.py

# 只生成某个包
python scripts/generate.py --only <name>

# 预览（不写文件）
python scripts/generate.py --dry-run

# 跳过 SHA256 计算（快速迭代模板）
python scripts/generate.py --skip-hash
```

设置 `GITHUB_TOKEN` 环境变量可提升 API 速率限制。

### packages/\<name\>.json 字段说明

**GitHub Release 源（标准方式）：**

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | 是 | 软件名，与文件名一致 |
| `repo` | 是 | GitHub 仓库，格式 `owner/repo` |
| `description` | 是 | 一句话描述 |
| `binary` | 是 | 安装后的可执行文件名 |
| `license` | 是 | 开源协议 |
| `homepage` | 是 | 项目主页 URL |
| `asset_pattern` | 是 | 各平台的 release asset 匹配规则 |

**自定义下载源（非 GitHub Release）：**

| 字段 | 必填 | 说明 |
|------|------|------|
| `version` | **是** | 当前软件版本号（`download_url` 存在时必填） |
| `download_url` | 否 | 各平台的下载 URL（见下方说明） |
| `checkver` | 否 | 版本检测配置（与 `download_url` 配合使用） |
| `autoupdate` | 否 | URL 模板（当原地替换版本号不够用时） |

当 `download_url` 存在时，生成器直接使用该 URL 和 `version` 字段，不走 GitHub API。

**零配置（推荐）：**

如果 `download_url` 本身包含版本号，无需任何额外配置，生成器会自动提取：

```json
{
  "version": "1.24.3",
  "download_url": {
    "linux_amd64": "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
  }
}
```

**checkver 完整配置：**

```json
{
  "version": "21.0.11",
  "download_url": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu21.50.19-ca-jdk21.0.11-linux_x64.tar.gz"
  },
  "checkver": {
    "url": "https://api.azul.com/metadata/v1/zulu/packages/latest",
    "jsonpath": "$.download_url",
    "regex": "zulu(?P<build>[\\d.]+)-ca-jdk(?P<ver>[\\d.]+)",
    "replace": "${ver}"
  },
  "autoupdate": {
    "linux_amd64": "https://cdn.azul.com/zulu/bin/zulu${build}-ca-jdk${ver}-linux_x64.tar.gz"
  }
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| `checkver` | string 或 object | `"github"` = 用 repo 的 GitHub API；object = 自定义 |
| `checkver.url` | string | 版本检测 URL（默认：download_url 第一个有效值的 origin） |
| `checkver.jsonpath` | string | JSONPath 表达式，如 `"$[0].version"` |
| `checkver.regex` | string | 正则，支持命名捕获组 `(?P<name>...)` |
| `checkver.replace` | string | 版本号构造模板，默认 `"${1}"` |
| `autoupdate` | object | 各平台 URL 模板，支持 `${version}` 和命名捕获组 `${name}` |

- `download_url` 的 key 与 `asset_pattern` 相同（6 个平台）
- 不支持的平台填 `"NO_MATCH"`
- 如果 URL 中版本号出现多段且需独立替换，请使用 `autoupdate`
- 命名捕获组使用 Python 语法 `(?P<name>...)`

### 验证

提交 PR 后 CI 会自动检查：
- JSON 格式是否合法
- 必填字段是否齐全
- asset_pattern 是否覆盖全部 6 个平台

## 报告问题

请在 [Issues](https://github.com/sixiang-world/tribucket/issues) 中提交，包含：
- 操作系统和架构
- 完整的错误输出
- 使用的安装方式（Homebrew / Scoop / Shell 脚本）
