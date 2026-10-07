# Contributing

## 提交新包（推荐）

打开 [包提交 Issue](https://github.com/sixiang-world/tribucket/issues/new?template=package-submission.yml)，
按表单填写即可，机器人全流程处理。见 README「提交新包」。

## 修引擎 / 改模板

1. Fork + 分支（feat/<desc>、fix/<desc>、chore/<desc>）
2. `python -m pytest tests/ -q` 必须全绿
3. 模板改动改 `skills/tribucket-gen/templates.json`（权威源）+ 补 `tests/test_draft.py` fixture
4. Conventional commits
5. PR 描述附测试证据
