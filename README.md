# ClaudeOS

The reference template for structuring Claude Code projects to maximize performance.

## What Is This

ClaudeOS defines the directory layout, memory architecture, self-improvement loop, configuration patterns, and conventions that every new Claude Code project should start from. Clone it, customize it, and let Claude operate at its best from the first prompt.

## Architecture

**5-Layer Memory System:**
1. **Rules** (`CLAUDE.md`) — permanent project instructions
2. **Primer** (`.claude/PRIMER.md`) — session handoff, auto-updated every session
3. **Memory** (`memory.sh`) — live git context injected at session start
4. **Hindsight** (`PATTERNS.md`) — behavioral patterns extracted from past sessions
5. **Knowledge Base** (Obsidian vault) — full knowledge base as working directory

**Self-Improvement Loop:** Observe (hooks capture signals) → Reflect (policy-refiner analyzes patterns) → Commit (gated updates via `/update-context`)

## Quick Start

```bash
# Clone the template
git clone https://github.com/drleadflow/ClaudeOS.git my-project
cd my-project

# Customize CLAUDE.md with your project details
# Add project-specific MCP servers to .mcp.json
# Start Claude Code
claude
```

## What's Included

| Component | Count | Examples |
|-----------|-------|---------|
| Skills | 3 + template | yt-search, research-daemon, youtube-pipeline |
| Agents | 2 + template | self-critic, policy-refiner |
| Commands | 3 | /yt-search, /youtube-pipeline, /update-context |
| Rules | 7 | coding-style, testing, security, operations, platform-selection, multi-platform-workflow, token-budgeting |
| Hooks | 5 | PreToolUse safety guard, SessionStart context, Stop session-end + hindsight, PreCompact archive |
| Hindsight Patterns | 4 | Loop detection, structural analysis, compact output, file ownership |

## Prerequisites

- [Claude Code CLI](https://claude.ai/code)
- `pip install yt-dlp` (for YouTube search skill)
- `pip install notebooklm-py` (for NotebookLM research skill)
- [Obsidian](https://obsidian.md/) (optional, for Layer 5)

## Project Structure

```
ClaudeOS/
  CLAUDE.md                    # Layer 1: Project manifest
  CLAUDE.local.md              # Personal overrides (git-ignored)
  .mcp.json                    # MCP server config
  tasks/NOTES.md               # In-flight decision tracking
  .claude/
    PRIMER.md                  # Layer 2: Session handoff
    settings.json              # Hook wiring
    agents/                    # self-critic, policy-refiner, _template
    commands/                  # /yt-search, /youtube-pipeline, /update-context
    skills/                    # yt-search, research-daemon, youtube-pipeline, _template
    rules/                     # 7 modular policy files
    hooks/                     # 5 automation scripts
    hindsight/PATTERNS.md      # Layer 4: Behavioral learning
    errors/                    # Error capture
    logs/                      # Structured event logs
    sessions/                  # Archived transcripts
```

## Multi-Platform Workflow

ClaudeOS is Claude Code-primary but supports a multi-AI development lifecycle:

1. **Research** (Perplexity) — real-time library/docs research
2. **Architecture** (Gemini) — full codebase ingestion, gap analysis
3. **Implementation** (Claude Code) — autonomous coding with agents
4. **Security** (OpenAI Codex Security) — vulnerability detection
5. **Visual Review** (OpenAI GPT-5) — screenshot vs spec comparison
6. **Documentation** (Gemini) — video analysis, full-context docs

See `.claude/rules/platform-selection.md` for the decision framework.

## License

MIT
