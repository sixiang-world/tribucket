# tribucket

**v4.1 Maintenance Edition** 是以 Windows Scoop 为主的个人软件源，同时为支持的包提供 Homebrew Formula。这里收录 Scoop 官方 `main`、`extras`、`java` 尚未收录的软件，包括自维护工具。

## Windows · Scoop

```powershell
scoop bucket add tribucket https://github.com/sixiang-world/tribucket
scoop install tribucket/qqmail-cli
```

将 `qqmail-cli` 替换为所需包名。可用清单见 [`bucket/`](bucket/)。

已由官方桶维护的软件请从对应桶安装。`main` 随 Scoop 提供，`extras` 和 `java` 可用 `scoop bucket add extras` 和 `scoop bucket add java` 启用。[Scoop 官方桶列表](https://github.com/ScoopInstaller/Scoop#known-application-buckets)

## Homebrew

```bash
brew tap sixiang-world/tribucket https://github.com/sixiang-world/tribucket.git
brew install sixiang-world/tribucket/qqmail-cli
```

可用清单见 [`Formula/`](Formula/)。

## 本地维护

维护者在本地新增或修改 `packages/*.json`。公开 Issue 收包流程已停用。用 `tribucket_gen` 的 `draft` 起草、`validate` 校验，再用 `render` 生成 Scoop 清单和 Homebrew Formula。也可让 Codex 按仓库技能完成同一流程。[维护步骤](AGENTS.md#adding-a-package) · [tribucket-gen 技能](skills/tribucket-gen/SKILL.md)

GitHub Actions 每日检查上游版本。CNB 镜像同步可在推送 `main` 时触发，也可手动运行。

## 独立使用 tribucket-gen

引擎支持 Python 3.9+，仅使用标准库。在自己维护的 tap 或 bucket 根目录起草并校验定义。

```bash
uvx --from git+https://github.com/sixiang-world/tribucket tribucket-gen draft owner/repo --name example-tool --out example-tool.json
uvx --from git+https://github.com/sixiang-world/tribucket tribucket-gen validate example-tool.json
```

通过后将定义移入 `packages/`，再生成安装清单。

```bash
uvx --from git+https://github.com/sixiang-world/tribucket tribucket-gen render --only example-tool
```

## 许可证

仓库使用 [MIT 许可证](LICENSE)。软件包的许可证记录在各自的定义中。
