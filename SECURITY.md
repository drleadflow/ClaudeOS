# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in ClaudeOS, please report it
responsibly by opening a [GitHub Security Advisory](https://github.com/drleadflow/ClaudeOS/security/advisories/new) or emailing **security@drleadflow.com** with:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

Do NOT open a public issue for security vulnerabilities.

## Scope

ClaudeOS is a configuration template, not a runtime application. Security
concerns most likely involve:

- Hook scripts that could be exploited (e.g., command injection in `block-dangerous.sh`)
- Skills that execute untrusted input
- Secrets accidentally committed to the template
- CLAUDE.md instructions that could lead to unsafe agent behavior

## Security Practices

- The `block-dangerous.sh` PreToolUse hook blocks destructive bash patterns
- `.gitignore` excludes `CLAUDE.local.md`, sessions, and logs
- No secrets, API keys, or tokens are stored in committed files
- All credentials use environment variables
