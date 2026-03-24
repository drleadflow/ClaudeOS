@echo off
REM setup.bat — Launcher for ClaudeOS setup on Windows
REM Detects PowerShell and runs setup.ps1, or falls back to basic setup.

where powershell >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo Running setup via PowerShell...
    powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
    exit /b %ERRORLEVEL%
)

where pwsh >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo Running setup via PowerShell Core...
    pwsh -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
    exit /b %ERRORLEVEL%
)

echo ERROR: PowerShell not found. Please run setup.ps1 manually or install PowerShell.
echo   https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell
exit /b 1
