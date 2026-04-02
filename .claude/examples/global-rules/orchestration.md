# Agent Orchestration — Manager-Worker Pattern

## Core Principle
When facing a task with multiple independent parts, ALWAYS use the Manager-Worker pattern:
- **1 Manager** (you, the main context) orchestrates and delegates
- **N Workers** (subagents) execute in parallel
- Workers report back to Manager, Manager synthesizes
- Workers NEVER ask the user directly — they ask Manager or research independently

## When to Use
- Task has 3+ independent subtasks → spawn parallel workers
- Task requires research before building → research agent first, then build agents
- Task touches multiple files/projects → one worker per project
- Bug has multiple possible causes → investigate each in parallel
- Review needed across codebase → one reviewer per area

## Manager Responsibilities
1. **Decompose**: Break the goal into independent, parallelizable tasks
2. **Assign**: Spawn one worker per task with clear instructions
3. **Coordinate**: Collect results, resolve conflicts, share learnings across workers
4. **Synthesize**: Combine worker outputs into coherent result
5. **Verify**: Check that the combined work actually achieves the goal

## Worker Rules
1. **Single purpose**: Each worker does ONE thing well
2. **Self-sufficient**: Include ALL context the worker needs in the prompt — it has no memory of prior conversation
3. **Research before asking**: If a worker doesn't know something, it spawns its own research subagent or uses WebSearch — it does NOT escalate to the user
4. **Report clearly**: Return structured results (what was done, what was found, any blockers)
5. **Fail gracefully**: If a worker fails, report the failure with diagnosis — don't retry blindly

## Scaling Pattern
```
Goal: Fix 20 issues
├── Manager: analyzes all 20, groups by independence
├── Wave 1 (parallel): Workers 1-5 (fully independent tasks)
├── Manager: reviews Wave 1 results, adjusts remaining tasks
├── Wave 2 (parallel): Workers 6-10 (may depend on Wave 1)
├── Wave 3 (parallel): Workers 11-15
├── Wave 4 (parallel): Workers 16-20
└── Manager: final verification, synthesize results
```

## Knowledge Sharing
When a worker discovers something useful for other workers:
1. Worker reports the finding to Manager
2. Manager includes that knowledge in subsequent worker prompts
3. If urgent: Manager can message running workers via SendMessage

## Auto-Research Pattern
When a worker encounters an unknown:
```
Worker hits unknown →
  1. Search codebase (Grep/Glob)
  2. If not found: search web (WebSearch)
  3. If not found: search memory files
  4. If still not found: report to Manager with what was tried
  5. Manager decides: research agent, or ask the user (LAST RESORT)
```

the user is the LAST resort, not the first. Exhaust all automated options before escalating.

## Worker Types
- **Builder**: writes code, creates files, implements features
- **Researcher**: searches web, reads docs, finds answers (READ ONLY)
- **Reviewer**: checks code quality, security, correctness (READ ONLY)
- **Tester**: runs tests, validates behavior (READ + EXECUTE)
- **Explorer**: navigates codebase, finds patterns (READ ONLY)

## Parallel Launch Template
When spawning multiple workers, ALWAYS use a single message with multiple Agent tool calls:
- Independent tasks → all workers in one message (true parallel)
- Dependent tasks → wave-based (Wave 1 completes before Wave 2 starts)
- Background tasks → use run_in_background for non-blocking work

## Anti-Patterns (NEVER do these)
- Sequential agents for independent tasks (wastes time)
- One giant agent doing everything (loses focus, bloats context)
- Workers asking the user for information they could research
- Workers modifying the same files (merge conflicts)
- Spawning agents without clear success criteria
