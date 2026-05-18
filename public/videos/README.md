# Dance video

Drop the final files here:

- `dance.mp4` — H.264/AAC MP4. Source is vertical (9:16) with audio.
- `dance-poster.jpg` — first-frame still used while the video loads.

## Suggested encode (from the Google Drive original)

Target: < 25 MB to fit Cloudflare Pages' per-file limit, with headroom for
fast loads on 3G.

```bash
# 720x1280 vertical, CRF 28, 80 kbps audio, web-optimized
# Typical output: ~18-22 MB from a ~500 MB source
ffmpeg -i source.mov \
  -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -profile:v main -preset slow -crf 28 -maxrate 1100k -bufsize 2200k \
  -c:a aac -b:a 80k -movflags +faststart \
  dance.mp4

# Poster (first frame)
ffmpeg -i dance.mp4 -frames:v 1 -q:v 3 dance-poster.jpg
```

If that's still too large, drop the resolution to 540x960 (still crisp on
phones) and push CRF to 30:

```bash
ffmpeg -i source.mov \
  -vf "scale=540:960:force_original_aspect_ratio=decrease,pad=540:960:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -profile:v main -preset slow -crf 30 -maxrate 800k -bufsize 1600k \
  -c:a aac -b:a 80k -movflags +faststart \
  dance.mp4
```

The RSVP page (`src/pages/rsvp.astro`) reveals these files inside
`#dance-reveal` after a successful RSVP where at least one guest is attending.
