# Build Quality Standards

## From nodebestpractices + You-Dont-Know-JS + OWASP

### Async Patterns (critical for agents and API calls)
- Always use async/await over raw promises
- Never mix callbacks and promises
- Handle every promise rejection (unhandled rejections crash Node)
- Use Promise.allSettled for parallel calls where some may fail
- Use Promise.all only when ALL must succeed
- Set timeouts on every external call (default: 10s, max: 30s)

### Event Loop Awareness
- Never block the event loop with synchronous operations
- CPU-intensive work goes to worker threads or subprocesses
- Large file reads: use streams, not readFileSync
- JSON.parse on large payloads: validate size first
- Database queries: always use connection pooling

### TypeScript Strictness
- strict: true in every tsconfig.json (already enforced)
- No `any` types — use `unknown` and narrow
- Discriminated unions for state machines (agent states, workflow steps)
- Branded types for IDs (LocationId, ContactId) to prevent mixing
- Use zod for runtime validation at system boundaries

### API Design
- Consistent envelope: { success, data, error, meta }
- Always paginate list endpoints (default: 20, max: 100)
- Use cursor-based pagination over offset for large datasets
- Include rate limit headers in responses
- Version APIs from day one (/v1/, /v2/)

### Error Messages
- Internal errors: full stack trace + context (for debugging)
- External errors: human-readable message + error code (for users)
- Never expose: stack traces, SQL queries, file paths, internal IDs to end users
- Always include: what went wrong, what the user can do about it

### Dependency Management (pnpm era)
- Use pnpm for all projects (installed globally)
- Lock exact versions in production (pnpm-lock.yaml)
- Audit dependencies monthly: pnpm audit
- Remove unused dependencies: check with knip or depcheck
- Prefer well-maintained packages (>1K stars, recent commits, multiple contributors)

### Performance Defaults
- Lazy load: don't import/initialize until needed
- Debounce user input (300ms default)
- Throttle API calls (respect rate limits)
- Use connection pooling for databases
- Compress responses (gzip/brotli) for HTTP APIs
- Use streaming for large payloads

### Testing Checklist (before marking work complete)
- [ ] Happy path works
- [ ] Error cases handled (invalid input, network failure, timeout)
- [ ] Edge cases covered (empty arrays, null values, unicode)
- [ ] No hardcoded values (use constants or config)
- [ ] No secrets in code (use $ENV_VARS)
- [ ] Idempotent where claimed
