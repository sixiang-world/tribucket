# 修复 tribucket asset_pattern 失效导致 Formula/Bucket 无产出

## 背景与目标

最新一次 Generate workflow 跑完后，106 个包中有 **9 个完全没有产出**（Formula 和 Bucket 都跳过），另有约 10 个包部分平台匹配失败。

根因：`asset_pattern` 里嵌入了**版本号或过时的文件命名格式**。上游发新版本后文件名变化，substring/fnmatch 匹配失败。

目标：修复全部失效包，并建立机制防止再次出现同样问题。

---

## TODO

### Phase 1 — 修复零产出包
- [ ] **CLIProxyAPI**: asset_pattern 版本号 → `*`
- [ ] **icloudpd**: asset_pattern `icloudpd` → `icloud`，版本号 → `*`
- [ ] **tencent-kona-jdk21**: asset_pattern `21-jdk_` → `21*-jdk_`
- [ ] **zola**: 先查最新 asset 命名，asset_pattern 版本号 → `*`
- [ ] **KrillinAI**: asset_pattern `KlicStudio_1.4.0_` → `KrillinAI-cli_*_`
- [ ] **go-musicfox**: asset_pattern 去 `v` 前缀，适配扩展名变化
- [ ] **graalvm-ce-jdk17**: 改 download_url 硬编码（多版本 repo）
- [ ] **sapmachine**: 检查是否需要同样处理
- [ ] **sapmachine-jdk17**: 改 download_url 硬编码

### Phase 2 — 修复部分平台失败（低优先级）
- [ ] ripgrep: linux_arm64
- [ ] lsd: windows_arm64
- [ ] hugo: windows_arm64
- [ ] gh: darwin_amd64, darwin_arm64
- [ ] fd: darwin_amd64
- [ ] eza: darwin_amd64/arm64, windows_arm64
- [ ] delta: darwin_amd64, windows_arm64
- [ ] goose: windows_arm64
- [ ] codewhale: windows_arm64

### Phase 3 — 系统性防护
- [ ] `generate.py` 加 `--check-assets` 模式
- [ ] validate workflow 加 asset check step
- [ ] CONTRIBUTING.md 加规范文档

---

## 失效包诊断

### A 类：版本号硬编码在 pattern 里（4个）

| 包 | 当前 pattern | 实际 asset | 修复 |
|---|---|---|---|
| CLIProxyAPI | `CLIProxyAPI_7.1.30_linux_amd64.tar.gz` | `CLIProxyAPI_7.1.33_linux_amd64.tar.gz` | `CLIProxyAPI_*_linux_amd64.tar.gz` |
| icloudpd | `icloudpd-1.32.2-linux-amd64` | `icloud-1.32.3-linux-amd64` | `icloud-*-linux-amd64`（名称也从 icloudpd 改成了 icloud） |
| tencent-kona-jdk21 | `TencentKona-21-jdk_linux-x86_64.tar.gz` | `TencentKona-21.0.11.b1-jdk_linux-x86_64.tar.gz` | `TencentKona-21*-jdk_linux-x86_64.tar.gz` |
| zola | `zola-x86_64-unknown-linux-gnu.tar.gz` | 待确认（API 超时） | `zola-*-x86_64-unknown-linux-gnu.tar.gz`（待验证实际 asset 命名） |

### B 类：上游改名/重构（2个）

| 包 | 当前 pattern | 实际 asset | 修复 |
|---|---|---|---|
| KrillinAI | `KlicStudio_1.4.0_...` | `KrillinAI-cli_2.0.2_...` | 全部改 `KrillinAI-cli_*_...` |
| go-musicfox | `go-musicfox_v4.8.5_linux_amd64.tar.gz` | `go-musicfox_4.8.5_linux_amd64.apk` | 去 `v` 前缀 + 改扩展名，或用 `go-musicfox_*_linux_amd64` 模糊匹配 |

### C 类：多版本 repo（3个）

这些包的 `repo` 包含多个 JDK 大版本，`/releases/latest` 永远返回最新大版本：

| 包 | repo | 预期版本 | 实际 latest |
|---|---|---|---|
| graalvm-ce-jdk17 | graalvm/graalvm-ce-builds | JDK 17 | JDK 25 |
| sapmachine | SAP/SapMachine | latest JDK | JDK 26 |
| sapmachine-jdk17 | SAP/SapMachine | JDK 17 | JDK 26 |

这类包**不能**用 github-release 模式。必须：
- 改为 `download_url` + 硬编码链接（同 liberica-jdk8 策略）
- 或加上 `checkver` 指向特定大版本的 release

### D 类：部分平台失败（10 个，低优先级）

| 包 | 失败平台 | 可能原因 |
|---|---|---|
| ripgrep | linux_arm64 | arm64 没有 musl 构建 |
| lsd | windows_arm64 | 无 Windows ARM 构建 |
| hugo | windows_arm64 | 版本号变化 |
| gh | darwin_amd64, darwin_arm64 | `macOS` vs `macos` 大小写？ |
| fd | darwin_amd64 | asset 命名变化 |
| eza | darwin_amd64/arm64, windows_arm64 | 同上 |
| delta | darwin_amd64, windows_arm64 | 同上 |
| goose | windows_arm64 | 同上 |
| codewhale | windows_arm64 | 同上 |
| sd | 网络 502 | 瞬态 |

---

## 修复方案

### Phase 1：修复 9 个零产出包（A+B+C 类）

#### Step 1: A 类（版本号通配符化）
- `packages/CLIProxyAPI.json` — 改 `asset_pattern` 所有平台的 `7.1.30` → `*`
- `packages/icloudpd.json` — 改 `asset_pattern`：`icloudpd` → `icloud`，版本号 → `*`
- `packages/tencent-kona-jdk21.json` — 改 `asset_pattern`：`TencentKona-21-` → `TencentKona-21*`
- `packages/zola.json` — 改 `asset_pattern` 版本号 → `*`（需先验证最新 asset 命名）

#### Step 2: B 类（改名适配）
- `packages/KrillinAI.json` — 改 `asset_pattern` 全部平台：`KlicStudio_1.4.0_` → `KrillinAI-cli_*_`
- `packages/go-musicfox.json` — 改 `asset_pattern` 去 `v` 前缀，扩展名改为实际格式；或直接用 `go-musicfox_*_<arch>` 模糊匹配

#### Step 3: C 类（多版本 repo → download_url）
- `packages/graalvm-ce-jdk17.json` — 加 `download_url`（硬编码 JDK 17 最后一版的链接），类似 liberica-jdk8
- `packages/sapmachine.json` — 检查是否需要拆分为 `sapmachine-jdk21` 等；或保留但加 wildcard 版本号的 asset_pattern
- `packages/sapmachine-jdk17.json` — 加 `download_url`（硬编码 JDK 17 链接）

### Phase 2：修复部分平台失败（D 类，可选）

逐包检查实际 asset 列表，调整 `asset_pattern` 或标记 `NO_MATCH`。

### Phase 3：系统性防止复发

#### Step 4: 添加 `--check-assets` 模式
在 `generate.py` 加一个 flag：
```
python scripts/generate.py --check-assets
```
只验证 `asset_pattern` 能否匹配最新 release 的 assets，不生成文件。打印每个包的匹配状态：✅ / ⚠️ 部分 / ❌ 全失败。

#### Step 5: CI 集成
在 validate workflow 中加一个 step：
```yaml
- name: Check asset patterns
  run: python scripts/generate.py --check-assets
```
如果任何包 asset_pattern 完全失效就 fail（提前发现，不等 generate 阶段才发现）。

#### Step 6: 文档规范
在 `CONTRIBUTING.md` 加：
- `asset_pattern` 不要嵌入版本号，用 `*` 通配
- 多版本 repo 不能用 github-release 模式
- 新包添加前用 `--check-assets` 验证

---

## 涉及文件

### 包文件（必改）
- `packages/CLIProxyAPI.json`
- `packages/icloudpd.json`
- `packages/tencent-kona-jdk21.json`
- `packages/zola.json`
- `packages/KrillinAI.json`
- `packages/go-musicfox.json`
- `packages/graalvm-ce-jdk17.json`
- `packages/sapmachine.json`
- `packages/sapmachine-jdk17.json`

### 代码文件（Phase 3）
- `scripts/generate.py` — 加 `--check-assets` 模式
- `.github/workflows/validate.yml` — 加 asset check step
- `CONTRIBUTING.md` — 加规范

---

## 验证

```bash
# 逐包干跑
for pkg in CLIProxyAPI go-musicfox graalvm-ce-jdk17 KrillinAI icloudpd \
           sapmachine sapmachine-jdk17 tencent-kona-jdk21 zola; do
  python3 scripts/generate.py --dry-run --skip-hash --only $pkg 2>&1 | grep -E 'Formula/|bucket/|error|Done'
done

# 全量跑确保不引入新 regression
python3 scripts/generate.py --dry-run --skip-hash 2>&1 | grep -c '\[error\]'  # 应为 0
```

---

## 风险与权衡

1. **通配符 `*` 过于宽泛**：可能匹配到错误的 asset（如 checksum 文件、debug build）。`match_asset` 会先取第一个匹配的，需确保 checksum/symbol 文件不被误匹配（现有 `is_checksum_asset` 过滤能部分防护）
2. **C 类改为 download_url**：失去自动更新能力，上游发新版需手动更新。但收益大于风险——至少能产出正确的 Formula/Bucket
3. **icloudpd 名称变了**：从 `icloudpd` 变成了 `icloud`，package 名称要不要改？建议不改，保持兼容
