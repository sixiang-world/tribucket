# tribucket bootstrap installer (Windows / PowerShell)
# Installs the tribucket CLI (Bun compiled binary) to ~\.tribucket\bin\
#
# Usage (PowerShell):
#   irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.ps1 | iex
# Or from a saved file:
#   powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

$Repo        = if ($env:TRIBUCKET_REPO) { $env:TRIBUCKET_REPO } else { 'sixiang-world/tribucket' }
$Home2       = if ($env:TRIBUCKET_HOME) { $env:TRIBUCKET_HOME } else { (Join-Path $env:USERPROFILE '.tribucket') }
$InstallDir  = Join-Path $Home2 'bin'
$TagUrl      = "https://api.github.com/repos/$Repo/releases/latest"

function Write-Info($m) { Write-Host "[info]  $m" }
function Write-Ok($m)   { Write-Host "[ok]    $m" -ForegroundColor Green }
function Write-Warn($m) { Write-Host "[warn]  $m" -ForegroundColor Yellow }
function Write-Err($m)  { Write-Host "[error] $m" -ForegroundColor Red; exit 1 }

Write-Info 'Installing tribucket CLI (Bun compiled binary)...'
Write-Host ''

# Detect architecture
$Arch = switch ($env:PROCESSOR_ARCHITECTURE) {
    'AMD64' { 'amd64' }
    'ARM64' { 'arm64' }
    default { 'amd64' }
}
$Suffix = "windows-$Arch"
$OutFile = Join-Path $InstallDir 'tribucket.exe'

# Resolve the latest release download URL via the GitHub API.
# Falls back to the /releases/latest/download/ short URL on any failure.
$DownloadUrl = ''
try {
    $release = Invoke-RestMethod -Uri $TagUrl -UseBasicParsing -ErrorAction Stop
    $asset = $release.assets | Where-Object { $_.name -like "*tribucket-$Suffix*" } | Select-Object -First 1
    if ($asset) { $DownloadUrl = $asset.browser_download_url }
} catch {
    Write-Warn "Could not query GitHub API ($($_.Exception.Message)); falling back to latest/download URL."
}
if (-not $DownloadUrl) {
    $DownloadUrl = "https://github.com/$Repo/releases/latest/download/tribucket-$Suffix.exe"
}

# Create directories
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Home2 'cache') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Home2 'backup') | Out-Null

# Download tribucket binary
Write-Info 'Downloading tribucket binary...'
try {
    # TLS 1.2 is required by GitHub on older .NET versions.
    try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutFile -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Err "Download failed: $($_.Exception.Message)"
}

# Verify
$Version = ''
try {
    $Version = (& $OutFile --version 2>$null | Select-Object -First 1)
} catch {}
if ($Version) {
    Write-Ok "Installed: $OutFile ($Version)"
} else {
    Write-Ok "Installed: $OutFile"
}

# Check PATH
Write-Host ''
$pathHas = ($env:PATH -split ';' | Where-Object { $_ -ieq $InstallDir }).Count -gt 0
if ($pathHas) {
    Write-Ok 'PATH already configured'
} else {
    Write-Warn ''
    Write-Warn "$InstallDir is not in your PATH."
    Write-Warn ''
    Write-Warn 'Add it for the current user by running:'
    Write-Warn "  [Environment]::SetEnvironmentVariable('PATH', `"$InstallDir;`$([Environment]::GetEnvironmentVariable('PATH','User'))`", 'User')"
    Write-Warn 'Then open a new terminal for the change to take effect.'
}

Write-Host ''
Write-Ok 'tribucket is ready! Try:'
Write-Host '  tribucket --help'
Write-Host '  tribucket install <package-name>'
