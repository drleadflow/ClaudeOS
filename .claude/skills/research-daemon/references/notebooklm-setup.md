# NotebookLM Setup

## Repository
github.com/teng-lin/notebooklm-py

## Install
```bash
# Basic
pip install notebooklm-py

# With browser login support (required for first-time auth)
pip install "notebooklm-py[browser]"
playwright install chromium
```

## Authentication
```bash
notebooklm login
# For orgs requiring Edge for SSO:
notebooklm login --browser msedge
```
Credentials are cached locally after first login.

Check auth status:
```bash
notebooklm auth check --test
```

## CLI Reference

### Notebook Management
```bash
notebooklm create "My Research"        # Create notebook
notebooklm use <notebook_id>           # Set active notebook
notebooklm list                        # List all notebooks
```

### Source Management
```bash
notebooklm source add "https://url"    # Add URL source
notebooklm source add "./file.pdf"     # Add file source
notebooklm source add-research "AI"    # Web research with auto-import
```

### Query
```bash
notebooklm ask "What are the key themes?"
```

### Generate Artifacts
```bash
notebooklm generate audio "make it engaging" --wait
notebooklm generate video --style whiteboard --wait
notebooklm generate cinematic-video "documentary-style" --wait
notebooklm generate quiz --difficulty hard
notebooklm generate flashcards --quantity more
notebooklm generate slide-deck
notebooklm generate infographic --orientation portrait
notebooklm generate mind-map
notebooklm generate data-table "compare key concepts"
```

### Download Artifacts
```bash
notebooklm download audio ./podcast.mp3
notebooklm download video ./overview.mp4
notebooklm download quiz --format markdown ./quiz.md
notebooklm download flashcards --format json ./cards.json
notebooklm download slide-deck ./slides.pdf
notebooklm download infographic ./infographic.png
notebooklm download mind-map ./mindmap.json
notebooklm download data-table ./data.csv
```

### Diagnostics
```bash
notebooklm auth check --test           # Check auth
notebooklm metadata --json             # Export notebook metadata
notebooklm skill status                # Check agent skill install
notebooklm language list               # Supported languages
```

## Python API

### Setup
```python
import asyncio
from notebooklm import NotebookLMClient

async def main():
    async with await NotebookLMClient.from_storage() as client:
        # Create notebook
        nb = await client.notebooks.create("Research")

        # Add sources
        await client.sources.add_url(nb.id, "https://example.com", wait=True)
        await client.sources.add_file(nb.id, "./paper.pdf", wait=True)

        # Query
        result = await client.chat.ask(nb.id, "Summarize the key points")
        print(result.answer)

        # Generate audio
        status = await client.artifacts.generate_audio(nb.id, instructions="engaging")
        await client.artifacts.wait_for_completion(nb.id, status.task_id)
        await client.artifacts.download_audio(nb.id, "podcast.mp3")

asyncio.run(main())
```

### Available API Methods
- `client.notebooks` — create, list, update
- `client.sources` — add_url, add_file, get, refresh, get_fulltext
- `client.chat` — ask, get_history
- `client.artifacts` — generate_audio/video/quiz/flashcards/slide_deck/infographic/mind_map/data_table/report, download_*, wait_for_completion
- `client.sharing` — create_public_link, add_user, get_status

## Artifact Types
| Type | Formats | Options |
|------|---------|---------|
| Audio | MP3/MP4 | 4 formats, 3 lengths, 50+ languages |
| Video | MP4 | 3 formats, 9 visual styles |
| Slide Deck | PDF, PPTX | Detailed or presenter mode |
| Quiz | JSON, MD, HTML | Configurable difficulty/quantity |
| Flashcards | JSON, MD, HTML | Configurable difficulty/quantity |
| Report | Markdown | Multiple templates (study_guide, briefing_doc, blog_post) |
| Data Table | CSV | Custom structure |
| Mind Map | JSON | Hierarchical |
| Infographic | PNG | 3 orientations, 3 detail levels |

## Agent Skill Install
NotebookLM can also install itself as a Claude Code skill:
```bash
notebooklm skill install
```
This creates its own skill at `~/.claude/skills/notebooklm`. The
research-daemon skill wraps this with YouTube integration.

## Limitations
- Unofficial API — may break if Google changes endpoints
- Rate limits apply under heavy usage
- Requires browser-based auth (one-time)
- Use PyPI releases, not main branch, for stability
