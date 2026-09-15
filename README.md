# Hankins-Reed Wedding Website

Static wedding site for ~175 guests, live at hankinsreedwedding.com from
February to September 2026. Decommissioned after the wedding; kept as a
portfolio piece.

**Stack:** Astro 5 (static) · Tailwind 4 · Cloudflare Pages + Pages Functions ·
Google Sheets (via service-account JWT signed with Web Crypto) · GitHub Actions
preview/prod deploys · hand-written service worker for offline.

- Architecture, diagrams, and design decisions: [`portfolio/ARCHITECTURE.md`](portfolio/ARCHITECTURE.md)
- Screenshots (desktop + mobile, every route): [`portfolio/screenshots/`](portfolio/screenshots/)

`src/data/guests.json` contains fixture households. The real guest list was
never part of this repository's history.

## Run locally

```bash
npm ci
npm run dev        # http://localhost:4321
npm run validate   # typecheck + lint + test + build
```

The RSVP endpoints (`functions/api/*`) need `GOOGLE_SERVICE_ACCOUNT_EMAIL`,
`GOOGLE_PRIVATE_KEY`, and `GOOGLE_SHEET_ID` in `.dev.vars` to write anywhere;
without them they return a 500 and the UI shows the fallback message.

## Excluded from this repo

- `public/videos/dance.mp4` (22 MB personal video shown in the Details page and RSVP success step) is not
  in this history. The `<video>` elements still reference it; the poster frame is kept.
- The real guest list (see above).
