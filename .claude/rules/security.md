# Security Rules

## Secrets
Never hardcode secrets in source code. Use environment variables or
secret managers. Validate required secrets at startup. Rotate any
that may have been exposed.

## Input Safety
- Parameterized queries only (no string-concatenated SQL)
- Sanitize all HTML output (XSS prevention)
- CSRF protection on all state-changing endpoints
- Rate limiting on all public endpoints

## Error Messages
Error messages must not leak sensitive data (stack traces, DB schemas,
internal paths, API keys).

## Before Any Commit
- No hardcoded secrets
- All user inputs validated
- Authentication/authorization verified
