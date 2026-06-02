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

# --- Check for custom download URL (non-GitHub sources) ---
$useCustomUrl = $false
$downloadUrlMap = $pkg.PSObject.Properties['download_url']
if ($downloadUrlMap) {
    $urlTemplate = $downloadUrlMap.Value.PSObject.Properties[$platform]
    if ($urlTemplate) {
        $resolvedUrl = $urlTemplate.Value
        # If URL contains {version}, resolve via checkver
        if ($resolvedUrl -match '\{version\}') {
            $checkver = $pkg.PSObject.Properties['checkver']
            if ($checkver) {
                $verUrl = $checkver.Value.url
                $verRegex = $checkver.Value.regex
                if ($verUrl) {
                    try {
                        $wc2 = New-Object System.Net.WebClient
                        $verContent = $wc2.DownloadString($verUrl)
                        if ($verRegex) {
                            $match = [regex]::Match($verContent, $verRegex)
                            if ($match.Success) {
                                $ver = $match.Groups[1].Value
                                $resolvedUrl = $resolvedUrl -replace '\{version\}', $ver
                            } else {
                                throw "Version regex did not match"
                            }
                        } else {
                            $resolvedUrl = $resolvedUrl -replace '\{version\}', $verContent.Trim()
                        }
                    } catch {
                        Write-Warn "Failed to resolve version from checkver: $_"
                        $resolvedUrl = ""
                    }
                }
            }
        }
        if ($resolvedUrl) {
            $url = $resolvedUrl
            $filename = Split-Path $url -Leaf
            # Try to extract a version number from the URL
            $verMatch = [regex]::Match($url, '[0-9]+\.[0-9]+[0-9.]*')
            $version = if ($verMatch.Success) { $verMatch.Value } else { "latest" }
            Write-Info "Latest: $version (custom source)"
            Write-Info "Using custom download source"
            $useCustomUrl = $true
        }
    }
}

if (-not $useCustomUrl) {
    # Existing GitHub API flow
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
}

# Install directory
if (-not $InstallDir) { $InstallDir = Get-Location }
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null }

# --- Version detection + legacy migration ---
# Use dot-prefixed dir to avoid collision when binary name == package name
$pkgDir = Join-Path $InstallDir ".$Package"
$destPath = Join-Path $InstallDir "$binary.exe"

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
} elseif ((Test-Path $destPath) -and -not (Get-Item $destPath).LinkType) {
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
    if ($oldVer -eq $version) {
        Write-Ok "Already up to date (v$version)."
        exit 0
    }
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

# --- Versioned install ---
$versionDir = Join-Path $pkgDir $version
New-Item -ItemType Directory -Path $versionDir -Force | Out-Null
Copy-Item -Path $downloadPath -Destination (Join-Path $versionDir "$binary.exe") -Force
Set-Content -Path (Join-Path $versionDir ".version") -Value $version

# Update current symlink/junction
$currentLink = Join-Path $pkgDir "current"
Create-SymlinkOrFallback -target $versionDir -linkPath $currentLink

# Generate helper scripts BEFORE creating user-visible symlink
# (to avoid path conflicts when binary == package name)

Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "Installed $binary v$version"

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

# Create user-visible binary symlink (after helper scripts to avoid path conflicts)
Create-SymlinkOrFallback -target (Join-Path $currentLink "$binary.exe") -linkPath $destPath

Write-Ok "Done! Run '$binary' to get started."
