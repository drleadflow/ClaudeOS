# ClaudeOS

The reference template for structuring Claude Code projects to maximize performance. Clone it, run setup, and Claude operates at its best from the first prompt.

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

Plus a **self-improvement loop**: hooks observe what happens → policy-refiner agent analyzes patterns → `/update-context` proposes changes → you approve.

## Quick Start

```bash
# Clone
git clone https://github.com/drleadflow/ClaudeOS.git my-project
cd my-project

# Setup (makes hooks executable, creates personal config files)
./setup.sh

# Customize
# 1. Edit CLAUDE.md with your project rules
# 2. Edit .mcp.json to add your MCP servers
# 3. Edit CLAUDE.local.md with personal preferences

# Go
claude
```

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
| **Hooks** | 5 | SessionStart (git context), Stop (session handoff + hindsight), PreCompact (archive), PreToolUse (safety guard) |
| **Agents** | 2 + template | self-critic (quality check), policy-refiner (self-improvement) |
| **Skills** | 3 + template | yt-search, research-daemon, youtube-pipeline |
| **Commands** | 3 | /yt-search, /youtube-pipeline, /update-context |
| **Rules** | 4 | operations, platform-selection, multi-platform-workflow, token-budgeting |
| **Hindsight Patterns** | 4 | Loop detection, structural analysis, compact output, file ownership |

## Project Structure

```
ClaudeOS/
  CLAUDE.md                        # Layer 1: Project manifest (edit this)
  CLAUDE.local.md                  # Personal overrides (git-ignored, created by setup.sh)
  setup.sh                         # First-time setup script
  .mcp.json                        # MCP server config (add yours here)
  tasks/NOTES.md                   # In-flight decision tracking
  .claude/
    PRIMER.md                      # Layer 2: Auto-updated session handoff
    settings.json                  # Hook wiring (pre-configured)
    agents/                        # self-critic, policy-refiner, _template
    commands/                      # /yt-search, /youtube-pipeline, /update-context
    skills/                        # yt-search, research-daemon, youtube-pipeline, _template
    rules/                         # 4 modular policy files (add your own here)
    hooks/                         # 5 automation scripts
    hindsight/PATTERNS.md          # Layer 4: Behavioral learning
    errors/                        # Error log + pattern promotion
    logs/                          # Event logs (git-ignored)
    sessions/                      # Archived transcripts (git-ignored)
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

### Set Up Layer 5 (Knowledge Base)
Point Claude at a note vault for full knowledge base access:
```bash
# Add a CLAUDE.md to your vault
echo "# Knowledge Base\nThis vault provides context to Claude." > ~/my-vault/CLAUDE.md
# Run Claude from the vault
cd ~/my-vault && claude
```

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

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code/overview) (required)
- Python 3 (required for the safety hook)
- `pip install yt-dlp` (optional, for YouTube search skill)
- `pip install 'notebooklm-py[browser]'` (optional, for research skill)

## FAQ

**Do I need to change anything in `settings.json`?**
No. The hooks are pre-wired. Just run `setup.sh` and they work.

**Can I use this with an existing project?**
Yes. Copy the `.claude/` directory, `CLAUDE.md`, `setup.sh`, and `.gitignore` entries into your project.

**Do the skills require external dependencies?**
The core 5-layer system works with zero dependencies beyond Claude Code and Python 3. Skills like yt-search and research-daemon need optional pip packages.

**What if I don't use Obsidian?**
Layer 5 is optional. The other 4 layers work without it. Any flat-file note system works as a knowledge base.

## License

MIT
