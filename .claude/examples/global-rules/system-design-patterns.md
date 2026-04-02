# System Design Patterns

## Caching Strategy
Before making any external API call (GHL, Airtable, Slack, etc.):
- Check if the data changes frequently — if not, cache it
- Use in-memory cache for session-scoped data (TTL: session lifetime)
- Use file-based cache for cross-session data (TTL: configurable)
- Cache keys: `${service}_${endpoint}_${params_hash}`
- Always cache: schema/metadata, user profiles, pipeline definitions, calendar configs
- Never cache: real-time data (messages, notifications, live metrics)

## Circuit Breaker Pattern
When calling external services that may fail:
- Track consecutive failures per service
- After 3 failures: open circuit, stop calling, return cached/fallback data
- After cooldown (60s): half-open, try one call
- On success: close circuit, resume normal
- Apply to: GHL API, Slack API, Airtable, any webhook endpoint
- Log every circuit state change

## Rate Limiting Awareness
- GHL API: respect rate limits, batch where possible
- Implement exponential backoff: 1s, 2s, 4s, 8s, max 30s
- Batch API calls when fetching lists (use pagination, not individual fetches)
- Prefer bulk endpoints over loops of single-item calls

## Message Queue Pattern (Agent Communication)
When building multi-agent workflows:
- Agents communicate through defined interfaces, not shared state
- Each agent owns its data — others request via tools/APIs
- Use event-driven patterns: agent publishes result, subscribers react
- Never have Agent A directly modify Agent B's state

## Microservice Principles (MCP Servers)
Each MCP server is a microservice. Apply:
- Single responsibility: one service, one domain
- Health checks: every service should report its status
- Graceful degradation: if a tool fails, return useful error, don't crash the server
- Idempotency: repeated calls with same input = same result
- Versioning: never break existing tool interfaces without migration path

## Database Patterns
- Repository pattern for all data access (abstract the storage)
- Immutable records where possible (append, don't update)
- Soft delete (is_active flag) over hard delete
- Always include created_at and updated_at timestamps
- Use transactions for multi-step operations
- Index columns used in WHERE clauses

## Error Handling Hierarchy
1. **Retry** (transient): network timeout, rate limit, 503
2. **Fallback** (degraded): use cached data, skip non-critical feature
3. **Escalate** (systemic): auth failure, schema change, data corruption
4. **Never**: silently swallow errors or return fake success
