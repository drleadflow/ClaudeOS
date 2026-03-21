---
name: research-daemon
description: Deep research using NotebookLM RAG + YouTube search/transcripts. Use when the user needs thorough research beyond simple web search — feeding sources into NotebookLM, searching/scraping YouTube, and synthesizing findings.
---

# Research Daemon

## Purpose
Turn Claude into a research daemon by combining NotebookLM's RAG-in-a-box
infrastructure with YouTube transcript scraping. Goes far beyond simple
web search — feed entire documents, videos, and sources into NotebookLM
and query against them.

## When to Use
- User needs deep research on a topic, not just a quick answer
- User wants to analyze multiple YouTube videos or documents together
- User says "research this", "dig into this", "analyze these sources"
- User provides YouTube URLs and wants insights extracted
- Any task where web search alone is insufficient

## Components

### NotebookLM Integration (via notebooklm-py)
CLI and Python API for NotebookLM. Claude can:
- Create notebooks and add sources (URLs, PDFs, text)
- Query against sources using NotebookLM's RAG
- Generate artifacts: audio overviews, videos, quizzes, flashcards,
  slide decks, infographics, mind maps, data tables, reports
- Download all generated artifacts
- Use `add-research` to auto-import web research

**CLI usage** (preferred — simpler for Claude to invoke):
```bash
notebooklm create "Topic Name"
notebooklm use <notebook_id>
notebooklm source add "https://example.com"
notebooklm source add "./document.pdf"
notebooklm source add-research "search query"
notebooklm ask "What are the key findings?"
notebooklm generate audio "make it engaging" --wait
notebooklm download audio ./output.mp3
```

Full CLI and Python API reference: `references/notebooklm-setup.md`

### YouTube Search (via yt-search skill)
Search YouTube and get structured results. Use the companion skill:
```bash
python3 .claude/skills/yt-search/scripts/search.py "query" --count 10
```

### YouTube Transcript Extraction
Extract transcripts from found videos to feed into NotebookLM:
```bash
pip install youtube-transcript-api
```
See `references/youtube-scraper-setup.md` for usage.

## Workflow
1. User provides topic or sources (URLs, videos, documents)
2. Search YouTube for relevant videos via yt-search skill
3. Extract transcripts from best matches
4. Create a NotebookLM notebook for the research topic
5. Add all sources (transcripts, docs, URLs, web research) to notebook
6. Query NotebookLM to synthesize findings
7. Optionally generate artifacts (audio summary, quiz, report, etc.)
8. Present structured research output to the user

## Constraints
- NotebookLM API is unofficial — may break if Google changes things
- Respect rate limits on both NotebookLM and YouTube
- Always attribute sources in research output
- Requires one-time browser auth: `notebooklm login`

## Gotchas
<!-- Add mistakes Claude makes when using this skill -->

None yet — skill is newly created. Add gotchas as they surface.
