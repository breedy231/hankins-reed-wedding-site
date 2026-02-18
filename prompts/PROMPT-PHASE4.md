# PROMPT.md - Phase 4: Design System Overhaul

## Context

You are redesigning the wedding website for Brendan & Scott's wedding. Phases 1-3 are complete (foundation, core pages, polish/offline). A designer has provided a new color palette and mockup establishing a different visual direction.

Read `CLAUDE.md` for project context. Read `AGENTS.md` for operating constraints and the new design system quick reference.

**Important:** This phase changes ONLY tokens, fonts, and data — no layout changes. The site should look different (new colors, new fonts) but have the same structure.

## Your Mission

Replace the old design system (fuchsia + Dancing Script/Quicksand) with the new warm sunset palette (coral primary + Cormorant Garamond/Nunito/Space Grotesk). Update placeholder data with real names and venue info.

## Tasks (in priority order)

### 1. Download & Self-Host New Fonts

Download from Google Fonts via `fontsource` or direct download, and place woff2 files in `public/fonts/`:

**Cormorant Garamond** (Display/headings — serif):
- Weights: 400, 600, 400 italic
- Files: `cormorant-garamond-latin-{weight}-{style}.woff2`

**Nunito** (Body — sans-serif):
- Weights: 400, 600, 700
- Files: `nunito-latin-{weight}-normal.woff2`

**Space Grotesk** (UI/labels/buttons — sans-serif):
- Weights: 500, 600, 700
- Files: `space-grotesk-latin-{weight}-normal.woff2`

Use `npx @fontsource-utils/cli` or download manually. Only latin subset is needed.

```bash
# Option A: fontsource CLI
npm install @fontsource/cormorant-garamond @fontsource/nunito @fontsource/space-grotesk
# Then copy woff2 files from node_modules/@fontsource/*/files/ to public/fonts/

# Option B: Direct download from fontsource CDN
# Download each weight from https://cdn.jsdelivr.net/fontsource/fonts/{font}@latest/latin-{weight}-normal.woff2
```

### 2. Remove Old Font Files

Delete old font files from `public/fonts/`:
```bash
rm public/fonts/dancing-script-*
rm public/fonts/quicksand-*
rm public/fonts/dancing-script.zip
```

### 3. Rewrite `src/styles/fonts.css`

Replace all `@font-face` declarations with the three new font families:

```css
/* Self-hosted fonts — Warm Sunset redesign */

/* Cormorant Garamond — Display font for headings and couple names */
@font-face {
  font-family: 'Cormorant Garamond';
  font-style: normal;
  font-display: swap;
  font-weight: 400;
  src: url('/fonts/cormorant-garamond-latin-400-normal.woff2') format('woff2');
}

@font-face {
  font-family: 'Cormorant Garamond';
  font-style: italic;
  font-display: swap;
  font-weight: 400;
  src: url('/fonts/cormorant-garamond-latin-400-italic.woff2') format('woff2');
}

@font-face {
  font-family: 'Cormorant Garamond';
  font-style: normal;
  font-display: swap;
  font-weight: 600;
  src: url('/fonts/cormorant-garamond-latin-600-normal.woff2') format('woff2');
}

/* Nunito — Body text */
@font-face {
  font-family: 'Nunito';
  font-style: normal;
  font-display: swap;
  font-weight: 400;
  src: url('/fonts/nunito-latin-400-normal.woff2') format('woff2');
}

@font-face {
  font-family: 'Nunito';
  font-style: normal;
  font-display: swap;
  font-weight: 600;
  src: url('/fonts/nunito-latin-600-normal.woff2') format('woff2');
}

@font-face {
  font-family: 'Nunito';
  font-style: normal;
  font-display: swap;
  font-weight: 700;
  src: url('/fonts/nunito-latin-700-normal.woff2') format('woff2');
}

/* Space Grotesk — UI labels, buttons, navigation */
@font-face {
  font-family: 'Space Grotesk';
  font-style: normal;
  font-display: swap;
  font-weight: 500;
  src: url('/fonts/space-grotesk-latin-500-normal.woff2') format('woff2');
}

@font-face {
  font-family: 'Space Grotesk';
  font-style: normal;
  font-display: swap;
  font-weight: 600;
  src: url('/fonts/space-grotesk-latin-600-normal.woff2') format('woff2');
}

@font-face {
  font-family: 'Space Grotesk';
  font-style: normal;
  font-display: swap;
  font-weight: 700;
  src: url('/fonts/space-grotesk-latin-700-normal.woff2') format('woff2');
}
```

### 4. Update `src/styles/global.css`

Replace the `@theme` block with new design tokens. Replace old color scale and font families:

```css
@theme {
  /* Warm Sunset Palette */
  --color-butter: #FDEC82;
  --color-dusty-rose: #E58B8B;
  --color-coral: #F96854;
  --color-coral-dark: #e0573f;
  --color-salmon: #F4845F;
  --color-warm-orange: #E8891B;
  --color-navy: #0D1240;
  --color-navy-light: #1a2050;
  --color-cream: #fdf8f2;
  --color-light-cream: #faf6f1;
  --color-text-muted: #686e77;
  --color-light-gray: #dde1e4;

  /* Semantic aliases */
  --color-primary: #F96854;
  --color-primary-hover: #e0573f;
  --color-text-dark: #0D1240;
  --color-bg-page: #fdf8f2;
  --color-bg-card: #ffffff;
  --color-bg-section-alt: #faf6f1;

  /* Font families */
  --font-display: "Cormorant Garamond", Georgia, serif;
  --font-body: "Nunito", system-ui, sans-serif;
  --font-ui: "Space Grotesk", system-ui, sans-serif;

  /* Font sizes - minimum 18px for body */
  --font-size-base: 1.125rem;
  --font-size-lg: 1.25rem;
  --font-size-xl: 1.5rem;
  --font-size-2xl: 1.875rem;
  --font-size-3xl: 2.25rem;
  --font-size-4xl: 3rem;
  --font-size-5xl: 3.75rem;
}
```

Update the base layer:
- Change `body` background from `bg-neutral-50` to use `var(--color-bg-page)` or `bg-cream`
- Change text from `text-neutral-900` to `text-navy` (using `var(--color-text-dark)`)
- Update `:focus-visible` outline to use `outline-coral` instead of `outline-primary-500`

### 5. Update `src/layouts/BaseLayout.astro`

Change font preload links from old fonts to new:
```html
<!-- Preload fonts for performance -->
<link rel="preload" href="/fonts/cormorant-garamond-latin-400-normal.woff2" as="font" type="font/woff2" crossorigin />
<link rel="preload" href="/fonts/nunito-latin-400-normal.woff2" as="font" type="font/woff2" crossorigin />
<link rel="preload" href="/fonts/space-grotesk-latin-600-normal.woff2" as="font" type="font/woff2" crossorigin />
```

Change `meta[name="theme-color"]` from `#d946ef` to `#F96854`.

### 6. Update `src/data/wedding.json`

Change `person2` from `"[Partner]"` to `"Scott"`:

```json
{
  "couple": {
    "person1": "Brendan",
    "person2": "Scott"
  },
  "date": "2026-09-12",
  "time": "16:00",
  "timezone": "America/Chicago",
  "location": "Chicago, IL"
}
```

Note: time changed to `"16:00"` to match the mockup's ceremony time.

### 7. Update `src/data/venues.json`

Replace "Venue TBD" with Allium details:

```json
{
  "ceremony": {
    "name": "Allium",
    "address": "333 N. Ogden Ave, Chicago, IL 60607",
    "time": "16:00",
    "neighborhood": "Fulton Market"
  },
  "cocktails": {
    "name": "Allium",
    "address": "333 N. Ogden Ave, Chicago, IL 60607",
    "time": "17:00"
  },
  "reception": {
    "name": "Allium",
    "address": "333 N. Ogden Ave, Chicago, IL 60607",
    "time": "18:00"
  }
}
```

### 8. Find & Fix Color References

Search all `.astro` and `.css` files for references to the old design system and update them:

- `primary-500` / `primary-*` → `coral` (or semantic class)
- `#d946ef` → `#F96854`
- `fuchsia` → `coral`
- `neutral-50` (background) → `cream`
- `neutral-900` (text) → `navy` or `text-dark`
- `font-display` references still work (same CSS variable name, but now maps to Cormorant Garamond)
- `font-body` references still work (same CSS variable name, but now maps to Nunito)

Use `grep -r` to find all occurrences:
```bash
grep -rn "primary-\|#d946ef\|fuchsia\|neutral-50\|neutral-900\|Dancing Script\|Quicksand" src/
```

Update each reference to use the new color tokens.

## Completion Criteria

Before declaring Phase 4 complete, verify ALL:

1. [ ] `npm run build` exits with code 0
2. [ ] `npm run typecheck` exits with code 0
3. [ ] `npm run lint` exits with code 0
4. [ ] New font files exist in `public/fonts/` (cormorant-garamond-*, nunito-*, space-grotesk-*)
5. [ ] Old font files removed from `public/fonts/` (no dancing-script-*, quicksand-*)
6. [ ] `src/styles/fonts.css` has only new @font-face declarations
7. [ ] `src/styles/global.css` has warm sunset color tokens, no fuchsia/primary-500 references
8. [ ] `wedding.json` shows "Scott" not "[Partner]"
9. [ ] `venues.json` shows "Allium" not "Venue TBD"
10. [ ] `grep -r "primary-500\|#d946ef\|Dancing Script\|Quicksand" src/` returns no results
11. [ ] Site runs locally — fonts render correctly, colors are warm tones
12. [ ] No console errors

## Backpressure

After EACH task, run:
```bash
npm run build && echo "Build OK" || echo "Build FAILED"
```

Do NOT proceed if build fails. Fix it first.

## Output

When all criteria are met, commit your changes:
```bash
git add -A
git commit -m "feat: Phase 4 complete - design system overhaul"
```

Then output:
<promise>PHASE4_DONE</promise>
