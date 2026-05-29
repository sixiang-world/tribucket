# Contributing to tribucket

## 添加新软件

1. Fork 本仓库
2. 在 `packages/` 下新建 `<name>.json`，格式参考已有文件
3. （可选）在 `Formula/` 下新建 `<name>.rb`，在 `bucket/` 下新建 `<name>.json`
4. 提交 PR

### packages/\<name\>.json 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | 是 | 软件名，与文件名一致 |
| `repo` | 是 | GitHub 仓库，格式 `owner/repo` |
| `description` | 是 | 一句话描述 |
| `binary` | 是 | 安装后的可执行文件名 |
| `license` | 是 | 开源协议 |
| `homepage` | 是 | 项目主页 URL |
| `asset_pattern` | 是 | 各平台的 release asset 匹配规则 |

### asset_pattern 注意事项

- 每个 key 必须是 `linux_amd64`、`linux_arm64`、`darwin_amd64`、`darwin_arm64`、`windows_amd64`、`windows_arm64` 之一
- 值是用于匹配 GitHub release 文件名的**子字符串或 glob 模式**（`*` 匹配任意字符）
- 确保包含文件扩展名（`.tar.gz`、`.zip`、`.exe` 等），安装脚本依赖扩展名判断解压方式
- 如果某平台没有对应的 release asset，填写一个不会匹配到其他文件的占位字符串

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
