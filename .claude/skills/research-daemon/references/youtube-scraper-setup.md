# YouTube Scraper Setup

## Purpose
Extract transcripts from YouTube videos so they can be fed into
NotebookLM or analyzed directly by Claude.

## Option 1: youtube-transcript-api (Recommended)
Lightweight, no video download needed. Just grabs the transcript.

```bash
pip install youtube-transcript-api
```

### Usage
```python
from youtube_transcript_api import YouTubeTranscriptApi

# Extract transcript from a video
transcript = YouTubeTranscriptApi.get_transcript("VIDEO_ID")

# Format as plain text
text = " ".join([entry["text"] for entry in transcript])
print(text)
```

### Extract video ID from URL
```python
import re

def extract_video_id(url):
    patterns = [
        r'(?:v=|/v/|youtu\.be/)([a-zA-Z0-9_-]{11})',
    ]
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    return None
```

## Option 2: yt-dlp (Full-featured)
Downloads video metadata, subtitles, and optionally the video itself.

```bash
pip install yt-dlp
```

### Transcript only
```bash
yt-dlp --write-auto-sub --sub-lang en --skip-download -o "%(title)s" "VIDEO_URL"
```

## Feeding into NotebookLM
Once you have the transcript text, add it as a source:
```python
notebook.add_source_text(transcript_text)
```

## Notes
- Not all videos have transcripts (auto-generated or manual)
- Auto-generated transcripts may have errors — useful but not perfect
- For playlists, loop through video IDs and extract each
