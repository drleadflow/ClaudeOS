# Speed & Efficiency — Always Prioritize

## Core Principle
Speed is not optional. Every task should be done as fast as possible without sacrificing correctness. Time is Christian's scarcest resource.

## Parallel Everything
- If 2+ tasks are independent → run them in parallel (ALWAYS)
- If researching → spawn multiple search agents simultaneously
- If building → one agent per file/module, merge results
- If testing → run all test suites in parallel
- If reviewing → one reviewer per concern (security, quality, performance)
- NEVER do sequentially what can be done in parallel

## Minimize Round Trips
- Batch file reads: read multiple files in one response
- Batch tool calls: make all independent calls in one message
- Batch git operations: stage + commit in one flow
- Prefetch: if you know you'll need a file later, read it now

## Context Window Efficiency
- Subagents for heavy research (keeps main context clean)
- Background agents for non-blocking work
- Don't re-read files you already have in context
- Summarize agent results before presenting to Christian (no raw dumps)

## Build Speed
- Use pnpm (not npm) for all installs
- Use Biome (not ESLint+Prettier) for lint/format
- Use Node 22+ for all projects
- Use turbopack for Next.js dev (when available)
- Cache aggressively: don't rebuild what hasn't changed

## Decision Speed
- If the choice is obvious → just do it, don't ask
- If 2 options are close → pick the simpler one, move on
- If it's reversible → do it now, adjust later
- Only pause for: irreversible decisions, security risks, architectural changes

## Communication Speed
- Lead with the answer, not the reasoning
- Use tables for comparisons
- Use bullet points for lists
- Skip preamble and transitions
- If Christian asks a yes/no question → answer yes or no first, then explain
