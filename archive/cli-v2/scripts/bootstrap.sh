#!/usr/bin/env bash
set -euo pipefail

# tribucket bootstrap installer (macOS / Linux)
# Installs the tribucket CLI (Bun compiled binary) to ~/.tribucket/bin/
# Usage: curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.sh | bash
#
# Windows users: use scripts/bootstrap.ps1 instead:
#   irm https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.ps1 | iex

REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
# Validate repo format to prevent URL injection
case "$REPO" in
  *..*|*[!a-zA-Z0-9_.-]*/[!a-zA-Z0-9_.-]*|*[!a-zA-Z0-9/_.-]*)
    echo "Error: Invalid TRIBUCKET_REPO format: ${REPO}" >&2
    exit 1
    ;;
esac
TRIBUCKET_HOME="${TRIBUCKET_HOME:-$HOME/.tribucket}"
INSTALL_DIR="$TRIBUCKET_HOME/bin"
RAW_URL="https://raw.githubusercontent.com/${REPO}/main"
BINARY_URL="https://github.com/${REPO}/releases/latest/download/tribucket-linux-amd64"
TAG_URL="https://api.github.com/repos/${REPO}/releases/latest"

# Colors
if [ -t 1 ]; then
    R='\033[0;31m' G='\033[0;32m' Y='\033[0;33m' BOLD='\033[1m' RESET='\033[0m'
else
    R='' G='' Y='' BOLD='' RESET=''
fi

info()  { printf '%s[info]%s  %s\n' "$BOLD" "$RESET" "$*"; }
ok()    { printf '%s[ok]%s    %s\n' "$G" "$RESET" "$*"; }
warn()  { printf '%s[warn]%s  %s\n' "$Y" "$RESET" "$*" >&2; }
err()   { printf '%s[error]%s %s\n' "$R" "$RESET" "$*" >&2; exit 1; }

# Main
main() {
    info "Installing tribucket CLI (Bun compiled binary)..."
    echo ""

    # Detect platform
    OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m)"
    case "$ARCH" in
        x86_64)  ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        arm64)   ARCH="arm64" ;;
    esac
    SUFFIX="${OS}-${ARCH}"

    # Try to get latest release download URL from GitHub API
    DOWNLOAD_URL=""
    if command -v curl &>/dev/null; then
        DOWNLOAD_URL=$(curl -sf "$TAG_URL" 2>/dev/null \
            | grep -oP '"browser_download_url":\s*"\K[^"]+' \
            | grep -i "tribucket-${SUFFIX}" \
            | head -1) || true
    fi

    if [ -z "$DOWNLOAD_URL" ]; then
        DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/tribucket-${SUFFIX}"
    fi

    # Create directories
    mkdir -p "$INSTALL_DIR" "$TRIBUCKET_HOME/cache" "$TRIBUCKET_HOME/backup"

    # Download tribucket binary
    info "Downloading tribucket binary..."
    if command -v curl &>/dev/null; then
        curl -fsSL "$DOWNLOAD_URL" -o "$INSTALL_DIR/tribucket"
    elif command -v wget &>/dev/null; then
        wget -q "$DOWNLOAD_URL" -O "$INSTALL_DIR/tribucket"
    else
        err "Neither curl nor wget found. Install one of them first."
    fi
    chmod +x "$INSTALL_DIR/tribucket"

    # Verify
    if "$INSTALL_DIR/tribucket" --version &>/dev/null; then
        VERSION=$("$INSTALL_DIR/tribucket" --version 2>&1 | head -1)
        ok "Installed: $INSTALL_DIR/tribucket ($VERSION)"
    else
        ok "Installed: $INSTALL_DIR/tribucket"
    fi

    # Check PATH
    echo ""
    case ":${PATH}:" in
        *":${INSTALL_DIR}:"*)
            ok "PATH already configured"
            ;;
        *)
            warn ""
            warn "${INSTALL_DIR} is not in your PATH."
            warn ""
            warn "Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
            warn "  export PATH=\"${INSTALL_DIR}:\$PATH\""
            warn ""
            warn "Or run:"
            warn "  echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.bashrc"
            warn "  source ~/.bashrc"
            ;;
    esac

    echo ""
    ok "tribucket is ready! Try:"
    echo "  tribucket --help"
    echo "  tribucket install <package-name>"
}

main "$@"
