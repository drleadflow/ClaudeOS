# Contributing to ClaudeOS

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/my-feature`)
3. Make your changes
4. Test that Claude Code works correctly with your changes
5. Commit with conventional commits (`feat:`, `fix:`, `docs:`, etc.)
6. Open a pull request

## What to Contribute

- New skills (must follow `_template/SKILL.md` structure)
- New agents (must follow `_template.md` structure)
- New hooks (must be wired in `settings.json`)
- Improvements to rules files
- Gotchas from real-world usage (add to relevant skill's Gotchas section)
- Bug fixes

## Standards

- Skills use `SKILL.md` with YAML frontmatter (name, description required)
- Agents use labeled sections (`<background_information>`, `<instructions>`)
- All agents include Step 0 startup protocol and max 1,500 token output
- Rules go in `.claude/rules/` (not CLAUDE.md) to prevent manifest bloat
- Keep CLAUDE.md concise and high-level
- No secrets, API keys, or tokens in any committed file

## Testing

After making changes, start a Claude Code session in the project and verify:
- Hooks fire correctly (SessionStart, Stop, PreToolUse, PreCompact)
- Skills are discoverable (check with `/skills`)
- Agents are available (check with `/agents`)
- CLAUDE.md loads without errors
