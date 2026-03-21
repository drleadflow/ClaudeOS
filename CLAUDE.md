# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What Is ClaudeOS

ClaudeOS is the reference template for structuring a Claude Code project to maximize performance. It defines the directory layout, memory architecture, self-improvement loop, configuration patterns, and conventions that every new project should start from. The goal is a single, opinionated scaffold that eliminates setup friction and ensures Claude operates at its best from the first prompt.

This repo serves two purposes:
1. **The template itself** — clone or copy this structure when starting any new project.
2. **The living spec** — the design and rationale behind each component lives here and evolves as best practices are discovered.

This is a **living document**. It evolves as failure modes are observed and new patterns are validated. Use `/update-context` to trigger the self-improvement cycle.

## Memory Architecture (5 Layers)

Claude's effectiveness depends on layered context. Each layer does something the others cannot.

| Layer | File | Purpose | When It Runs |
|-------|------|---------|-------------|
| 1. Rules | `CLAUDE.md` + `.claude/rules/` | Permanent rules and preferences. Does not change session-to-session. Tells Claude who it is. Keep this file concise — push detail into modular rules. | Always loaded |
| 2. Primer | `.claude/PRIMER.md` | Session handoff. Rewrites itself at the end of every session: active project, last completed, next steps, open blockers. Always current. | Always loaded |
| 3. Memory | `.claude/hooks/memory.sh` | Live context injection. Last 5 git commits, modified files, current branch. Claude knows what changed before you say a word. | SessionStart hook |
| 4. Hindsight | `.claude/hindsight/PATTERNS.md` | Behavioral patterns extracted from previous sessions. Not what happened — how Claude should respond differently. Actual learning. | Always loaded + Stop hook extracts new patterns |
| 5. Knowledge Base | Obsidian vault (`~/Desktop/Obsidian/Obsidian/`) | Full knowledge base as Claude's working directory. Every note ever written becomes available context. Has its own CLAUDE.md (brain within the brain). | Always available when Claude runs from the vault |

## Self-Improvement Loop

ClaudeOS improves itself through a three-phase cycle:

### 1. Observation
Hooks capture signals about what happened during a session:
- `memory.sh` (SessionStart) — what changed since last session
- `pre-compact.sh` (PreCompact) — archives state before compaction
- `session-end.sh` (Stop) — captures what was accomplished
- `hindsight-extract.sh` (Stop) — extracts behavioral patterns
- Error logging captures failures and recurring issues

### 2. Reflection
The policy-refiner agent analyzes accumulated evidence:
- Error logs and patterns for recurring failures
- Hindsight patterns for behavioral improvements
- CLAUDE.md and rules for staleness or contradiction
- Session history for missing guidance

### 3. Commitment
Changes are proposed and applied under review:
- `/update-context` triggers the reflection cycle
- Policy-refiner proposes changes with evidence and risk assessment
- User reviews and approves before any manifest is modified
- New policies go to `.claude/rules/` (not CLAUDE.md) to prevent bloat
- Use `CLAUDE.local.md` for experiments before promoting to shared config

**Log first, update later.** Observation hooks primarily log. The reflection and update cycle happens separately, keeping live sessions fast.

## Context Management

These rules ensure Claude uses its context window efficiently.

### Token Budgeting
Agentic mode consumes 10-100x more tokens than standard chat. A single complex task generates 8-12 internal API calls (50,000-150,000 tokens). Use `/tokens` to monitor. Scope tasks narrowly to avoid hitting rate limits mid-work. See `.claude/rules/token-budgeting.md` for full guidance.

### Attempt Budget
When pursuing a goal, track attempts internally. When multiple attempts fail without meaningful progress: stop, declare explicitly what was tried and why each failed, and re-plan with the user. Never silently escalate to increasingly lateral strategies without declaring the loop first.

### Subagent Output Discipline
Subagents return condensed summaries — target 1,000-2,000 tokens max. Include only: verdict, summary, failures/findings, and artifact list. Never return passing test logs, full file contents, or raw tool output. The parent context window is finite.

### Tool Result Clearing
Once a tool result has been processed and its content incorporated into reasoning, treat the raw result as consumed. Do not re-read it or reference it again unless the task specifically requires it. Processed tool outputs accumulate and consume context.

### In-Flight Notes
For any task spanning 3+ exchanges, maintain `tasks/NOTES.md` with: current task, decisions made, rejected approaches, active state, blockers, and next step. Update after each significant action. This enables coherence across context resets and compaction.

### Summary Instructions
When summarizing this conversation (during compaction), always preserve:
- Current task objective and acceptance criteria
- File paths that have been read or modified
- Decisions made and the reasoning behind them
- Unresolved bugs and their current state
- Implementation details that future steps depend on

Discard: redundant tool outputs, passing test logs, superseded plans.

## Project Structure

```
ClaudeOS/
  CLAUDE.md                        # Layer 1: Permanent rules (this file)
  CLAUDE.local.md                  # Personal overrides (git-ignored)
  .gitignore                       # Ignores local files, logs, sessions
  .mcp.json                        # Project-scoped MCP server config
  tasks/
    NOTES.md                       # In-flight decision tracking
  .claude/
    PRIMER.md                      # Layer 2: Session handoff (auto-updated)
    settings.json                  # Hook wiring for all layers
    agents/                        # Specialist subagents
      _template.md                 # Canonical agent structure
      self-critic.md               # Post-task quality check
      policy-refiner.md            # Self-improvement: proposes manifest updates
    commands/                      # Slash commands
      update-context.md            # Gated self-improvement workflow
    skills/                        # Repeatable tasks (folder-based)
      _template/                   # Canonical skill structure
        SKILL.md                   # Skill definition with gotchas section
        references/                # Examples, scripts, templates (progressive disclosure)
    rules/                         # Modular policy files (keeps CLAUDE.md lean)
      coding-style.md              # Immutability, file org, error handling
      testing.md                   # TDD, coverage, test isolation
      security.md                  # Secrets, input safety, error messages
      operations.md                # Deployments, destructive actions, resources
    errors/                        # Error log + promoted patterns
    hindsight/                     # Layer 4: Behavioral pattern learning
      PATTERNS.md                  # Extracted patterns from past sessions
    logs/                          # Structured event/incident logs (git-ignored)
    hooks/                         # Automation scripts
      memory.sh                   # Layer 3: Git context injection (SessionStart)
      session-end.sh              # Layer 2: PRIMER.md rewriter (Stop)
      hindsight-extract.sh        # Layer 4: Pattern extraction (Stop)
      pre-compact.sh              # Archive transcript before compaction (PreCompact)
    sessions/                      # Auto-archived session transcripts (git-ignored)
```

## Directory Reference

### `CLAUDE.md` (this file)
Project-wide manifest. Keep it concise and high-level. Push detailed policies into `.claude/rules/` files. This file is version-controlled and shared across collaborators.

### `CLAUDE.local.md`
Personal overrides and experimental behavior. Git-ignored. Takes precedence over CLAUDE.md when instructions conflict. Use for testing new instructions before promoting to shared config. Delete entries once promoted.

### `.claude/PRIMER.md`
Session handoff document. Rewritten at the end of every session by the Stop hook. Contains: active project, last completed task, next steps, open blockers, and session notes. Ensures Claude picks up exactly where the last session left off.

### `.claude/rules/`
Modular policy files that Claude discovers recursively. These keep CLAUDE.md lean while maintaining enforcement. When a new policy is identified, prefer adding a short entry here over expanding the main manifest. Subdirectories can scope rules to specific domains (e.g., `rules/frontend/`, `rules/backend/`).

### `.claude/agents/`
Subagent definitions. Each agent is a markdown file with YAML frontmatter.

Key conventions:
- `tools:` scopes tool access (omit to inherit all)
- `memory: project` enables persistent cross-session knowledge
- `effort:` controls reasoning depth (low for explorers, high for complex work)
- `isolation: worktree` for safe experimentation in isolated git worktrees
- MCP servers scoped inline via `mcpServers:` reduces context pollution
- Skills NOT inherited — list explicitly in `skills:` frontmatter
- Subagents cannot spawn other subagents (no nesting)
- System prompts use `<background_information>` + `<instructions>` sections
- All agents include Step 0 startup protocol and compact output format (max 1,500 tokens)

### `.claude/commands/`
Slash commands invoked via `/<name>`. Use `disable-model-invocation: true` for commands with side effects.

### `.claude/skills/`
Folder-based skills with three-level progressive loading:
1. **Metadata** (name + description) — always in context (~100 tokens per skill)
2. **Instructions** (SKILL.md body) — loaded on trigger (< 500 lines)
3. **Resources** (supporting files) — loaded only when referenced

Write descriptions in third person with trigger phrases. Claude undertriggers by default — include "Use when..." phrasing. The **Gotchas** section is the most important part of any skill.

Two skill categories: **Capability Uplift** (gives Claude abilities it lacks — web scraping, browser testing, PDF creation) and **Encoded Preference** (guides Claude to follow team-specific workflows — TDD, commit formats, review checklists). Skills are an open standard — they work across Claude Code, Gemini CLI, Codex CLI, and Cursor without modification.

### `.claude/errors/`
Error capture. `LOG.md` records failures. `PATTERNS.md` surfaces recurring issues (3+).

### `.claude/hindsight/`
Behavioral learning. `PATTERNS.md` captures how Claude should respond differently based on past sessions.

### `.claude/logs/`
Structured event and incident logs from hooks. Git-ignored (can grow large). Files: `events.jsonl`, `incidents.jsonl`.

### `.claude/hooks/`
Automation wired via `settings.json`:
- **block-dangerous.sh** (PreToolUse/Bash) — blocks destructive commands (rm -rf, fork bombs, pipe-to-shell, dd to disk)
- **memory.sh** (SessionStart) — injects git state
- **session-end.sh** (Stop) — rewrites PRIMER.md
- **hindsight-extract.sh** (Stop) — extracts behavioral patterns
- **pre-compact.sh** (PreCompact) — archives session state (observability only, cannot block)

### `tasks/NOTES.md`
In-flight decision tracking for complex tasks. Enables coherence across context resets.

### `.mcp.json`
Project-scoped MCP server configuration. Keeps integrations isolated from global config.

### Subdirectory CLAUDE.md Files
For larger projects, add `CLAUDE.md` files in subdirectories (e.g., `src/CLAUDE.md`, `tests/CLAUDE.md`, `infra/CLAUDE.md`). Claude discovers these lazily when working in that subtree. This provides fine-grained local guidance without bloating the root manifest.

## Agent Interaction Guidance

How agents, skills, and commands work together:
- **Commands** decide WHEN to run something (user-initiated via `/command`)
- **Skills** define WHAT gets done (auto-discoverable by Claude)
- **Agents** are the execution context that DOES the work (isolated context windows)

Prefer skills over commands for repeatable workflows. Use commands for side-effect operations that need explicit user initiation. Use agents when the work benefits from context isolation or specialized tool access.

## Skills

| Skill | Purpose | Sub-skills |
|-------|---------|------------|
| `yt-search` | Search YouTube, return structured results | standalone |
| `research-daemon` | Deep research via NotebookLM RAG + YouTube transcripts | yt-search, notebooklm |
| `youtube-pipeline` | End-to-end: search → NotebookLM → analysis → deliverables → vault | yt-search, research-daemon |
| `_template` | Canonical skill structure for creating new skills | -- |

**Super skills** chain sub-skills into a single invocation.

## Agents

| Agent | Purpose | Model | Tools |
|-------|---------|-------|-------|
| `self-critic` | Post-task quality check — did the work meet requirements? | sonnet | Read, Glob, Grep |
| `policy-refiner` | Self-improvement — analyzes patterns and proposes manifest updates | sonnet | Read, Glob, Grep, Write |
| `_template` | Canonical agent structure for creating new agents | -- | -- |

## Commands

| Command | Description |
|---------|-------------|
| `/yt-search <query>` | Search YouTube from the terminal |
| `/youtube-pipeline <topic>` | Full research pipeline: YouTube → NotebookLM → Obsidian |
| `/update-context` | Trigger self-improvement: analyze sessions → propose updates → review |

## Obsidian Integration (Layer 5)

The Obsidian vault at `~/Desktop/Obsidian/Obsidian/` is Claude's knowledge base. When Claude runs from the vault, every note is available as context.

- **CLAUDE.md** inside the vault is the "brain within the brain"
- **research/** directory holds pipeline output as Obsidian-compatible markdown with `[[wikilinks]]`
- The vault is a self-improving loop: more research → more context → better analysis → updated CLAUDE.md → repeat

To use: `cd ~/Desktop/Obsidian/Obsidian && claude`

## Agent Teams (Experimental)

Agent teams are a separate primitive from subagents. Each teammate is an independent Claude Code session with its own context window.

- Enable: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Sweet spot: 3-5 teammates, 5-6 tasks per teammate
- Each teammate must own non-overlapping files
- Use `TaskCompleted` hooks for quality gates
- Use `TeammateIdle` hooks to keep teammates working or shut them down
- Token cost scales with team size (up to ~7x in plan mode)

Default to subagents for most work. Use teams only for adversarial research, non-overlapping parallel work, or when inter-agent messaging adds value.

## Multi-Platform Development

ClaudeOS is Claude Code-primary but designed for a multi-AI workflow. Different platforms excel at different tasks — use each for its core strength.

See `.claude/rules/` for full guidance:
- `platform-selection.md` — decision framework for when to use which AI
- `multi-platform-workflow.md` — 6-phase development lifecycle across platforms
- `token-budgeting.md` — cost management and monitoring

**Quick reference:** Claude Code for implementation, Perplexity for real-time research, Gemini for breadth (1M context), OpenAI for security auditing and multimodal analysis.

## Operational Guardrails

- Never auto-commit. Only commit when explicitly asked.
- Never push to remote unless explicitly asked.
- Never run destructive operations without user confirmation.
- PreToolUse hook blocks dangerous bash patterns automatically (rm -rf, fork bombs, pipe-to-shell).
- Use dedicated commands instead of raw CLI tools for deployments.
- Secrets in env vars only — never hardcoded.
- Detailed policies live in `.claude/rules/`.

## Rules Reference

| Rule File | Domain |
|-----------|--------|
| `coding-style.md` | Immutability, file org, error handling |
| `testing.md` | TDD, coverage, test isolation |
| `security.md` | Secrets, input safety, error messages |
| `operations.md` | Deployments, destructive actions, resources |
| `platform-selection.md` | When to use Claude vs OpenAI vs Gemini vs Perplexity |
| `multi-platform-workflow.md` | 6-phase development lifecycle across platforms |
| `token-budgeting.md` | Agentic mode costs, monitoring, platform comparison |

## Status

All 5 memory layers implemented. Self-improvement loop (observe → reflect → commit) fully wired. Three skills, two agents, three commands, seven rule files, five hooks built. Multi-platform workflow architecture documented. Research-verified against 7 official Anthropic sources + cross-platform comparison analysis.
