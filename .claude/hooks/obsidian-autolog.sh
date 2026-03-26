#!/bin/bash
# obsidian-autolog.sh — Auto-log session work to Obsidian daily note
# Global Stop hook — fires at end of every Claude session in any project.
# Prompts Claude to append a summary to today's Obsidian daily note.

OBSIDIAN_VAULT="$HOME/Desktop/Obsidian"
DAILY_DIR="$OBSIDIAN_VAULT/daily"
TODAY=$(date +%Y-%m-%d)
DAILY_NOTE="$DAILY_DIR/$TODAY.md"

# Detect current project name from directory
PROJECT_DIR=$(basename "$PWD")

# Create daily dir if needed
mkdir -p "$DAILY_DIR"

# Create today's daily note if it doesn't exist
if [ ! -f "$DAILY_NOTE" ]; then
    cat > "$DAILY_NOTE" << TEMPLATE
---
created: $TODAY
tags: [daily]
---

# $TODAY

## What Happened

## Decisions

## Links
TEMPLATE
fi

cat <<EOF
Before ending, append to the Obsidian daily note at $DAILY_NOTE.

Under "## What Happened", add bullet points for what was accomplished in THIS session.
- Prefix each bullet with [[${PROJECT_DIR}]] wikilink so it links to the project
- Be specific: what was built, fixed, decided, or researched
- Keep it concise — 2-5 bullets max

Under "## Decisions", add any non-trivial decisions made this session.
- Format: "Chose X over Y — reason" with a wikilink to the project

Under "## Links", add wikilinks to any projects, people, or concepts touched.

If the daily note already has content from earlier sessions today, APPEND — do not overwrite.
Do NOT duplicate entries that are already there.
EOF
