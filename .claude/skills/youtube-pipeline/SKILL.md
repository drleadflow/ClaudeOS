---
name: youtube-pipeline
description: End-to-end research pipeline that searches YouTube, sends videos to NotebookLM for analysis, generates deliverables (infographic, podcast, slides, etc.), and saves all output to the Obsidian vault as linked markdown. Use when the user wants to research a topic via YouTube videos with full analysis and deliverables.
---

# YouTube Pipeline

## Purpose
This is the super skill — it chains yt-search + notebooklm + obsidian
output into a single research workflow. One prompt in, full analysis out.

## When to Use
- User says "research [topic] via YouTube" or similar
- User wants video-based research with analysis and deliverables
- User invokes `/youtube-pipeline`
- Any research task where YouTube is the primary source

## Pipeline Steps

### Step 1: YouTube Search
Use the yt-search skill to find relevant videos.
```bash
python3 .claude/skills/yt-search/scripts/search.py "<query>" --count <N>
```
Present results to the user. Let them confirm which videos to analyze,
or proceed with the top results if they gave a clear directive.

### Step 2: Send to NotebookLM
Create a notebook for the research topic and add video URLs as sources.
```bash
notebooklm create "<Topic> Research"
notebooklm use <notebook_id>
notebooklm source add "https://youtube.com/watch?v=<id>"
# Repeat for each video
```
Wait for sources to be processed before querying.

### Step 3: Analysis
Query NotebookLM for the analysis the user requested.
```bash
notebooklm ask "<user's analysis question>"
```
If the user didn't specify, default to:
- Key themes and takeaways across all videos
- What's driving views/engagement (outliers)
- Gaps in coverage — what's missing
- Actionable insights

### Step 4: Deliverables (if requested)
Generate whatever the user asked for:
```bash
notebooklm generate <type> "<instructions>" --wait
notebooklm download <type> ./research/<filename>
```
Types: audio, video, infographic, slide-deck, quiz, flashcards,
mind-map, data-table, report

### Step 5: Save to Vault
Save all output as markdown in the `research/` directory with
Obsidian-style wikilinks so notes connect in the graph.

Output file format:
```markdown
# <Topic> Research

## Metadata
- **Date:** YYYY-MM-DD
- **Query:** <search query>
- **Videos Analyzed:** <count>
- **Deliverables:** <list>

## Sources
- [[Video Title 1]] — channel, views, link
- [[Video Title 2]] — channel, views, link

## Analysis
<NotebookLM analysis output>

## Key Takeaways
<Bullet points>

## Gaps & Opportunities
<What's missing, what to capitalize on>

## Deliverables
<Links to generated files>
```

Use `[[double brackets]]` for any concept, tool, person, or topic that
could become its own note. This builds the knowledge graph over time.

## Constraints
- NotebookLM must be installed and authenticated (`notebooklm login`)
- yt-dlp must be installed (`pip install yt-dlp`)
- Save all output files to `research/` directory
- Always use Obsidian-compatible markdown (wikilinks, not regular links)
- Keep the analysis focused on what the user asked for

## Adaptability
This pipeline is a template. The user may substitute:
- YouTube for PDFs, articles, or any other source
- NotebookLM for direct Claude analysis
- Different deliverable types

Adapt to what they need. The skeleton is: search → ingest → analyze →
deliver → save to vault.

## Gotchas
<!-- Add mistakes Claude makes when using this skill -->

None yet.
