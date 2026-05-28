     1|     1|# tribucket
     2|     2|
     3|     3|**tri** (三合一) + **bucket** (包仓库) = 三种安装方式，一个仓库。
     4|     4|
     5|     5|一个通用的跨平台软件包仓库，每个软件同时提供：
     6|     6|- **Homebrew** (macOS / Linux)
     7|     7|- **Scoop** (Windows)
     8|     8|- **Shell 脚本** (任意平台兜底)
     9|     9|
    10|    10|## 当前收录
    11|    11|
    12|    12|| 软件 | 描述 | GitHub |
    13|    13||------|------|--------|
    14|    14|| ccx | Claude / Codex / Gemini API Proxy | [BenedictKing/ccx](https://github.com/BenedictKing/ccx) |
    15|    15|
    16|    16|## 安装方式
    17|    17|
    18|    18|### Homebrew (macOS / Linux)
    19|    19|```bash
    20|    20|brew tap sixiang-world/tribucket
    21|    21|brew install ccx
    22|    22|```
    23|    23|
    24|    24|### Scoop (Windows)
    25|    25|```powershell
    26|    26|scoop bucket add tribucket https://github.com/sixiang-world/tribucket
    27|    27|scoop install ccx
    28|    28|```
    29|    29|
    30|    30|### 脚本兜底 (任意平台)
    31|    31|
    32|    32|**Linux / macOS：**
    33|    33|```bash
    34|    34|# 安装到当前目录
    35|    35|curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | bash -s ccx
    36|    36|
    37|    37|# 安装到指定目录
    38|    38|curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh | INSTALL_DIR=/usr/local/bin bash -s ccx
    39|    39|```
    40|    40|
    41|    41|**Windows (PowerShell)：**
    42|    42|```powershell
    43|    43|irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1 | iex -ArgumentList ccx
    44|    44|```
    45|    45|
    46|    46|### 更新 / 卸载
    47|    47|
    48|    48|脚本安装后会在安装目录生成 `update.sh` / `update.ps1` 和 `uninstall.sh` / `uninstall.ps1`：
    49|    49|```bash
    50|    50|./update.sh ccx        # 更新到最新版
    51|    51|./uninstall.sh ccx     # 卸载
    52|    52|```
    53|    53|
    54|    54|## 项目结构
    55|    55|
    56|    56|```
    57|    57|tribucket/
    58|    58|├── README.md
    59|    59|├── Formula/           # Homebrew formulas
    60|    60|│   └── ccx.rb
    61|    61|├── bucket/            # Scoop manifests
    62|    62|│   └── ccx.json
    63|    63|├── packages/          # 软件包元数据 (核心)
    64|    64|│   └── ccx.json
    65|    65|└── scripts/           # 通用安装/更新/卸载脚本
    66|    66|    ├── install.sh
    67|    67|    ├── install.ps1
    68|    68|    ├── update.sh
    69|    69|    └── uninstall.sh
    70|    70|```
    71|    71|
    72|    72|## 添加新软件
    73|    73|
    74|    74|1. 在 `packages/` 下新建 `<name>.json`，填入 GitHub 仓库和 asset 匹配规则
    75|    75|2. 在 `Formula/` 下新建 `<name>.rb` (Homebrew formula)
    76|    76|3. 在 `bucket/` 下新建 `<name>.json` (Scoop manifest)
    77|    77|4. 提交 PR
    78|    78|
    79|    79|`packages/<name>.json` 格式：
    80|    80|```json
    81|    81|{
    82|    82|  "name": "tool-name",
    83|    83|  "repo": "owner/repo",
    84|    84|  "description": "一句话描述",
    85|    85|  "binary": "binary-name",
    86|    86|  "license": "MIT",
    87|    87|  "homepage": "https://github.com/owner/repo",
    88|    88|  "asset_pattern": {
    89|    89|    "linux_amd64": "keyword-in-asset-filename",
    90|    90|    "linux_arm64": "keyword-in-asset-filename",
    91|    91|    "darwin_amd64": "keyword-in-asset-filename",
    92|    92|    "darwin_arm64": "keyword-in-asset-filename",
    93|    93|    "windows_amd64": "keyword-in-asset-filename.exe",
    94|    94|    "windows_arm64": "keyword-in-asset-filename.exe"
    95|    95|  }
    96|    96|}
    97|    97|```
    98|    98|
    99|    99|## License
   100|   100|
   101|   101|MIT
   102|   102|