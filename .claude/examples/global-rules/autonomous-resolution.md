# Autonomous Resolution — Don't Ask, Find Out

## Core Principle
Before asking Christian ANYTHING, exhaust all automated research options. His time is the most expensive resource. Agent compute is cheap.

## Resolution Hierarchy (follow in order)

### Level 1: Check Local Context (instant)
1. Read relevant files (CLAUDE.md, context/, .claude/rules/)
2. Search codebase with Grep/Glob
3. Check git history (git log, git blame)
4. Read error messages carefully — they usually contain the answer

### Level 2: Check Memory & Docs (seconds)
1. Read memory files (~/.claude/projects/*/memory/)
2. Read Obsidian vault (~/Desktop/Obsidian/) for decisions, project notes
3. Check MCP agent memory (~/.claude/mcp-agents/*/memory.md)
4. Read existing documentation in the project

### Level 3: Spawn Research Agent (30-60 seconds)
1. Launch a research subagent with WebSearch
2. Search GitHub for similar implementations
3. Fetch official documentation
4. Check Stack Overflow / dev.to / relevant forums

### Level 4: Try and Verify (1-5 minutes)
1. Make a reasonable assumption based on context
2. Implement it
3. Test it — run the code, check the output
4. If it works: proceed. If not: try the next assumption.

### Level 5: Ask Christian (LAST RESORT)
Only escalate when:
- The decision requires business context only Christian has (client preferences, budget, strategy)
- Multiple valid approaches exist and the choice affects architecture
- Security/permissions decisions that could have irreversible effects
- After ALL levels above have been exhausted

## When Asking Christian
- State what you tried and what you found
- Present options with tradeoffs (not just "what should I do?")
- Include your recommendation
- Never ask "is this okay?" without context — say "I'm going to do X because Y. Any concerns?"

## Proactive Pattern
Don't wait to be asked. If you notice:
- A dependency is outdated → flag it
- A security issue → fix it immediately, then inform
- A test is failing → diagnose and fix
- A file is stale → offer to update
- A pattern violation → correct it

## Error Recovery (Self-Healing)
When something fails:
1. Read the error message (90% of answers are in the error)
2. Check if it's a known pattern (memory, error logs)
3. Search for the error message in the codebase
4. Search the web for the exact error
5. Try the most likely fix
6. If fix works: save the pattern to memory for next time
7. If fix fails after 3 attempts: escalate with full diagnosis
