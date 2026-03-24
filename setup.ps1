# setup.ps1 — First-time setup for ClaudeOS (Windows PowerShell)
# Run once after cloning: .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "Setting up ClaudeOS..." -ForegroundColor Cyan
Write-Host ""

# Create CLAUDE.local.md if it doesn't exist
if (-not (Test-Path "CLAUDE.local.md")) {
    Write-Host "Creating CLAUDE.local.md (personal overrides, git-ignored)..."
    @"
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
"@ | Set-Content -Path "CLAUDE.local.md" -Encoding UTF8
    Write-Host "  Done." -ForegroundColor Green
} else {
    Write-Host "CLAUDE.local.md already exists, skipping."
}

# Create settings.local.json if it doesn't exist
if (-not (Test-Path ".claude\settings.local.json")) {
    Write-Host "Creating .claude\settings.local.json (personal permissions, git-ignored)..."
    @"
{
  "permissions": {
    "allow": []
  }
}
"@ | Set-Content -Path ".claude\settings.local.json" -Encoding UTF8
    Write-Host "  Done." -ForegroundColor Green
} else {
    Write-Host ".claude\settings.local.json already exists, skipping."
}

# Verify python3 is available (needed for block-dangerous.sh hook)
Write-Host ""
$python = $null
foreach ($cmd in @("python3", "python")) {
    try {
        $version = & $cmd --version 2>&1
        if ($version -match "Python 3") {
            $python = $cmd
            Write-Host "$cmd found: $version" -ForegroundColor Green
            break
        }
    } catch {}
}
if (-not $python) {
    Write-Host "WARNING: Python 3 not found. The block-dangerous.sh hook requires it." -ForegroundColor Yellow
    Write-Host "  Install Python 3: https://www.python.org/downloads/" -ForegroundColor Yellow
}

# Check for bash (needed for hooks)
Write-Host ""
$bashFound = $false
foreach ($bashPath in @("bash", "C:\Program Files\Git\bin\bash.exe", "C:\Windows\System32\bash.exe")) {
    try {
        $null = & $bashPath --version 2>&1
        $bashFound = $true
        Write-Host "bash found: $bashPath" -ForegroundColor Green
        break
    } catch {}
}
if (-not $bashFound) {
    Write-Host "WARNING: bash not found. ClaudeOS hooks require bash." -ForegroundColor Yellow
    Write-Host "  Options:" -ForegroundColor Yellow
    Write-Host "    1. Install Git for Windows (includes Git Bash): https://git-scm.com/downloads" -ForegroundColor Yellow
    Write-Host "    2. Enable WSL: wsl --install" -ForegroundColor Yellow
    Write-Host "  Git Bash is recommended — Claude Code can use it automatically." -ForegroundColor Yellow
}

# Check for optional dependencies
Write-Host ""
Write-Host "Optional dependencies:"
try {
    $null = & yt-dlp --version 2>&1
    Write-Host "  yt-dlp: installed (YouTube search skill ready)" -ForegroundColor Green
} catch {
    Write-Host "  yt-dlp: not installed (needed for /yt-search skill)" -ForegroundColor DarkGray
    Write-Host "    Install: pip install yt-dlp" -ForegroundColor DarkGray
}

try {
    $null = python3 -c "import notebooklm" 2>&1
    Write-Host "  notebooklm-py: installed (research-daemon skill ready)" -ForegroundColor Green
} catch {
    Write-Host "  notebooklm-py: not installed (needed for research-daemon skill)" -ForegroundColor DarkGray
    Write-Host "    Install: pip install 'notebooklm-py[browser]'" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Setup complete. Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit CLAUDE.md with your project-specific rules"
Write-Host "  2. Edit .mcp.json to add your MCP servers"
Write-Host "  3. Edit CLAUDE.local.md with personal preferences"
Write-Host "  4. Run: claude"
Write-Host ""
Write-Host "The 5-layer memory system will activate automatically." -ForegroundColor Cyan
