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

维护者核对官方 Scoop 桶后，在仓库根目录用一条命令起草、验证并生成新包。

```bash
python -m tribucket_gen add owner/repo --name example-tool
```

可用 `--name`、`--description`、`--binary`、`--license`、`--homepage` 覆盖元数据。命令写入包定义及该软件支持的 Scoop 清单和 Homebrew Formula，失败时删除本次新增的文件。手工调整定义时，可分步运行 `draft`、`validate` 和 `render`。[维护步骤](AGENTS.md#adding-a-package) · [tribucket-gen 技能](skills/tribucket-gen/SKILL.md)

GitHub Actions 每周一 05:17 UTC 检查上游版本，推送包定义或手动触发也可运行。自动更新提交推送后，有镜像凭据时会同步到 CNB。

## 独立使用 tribucket-gen

引擎支持 Python 3.9+，仅使用标准库。在含有 `packages/` 目录的 tap 或 bucket 根目录，也可用 `uvx` 新增软件包。

```bash
uvx --from git+https://github.com/sixiang-world/tribucket tribucket-gen add owner/repo --name example-tool
```

## 许可证

仓库使用 [MIT 许可证](LICENSE)。软件包的许可证记录在各自的定义中。
