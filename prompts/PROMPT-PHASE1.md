# PROMPT.md - Phase 1: Foundation

## Context
You are building a wedding website for Brendan's wedding. This is Phase 1: Foundation - the most critical phase where architectural decisions are made.

Read CLAUDE.md for project context. Read AGENTS.md for operating constraints.

## Your Mission
Set up the foundational architecture that all future work builds upon. Get this right - shortcuts here cascade through the entire project.

## Tasks (in priority order)

### 1. Initialize Astro Project
```bash
npm create astro@latest . -- --template minimal --typescript strict --install --no-git
```

Configure astro.config.mjs:
- output: 'static'
- site: 'https://reedwedding.com' (placeholder)

### 2. Set Up Tailwind CSS
```bash
npx astro add tailwind
```

Create tailwind.config.mjs with:
- Design system colors (primary: fuchsia, neutrals)
- Font families (Dancing Script, Quicksand)
- Extended spacing scale

### 3. Download and Self-Host Fonts
Download from Google Fonts and place in public/fonts/:
- Dancing Script (400, 700)
- Quicksand (400, 500, 600, 700)

Create src/styles/fonts.css with @font-face declarations.

### 4. Create Global Styles
Create src/styles/global.css with:
- Tailwind directives (@tailwind base/components/utilities)
- Import fonts.css
- CSS custom properties for design tokens
- Reduced motion media query

### 5. Create Base Layout
Create src/layouts/BaseLayout.astro with:
- HTML structure with lang="en"
- Meta tags for SEO
- Font preloading
- Global styles import
- Skip link for accessibility
- Slot for page content

### 6. Create Navigation Component
Create src/components/Navigation.astro:
- Sticky bottom nav on mobile (< 768px)
- Horizontal top nav on desktop (≥ 768px)
- 5 nav items: Home, Details, Travel, FAQ, Our Story
- Icons + text labels (use simple SVG or emoji for now)
- Active state indicator
- 48px minimum touch targets

### 7. Create Footer Component
Create src/components/Footer.astro:
- Contact email link
- "Made with ❤️" text
- Simple, minimal design

### 8. Create Placeholder Data Files
Create src/data/ directory with:

wedding.json:
```json
{
  "couple": {
    "person1": "Brendan",
    "person2": "[Partner]"
  },
  "date": "2026-09-12",
  "time": "16:30",
  "timezone": "America/Chicago",
  "location": "Chicago, IL"
}
```

venues.json:
```json
{
  "ceremony": {
    "name": "Venue TBD",
    "address": "Chicago, IL",
    "time": "16:30"
  },
  "reception": {
    "name": "Venue TBD", 
    "address": "Chicago, IL",
    "time": "18:00"
  }
}
```

### 9. Create Index Page
Create src/pages/index.astro:
- Uses BaseLayout
- Hero section with couple names and date (from wedding.json)
- Simple welcome message
- Navigation works
- Footer displays

### 10. Create Stub Pages
Create placeholder pages (just title + "Coming soon"):
- src/pages/details.astro
- src/pages/travel.astro
- src/pages/faq.astro
- src/pages/our-story.astro

### 11. Set Up Scripts
Update package.json scripts:
```json
{
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "typecheck": "astro check",
    "lint": "eslint src --ext .ts,.astro",
    "validate": "npm run typecheck && npm run lint && npm run build"
  }
}
```

Install ESLint:
```bash
npm install -D eslint eslint-plugin-astro @typescript-eslint/parser
```

Create basic .eslintrc.cjs config.

## Completion Criteria

Before declaring Phase 1 complete, verify ALL:

1. [ ] `npm run build` exits with code 0
2. [ ] `npm run typecheck` exits with code 0
3. [ ] Site runs locally with `npm run dev`
4. [ ] Navigation shows on all pages
5. [ ] Index page displays couple names from JSON
6. [ ] All 5 pages exist and are navigable
7. [ ] Fonts are self-hosted (check Network tab - no Google Fonts requests)
8. [ ] Mobile nav is at bottom (check at 375px width)
9. [ ] Desktop nav is at top (check at 1024px width)
10. [ ] No console errors

## Backpressure

After EACH major task, run:
```bash
npm run build && echo "✅ Build OK" || echo "❌ Build FAILED"
```

Do NOT proceed if build fails. Fix it first.

## Output

When all criteria are met, commit your changes:
```bash
git add -A
git commit -m "feat: Phase 1 complete - foundation and architecture"
```

Then output:
<promise>PHASE1_DONE</promise>
