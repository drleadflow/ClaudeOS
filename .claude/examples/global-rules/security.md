# Security Guidelines

## Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management

- NEVER hardcode secrets in source code or shell config files
- All secrets live in `~/.env.secrets` (chmod 600, owner-only)
- `~/.env.secrets` is sourced by `~/.zshrc` — never put secrets directly in `.zshrc`
- `~/.gitignore_global` prevents accidental commits of `.env.secrets` and `*.secrets`
- Reference secrets as `$VAR_NAME` in code/config — never the raw value
- Validate that required secrets are present at startup
- Rotate any secrets that may have been exposed
- If you ever see a secret value in a file that could be committed, flag it IMMEDIATELY

## Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
