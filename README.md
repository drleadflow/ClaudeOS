# ClaudeOS

The reference template for structuring Claude Code projects to maximize performance. Clone it, run setup, and Claude operates at its best from the first prompt.

**Works on macOS, Linux, and Windows.**

## The Problem

Every Claude Code session starts from zero. No memory of past sessions, no behavioral learning, no context about what changed. You re-brief Claude every time.

## The Solution

ClaudeOS gives Claude a 5-layer memory system that activates automatically:

| Layer | What It Does | How It Works |
|-------|-------------|--------------|
| **1. Rules** | Permanent project instructions | `CLAUDE.md` + `.claude/rules/` — always loaded |
| **2. Primer** | Session-to-session handoff | `.claude/PRIMER.md` — auto-rewritten every session end |
| **3. Memory** | Live git context | `memory.sh` hook — injects branch, commits, modified files at session start |
| **4. Hindsight** | Behavioral learning | `PATTERNS.md` — extracts how Claude should behave differently, not just what happened |
| **5. Knowledge Base** | External vault | Any note system (Obsidian, etc.) — full knowledge base as context |

Plus a **self-improvement loop**: hooks observe what happens -> policy-refiner agent analyzes patterns -> `/update-context` proposes changes -> you approve.

## Quick Start

### macOS / Linux

```bash
# Clone
git clone https://github.com/drleadflow/ClaudeOS.git my-project
cd my-project

# Setup (makes hooks executable, creates personal config files)
chmod +x setup.sh
./setup.sh

# Go
claude
```

### Windows

**Option A: PowerShell (recommended)**
```powershell
# Clone
git clone https://github.com/drleadflow/ClaudeOS.git my-project
cd my-project

# Setup
.\setup.ps1
# If blocked by execution policy:
# powershell -ExecutionPolicy Bypass -File .\setup.ps1

# Go
claude
```

**Option B: Double-click**
```
# Clone the repo, then double-click setup.bat
# It runs setup.ps1 automatically
```

**Option C: WSL / Git Bash**
```bash
# If you have WSL or Git Bash, use the Linux instructions
./setup.sh
```

> **Windows prerequisite:** ClaudeOS hooks use bash scripts. You need one of:
> - **Git for Windows** (recommended — includes Git Bash, which Claude Code can use)
> - **WSL** (`wsl --install` from an admin PowerShell)
>
> If you already have `git` installed on Windows, you almost certainly have Git Bash.

### Then Customize

1. Edit `CLAUDE.md` with your project-specific rules
2. Edit `.mcp.json` to add your MCP servers (Supabase, Slack, GitHub, etc.)
3. Edit `CLAUDE.local.md` with personal preferences (git-ignored)

That's it. The 5-layer system activates automatically when Claude starts.

## What Happens Automatically

Once set up, every Claude session gets:

1. **Session Start** — `memory.sh` injects current branch, last 5 commits, modified files, untracked count
2. **During Session** — Claude follows rules from `CLAUDE.md` + `.claude/rules/`, tracks in-flight decisions in `tasks/NOTES.md`
3. **Before Compaction** — `pre-compact.sh` archives session state so nothing is lost
4. **Session End** — `session-end.sh` rewrites `PRIMER.md` with what was done and what's next; `hindsight-extract.sh` extracts behavioral patterns
5. **Next Session** — Claude reads the updated `PRIMER.md` and `PATTERNS.md`, picking up exactly where you left off

## What's Included

| Component | Count | Details |
|-----------|-------|---------|
| **Hooks** | 6 | SessionStart (git context), Stop (session handoff + hindsight + Obsidian autolog), PreCompact (archive), PreToolUse (safety guard) |
| **Agents** | 2 + template | self-critic (quality check), policy-refiner (self-improvement) |
| **Workforce** | 6 roles | researcher, builder, reviewer, tester, auditor, ops — persistent memory per role |
| **Skills** | 9 + template | team-up, vet-repo, yt-search, research-daemon, youtube-pipeline, obsidian-markdown, obsidian-bases, obsidian-cli, json-canvas |
| **Commands** | 6 | /team-up, /vet-repo, /template-project, /yt-search, /youtube-pipeline, /update-context |
| **Rules** | 5 | operations, platform-selection, multi-platform-workflow, token-budgeting, team-evaluation |
| **Global Rule Examples** | 16 common + 5 TypeScript | Coding style, testing, security, orchestration, speed, deviation prevention, and more |
| **Hindsight Patterns** | 4 | Loop detection, structural analysis, compact output, file ownership |
| **Obsidian Integration** | 4 skills + 1 hook | Markdown, Bases, CLI, Canvas skills + daily note autolog hook |

## Project Structure

```
ClaudeOS/
  CLAUDE.md                        # Layer 1: Project manifest (edit this)
  CLAUDE.local.md                  # Personal overrides (git-ignored, created by setup)
  setup.sh                         # Setup for macOS / Linux
  setup.ps1                        # Setup for Windows (PowerShell)
  setup.bat                        # Setup for Windows (double-click launcher)
  .mcp.json                        # MCP server config (add yours here)
  tasks/NOTES.md                   # In-flight decision tracking
  .claude/
    PRIMER.md                      # Layer 2: Auto-updated session handoff
    settings.json                  # Hook wiring (pre-configured)
    agents/                        # self-critic, policy-refiner, _template
    commands/                      # /team-up, /vet-repo, /template-project, /yt-search, /youtube-pipeline, /update-context
    skills/                        # team-up, vet-repo, yt-search, research-daemon, youtube-pipeline, obsidian-*, json-canvas, _template
    workforce/                     # 6-role agent team with persistent memory
      researcher/                  # profile.md + memory.md
      builder/                     # profile.md + memory.md
      reviewer/                    # profile.md + memory.md
      tester/                      # profile.md + memory.md
      auditor/                     # profile.md + memory.md
      ops/                         # profile.md + memory.md
    rules/                         # 5 modular policy files (add your own here)
    hooks/                         # 5 automation scripts (bash)
    hindsight/PATTERNS.md          # Layer 4: Behavioral learning
    errors/                        # Error log + pattern promotion
    logs/                          # Event logs (git-ignored)
    sessions/                      # Archived transcripts (git-ignored)
```

## Workforce System

ClaudeOS includes a 6-role agent team that can be orchestrated via `/team-up`:

| Role | What It Does | Access Level |
|------|-------------|--------------|
| **researcher** | Web search, docs, codebase exploration | Read-only |
| **builder** | Code implementation, feature building | Git worktree (isolated) |
| **reviewer** | Code quality, security, correctness | Read-only |
| **tester** | Test execution, coverage validation | Read + test files only |
| **auditor** | System health inspection via MCP tools | Read-only on services |
| **ops** | Deployments, CI/CD, infrastructure | Full access with gates |

Each role has a **profile** (identity, tools, constraints, reporting format) and **memory** (learnings that persist across sessions). When you run `/team-up`, Claude:

1. Decomposes your task into subtasks
2. Assigns the right roles
3. Spawns agents in parallel waves
4. Collects results and synthesizes a report
5. Saves learnings for next time

```bash
# Example
/team-up "Build a REST API with auth, tests, and deploy to staging"
# → spawns: 1 researcher + 2 builders + 1 reviewer + 1 tester + 1 ops
```

## Security Auditing

Before cloning any GitHub repo, run `/vet-repo` to get a security rating:

```bash
/vet-repo https://github.com/some-org/some-repo
# → checks: ownership, activity, license, install scripts, dependencies, entry points, secrets
# → returns: SAFE / CAUTION / DANGER
```

## Scaffolding New Projects

Create a new project from the ClaudeOS template:

```bash
/template-project my-new-project
/template-project my-new-project ~/Desktop/projects/
# → copies full ClaudeOS structure including workforce, skills, hooks, agents
# → initializes git
```

## Extending ClaudeOS

### Add a Skill
```bash
cp -r .claude/skills/_template .claude/skills/my-skill
# Edit .claude/skills/my-skill/SKILL.md
```

### Add an Agent
```bash
cp .claude/agents/_template.md .claude/agents/my-agent.md
# Edit the frontmatter and instructions
```

### Add a Rule
Create a new `.md` file in `.claude/rules/`. Claude discovers them recursively.

### Add MCP Servers
Edit `.mcp.json` to connect external services (Supabase, Slack, GitHub, etc.).

### Set Up Layer 5 (Knowledge Base / Obsidian)

ClaudeOS includes 4 Obsidian skills out of the box: `obsidian-markdown`, `obsidian-bases`, `obsidian-cli`, and `json-canvas`. These give Claude full fluency with Obsidian-flavored Markdown, Bases databases, the Obsidian CLI, and Canvas files.

**Connect your vault:**
```bash
# Add a CLAUDE.md to your vault
echo "# Knowledge Base" > ~/my-vault/CLAUDE.md
# Run Claude from the vault
cd ~/my-vault && claude
```

**Enable auto-logging to daily notes (optional):**

The `obsidian-autolog.sh` hook automatically logs session summaries to your Obsidian daily note at session end.

1. Edit `.claude/hooks/obsidian-autolog.sh` and set `OBSIDIAN_VAULT` to your vault path
2. Add this Stop hook to `.claude/settings.json` inside the `"Stop"` array:

```json
{
  "hooks": [
    {
      "type": "command",
      "command": "bash .claude/hooks/obsidian-autolog.sh"
    }
  ]
}
```

## Global Rules (Optional Power-Up)

ClaudeOS works great as a project template. But you can also install **global rules** that apply to every Claude Code project on your machine. These enforce coding style, testing standards, security checks, orchestration patterns, and workflow discipline across all repos.

### Install Global Rules

```bash
# Create the global rules directories
mkdir -p ~/.claude/rules/common
mkdir -p ~/.claude/rules/typescript

# Copy common rules (apply to all projects)
cp -r .claude/examples/global-rules/* ~/.claude/rules/common/

# Copy TypeScript rules (apply to TS/JS projects)
cp -r .claude/examples/typescript-rules/* ~/.claude/rules/typescript/
```

### Common Rules (16 files — all projects)

| Rule File | What It Enforces |
|-----------|------------------|
| `coding-style.md` | Immutability, small files, error handling, input validation |
| `testing.md` | 80% coverage minimum, TDD workflow (red/green/refactor) |
| `security.md` | No hardcoded secrets, SQL injection prevention, OWASP checks |
| `git-workflow.md` | Conventional commits, PR process |
| `development-workflow.md` | Research -> plan -> TDD -> review -> commit pipeline |
| `performance.md` | Model selection (Haiku/Sonnet/Opus), context management |
| `agents.md` | When to use which agent, parallel execution patterns |
| `hooks.md` | Hook types, auto-accept permissions, TodoWrite best practices |
| `patterns.md` | Repository pattern, API response format, skeleton projects |
| `speed-efficiency.md` | Parallel everything, minimize round trips, batch operations |
| `autonomous-resolution.md` | 5-level resolution hierarchy — exhaust automated options before asking the user |
| `orchestration.md` | Manager-Worker pattern, wave-based parallel execution, worker rules |
| `build-quality.md` | Async patterns, event loop safety, TypeScript strictness, API design, dependency management |
| `system-design-patterns.md` | Caching, circuit breaker, rate limiting, message queues, microservice principles |
| `agent-architecture.md` | Agent design (role/goal/tools/memory/constraints), self-learning, MCP server patterns |
| `deviation-prevention.md` | RALPH loop, scope lock, red flags table, loop protection for autonomous execution |

### TypeScript Rules (5 files — TS/JS projects)

| Rule File | What It Enforces |
|-----------|------------------|
| `coding-style.md` | TypeScript-specific style: strict mode, branded types, discriminated unions |
| `testing.md` | Vitest patterns, test file organization, mock best practices |
| `patterns.md` | TypeScript design patterns, type utilities, error handling patterns |
| `hooks.md` | TypeScript-specific hook patterns, type-safe event handling |
| `security.md` | TypeScript security: input validation with zod, safe type narrowing |

These are **optional** — ClaudeOS works without them. But if you want Claude to follow consistent standards across every project, they're a one-time setup.

### Customize

Edit any file in `~/.claude/rules/common/` or `~/.claude/rules/typescript/` to match your preferences. Claude reads them automatically for every project. Add language-specific rule directories as needed (e.g., `~/.claude/rules/python/`).

## Self-Improvement

ClaudeOS gets better over time:

1. **Errors** get logged to `.claude/errors/LOG.md`
2. **Patterns** (3+ occurrences) get promoted to `.claude/errors/PATTERNS.md`
3. **Hindsight** extracts behavioral changes after each session
4. **`/update-context`** triggers the policy-refiner to analyze everything and propose rule updates
5. **You review and approve** — nothing changes without your sign-off

## Multi-Platform Workflow

ClaudeOS is Claude Code-primary but includes guidance for multi-AI workflows:

| Phase | Platform | Why |
|-------|----------|-----|
| Research | Perplexity | Real-time web data |
| Architecture | Gemini | 1M token context for full codebase |
| Implementation | Claude Code | Agents, hooks, persistent memory |
| Security | OpenAI Codex | Sandbox-validated vulnerability detection |
| Visual Review | GPT-5 | Screenshot vs spec comparison |
| Documentation | Gemini | Video analysis, full-context docs |

See `.claude/rules/platform-selection.md` for the full decision framework.

## Prerequisites

| Requirement | macOS | Linux | Windows |
|-------------|-------|-------|---------|
| **Claude Code CLI** | Required | Required | Required |
| **Python 3** | Required (for safety hook) | Required (for safety hook) | Required (for safety hook) |
| **bash** | Included | Included | Git Bash (with Git for Windows) or WSL |
| **git** | Required | Required | Required |
| `yt-dlp` | Optional (YouTube skill) | Optional (YouTube skill) | Optional (YouTube skill) |
| `notebooklm-py` | Optional (research skill) | Optional (research skill) | Optional (research skill) |

### Installing Prerequisites

**Claude Code CLI:**
```bash
npm install -g @anthropic-ai/claude-code
```

**Python 3:**
- macOS: `brew install python3` or [python.org](https://www.python.org/downloads/)
- Linux: `sudo apt install python3` (Debian/Ubuntu) or `sudo dnf install python3` (Fedora)
- Windows: [python.org](https://www.python.org/downloads/) (check "Add to PATH" during install)

**Git for Windows (includes bash):**
- [git-scm.com/downloads](https://git-scm.com/downloads)

## FAQ

**Do I need to change anything in `settings.json`?**
No. The hooks are pre-wired. Just run setup and they work.

**Can I use this with an existing project?**
Yes. Copy the `.claude/` directory, `CLAUDE.md`, `setup.sh` (or `setup.ps1`), and `.gitignore` entries into your project.

**Do the skills require external dependencies?**
The core 5-layer system works with zero dependencies beyond Claude Code and Python 3. Skills like yt-search and research-daemon need optional pip packages.

**What if I don't use Obsidian?**
Layer 5 is optional. The other 4 layers work without it. The Obsidian skills are included but only activate when you work with `.md` files in an Obsidian vault, `.base` files, or `.canvas` files. Any flat-file note system works as a knowledge base.

**Does this work on Windows?**
Yes. The hooks are bash scripts, which run through Git Bash (included with Git for Windows) or WSL. Claude Code on Windows uses bash automatically if it's available.

**Do I need WSL on Windows?**
No. Git for Windows includes Git Bash, which is sufficient. WSL works too if you prefer it.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT
