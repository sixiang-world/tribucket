     1|# tribucket
     2|
     3|**tri** (三合一) + **bucket** (包仓库) = 三种安装方式，一个仓库。
     4|
     5|一个通用的跨平台软件包仓库，每个软件同时提供：
     6|- **Homebrew** (macOS / Linux)
     7|- **Scoop** (Windows)
     8|- **Shell 脚本** (任意平台兜底)
     9|
    10|## 当前收录
    11|
    12|| 软件 | 描述 | GitHub |
    13||------|------|--------|
    14|| ccx | Claude / Codex / Gemini API Proxy | [BenedictKing/ccx](https://github.com/BenedictKing/ccx) |
    15|
    16|## 安装方式
    17|
    18|### Homebrew (macOS / Linux)
    19|```bash
    20|brew tap sixiang-world/tribucket
    21|brew install ccx
    22|```
    23|
    24|### Scoop (Windows)
    25|```powershell
    26|scoop bucket add tribucket https://github.com/sixiang-world/tribucket
    27|scoop install ccx
    28|```
    29|
    30|### 脚本兜底 (任意平台)
    31|
    32|**Linux / macOS：**
    33|```bash
    34|# 安装到当前目录
    35|curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash -s ccx
    36|
    37|# 安装到指定目录
    38|curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | INSTALL_DIR=/usr/local/bin bash -s ccx
    39|```
    40|
    41|**Windows (PowerShell)：**
    42|```powershell
    43|irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1 | iex -ArgumentList ccx
    44|```
    45|
    46|### 更新 / 卸载
    47|
    48|脚本安装后会在安装目录生成 `update.sh` / `update.ps1` 和 `uninstall.sh` / `uninstall.ps1`：
    49|```bash
    50|./update.sh ccx        # 更新到最新版
    51|./uninstall.sh ccx     # 卸载
    52|```
    53|
    54|## 项目结构
    55|
    56|```
    57|tribucket/
    58|├── README.md
    59|├── Formula/           # Homebrew formulas
    60|│   └── ccx.rb
    61|├── bucket/            # Scoop manifests
    62|│   └── ccx.json
    63|├── packages/          # 软件包元数据 (核心)
    64|│   └── ccx.json
    65|└── scripts/           # 通用安装/更新/卸载脚本
    66|    ├── install.sh
    67|    ├── install.ps1
    68|    ├── update.sh
    69|    └── uninstall.sh
    70|```
    71|
    72|## 添加新软件
    73|
    74|1. 在 `packages/` 下新建 `<name>.json`，填入 GitHub 仓库和 asset 匹配规则
    75|2. 在 `Formula/` 下新建 `<name>.rb` (Homebrew formula)
    76|3. 在 `bucket/` 下新建 `<name>.json` (Scoop manifest)
    77|4. 提交 PR
    78|
    79|`packages/<name>.json` 格式：
    80|```json
    81|{
    82|  "name": "tool-name",
    83|  "repo": "owner/repo",
    84|  "description": "一句话描述",
    85|  "binary": "binary-name",
    86|  "license": "MIT",
    87|  "homepage": "https://github.com/owner/repo",
    88|  "asset_pattern": {
    89|    "linux_amd64": "keyword-in-asset-filename",
    90|    "linux_arm64": "keyword-in-asset-filename",
    91|    "darwin_amd64": "keyword-in-asset-filename",
    92|    "darwin_arm64": "keyword-in-asset-filename",
    93|    "windows_amd64": "keyword-in-asset-filename.exe",
    94|    "windows_arm64": "keyword-in-asset-filename.exe"
    95|  }
    96|}
    97|```
    98|
    99|## License
   100|
   101|MIT
   102|