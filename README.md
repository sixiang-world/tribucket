# tribucket

Issue 驱动的多软件源聚合仓库：提交一个 GitHub 仓库，自动生成 **Homebrew Formula** 与 **Scoop bucket**。

## 安装软件

```bash
# Homebrew
brew install shisheng820/tribucket/<name>
# Scoop
scoop bucket add tribucket https://github.com/shisheng820/tribucket
scoop install <name>
```

全部可用包见 [`packages/`](packages/) 目录（106+ 个）。

## 提交新包

1. [打开一个包提交 Issue](https://github.com/shisheng820/tribucket/issues/new?template=package-submission.yml)，填几个基本字段（仓库 URL、一句话描述）
2. 机器人分析最新 Release 资产，自动生成包定义并贴回评论
3. 确认无误后回复 `@tribucket-bot confirm` —— 一次 commit 原子入库（定义 + Formula + bucket）

支持的资产命名模板见 [skills/tribucket-gen/templates.json](skills/tribucket-gen/templates.json)；不在模板内的仓库会转人工处理。

## 独立使用 tribucket-gen

不依赖本仓库，给自己维护的 tap/bucket 生成软件源：

```bash
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen draft <owner/repo> --json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen validate packages/<name>.json
uvx --from git+https://github.com/shisheng820/tribucket tribucket-gen render --only <name>
```

（Python 3.9+，仅标准库。也可安装 [skill](skills/tribucket-gen/) 到你的 AI Agent。）

## 引擎命令（仓库内）

```bash
python -m tribucket_gen render [--only NAME] [--dry-run]   # 生成 Formula/bucket
python -m tribucket_gen check                              # 全库资产模式体检
python -m tribucket_gen draft <owner/repo> --json          # repo → 包定义草稿
python -m tribucket_gen validate <file>                    # 定义校验
```

上游新版本由 CI 每日自动跟进（cron）；详见 [AGENTS.md](AGENTS.md)。
