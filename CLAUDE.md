# CLAUDE.md

## Project: Reed Wedding Website

A mobile-first, static wedding website for ~175 guests attending a Chicago wedding in Summer 2026.

## Quick Commands

```bash
# Development
npm run dev           # Start dev server

# Validation (run before EVERY commit)
npm run build         # Build static site
npm run typecheck     # TypeScript checks
npm run lint          # ESLint

# Testing  
npm run test          # All tests
npm run test:a11y     # Accessibility tests

# Full validation
npm run validate      # typecheck + lint + build
```

## Architecture

- **Framework**: Astro 5.x (static output, zero JS by default)
- **Styling**: Tailwind CSS 4.x with custom design tokens
- **Hosting**: Cloudflare Pages (unlimited bandwidth)
- **Password**: StatiCrypt (AES-256 client-side encryption)
- **Maps**: Leaflet.js + OpenStreetMap (no API key needed)

## Key Files

| File | Purpose |
|------|---------|
| `SPEC.md` | Full technical specification |
| `AGENTS.md` | AI agent operating constraints |
| `prompts/PROMPT-PHASE*.md` | Ralph Wiggum phase prompts |
| `src/data/wedding.json` | Core wedding info (names, date) |
| `src/data/venues.json` | Venue details |
| `src/data/hotels.json` | Hotel block information |

## Critical Constraints

1. **Performance**: < 2.5s LCP on 3G, < 50KB JS total
2. **Accessibility**: WCAG AA, 48px touch targets, 4.5:1 contrast
3. **Offline**: Service worker must cache Details + FAQ pages
4. **Mobile-first**: Design for 375px width first

## Design System

- **Display font**: Dancing Script (headings, couple names only)
- **Body font**: Quicksand (everything else)
- **Primary color**: #d946ef (customizable)
- **Min body text**: 18px
- **Touch targets**: 48x48px minimum

## Backpressure

Before committing, ALL must pass:
```bash
npm run build && npm run typecheck && npm run lint
```

## Password

Site password: "turtletime" (stored in environment variable SITE_PASSWORD for CI)
