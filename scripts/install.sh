#!/bin/sh
# tribucket installer — works without homebrew/scoop
# Usage: curl -fsSL <url>/install.sh | bash -s <package>
# Env: INSTALL_DIR=<path> to override install location (default: current dir)
set -eu

TRIBUCKET_REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
TRIBUCKET_RAW="https://raw.githubusercontent.com/${TRIBUCKET_REPO}/main"

PKG_NAME="${1:-}"

# --- Colors (safe for pipes) ---
if [ -t 1 ]; then
  R='\033[0;31m' G='\033[0;32m' Y='\033[0;33m' B='\033[0;34m' BOLD='\033[1m' Z='\033[0m'
else
  R='' G='' Y='' B='' BOLD='' Z=''
fi

info()  { printf "${B}[info]${Z}  %s\n" "$*"; }
ok()    { printf "${G}[ok]${Z}    %s\n" "$*"; }
warn()  { printf "${Y}[warn]${Z}  %s\n" "$*" >&2; }
err()   { printf "${R}[error]${Z} %s\n" "$*" >&2; exit 1; }

# --- HTTP GET ---
http_get() {
  _url="$1" _file="${2:-}"
  if command -v curl >/dev/null 2>&1; then
    if [ -n "$_file" ]; then
      curl -fSL --progress-bar "$_url" -o "$_file"
    else
      curl -fsSL "$_url"
    fi
  elif command -v wget >/dev/null 2>&1; then
    if [ -n "$_file" ]; then
      wget -q --show-progress "$_url" -O "$_file"
    else
      wget -qO- "$_url"
    fi
  else
    err "Neither curl nor wget found."
  fi
}

# --- Load package definition ---
load_pkg_def() {
  _name="$1"
  # Try local file first (running from cloned repo)
  _local="$(cd "$(dirname "$0")/.." && pwd)/packages/${_name}.json"
  if [ -f "$_local" ]; then
    cat "$_local"
    return
  fi
  # Fallback: fetch from GitHub
  http_get "${TRIBUCKET_RAW}/packages/${_name}.json"
}

# --- Detect platform key ---
detect_platform() {
  _os=$(uname -s | tr '[:upper:]' '[:lower:]')
  _arch=$(uname -m)
  case "$_os" in
    linux*)  _os="linux" ;;
    darwin*) _os="darwin" ;;
    *)       err "Unsupported OS: $(uname -s). Use install.bat/install.ps1 on Windows." ;;
  esac
  case "$_arch" in
    x86_64|amd64) _arch="amd64" ;;
    aarch64|arm64) _arch="arm64" ;;
    *)            err "Unsupported arch: $_arch" ;;
  esac
  echo "${_os}_${_arch}"
}

# --- Parse JSON value (minimal, no jq dependency) ---
json_val() {
  _json="$1" _key="$2"
  printf '%s' "$_json" | grep -o "\"${_key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 | sed 's/.*"'$_key'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/'
}

# --- Main ---
main() {
  [ -z "$PKG_NAME" ] && err "Usage: install.sh <package-name>\n  Available: ccx"

  info "Package: ${BOLD}${PKG_NAME}${Z}"

  # Load package definition
  PKG_JSON=$(load_pkg_def "$PKG_NAME")
  [ -z "$PKG_JSON" ] && err "Package '${PKG_NAME}' not found."

  REPO=$(json_val "$PKG_JSON" "repo")
  BINARY=$(json_val "$PKG_JSON" "binary")
  DESCRIPTION=$(json_val "$PKG_JSON" "description")
  [ -z "$REPO" ] && err "Invalid package definition: missing 'repo'."

  info "${DESCRIPTION}"

  # Detect platform
  PLATFORM=$(detect_platform)
  info "Platform: ${BOLD}${PLATFORM}${Z}"

  # Find asset pattern for this platform
  ASSET_PATTERN=$(printf '%s' "$PKG_JSON" | grep -o "\"${PLATFORM}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 | sed 's/.*"'${PLATFORM}'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  [ -z "$ASSET_PATTERN" ] && err "No asset pattern for ${PLATFORM}. Check packages/${PKG_NAME}.json"

  # Get latest release
  info "Fetching latest release..."
  RELEASE_JSON=$(http_get "https://api.github.com/repos/${REPO}/releases/latest")
  VERSION=$(printf '%s' "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v\{0,1\}\([^"]*\)".*/\1/')
  [ -z "$VERSION" ] && err "Failed to parse version from GitHub API."
  info "Latest: ${BOLD}v${VERSION}${Z}"

  # Find matching asset URL
  DOWNLOAD_URL=$(printf '%s' "$RELEASE_JSON" | grep '"browser_download_url"' | grep -i "$ASSET_PATTERN" | head -1 | sed 's/.*"browser_download_url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  [ -z "$DOWNLOAD_URL" ] && err "No asset matching '${ASSET_PATTERN}' in release v${VERSION}"

  # Install directory
  INSTALL_DIR="${INSTALL_DIR:-$(pwd)}"
  mkdir -p "$INSTALL_DIR"

  # Check current version
  if [ -f "${INSTALL_DIR}/${BINARY}" ]; then
    CURRENT=$("${INSTALL_DIR}/${BINARY}" --version 2>/dev/null | head -1 | sed 's/[^0-9.]//g' || echo "unknown")
    if [ "$CURRENT" = "$VERSION" ]; then
      ok "Already up to date (v${VERSION}). Nothing to do."
      exit 0
    fi
    info "Updating ${CURRENT} -> v${VERSION}..."
  fi

  # Download
  FILENAME=$(basename "$DOWNLOAD_URL")
  TMPDIR=$(mktemp -d)
  trap 'rm -rf "$TMPDIR"' EXIT

  info "Downloading ${FILENAME}..."
  http_get "$DOWNLOAD_URL" "${TMPDIR}/${FILENAME}"

  # Handle archive
  case "$FILENAME" in
    *.tar.gz|*.tgz)
      tar -xzf "${TMPDIR}/${FILENAME}" -C "$TMPDIR"
      EXTRACTED=$(find "$TMPDIR" -type f -name "${BINARY}*" ! -name "*.tar*" | head -1)
      ;;
    *.zip)
      unzip -qo "${TMPDIR}/${FILENAME}" -d "$TMPDIR"
      EXTRACTED=$(find "$TMPDIR" -type f -name "${BINARY}*" ! -name "*.zip" | head -1)
      ;;
    *)
      EXTRACTED="${TMPDIR}/${FILENAME}"
      ;;
  esac
  [ -z "$EXTRACTED" ] && err "Binary not found in download."
  chmod +x "$EXTRACTED"
  mv "$EXTRACTED" "${INSTALL_DIR}/${BINARY}"
  ok "Installed ${BOLD}${BINARY} v${VERSION}${Z} -> ${INSTALL_DIR}/${BINARY}"

  # Generate helper scripts in install dir
  gen_update_script "$INSTALL_DIR" "$BINARY" "$PKG_NAME"
  gen_uninstall_script "$INSTALL_DIR" "$BINARY"

  # PATH hint
  case ":${PATH}:" in
    *":${INSTALL_DIR}:"*) ;;
    *)
      warn ""
      warn "${INSTALL_DIR} is not in your PATH."
      warn "  export PATH=\"${INSTALL_DIR}:\$PATH\""
      ;;
  esac

  ok "Done! Run '${BINARY}' to get started."
}

# --- Generate update.sh ---
gen_update_script() {
  _dir="$1" _bin="$2" _pkg="$3"
  cat > "${_dir}/update.sh" << 'UPDEOF'
#!/bin/sh
# tribucket updater (auto-generated)
# Re-downloads and runs the latest install.sh from GitHub
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_NAME="__PKG__"
echo "Updating ${PKG_NAME} in ${INSTALL_DIR}..."
curl -fsSL "https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/install.sh" | INSTALL_DIR="${INSTALL_DIR}" bash -s "${PKG_NAME}"
UPDEOF
  # Replace placeholder with actual package name
  sed -i "s/__PKG__/${_pkg}/g" "${_dir}/update.sh"
  chmod +x "${_dir}/update.sh"
}

# --- Generate uninstall.sh ---
gen_uninstall_script() {
  _dir="$1" _bin="$2"
  cat > "${_dir}/uninstall.sh" << UNEOF
#!/bin/sh
# tribucket uninstaller (auto-generated)
INSTALL_DIR="${_dir}"
BINARY="${_bin}"
echo "Removing \${BINARY} from \${INSTALL_DIR}..."
rm -f "\${INSTALL_DIR}/\${BINARY}" "\${INSTALL_DIR}/update.sh" "\${INSTALL_DIR}/uninstall.sh"
echo "Done."
UNEOF
  chmod +x "${_dir}/uninstall.sh"
}

main "$@"
