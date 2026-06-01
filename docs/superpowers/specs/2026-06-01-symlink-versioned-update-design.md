# 软链接版本化更新 — 设计文档

> **日期**：2026-06-01
> **状态**：已批准
> **范围**：install.sh + install.ps1

## 目标

改造 tribucket 的安装脚本，使每次安装和更新保留旧版本，通过软链接切换激活版本。用户可以回滚到任意历史版本。

## 决策记录

| 决策点 | 选择 | 理由 |
|--------|------|------|
| update 机制 | re-run install.sh | DRY，不重复维护下载/解压逻辑 |
| 版本记录 | .version 文件 + fallback --version | 可靠且兼容旧版迁移 |
| 旧版清理 | 暂不实现 | YAGNI，核心功能优先 |
| install.ps1 | 同步改 | 保持跨平台一致性 |
| 软链接 | 绝对路径 | 跨目录调用不会断 |
| 实现方案 | 就地改造 install.sh | 改动集中，不新增文件 |

## 目录结构

### Linux/macOS（install.sh）

```
<INSTALL_DIR>/
├── <binary>              ← 绝对路径软链接 -> <INSTALL_DIR>/<pkg>/current/<binary>
├── <pkg>/                ← 包数据目录
│   ├── <version>/        ← 版本目录（如 14.1.0/）
│   │   ├── <binary>      ← 实际 binary
│   │   └── .version      ← 版本号文本文件（如 "14.1.0"）
│   ├── current -> <version>/  ← 软链接指向当前版本
│   ├── update.sh         ← 直接运行，已绑定源和路径
│   └── uninstall.sh      ← 直接运行
```

示例：在 `~/tools/` 下执行 `install.sh rg`

```
~/tools/
├── rg -> ~/tools/rg/current/rg     ← 用户直接运行
├── rg/
│   ├── 14.1.0/
│   │   ├── rg
│   │   └── .version                ← 内容: "14.1.0"
│   ├── current -> 14.1.0/
│   ├── update.sh
│   └── uninstall.sh
```

### Windows（install.ps1）

```
<InstallDir>/
├── <binary>.exe          ← 软链接（fallback: copy）
├── <pkg>/
│   ├── <version>/
│   │   ├── <binary>.exe
│   │   └── .version
│   ├── current           ← junction（fallback: copy）
│   ├── update.ps1
│   └── uninstall.ps1
```

Windows 符号链接 fallback 策略：
1. 尝试 `New-Item -ItemType SymbolicLink`
2. 失败则用 `New-Item -ItemType Junction`（current 目录）
3. 文件级别 fallback 用 `Copy-Item`

## install.sh 改动

### 新增函数：setup_versioned_install()

集中处理版本化安装逻辑，main() 在下载+解压完成后调用。

```bash
setup_versioned_install() {
  # $1=INSTALL_DIR  $2=BINARY  $3=PKG_NAME  $4=VERSION  $5=EXTRACTED
  PKG_DIR="${1}/${3}"
  VERSION_DIR="${PKG_DIR}/${4}"

  # 创建版本目录，移动 binary
  mkdir -p "$VERSION_DIR"
  mv "$5" "${VERSION_DIR}/${2}"
  chmod +x "${VERSION_DIR}/${2}"

  # 写入版本号文件
  printf '%s' "$4" > "${VERSION_DIR}/.version"

  # 更新 current 软链接
  ln -snf "$4" "${PKG_DIR}/current"

  # 更新用户可见的 binary 软链接（绝对路径）
  ln -snf "${PKG_DIR}/current/${2}" "${1}/${2}"
}
```

### 版本检测改动（main() 中）

替换现有第 276-283 行。三级检测：

1. **新版结构**（软链接 + PKG_DIR 存在）：读 `.version` 文件，fallback 到 `--version` 解析
2. **旧版结构**（实际文件，非软链接）：自动迁移到版本化结构，备份原文件为 `.bak`
3. **未安装**：正常安装

### 迁移逻辑

检测到旧版安装时：
1. 探测当前版本（`--version` 解析）
2. 创建 `PKG_DIR/<old_version>/` 目录
3. 复制旧 binary 到版本目录
4. 写入 `.version` 文件
5. 设置 `current` 软链接
6. 备份旧 binary 为 `<binary>.bak`
7. 创建新的 binary 软链接

### helper scripts 生成

**gen_update_script()** — 替换现有实现：
- 生成到 `PKG_DIR/update.sh`（而非 INSTALL_DIR 下）
- update.sh 内容：re-run install.sh，已写入 INSTALL_DIR、PKG_NAME、TRIBUCKET_RAW
- 约 4 行核心逻辑

**gen_uninstall_script()** — 替换现有实现：
- 生成到 `PKG_DIR/uninstall.sh`
- 新增第三个参数 `$PKG_NAME`
- 清理逻辑：删除 binary 软链接 + 整个 PKG_DIR（含所有版本）

### main() 调用点改动

```bash
# 原来（第 334-336 行）：
mv "$EXTRACTED" "${INSTALL_DIR}/${BINARY}"
ok "Installed ${BOLD}${BINARY} v${VERSION}${Z} -> ${INSTALL_DIR}/${BINARY}"

# 改为：
setup_versioned_install "$INSTALL_DIR" "$BINARY" "$PKG_NAME" "$VERSION" "$EXTRACTED"
ok "Installed ${BOLD}${BINARY} v${VERSION}${Z}"

# 原来（第 338-340 行）：
gen_update_script "$INSTALL_DIR" "$BINARY" "$PKG_NAME"
gen_uninstall_script "$INSTALL_DIR" "$BINARY"

# 改为：
gen_update_script "${INSTALL_DIR}/${PKG_NAME}" "$BINARY" "$PKG_NAME"
gen_uninstall_script "${INSTALL_DIR}/${PKG_NAME}" "$BINARY" "$PKG_NAME"
```

## install.ps1 改动

与 install.sh 对称的改动：

1. **版本检测**：替换第 170-179 行，新增旧版迁移逻辑
2. **安装放置**：替换第 205 行 `Copy-Item` 为版本化放置
3. **helper scripts**：替换 update.ps1/uninstall.ps1 生成为版本化版本
4. **符号链接**：尝试 SymbolicLink → Junction → Copy fallback

## 不做的事情

- 不提供旧版本清理机制（后续按需添加）
- 不新增 CLI 命令（tribucket list/switch/clean）
- 不改 packages/*.json 格式
- 不改 generate.py / checkver.py
- 不处理并发安装竞态（低优先级）
