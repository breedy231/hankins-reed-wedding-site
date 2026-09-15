# Portfolio artifacts — Hankins-Reed wedding site

Captured 2026-09-15 from the live production site, before decommission.

## Contents

- `ARCHITECTURE.md` — system + sequence diagrams (Mermaid), design decisions, repo layout
- `DECOMMISSION.md` — teardown runbook and pre-teardown state
- `screenshots/desktop/` — 1440px full-page PNGs, 14 shots
- `screenshots/mobile/` — 390px full-page PNGs, 14 shots

Per viewport: home, details, travel, chicago, faq, registry, rsvp (gated),
rsvp-unlocked-open (pre-deadline, clock frozen to 2026-06-01), rsvp-search-results,
rsvp-form, rsvp-unlocked-closed (post-deadline state), bachelor-party (gated),
bachelor-party-unlocked, 404-not-a-page.

## PII handling

- Guest names in the RSVP lookup/form shots were replaced in the DOM with "Guest A/B/..." before capture.
- Photos of the couple are the same ones that were on the public site.
- The repo itself still contains `src/data/guests.json` (real names) in the tree and in history.
  Do NOT make the repo public without removing that file and rewriting history
  (`git filter-repo --path src/data/guests.json --invert-paths`), and replacing it with fixture data.
- Site passwords ("disco", "bro") are hardcoded in page source; harmless once the site is down.

## Suggested portfolio blurb

Static Astro 5 wedding site for ~175 guests on Cloudflare Pages: zero-JS pages,
a 12 KB RSVP island with household lookup, Pages Functions that sign a Google
service-account JWT with Web Crypto and append RSVPs to a Sheet, per-PR preview
deploys via GitHub Actions, offline-capable via a hand-rolled service worker.
