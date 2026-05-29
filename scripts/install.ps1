# tribucket installer for Windows (PowerShell 2.0+)
# Usage: .\install.ps1 -Package <name> [-InstallDir <path>]
param(
    [string]$Package = "",
    [string]$InstallDir = ""
)

$ErrorActionPreference = "Stop"
$TRIBUCKET_REPO = if ($env:TRIBUCKET_REPO) { $env:TRIBUCKET_REPO } else { "sixiang-world/tribucket" }
$TRIBUCKET_RAW = "https://raw.githubusercontent.com/$TRIBUCKET_REPO/main"

function Write-Info  { param($msg) Write-Host "[info]  $msg" -ForegroundColor Cyan }
function Write-Ok    { param($msg) Write-Host "[ok]    $msg" -ForegroundColor Green }
function Write-Warn  { param($msg) Write-Host "[warn]  $msg" -ForegroundColor Yellow }
function Write-Err   { param($msg) Write-Host "[error] $msg" -ForegroundColor Red; exit 1 }

function Validate-Url {
    param([string]$url)
    if ($url -notmatch '^https://github\.com/') {
        Write-Err "Unexpected download URL domain: $url"
    }
}

function Verify-Checksum {
    param([string]$filePath, [string]$downloadUrl)
    $basename = Split-Path $filePath -Leaf
    $candidates = @("${basename}.sha256", "SHA256SUMS", "sha256sums.txt", "checksums.txt")
    $dir = Split-Path $filePath
    foreach ($name in $candidates) {
        $cksumUrl = $downloadUrl -replace '/[^/]*$', "/$name"
        try {
            $wc = New-Object System.Net.WebClient
            $cksumContent = $wc.DownloadString($cksumUrl)
        } catch { continue }
        if ([string]::IsNullOrEmpty($cksumContent)) { continue }
        $expected = ($cksumContent -split "`n" | Where-Object { $_ -match $basename } | Select-Object -First 1) -replace '\s+.*', ''
        if ([string]::IsNullOrEmpty($expected)) { continue }
        $actual = (Get-FileHash -Path $filePath -Algorithm SHA256).Hash.ToLower()
        if ($actual -eq $expected.ToLower()) {
            Write-Ok "Checksum verified."
            return
        } else {
            Write-Err "Checksum mismatch! Expected: $expected, Got: $actual"
        }
    }
    Write-Info "No checksum file found — skipping verification."
}

# --- Main ---
if (-not $Package) {
    $pkgDir = Join-Path $PSScriptRoot "..\packages"
    $available = if (Test-Path $pkgDir) {
        (Get-ChildItem $pkgDir -Filter *.json | ForEach-Object { $_.BaseName }) -join ", "
    } else { "(cannot list — run from cloned repo)" }
    Write-Err "Usage: install.ps1 -Package <name>`n  Available: $available"
}

Write-Info "Package: $Package"

# Load package definition
$localPath = Join-Path $PSScriptRoot "..\packages\$Package.json"
if (Test-Path $localPath) {
    $pkgJson = Get-Content $localPath -Raw
} else {
    try {
        $wc = New-Object System.Net.WebClient
        $pkgJson = $wc.DownloadString("$TRIBUCKET_RAW/packages/$Package.json")
    } catch {
        Write-Err "Package '$Package' not found."
    }
}

# Parse JSON properly
try {
    $pkg = $pkgJson | ConvertFrom-Json
} catch {
    Write-Err "Invalid JSON in package definition for '$Package'."
}

$repo = $pkg.repo
$binary = $pkg.binary
$description = $pkg.description
if (-not $repo) { Write-Err "Invalid package definition: missing 'repo'." }
if (-not $binary) { Write-Err "Invalid package definition: missing 'binary'." }

Write-Info $description

# Detect arch
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "amd64" }
$platform = "windows_$arch"
Write-Info "Platform: $platform"

# Get asset pattern from nested asset_pattern object
$assetPattern = $pkg.asset_pattern.$platform
if (-not $assetPattern) { Write-Err "No asset pattern for $platform" }

# Get latest release
Write-Info "Fetching latest release..."
$headers = @{ "Accept" = "application/vnd.github.v3+json" }
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -Headers $headers
$version = $release.tag_name -replace '^v', ''
Write-Info "Latest: v$version"

# Find asset
$asset = $release.assets | Where-Object { $_.name -match $assetPattern } | Select-Object -First 1
if (-not $asset) { Write-Err "No asset matching '$assetPattern' in release v$version" }
$url = $asset.browser_download_url

# Validate download URL
Validate-Url $url

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

# Download
$tmpDir = Join-Path $env:TEMP "tribucket-$(Get-Random)"
New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
$filename = Split-Path $url -Leaf
$downloadPath = Join-Path $tmpDir $filename

Write-Info "Downloading $filename..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $downloadPath)

# Verify checksum
Verify-Checksum $downloadPath $url

# Handle zip
if ($filename -match '\.zip$') {
    $extractDir = Join-Path $tmpDir "extracted"
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
    $shell = New-Object -ComObject Shell.Application
    $zip = $shell.NameSpace($downloadPath)
    $shell.NameSpace($extractDir).CopyHere($zip.Items(), 16)
    $downloadPath = Get-ChildItem -Path $extractDir -Recurse -Filter "$binary*" | Where-Object { !$_.PSIsContainer } | Select-Object -First 1 -ExpandProperty FullName
    if (!$downloadPath) { Write-Err "Binary not found in archive" }
}

Copy-Item -Path $downloadPath -Destination $destPath -Force
Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "Installed $binary v$version -> $destPath"

# Generate update.ps1
$updateContent = @"
# tribucket updater for $Package (auto-generated)
`$ErrorActionPreference = "Stop"
`$wc = New-Object System.Net.WebClient
`$pkgJson = `$wc.DownloadString("https://raw.githubusercontent.com/sixiang-world/tribucket/main/packages/$Package.json")
`$pkg = `$pkgJson | ConvertFrom-Json
`$repo = `$pkg.repo
`$release = Invoke-RestMethod -Uri "https://api.github.com/repos/`$repo/releases/latest"
`$version = `$release.tag_name -replace '^v', ''
`$arch = if (`$env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'amd64' }
`$platform = "windows_`$arch"
`$pattern = `$pkg.asset_pattern.`$platform
`$asset = `$release.assets | Where-Object { `$_.name -match `$pattern } | Select-Object -First 1
`$destPath = Join-Path (Get-Location) "$binary.exe"
`$currentVer = if (Test-Path `$destPath) { try { ((& `$destPath --version 2>&1) -replace '[^0-9.]','').Trim() } catch { 'none' } } else { 'none' }
if (`$currentVer -eq `$version) { Write-Host "Already up to date (v`$version)."; exit 0 }
Write-Host "Updating `$currentVer -> v`$version..."
`$tmp = Join-Path `$env:TEMP "tribucket-`$(Get-Random)"; New-Item -ItemType Directory -Path `$tmp -Force | Out-Null
`$wc.DownloadFile(`$asset.browser_download_url, (Join-Path `$tmp `$asset.name))
Copy-Item (Join-Path `$tmp `$asset.name) `$destPath -Force
Remove-Item `$tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Updated to v`$version."
"@
Set-Content -Path (Join-Path $InstallDir "update.ps1") -Value $updateContent -Encoding UTF8

# Generate uninstall.ps1
$uninstallContent = @"
# tribucket uninstaller (auto-generated)
`$dir = Get-Location
Remove-Item (Join-Path `$dir "$binary.exe") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path `$dir "update.ps1") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path `$dir "uninstall.ps1") -Force -ErrorAction SilentlyContinue
Write-Host "Done."
"@
Set-Content -Path (Join-Path $InstallDir "uninstall.ps1") -Value $uninstallContent -Encoding UTF8

Write-Ok "Done! Run '$binary' to get started."
