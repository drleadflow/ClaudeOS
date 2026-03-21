---
name: yt-search
description: Search YouTube from Claude Code and return structured video results with titles, channels, views, duration, and dates. Use when the user wants to find YouTube videos, research video content, or feed video transcripts into other tools.
---

# YouTube Search

## Purpose
Search YouTube directly from the terminal. Returns structured results
filtered by recency. Can be combined with the research-daemon skill
to feed transcripts into NotebookLM.

## When to Use
- User asks to search YouTube or find videos
- User wants to research a topic via video content
- User needs YouTube URLs to extract transcripts from
- Feeding into the research-daemon pipeline

## Usage
Run the search script with a query:
```bash
python3 .claude/skills/yt-search/scripts/search.py <query> [--count N] [--months N] [--no-date-filter]
```

### Options
| Flag | Default | Description |
|------|---------|-------------|
| `--count N` | 20 | Number of results to return |
| `--months N` | 6 | Only show videos from the last N months |
| `--no-date-filter` | -- | Show all results regardless of date |

## Output
For each video: title, channel (subscriber count), views, duration,
upload date, and direct YouTube URL.

## Prerequisites
```bash
pip install yt-dlp
```

## Constraints
- Results depend on yt-dlp's YouTube search integration
- yt-dlp may need periodic updates as YouTube changes its API
- Search timeout is 120 seconds

## Gotchas
<!-- Add mistakes Claude makes when using this skill -->

None yet.
