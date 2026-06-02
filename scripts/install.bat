@echo off
REM tribucket installer — Win7 SP1+ compatible (PowerShell 2.0+)
REM Usage: install.bat <package-name> [cn]
REM   cn = use gh.do.hunluan.space mirror (China acceleration)
REM Env:   set INSTALL_DIR=C:\tools
REM
REM This script downloads install.ps1 from GitHub and runs it.
REM Only needs this one .bat file — no other files required.

setlocal

set "PKG_NAME=%~1"
if "%PKG_NAME%"=="" (
    echo [error] Usage: install.bat ^<package-name^> [cn]
    echo   See packages/ directory for available packages.
    exit /b 1
)

set "MIRROR=%~2"
set "PS_SCRIPT=%TEMP%\tribucket-install.ps1"

REM Determine install.ps1 URL (mirror or direct)
if /i "%MIRROR%"=="cn" (
    set "PS_URL=https://gh.do.hunluan.space/https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1"
) else (
    set "PS_URL=https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.ps1"
)

REM Download install.ps1 via PowerShell (available on Win7 SP1+)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%PS_URL%', '%PS_SCRIPT%')"

if not exist "%PS_SCRIPT%" (
    echo [error] Failed to download install script.
    exit /b 1
)

REM Build arguments
set "PS_ARGS=-Package %PKG_NAME%"
if /i "%MIRROR%"=="cn" set "PS_ARGS=%PS_ARGS% -Mirror cn"
if not "%INSTALL_DIR%"=="" set "PS_ARGS=%PS_ARGS% -InstallDir '%INSTALL_DIR%'"

REM Run
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %PS_ARGS%
set "EXIT_CODE=%ERRORLEVEL%"

REM Cleanup
del "%PS_SCRIPT%" 2>nul

endlocal
exit /b %EXIT_CODE%
