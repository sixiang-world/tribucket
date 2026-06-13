#!/usr/bin/env bash
set -euo pipefail

# tribucket bootstrap installer
# Installs the tribucket CLI to ~/.tribucket/bin/
# Usage: curl -fsSL https://raw.githubusercontent.com/sixiang-world/tribucket/main/scripts/bootstrap.sh | bash

REPO="${TRIBUCKET_REPO:-sixiang-world/tribucket}"
TRIBUCKET_HOME="${TRIBUCKET_HOME:-$HOME/.tribucket}"
INSTALL_DIR="$TRIBUCKET_HOME/bin"
RAW_URL="https://raw.githubusercontent.com/${REPO}/main"

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

# Check Python
check_python() {
    if command -v python3 &>/dev/null; then
        PYTHON=python3
    elif command -v python &>/dev/null; then
        PYTHON=python
    else
        err "Python 3 is required but not found. Install Python 3.8+ first."
    fi

    # Check version
    PY_VERSION=$($PYTHON -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    PY_MAJOR=$($PYTHON -c "import sys; print(sys.version_info.major)")
    PY_MINOR=$($PYTHON -c "import sys; print(sys.version_info.minor)")

    if [ "$PY_MAJOR" -lt 3 ] || ([ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 8 ]); then
        err "Python 3.8+ required, found $PY_VERSION"
    fi

    info "Python: $PY_VERSION"
}

# Main
main() {
    info "Installing tribucket CLI..."
    echo ""

    # Check Python
    check_python

    # Create directories
    mkdir -p "$INSTALL_DIR" "$TRIBUCKET_HOME/cache" "$TRIBUCKET_HOME/backup"

    # Download tribucket CLI
    info "Downloading tribucket CLI..."
    curl -fsSL "${RAW_URL}/bin/tribucket" -o "$INSTALL_DIR/tribucket"
    chmod +x "$INSTALL_DIR/tribucket"

    # Verify
    if "$PYTHON" "$INSTALL_DIR/tribucket" --version &>/dev/null; then
        VERSION=$("$PYTHON" "$INSTALL_DIR/tribucket" --version 2>&1 | head -1)
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
