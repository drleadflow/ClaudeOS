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
| 5. Knowledge Base | External vault or docs | Full knowledge base as Claude's working directory. Every note ever written becomes available context. Example: an Obsidian vault with its own CLAUDE.md. | Always available when Claude runs from the vault |

### How to Set Up Layer 5 (Knowledge Base)

Layer 5 is optional but powerful. Point it at any directory of notes/docs:

1. Create a CLAUDE.md inside your knowledge base directory
2. Run `cd /path/to/your/vault && claude` to give Claude full access
3. The vault becomes a self-improving loop: more notes → more context → better analysis

Obsidian, Logseq, or any flat-file note system works. The key is that Claude can read and write to it.

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
  setup.sh                         # First-time setup script
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
      team-up.md                   # Invoke /team-up orchestrator
      vet-repo.md                  # Invoke /vet-repo security audit
      template-project.md          # Scaffold a new project from this template
    skills/                        # Repeatable tasks (folder-based)
      _template/                   # Canonical skill structure
        SKILL.md                   # Skill definition with gotchas section
        references/                # Examples, scripts, templates (progressive disclosure)
      team-up/                     # Auto-team orchestrator
        SKILL.md                   # Decomposes tasks, assigns workforce, runs waves
      vet-repo/                    # GitHub repo security audit
        SKILL.md                   # SAFE/CAUTION/DANGER rating before cloning
    workforce/                     # Persistent agent team (6 roles)
      researcher/                  # Web search, docs, codebase exploration
        profile.md                 # Role definition, tools, constraints
        memory.md                  # Persistent learnings across sessions
      builder/                     # Code implementation (git worktree isolation)
        profile.md
        memory.md
      reviewer/                    # Code quality, security, correctness
        profile.md
        memory.md
      tester/                      # Test execution, coverage validation
        profile.md
        memory.md
      auditor/                     # System health inspection via MCP
        profile.md
        memory.md
      ops/                         # Deployments, CI/CD, infrastructure
        profile.md
        memory.md
    rules/                         # Modular policy files (keeps CLAUDE.md lean)
      operations.md                # Deployments, destructive actions, resources
      platform-selection.md        # When to use Claude vs other AI platforms
      multi-platform-workflow.md   # 6-phase development lifecycle
      token-budgeting.md           # Cost management and monitoring
      team-evaluation.md           # Auto SOLO vs TEAM assessment
    errors/                        # Error log + promoted patterns
      LOG.md                       # Individual error entries
      PATTERNS.md                  # Recurring patterns (3+ occurrences)
    hindsight/                     # Layer 4: Behavioral pattern learning
      PATTERNS.md                  # Extracted patterns from past sessions
    logs/                          # Structured event/incident logs (git-ignored)
    hooks/                         # Automation scripts
      memory.sh                   # Layer 3: Git context injection (SessionStart)
      session-end.sh              # Layer 2: PRIMER.md rewriter (Stop)
      hindsight-extract.sh        # Layer 4: Pattern extraction (Stop)
      pre-compact.sh              # Archive transcript before compaction (PreCompact)
      block-dangerous.sh          # Safety guard for destructive commands (PreToolUse)
    sessions/                      # Auto-archived session transcripts (git-ignored)
```

## Directory Reference

### `CLAUDE.md` (this file)
Project-wide manifest. Keep it concise and high-level. Push detailed policies into `.claude/rules/` files. This file is version-controlled and shared across collaborators.

### `CLAUDE.local.md`
Personal overrides and experimental behavior. Git-ignored. Takes precedence over CLAUDE.md when instructions conflict. Use for testing new instructions before promoting to shared config. Delete entries once promoted.

To create your own:
```bash
cp CLAUDE.local.md.example CLAUDE.local.md
# Edit with your personal preferences
```

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
Error capture. `LOG.md` records individual failures. `PATTERNS.md` surfaces recurring issues (3+ occurrences).

### `.claude/hindsight/`
Behavioral learning. `PATTERNS.md` captures how Claude should respond differently based on past sessions.

### `.claude/logs/`
Structured event and incident logs from hooks. Git-ignored (can grow large).

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
Project-scoped MCP server configuration. Keeps integrations isolated from global config. Add your MCP servers here.

### Subdirectory CLAUDE.md Files
For larger projects, add `CLAUDE.md` files in subdirectories (e.g., `src/CLAUDE.md`, `tests/CLAUDE.md`, `infra/CLAUDE.md`). Claude discovers these lazily when working in that subtree. This provides fine-grained local guidance without bloating the root manifest.

## Agent Interaction Guidance

How agents, skills, and commands work together:
- **Commands** decide WHEN to run something (user-initiated via `/command`)
- **Skills** define WHAT gets done (auto-discoverable by Claude)
- **Agents** are the execution context that DOES the work (isolated context windows)

Prefer skills over commands for repeatable workflows. Use commands for side-effect operations that need explicit user initiation. Use agents when the work benefits from context isolation or specialized tool access.

## Included Skills

| Skill | Purpose | Sub-skills |
|-------|---------|------------|
| `team-up` | Auto-team orchestrator — decomposes tasks, assigns workforce roles, runs parallel waves | workforce profiles |
| `vet-repo` | Security audit GitHub repos before cloning — SAFE/CAUTION/DANGER rating | standalone |
| `yt-search` | Search YouTube, return structured results | standalone |
| `research-daemon` | Deep research via NotebookLM RAG + YouTube transcripts | yt-search, notebooklm |
| `youtube-pipeline` | End-to-end: search → NotebookLM → analysis → deliverables → vault | yt-search, research-daemon |
| `obsidian-markdown` | Create/edit Obsidian-flavored Markdown (wikilinks, embeds, callouts, properties) | standalone |
| `obsidian-bases` | Create/edit Obsidian Bases (.base files) with views, filters, formulas | standalone |
| `obsidian-cli` | Interact with Obsidian vaults via CLI (read, create, search, plugin dev) | standalone |
| `json-canvas` | Create/edit JSON Canvas files (.canvas) for visual maps and flowcharts | standalone |
| `_template` | Canonical skill structure for creating new skills | -- |

**Super skills** chain sub-skills into a single invocation.

## Workforce System

ClaudeOS includes a 6-role agent workforce with persistent memory. Each role has a defined identity, tool access, constraints, and reporting format. Memory persists across sessions so agents learn from past work.

| Role | Purpose | Access |
|------|---------|--------|
| **researcher** | Web search, docs, codebase exploration | Read-only |
| **builder** | Code implementation, feature building | Git worktree isolation |
| **reviewer** | Code quality, security, correctness | Read-only |
| **tester** | Test execution, coverage validation | Read + test files only |
| **auditor** | System health inspection via MCP | Read-only on all services |
| **ops** | Deployments, CI/CD, infrastructure | Full access with approval gates |

### How It Works

1. **Auto-evaluate**: Every non-trivial task is assessed as SOLO or TEAM (see `.claude/rules/team-evaluation.md`)
2. **Decompose**: Tasks are broken into independent subtasks and grouped into parallel waves
3. **Spawn**: Each agent gets its role profile, memory, task brief, and team context
4. **Execute**: Waves run in parallel — agents resolve unknowns autonomously before escalating
5. **Learn**: Each agent writes learnings to its `memory.md` after completing work
6. **Report**: Manager synthesizes results into a single coherent report

### Invoke Manually

```
/team-up "Build the new API endpoint with tests and deploy to staging"
/team-up "Audit all connected accounts for missing configurations"
```

Profiles: `.claude/workforce/{role}/profile.md`
Memory: `.claude/workforce/{role}/memory.md`

## Included Agents

| Agent | Purpose | Model | Tools |
|-------|---------|-------|-------|
| `self-critic` | Post-task quality check — did the work meet requirements? | sonnet | Read, Glob, Grep |
| `policy-refiner` | Self-improvement — analyzes patterns and proposes manifest updates | sonnet | Read, Glob, Grep, Write |
| `_template` | Canonical agent structure for creating new agents | -- | -- |

## Included Commands

| Command | Description |
|---------|-------------|
| `/team-up <description>` | Spin up a parallel agent team for a project |
| `/vet-repo <github-url>` | Security audit a GitHub repo before cloning |
| `/template-project <name> [path]` | Scaffold a new project from the ClaudeOS template |
| `/yt-search <query>` | Search YouTube from the terminal |
| `/youtube-pipeline <topic>` | Full research pipeline: YouTube → NotebookLM → Obsidian |
| `/update-context` | Trigger self-improvement: analyze sessions → propose updates → review |

## Multi-Platform Workflow

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
| `operations.md` | Deployments, destructive actions, resources |
| `platform-selection.md` | When to use Claude vs other AI platforms |
| `multi-platform-workflow.md` | 6-phase development lifecycle |
| `token-budgeting.md` | Agentic mode costs, monitoring, platform comparison |
| `team-evaluation.md` | Auto SOLO vs TEAM assessment, workforce roles |

**Note:** Common rules belong in your global `~/.claude/rules/common/` so they apply to all projects. This template ships 16 common rules and 5 TypeScript-specific rules as examples in `.claude/examples/`. Copy them to your global rules directory during setup. This template includes only rules specific to the ClaudeOS workflow in `.claude/rules/`. Add your own project-specific rules there.

## Getting Started

After cloning, run:
```bash
./setup.sh
```

This makes hooks executable and creates your personal config files. Then customize:

1. **Edit `CLAUDE.md`** — Replace this template content with your project-specific rules
2. **Edit `.mcp.json`** — Add your MCP servers (Supabase, Slack, GitHub, etc.)
3. **Create `CLAUDE.local.md`** — Personal overrides (git-ignored)
4. **Add skills** — Copy `.claude/skills/_template/` for each new skill
5. **Add agents** — Copy `.claude/agents/_template.md` for each new agent
6. **Start Claude** — `claude` and the 5-layer system activates automatically

## Status

All 5 memory layers implemented. Self-improvement loop (observe → reflect → commit) fully wired. Nine skills, two agents, six commands, five project rule files, six hooks built. 6-role workforce system with persistent memory. 16 common global rules + 5 TypeScript global rules shipped as examples. Multi-platform workflow architecture documented.
