# 软链接版本化更新 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 改造 install.sh 和 install.ps1，使每次安装保留旧版本，通过软链接切换激活版本。

**Architecture:** 在现有 install.sh 中新增 `setup_versioned_install()` 函数集中处理版本化逻辑。main() 的安装放置从 `mv` 改为调用该函数。版本检测改为读 `.version` 文件（fallback `--version`）。旧版安装自动迁移。update.sh 保持 re-run install.sh 模式。install.ps1 做对称改动。

**Tech Stack:** POSIX shell (install.sh), PowerShell 2.0+ (install.ps1)

**Spec:** `docs/superpowers/specs/2026-06-01-symlink-versioned-update-design.md`

---

### Task 1: 添加 setup_versioned_install() 函数到 install.sh

**Files:**
- Modify: `scripts/install.sh` — 在 `main()` 函数之前（第 198 行之前）插入新函数

- [ ] **Step 1: 在 install.sh 的 main() 函数之前插入 setup_versioned_install()**

在 `# --- Main ---` 注释（第 198 行）和 `main()` 函数定义（第 199 行）之间插入：

```bash
# --- Versioned install: place binary in version dir, create symlinks ---
setup_versioned_install() {
  _install_dir="$1" _binary="$2" _pkg_name="$3" _version="$4" _extracted="$5"
  _pkg_dir="${_install_dir}/${_pkg_name}"
  _version_dir="${_pkg_dir}/${_version}"

  # Create version directory and move binary
  mkdir -p "$_version_dir"
  mv "$_extracted" "${_version_dir}/${_binary}"
  chmod +x "${_version_dir}/${_binary}"

  # Write version file
  printf '%s' "$_version" > "${_version_dir}/.version"

  # Update current symlink
  ln -snf "$_version" "${_pkg_dir}/current"

  # Update user-visible binary symlink (absolute path)
  ln -snf "${_pkg_dir}/current/${_binary}" "${_install_dir}/${_binary}"
}

```

- [ ] **Step 2: 验证语法正确**

Run: `sh -n scripts/install.sh`
Expected: 无输出（语法正确）

- [ ] **Step 3: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: add setup_versioned_install() function"
```

---

### Task 2: 重写版本检测逻辑（含旧版迁移）

**Files:**
- Modify: `scripts/install.sh:276-283` — 替换版本检测块

- [ ] **Step 1: 替换 install.sh 第 276-283 行**

将现有的：

```bash
  # Check current version (with timeout to prevent hangs) [#155]
  if [ -f "${INSTALL_DIR}/${BINARY}" ]; then
    CURRENT=$(timeout 5 "${INSTALL_DIR}/${BINARY}" --version 2>/dev/null | head -1 | sed 's/[^0-9.]//g' || echo "unknown")
    if [ "$CURRENT" = "$VERSION" ]; then
      ok "Already up to date (v${VERSION}). Nothing to do."
      exit 0
    fi
    info "Updating ${CURRENT} -> v${VERSION}..."
  fi
```

替换为：

```bash
  # --- Version detection + legacy migration ---
  PKG_DIR="${INSTALL_DIR}/${PKG_NAME}"
  if [ -L "${INSTALL_DIR}/${BINARY}" ] && [ -d "${PKG_DIR}" ]; then
    # New structure: symlink + pkg dir exist
    _ver_file="${PKG_DIR}/current/.version"
    if [ -f "$_ver_file" ]; then
      CURRENT=$(cat "$_ver_file")
    else
      CURRENT=$(timeout 5 "${INSTALL_DIR}/${BINARY}" --version 2>/dev/null | head -1 | sed 's/[^0-9.]//g' || echo "unknown")
    fi
    if [ "$CURRENT" = "$VERSION" ]; then
      ok "Already up to date (v${VERSION}). Nothing to do."
      exit 0
    fi
    info "Updating ${CURRENT} -> v${VERSION}..."
  elif [ -f "${INSTALL_DIR}/${BINARY}" ] && [ ! -L "${INSTALL_DIR}/${BINARY}" ]; then
    # Legacy structure: binary is a real file — auto-migrate
    OLD_VER=$(timeout 5 "${INSTALL_DIR}/${BINARY}" --version 2>/dev/null | head -1 | sed 's/[^0-9.]//g' || echo "legacy")
    info "Detected legacy install (v${OLD_VER}) — migrating to versioned structure..."
    mkdir -p "${PKG_DIR}/${OLD_VER}"
    cp "${INSTALL_DIR}/${BINARY}" "${PKG_DIR}/${OLD_VER}/${BINARY}"
    chmod +x "${PKG_DIR}/${OLD_VER}/${BINARY}"
    printf '%s' "$OLD_VER" > "${PKG_DIR}/${OLD_VER}/.version"
    ln -snf "$OLD_VER" "${PKG_DIR}/current"
    mv "${INSTALL_DIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}.bak"
    ln -snf "${PKG_DIR}/current/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    ok "Migrated legacy v${OLD_VER}. Old binary backed up as ${BINARY}.bak"
  fi
```

- [ ] **Step 2: 验证语法正确**

Run: `sh -n scripts/install.sh`
Expected: 无输出

- [ ] **Step 3: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: version detection with .version file + legacy migration"
```

---

### Task 3: 替换 gen_update_script() 为版本化版本

**Files:**
- Modify: `scripts/install.sh:356-374` — 替换整个函数

- [ ] **Step 1: 替换 gen_update_script() 函数**

将现有的第 356-374 行（从 `# --- Generate update.sh ---` 到函数结束的 `}`）替换为：

```bash
# --- Generate versioned update.sh ---
gen_update_script() {
  _pkg_dir="$1" _bin="$2" _pkg="$3"
  _install_dir=$(cd "$(dirname "$_pkg_dir")" && pwd)
  _tribucket_raw="${TRIBUCKET_RAW}"

  cat > "${_pkg_dir}/update.sh" << 'UPDEOF'
#!/bin/sh
# tribucket updater (auto-generated)
set -eu
INSTALL_DIR="__INSTALL_DIR__"
PKG="__PKG__"
printf '\033[0;34m[info]\033[0m  Updating %s...\n' "${PKG}"
curl -fsSL "__TRIBUCKET_RAW__/scripts/install.sh" | INSTALL_DIR="${INSTALL_DIR}" bash -s "${PKG}"
UPDEOF
  sed "s|__PKG__|${_pkg}|g; s|__INSTALL_DIR__|${_install_dir}|g; s|__TRIBUCKET_RAW__|${_tribucket_raw}|g" \
    "${_pkg_dir}/update.sh" > "${_pkg_dir}/update.sh.tmp"
  mv "${_pkg_dir}/update.sh.tmp" "${_pkg_dir}/update.sh"
  chmod +x "${_pkg_dir}/update.sh"
}
```

- [ ] **Step 2: 验证语法正确**

Run: `sh -n scripts/install.sh`
Expected: 无输出

- [ ] **Step 3: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: replace gen_update_script with versioned re-run approach"
```

---

### Task 4: 替换 gen_uninstall_script() 为版本化版本

**Files:**
- Modify: `scripts/install.sh:377-393` — 替换整个函数

- [ ] **Step 1: 替换 gen_uninstall_script() 函数**

将现有的第 377-393 行（从 `# --- Generate uninstall.sh ---` 到函数结束的 `}`）替换为：

```bash
# --- Generate versioned uninstall.sh ---
gen_uninstall_script() {
  _pkg_dir="$1" _bin="$2" _pkg="$3"
  _install_dir=$(cd "$(dirname "$_pkg_dir")" && pwd)

  cat > "${_pkg_dir}/uninstall.sh" << 'UNEOF'
#!/bin/sh
# tribucket uninstaller (auto-generated)
set -eu
INSTALL_DIR="__INSTALL_DIR__"
BIN="__BIN__"
PKG="__PKG__"
PKG_DIR="${INSTALL_DIR}/${PKG}"
printf 'Removing %s (%s)...\n' "$BIN" "$PKG"
rm -f "${INSTALL_DIR}/${BIN}"
rm -rf "${PKG_DIR}"
echo "Done."
UNEOF
  sed "s|__INSTALL_DIR__|${_install_dir}|g; s|__BIN__|${_bin}|g; s|__PKG__|${_pkg}|g" \
    "${_pkg_dir}/uninstall.sh" > "${_pkg_dir}/uninstall.sh.tmp"
  mv "${_pkg_dir}/uninstall.sh.tmp" "${_pkg_dir}/uninstall.sh"
  chmod +x "${_pkg_dir}/uninstall.sh"
}
```

注意：函数签名从 2 参数变为 3 参数（新增 `$_pkg`）。

- [ ] **Step 2: 验证语法正确**

Run: `sh -n scripts/install.sh`
Expected: 无输出

- [ ] **Step 3: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: replace gen_uninstall_script with versioned version"
```

---

### Task 5: 更新 main() 调用点

**Files:**
- Modify: `scripts/install.sh:334-340` — 替换安装放置 + helper script 生成

- [ ] **Step 1: 替换安装放置逻辑（第 334-336 行）**

将：

```bash
  chmod +x "$EXTRACTED"
  mv "$EXTRACTED" "${INSTALL_DIR}/${BINARY}"
  ok "Installed ${BOLD}${BINARY} v${VERSION}${Z} -> ${INSTALL_DIR}/${BINARY}"
```

替换为：

```bash
  setup_versioned_install "$INSTALL_DIR" "$BINARY" "$PKG_NAME" "$VERSION" "$EXTRACTED"
  ok "Installed ${BOLD}${BINARY} v${VERSION}${Z}"
```

- [ ] **Step 2: 替换 helper script 生成调用（第 338-340 行）**

将：

```bash
  # Generate helper scripts in install dir
  gen_update_script "$INSTALL_DIR" "$BINARY" "$PKG_NAME"
  gen_uninstall_script "$INSTALL_DIR" "$BINARY"
```

替换为：

```bash
  # Generate helper scripts in package dir
  gen_update_script "${INSTALL_DIR}/${PKG_NAME}" "$BINARY" "$PKG_NAME"
  gen_uninstall_script "${INSTALL_DIR}/${PKG_NAME}" "$BINARY" "$PKG_NAME"
```

- [ ] **Step 3: 验证语法正确**

Run: `sh -n scripts/install.sh`
Expected: 无输出

- [ ] **Step 4: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: wire up versioned install in main()"
```

---

### Task 6: install.sh 集成测试

**Files:**
- 无文件修改，手动验证

- [ ] **Step 1: 测试全新安装**

```bash
cd /tmp && mkdir -p test-install && cd test-install
curl -fsSL file:///root/tribucket/scripts/install.sh | INSTALL_DIR=/tmp/test-install bash -s fzf
```

验证：
- `ls -la /tmp/test-install/fzf` — 应为软链接
- `ls -la /tmp/test-install/fzf/` — 应有版本目录、current 软链接
- `cat /tmp/test-install/fzf/current/.version` — 应有版本号
- `/tmp/test-install/fzf --version` — 应正常运行
- `cat /tmp/test-install/fzf/update.sh` — 应包含 re-run 逻辑
- `cat /tmp/test-install/fzf/uninstall.sh` — 应包含清理逻辑

- [ ] **Step 2: 测试更新（同版本跳过）**

```bash
curl -fsSL file:///root/tribucket/scripts/install.sh | INSTALL_DIR=/tmp/test-install bash -s fzf
```

Expected: "Already up to date" 消息，无重复下载

- [ ] **Step 3: 测试 uninstall.sh**

```bash
sh /tmp/test-install/fzf/uninstall.sh
```

验证：
- `/tmp/test-install/fzf` 不再存在
- `/tmp/test-install/fzf/` 目录不再存在

- [ ] **Step 4: 测试旧版迁移**

```bash
# 模拟旧版安装：放一个实际文件
mkdir -p /tmp/test-legacy
echo '#!/bin/sh' > /tmp/test-legacy/fzf
chmod +x /tmp/test-legacy/fzf
# 运行新版 install.sh
curl -fsSL file:///root/tribucket/scripts/install.sh | INSTALL_DIR=/tmp/test-legacy bash -s fzf
```

验证：
- `/tmp/test-legacy/fzf.bak` 存在（旧版备份）
- `/tmp/test-legacy/fzf` 是软链接
- `/tmp/test-legacy/fzf/` 有版本目录结构

- [ ] **Step 5: 清理测试目录**

```bash
rm -rf /tmp/test-install /tmp/test-legacy
```

- [ ] **Step 6: Commit（如果有修复）**

```bash
git add scripts/install.sh
git commit -m "fix: address issues found during integration testing"
```

---

### Task 7: 更新 install.ps1 — 版本检测 + 迁移

**Files:**
- Modify: `scripts/install.ps1:164-179` — 版本检测 + 迁移逻辑

- [ ] **Step 1: 替换 install.ps1 第 164-179 行**

将：

```powershell
# Install directory
if (-not $InstallDir) { $InstallDir = Get-Location }
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null }

# Check current version
$destPath = Join-Path $InstallDir "$binary.exe"
if (Test-Path $destPath) {
    try {
        $currentVer = ((& $destPath --version 2>&1) -replace '[^0-9.]','').Trim()
        if ($currentVer -eq $version) {
            Write-Ok "Already up to date (v$version)."
            exit 0
        }
        Write-Info "Updating $currentVer -> v$version..."
    } catch {}
}
```

替换为：

```powershell
# Install directory
if (-not $InstallDir) { $InstallDir = Get-Location }
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null }

# --- Version detection + legacy migration ---
$pkgDir = Join-Path $InstallDir $Package
$destPath = Join-Path $InstallDir "$binary.exe"

function Create-SymlinkOrFallback {
    param([string]$target, [string]$linkPath)
    try {
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $target -Force | Out-Null
    } catch {
        try {
            if (Test-Path $target -PathType Container) {
                New-Item -ItemType Junction -Path $linkPath -Target $target -Force | Out-Null
            } else {
                Copy-Item -Path $target -Destination $linkPath -Force
            }
        } catch {
            Copy-Item -Path $target -Destination $linkPath -Force
        }
    }
}

if ((Test-Path $destPath) -and (Test-Path $pkgDir)) {
    # New structure: check .version file
    $verFile = Join-Path $pkgDir "current\.version"
    if (Test-Path $verFile) {
        $currentVer = (Get-Content $verFile -Raw).Trim()
    } else {
        try { $currentVer = ((& $destPath --version 2>&1) -replace '[^0-9.]','').Trim() } catch { $currentVer = "unknown" }
    }
    if ($currentVer -eq $version) {
        Write-Ok "Already up to date (v$version)."
        exit 0
    }
    Write-Info "Updating $currentVer -> v$version..."
} elseif ((Test-Path $destPath) -and -not (Get-Item $destPath).Attributes.ToString().Contains("ReparsePoint")) {
    # Legacy structure: real file — auto-migrate
    try { $oldVer = ((& $destPath --version 2>&1) -replace '[^0-9.]','').Trim() } catch { $oldVer = "legacy" }
    Write-Info "Detected legacy install (v$oldVer) — migrating to versioned structure..."
    $oldVerDir = Join-Path $pkgDir $oldVer
    New-Item -ItemType Directory -Path $oldVerDir -Force | Out-Null
    Copy-Item -Path $destPath -Destination (Join-Path $oldVerDir "$binary.exe") -Force
    Set-Content -Path (Join-Path $oldVerDir ".version") -Value $oldVer
    $currentLink = Join-Path $pkgDir "current"
    Create-SymlinkOrFallback -target $oldVerDir -linkPath $currentLink
    Rename-Item -Path $destPath -NewName "$binary.exe.bak"
    Create-SymlinkOrFallback -target (Join-Path $currentLink "$binary.exe") -linkPath $destPath
    Write-Ok "Migrated legacy v$oldVer. Old binary backed up as $binary.exe.bak"
}
```

- [ ] **Step 2: 验证 PowerShell 语法**

Run: `pwsh -Command "& { \$null = [System.Management.Automation.Language.Parser]::ParseFile('scripts/install.ps1', [ref]\$null, [ref]\$null) }" 2>&1 || powershell -Command "& { \$null = [System.Management.Automation.Language.Parser]::ParseFile('scripts/install.ps1', [ref]\$null, [ref]\$null) }"`
Expected: 无错误输出

- [ ] **Step 3: Commit**

```bash
git add scripts/install.ps1
git commit -m "feat(ps1): version detection with .version file + legacy migration"
```

---

### Task 8: 更新 install.ps1 — 安装放置 + helper scripts

**Files:**
- Modify: `scripts/install.ps1:205-244` — 安装放置 + update/uninstall 生成

- [ ] **Step 1: 替换安装放置逻辑（第 205-207 行）**

将：

```powershell
Copy-Item -Path $downloadPath -Destination $destPath -Force
Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "Installed $binary v$version -> $destPath"
```

替换为：

```powershell
# --- Versioned install ---
$versionDir = Join-Path $pkgDir $version
New-Item -ItemType Directory -Path $versionDir -Force | Out-Null
Copy-Item -Path $downloadPath -Destination (Join-Path $versionDir "$binary.exe") -Force
Set-Content -Path (Join-Path $versionDir ".version") -Value $version

# Update current symlink
$currentLink = Join-Path $pkgDir "current"
Create-SymlinkOrFallback -target $versionDir -linkPath $currentLink

# Update user-visible binary symlink
Create-SymlinkOrFallback -target (Join-Path $currentLink "$binary.exe") -linkPath $destPath

Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "Installed $binary v$version"
```

- [ ] **Step 2: 替换 update.ps1 生成（第 209-233 行）**

将现有的 `$updateContent = @"..."@` 块和 `Set-Content` 替换为：

```powershell
# Generate versioned update.ps1
$updateContent = @"
# tribucket updater for $Package (auto-generated)
# Usage: .\update.ps1
`$ErrorActionPreference = "Stop"
Write-Host "[info]  Updating $Package..." -ForegroundColor Cyan
`$scriptDir = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$installDir = Split-Path -Parent `$scriptDir
`$url = "$TRIBUCKET_RAW/scripts/install.ps1"
`$tmpFile = Join-Path `$env:TEMP "tribucket-install.ps1"
(New-Object System.Net.WebClient).DownloadString(`$url) | Set-Content -Path `$tmpFile -Encoding UTF8
& `$tmpFile -Package "$Package" -InstallDir `$installDir
Remove-Item `$tmpFile -ErrorAction SilentlyContinue
"@
$updatePath = Join-Path $pkgDir "update.ps1"
Set-Content -Path $updatePath -Value $updateContent -Encoding UTF8
```

- [ ] **Step 3: 替换 uninstall.ps1 生成（第 235-244 行）**

将现有的 `$uninstallContent = @"..."@` 块和 `Set-Content` 替换为：

```powershell
# Generate versioned uninstall.ps1
$uninstallContent = @"
# tribucket uninstaller for $Package (auto-generated)
`$ErrorActionPreference = "Stop"
`$scriptDir = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$installDir = Split-Path -Parent `$scriptDir
Write-Host "Removing $binary ($Package)..."
Remove-Item (Join-Path `$installDir "$binary.exe") -Force -ErrorAction SilentlyContinue
Remove-Item `$scriptDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Done."
"@
$uninstallPath = Join-Path $pkgDir "uninstall.ps1"
Set-Content -Path $uninstallPath -Value $uninstallContent -Encoding UTF8
```

- [ ] **Step 4: 验证 PowerShell 语法**

Run: `pwsh -Command "& { \$null = [System.Management.Automation.Language.Parser]::ParseFile('scripts/install.ps1', [ref]\$null, [ref]\$null) }" 2>&1 || powershell -Command "& { \$null = [System.Management.Automation.Language.Parser]::ParseFile('scripts/install.ps1', [ref]\$null, [ref]\$null) }"`
Expected: 无错误输出

- [ ] **Step 5: Commit**

```bash
git add scripts/install.ps1
git commit -m "feat(ps1): versioned install placement + helper scripts"
```

---

### Task 9: 最终验证

**Files:**
- 无文件修改

- [ ] **Step 1: 语法检查两个脚本**

```bash
sh -n scripts/install.sh
```

```bash
pwsh -Command "& { \$null = [System.Management.Automation.Language.Parser]::ParseFile('scripts/install.ps1', [ref]\$null, [ref]\$null) }" 2>&1 || echo "pwsh not available, skip ps1 syntax check"
```

- [ ] **Step 2: 运行现有测试套件**

Run: `python -m pytest tests/ -v`
Expected: 所有测试通过（本次改动不影响 generate.py/checkver.py）

- [ ] **Step 3: 完整端到端测试（install.sh）**

```bash
# Clean install
mkdir -p /tmp/tb-e2e
cd /tmp/tb-e2e
curl -fsSL file:///root/tribucket/scripts/install.sh | INSTALL_DIR=/tmp/tb-e2e bash -s fzf

# Verify structure
test -L /tmp/tb-e2e/fzf && echo "PASS: binary is symlink"
test -d /tmp/tb-e2e/fzf/ && echo "PASS: pkg dir exists"
test -L /tmp/tb-e2e/fzf/current && echo "PASS: current is symlink"
test -f /tmp/tb-e2e/fzf/current/.version && echo "PASS: .version exists"
/tmp/tb-e2e/fzf --version && echo "PASS: binary works"
test -x /tmp/tb-e2e/fzf/update.sh && echo "PASS: update.sh exists"
test -x /tmp/tb-e2e/fzf/uninstall.sh && echo "PASS: uninstall.sh exists"

# Cleanup
rm -rf /tmp/tb-e2e
```

- [ ] **Step 4: Final commit (if any fixes needed)**

```bash
git add -A
git commit -m "fix: final adjustments from end-to-end testing"
```
