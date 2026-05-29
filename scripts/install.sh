#!/bin/sh
# tribucket installer — works without homebrew/scoop
# Usage: curl -fsSL <url>/install.sh | bash -s <package>
# Env: INSTALL_DIR=<path> to override install location (default: current dir)
# Note: #!/bin/sh for maximum portability. pipefail is not available in POSIX sh;
#       we mitigate this with explicit || true on critical pipelines.
set -eu

# --- Colors (safe for pipes) — defined first so err() is available early ---
if [ -t 1 ]; then
  R='\033[0;31m' G='\033[0;32m' Y='\033[0;33m' B='\033[0;34m' BOLD='\033[1m' Z='\033[0m'
else
  R='' G='' Y='' B='' BOLD='' Z=''
fi

# Use %b for color codes and %s for data to prevent printf format injection [#19]
info()  { printf '%b[info]%b  %s\n' "$B" "$Z" "$*"; }
ok()    { printf '%b[ok]%b    %s\n' "$G" "$Z" "$*"; }
warn()  { printf '%b[warn]%b  %s\n' "$Y" "$Z" "$*" >&2; }
err()   { printf '%b[error]%b %s\n' "$R" "$Z" "$*" >&2; exit 1; }

TRIBUCKET_REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
# Validate repo format to prevent URL injection [#101]
case "$TRIBUCKET_REPO" in
  *[!a-zA-Z0-9_.-]*/[!a-zA-Z0-9_.-]*|*[!a-zA-Z0-9/_.-]*)
    err "Invalid TRIBUCKET_REPO format: ${TRIBUCKET_REPO}"
    ;;
esac
TRIBUCKET_RAW="https://raw.githubusercontent.com/${TRIBUCKET_REPO}/main"

PKG_NAME="${1:-}"

# Global temp directory — cleaned up on exit [#trap-late, #TMPDIR-shadow]
TRIBUCKET_TMPDIR=""

cleanup() {
  [ -n "$TRIBUCKET_TMPDIR" ] && rm -rf "$TRIBUCKET_TMPDIR"
}
trap cleanup EXIT

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
  # Use readlink to resolve symlinks for robustness [#dirname-fragile]
  _self="$0"
  if command -v readlink >/dev/null 2>&1; then
    _self_resolved=$(readlink -f "$0" 2>/dev/null || echo "$0")
    [ -n "$_self_resolved" ] && _self="$_self_resolved"
  fi
  _local="$(cd "$(dirname "$_self")/.." && pwd)/packages/${_name}.json"
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

# --- Parse JSON value (use jq if available, fallback to grep) [#json-fragile] ---
json_val() {
  _json="$1" _key="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$_json" | jq -r ".$_key // empty" 2>/dev/null || true
    return
  fi
  # Fallback: regex-based extraction with proper quoting [#76]
  printf '%s' "$_json" \
    | grep -o "\"${_key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 \
    | sed "s/.*\"${_key}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/" \
    || true
}

# --- Verify SHA256 checksum (best-effort) ---
verify_checksum() {
  _file="$1" _url="$2" _dir="$3"
  _basename=$(basename "$_file")
  # Try common checksum file names
  for _cksum_name in "${_basename}.sha256" "SHA256SUMS" "sha256sums.txt" "checksums.txt"; do
    _cksum_url=$(printf '%s' "$_url" | sed "s|/[^/]*$|/${_cksum_name}|")
    _cksum_content=$(http_get "$_cksum_url" 2>/dev/null) || continue
    [ -z "$_cksum_content" ] && continue
    # Extract expected hash for our file
    _expected=$(printf '%s' "$_cksum_content" | grep "$_basename" | head -1 | awk '{print $1}')
    [ -z "$_expected" ] && continue
    # Compute actual hash
    if command -v sha256sum >/dev/null 2>&1; then
      _actual=$(sha256sum "$_file" | awk '{print $1}')
    elif command -v shasum >/dev/null 2>&1; then
      _actual=$(shasum -a 256 "$_file" | awk '{print $1}')
    else
      info "No sha256sum/shasum available — skipping checksum verification."
      return 0
    fi
    if [ "$_actual" = "$_expected" ]; then
      ok "Checksum verified."
      return 0
    else
      err "Checksum mismatch! Expected: ${_expected}, Got: ${_actual}"
    fi
  done
  info "No checksum file found — skipping verification."
}

# --- Main ---
main() {
  [ -z "$PKG_NAME" ] && err "Usage: install.sh <package-name>"

  info "Package: ${BOLD}${PKG_NAME}${Z}"

  # Load package definition
  PKG_JSON=$(load_pkg_def "$PKG_NAME")
  [ -z "$PKG_JSON" ] && err "Package '${PKG_NAME}' not found."

  REPO=$(json_val "$PKG_JSON" "repo")
  BINARY=$(json_val "$PKG_JSON" "binary")
  DESCRIPTION=$(json_val "$PKG_JSON" "description")
  [ -z "$REPO" ] && err "Invalid package definition: missing 'repo'."
  [ -z "$BINARY" ] && err "Invalid package definition: missing 'binary'."

  info "${DESCRIPTION}"

  # Detect platform
  PLATFORM=$(detect_platform)
  info "Platform: ${BOLD}${PLATFORM}${Z}"

  # Find asset pattern for this platform
  # PLATFORM is safe (controlled by detect_platform), so regex interpolation is OK
  ASSET_PATTERN=$(printf '%s' "$PKG_JSON" \
    | grep -o "\"${PLATFORM}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 \
    | sed "s/.*\"${PLATFORM}\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/" \
    || true)
  [ -z "$ASSET_PATTERN" ] && err "No asset pattern for ${PLATFORM}. Check packages/${PKG_NAME}.json"

  # Get latest release
  info "Fetching latest release..."
  RELEASE_JSON=$(http_get "https://api.github.com/repos/${REPO}/releases/latest")
  VERSION=$(printf '%s' "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v?([^"]*)".*/\1/' || true)
  [ -z "$VERSION" ] && err "Failed to parse version from GitHub API."
  info "Latest: ${BOLD}v${VERSION}${Z}"

  # Find matching asset URL using fixed-string match where possible
  # Convert glob patterns to regex for grep -E
  _regex_pattern=$(printf '%s' "$ASSET_PATTERN" | sed 's/[].$*+?(){}[]/\\&/g; s/\\\*/.*/g; s/\\\./\\./g')
  DOWNLOAD_URL=$(printf '%s' "$RELEASE_JSON" \
    | grep '"browser_download_url"' \
    | grep -E "$_regex_pattern" \
    | head -1 \
    | sed 's/.*"browser_download_url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' \
    || true)
  [ -z "$DOWNLOAD_URL" ] && err "No asset matching '${ASSET_PATTERN}' in release v${VERSION}"
  # Validate download URL to prevent injection
  case "$DOWNLOAD_URL" in
    https://github.com/*) ;;
    *) err "Unexpected download URL domain: ${DOWNLOAD_URL}" ;;
  esac

  # Install directory
  INSTALL_DIR="${INSTALL_DIR:-$(pwd)}"
  mkdir -p "$INSTALL_DIR"

  # Check current version (with timeout to prevent hangs) [#155]
  if [ -f "${INSTALL_DIR}/${BINARY}" ]; then
    CURRENT=$(timeout 5 "${INSTALL_DIR}/${BINARY}" --version 2>/dev/null | head -1 | sed 's/[^0-9.]//g' || echo "unknown")
    if [ "$CURRENT" = "$VERSION" ]; then
      ok "Already up to date (v${VERSION}). Nothing to do."
      exit 0
    fi
    info "Updating ${CURRENT} -> v${VERSION}..."
  fi

  # Download — use TRIBUCKET_TMPDIR to avoid shadowing system TMPDIR [#67]
  FILENAME=$(basename "$DOWNLOAD_URL")
  TRIBUCKET_TMPDIR=$(mktemp -d)

  info "Downloading ${FILENAME}..."
  http_get "$DOWNLOAD_URL" "${TRIBUCKET_TMPDIR}/${FILENAME}"

  # Verify checksum (best-effort) [#security-checksum]
  verify_checksum "${TRIBUCKET_TMPDIR}/${FILENAME}" "$DOWNLOAD_URL" "$TRIBUCKET_TMPDIR"

  # Handle archive — prefer exact binary match to avoid false positives [#168]
  case "$FILENAME" in
    *.tar.gz|*.tgz)
      tar -xzf "${TRIBUCKET_TMPDIR}/${FILENAME}" -C "$TRIBUCKET_TMPDIR"
      EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f -name "$BINARY" -print | head -1)
      if [ -z "$EXTRACTED" ]; then
        EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f \( -name "${BINARY}-*" -o -name "${BINARY}.*" \) \
          ! -name "*.tar*" ! -name "*.sha*" ! -name "*.zip" -print | head -1)
      fi
      ;;
    *.tar.zst)
      if ! command -v zstd >/dev/null 2>&1; then
        err "zstd is required to extract .tar.zst archives. Install it with your package manager."
      fi
      zstd -d "${TRIBUCKET_TMPDIR}/${FILENAME}" --output-dir-flat "$TRIBUCKET_TMPDIR" 2>/dev/null \
        || zstd -d "${TRIBUCKET_TMPDIR}/${FILENAME}" -o "${TRIBUCKET_TMPDIR}/${FILENAME%.zst}" 2>/dev/null \
        || err "Failed to decompress .tar.zst archive"
      _tar_file=$(find "$TRIBUCKET_TMPDIR" -type f -name "*.tar" ! -name "*.zst" -print | head -1)
      [ -z "$_tar_file" ] && err "No .tar file found after zstd decompression"
      tar -xf "$_tar_file" -C "$TRIBUCKET_TMPDIR"
      EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f -name "$BINARY" -print | head -1)
      if [ -z "$EXTRACTED" ]; then
        EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f \( -name "${BINARY}-*" -o -name "${BINARY}.*" \) \
          ! -name "*.tar*" ! -name "*.sha*" ! -name "*.zip" ! -name "*.zst" -print | head -1)
      fi
      ;;
    *.zip)
      unzip -qo "${TRIBUCKET_TMPDIR}/${FILENAME}" -d "$TRIBUCKET_TMPDIR"
      EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f -name "$BINARY" -print | head -1)
      if [ -z "$EXTRACTED" ]; then
        EXTRACTED=$(find "$TRIBUCKET_TMPDIR" -type f \( -name "${BINARY}-*" -o -name "${BINARY}.*" \) \
          ! -name "*.zip" ! -name "*.sha*" -print | head -1)
      fi
      ;;
    *)
      EXTRACTED="${TRIBUCKET_TMPDIR}/${FILENAME}"
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
  # Use quoted heredoc + sed placeholders to handle special chars in repo URL [#189]
  _repo_url="${TRIBUCKET_RAW}/scripts/install.sh"
  cat > "${_dir}/update.sh" << 'UPDEOF'
#!/bin/sh
# tribucket updater (auto-generated)
# Re-downloads and runs the latest install.sh from GitHub
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_NAME="__PKG__"
SCRIPT_URL="__REPO_URL__"
echo "Updating ${PKG_NAME} in ${INSTALL_DIR}..."
curl -fsSL "${SCRIPT_URL}" | INSTALL_DIR="${INSTALL_DIR}" bash -s "${PKG_NAME}"
UPDEOF
  # Replace placeholders with actual values (portable: no sed -i)
  sed "s|__PKG__|${_pkg}|g; s|__REPO_URL__|${_repo_url}|g" "${_dir}/update.sh" > "${_dir}/update.sh.tmp"
  mv "${_dir}/update.sh.tmp" "${_dir}/update.sh"
  chmod +x "${_dir}/update.sh"
}

# --- Generate uninstall.sh ---
gen_uninstall_script() {
  _dir="$1" _bin="$2"
  # Use quoted heredoc + placeholders to handle paths with special chars [$, backtick, etc.] [#195]
  cat > "${_dir}/uninstall.sh" << 'UNEOF'
#!/bin/sh
# tribucket uninstaller (auto-generated)
INSTALL_DIR="__INSTALL_DIR__"
BINARY="__BINARY__"
echo "Removing ${BINARY} from ${INSTALL_DIR}..."
rm -f "${INSTALL_DIR}/${BINARY}" "${INSTALL_DIR}/update.sh" "${INSTALL_DIR}/uninstall.sh"
echo "Done."
UNEOF
  # Replace placeholders (portable: no sed -i; using | as delimiter)
  sed "s|__INSTALL_DIR__|${_dir}|g; s|__BINARY__|${_bin}|g" "${_dir}/uninstall.sh" > "${_dir}/uninstall.sh.tmp"
  mv "${_dir}/uninstall.sh.tmp" "${_dir}/uninstall.sh"
  chmod +x "${_dir}/uninstall.sh"
}

main "$@"
