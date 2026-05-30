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

当 `download_url` 存在时，生成器直接使用该 URL 和 `version` 字段，不走 GitHub API。

```json
{
  "version": "1.2.3",
  "download_url": {
    "linux_amd64": "https://example.com/releases/tool-1.2.3-linux-x64.tar.gz",
    "darwin_amd64": "https://example.com/releases/tool-1.2.3-macos-x64.tar.gz",
    "windows_amd64": "https://example.com/releases/tool-1.2.3-windows-x64.zip"
  },
  "checkver": {
    "url": "https://example.com/api/latest",
    "regex": "\"version\":\"([^\"]+)\""
  }
}
```

- `download_url` 的 key 与 `asset_pattern` 相同（6 个平台）
- `{version}` 占位符会被 `checkver` 获取的版本号替换
- `checkver.url` 返回的内容用 `checkver.regex` 提取版本号（第一个捕获组）
- 如果 URL 不含 `{version}`，则直接使用（静态 URL）
- 不支持的平台填 `"NO_MATCH"`

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
