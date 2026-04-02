# Agent Architecture Patterns

## Agent Design (from CrewAI/LangChain/Mastra research)

### Every agent has:
- **Role**: one clear responsibility (not "do everything")
- **Goal**: measurable outcome (not "help the user")
- **Tools**: explicit list of what it can access
- **Memory**: what it remembers between invocations
- **Constraints**: what it cannot do (autonomy boundary)

### Agent Communication
- Agents talk through structured interfaces (MCP tools, function calls)
- Never share mutable state between agents
- Use the Mediator pattern: a coordinator routes messages, agents don't call each other directly
- Every agent output is typed and validated

### Self-Learning Pattern (Reflexion)
After every significant task:
1. Did it succeed or fail?
2. If failed: what went wrong? (natural language reflection)
3. Store the reflection as a memory (type: correction or pattern)
4. Before next similar task: search for relevant reflections
5. Apply learned lessons to approach

### Memory Types for Agents
- **Fact**: "GHL API uses locationId not location_id"
- **Decision**: "We chose sqlite-vec over Pinecone"
- **Preference**: "The user prefers short messages"
- **Correction**: "The Slack tool name is slack_read_channel not read_channel"
- **Pattern**: "When building MCP servers, test stdio transport first"

### Orchestration Patterns
- **Sequential**: Task A → Task B → Task C (use when order matters)
- **Parallel**: Tasks A, B, C simultaneously (use when independent)
- **Conditional**: If X then Task A, else Task B (use for branching logic)
- **Iterative**: Repeat Task A until condition met (use for convergence)
- Always prefer parallel over sequential when tasks are independent

## Building MCP Servers
- Use stdio transport for local servers (simplest, fastest)
- Use HTTP/SSE transport for remote servers (Cloudflare Workers)
- Every tool has: name, description, input schema (zod), handler
- Tool names are snake_case with service prefix (ghl_list_contacts)
- Never duplicate tool registrations (McpServer.tool() throws on duplicates)
- Return structured JSON, not free text
- Include error details in tool responses (don't throw)

## Subagent Strategy
- Use subagents liberally to keep main context clean
- One task per subagent for focused execution
- Parallel subagents for independent research/analysis
- Background subagents for non-blocking work
- Always specify what the subagent should RETURN (not just what it should do)
