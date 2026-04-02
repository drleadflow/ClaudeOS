#!/usr/bin/env bash
# setup.sh — First-time setup for ClaudeOS
# Works on macOS and Linux. Windows users: run setup.ps1 or setup.bat instead.
# Run once after cloning: ./setup.sh

set -e

echo "Setting up ClaudeOS..."
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)   PLATFORM="Linux" ;;
    Darwin*)  PLATFORM="macOS" ;;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="Windows (Git Bash)" ;;
    *)        PLATFORM="Unknown ($OS)" ;;
esac
echo "Detected platform: $PLATFORM"
echo ""

# Make all hooks executable (not needed on Windows but harmless)
echo "Making hooks executable..."
chmod +x .claude/hooks/*.sh 2>/dev/null || true
echo "  Done."

# Create workforce directories if they don't exist
echo "Setting up workforce directories..."
for role in researcher builder reviewer tester auditor ops; do
    mkdir -p ".claude/workforce/$role/history"
done
echo "  Done."

# Create CLAUDE.local.md if it doesn't exist
if [ ! -f "CLAUDE.local.md" ]; then
    echo "Creating CLAUDE.local.md (personal overrides, git-ignored)..."
    cat > CLAUDE.local.md << 'EOF'
# CLAUDE.local.md

Personal overrides and experimental behavior. This file is git-ignored
and takes precedence over CLAUDE.md when instructions conflict.

Use this for:
- Personal coding style preferences
- Debug workflows and verbose output
- Experimental agent behaviors
- Temporary workarounds

Delete entries here once promoted to shared CLAUDE.md or .claude/rules/.

## Your Preferences

<!-- Add your personal Claude preferences below -->
EOF
    echo "  Done."
else
    echo "CLAUDE.local.md already exists, skipping."
fi

# Create settings.local.json if it doesn't exist
if [ ! -f ".claude/settings.local.json" ]; then
    echo "Creating .claude/settings.local.json (personal permissions, git-ignored)..."
    cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": []
  }
}
EOF
    echo "  Done."
else
    echo ".claude/settings.local.json already exists, skipping."
fi

# Verify python3 is available (needed for block-dangerous.sh hook)
echo ""
if command -v python3 &> /dev/null; then
    echo "python3 found: $(python3 --version)"
elif command -v python &> /dev/null && python --version 2>&1 | grep -q "Python 3"; then
    echo "python found (Python 3): $(python --version)"
    echo "  NOTE: Some hooks reference 'python3'. You may need to alias or symlink:"
    if [ "$PLATFORM" = "Linux" ]; then
        echo "    sudo apt install python-is-python3  # Debian/Ubuntu"
        echo "    # or: sudo ln -s \$(which python) /usr/local/bin/python3"
    elif [ "$PLATFORM" = "macOS" ]; then
        echo "    brew install python3"
    fi
else
    echo "WARNING: python3 not found. The block-dangerous.sh hook requires it."
    echo "  Install Python 3:"
    if [ "$PLATFORM" = "Linux" ]; then
        echo "    sudo apt install python3   # Debian/Ubuntu"
        echo "    sudo dnf install python3   # Fedora/RHEL"
        echo "    sudo pacman -S python      # Arch"
    elif [ "$PLATFORM" = "macOS" ]; then
        echo "    brew install python3"
        echo "    # or: https://www.python.org/downloads/"
    else
        echo "    https://www.python.org/downloads/"
    fi
fi

# Check for optional dependencies
echo ""
echo "Optional dependencies:"
if command -v yt-dlp &> /dev/null; then
    echo "  yt-dlp: installed (YouTube search skill ready)"
else
    echo "  yt-dlp: not installed (needed for /yt-search skill)"
    echo "    Install: pip install yt-dlp"
fi

if command -v notebooklm &> /dev/null || python3 -c "import notebooklm" 2>/dev/null; then
    echo "  notebooklm-py: installed (research-daemon skill ready)"
else
    echo "  notebooklm-py: not installed (needed for research-daemon skill)"
    echo "    Install: pip install 'notebooklm-py[browser]'"
fi

echo ""
echo "Setup complete. Next steps:"
echo "  1. Edit CLAUDE.md with your project-specific rules"
echo "  2. Edit .mcp.json to add your MCP servers"
echo "  3. Edit CLAUDE.local.md with personal preferences"
echo "  4. Run: claude"
echo ""
echo "Included:"
echo "  - 5-layer memory system (activates automatically)"
echo "  - 6-role workforce (researcher, builder, reviewer, tester, auditor, ops)"
echo "  - /team-up — parallel agent orchestration"
echo "  - /vet-repo — GitHub repo security audit"
echo "  - /template-project — scaffold new projects from this template"
