#!/bin/bash
# setup.sh — First-time setup for ClaudeOS
# Run once after cloning: ./setup.sh

set -e

echo "Setting up ClaudeOS..."
echo ""

# Make all hooks executable
echo "Making hooks executable..."
chmod +x .claude/hooks/*.sh
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
if command -v python3 &> /dev/null; then
    echo "python3 found: $(python3 --version)"
else
    echo "WARNING: python3 not found. The block-dangerous.sh hook requires it."
    echo "  Install Python 3: https://www.python.org/downloads/"
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

if command -v notebooklm &> /dev/null; then
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
echo "The 5-layer memory system will activate automatically."
