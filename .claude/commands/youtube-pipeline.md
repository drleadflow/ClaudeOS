---
description: "Research a topic via YouTube → NotebookLM → Obsidian vault"
argument-hint: "<topic> [--count N] [--deliverable type]"
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

You are executing the YouTube Pipeline skill. This is an end-to-end research
workflow that chains YouTube search, NotebookLM analysis, and Obsidian output.

Read the skill definition at `.claude/skills/youtube-pipeline/SKILL.md` and
follow the pipeline steps exactly with the user's arguments: $ARGUMENTS

Save all research output to the `research/` directory as Obsidian-compatible
markdown with [[wikilinks]].
