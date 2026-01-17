# PROMPT.md - Phase 3: Polish & Offline

## Context
Phases 1-2 complete. Core pages exist. Now add polish and offline support.

## Tasks

### 1. Chicago Things To Do Page
Create src/pages/chicago.astro with local recommendations:
- Restaurants (5-7)
- Activities (5-7)
- Neighborhoods to explore

Create src/data/chicago.json with recommendations.

### 2. Service Worker for Offline
Create public/sw.js:
- Cache HTML pages
- Cache CSS/JS
- Cache fonts
- Offline fallback

Register in BaseLayout.astro.

### 3. PWA Manifest
Create public/manifest.json:
- name, short_name
- icons (create simple placeholder icons)
- theme_color, background_color

Add to BaseLayout head.

### 4. Image Placeholders
Create src/assets/images/ with placeholder images:
- hero-placeholder.jpg (or use gradient)
- Create actual placeholder files or document where real images will go

### 5. Accessibility Audit
Check all pages for:
- Color contrast (4.5:1)
- Touch targets (48px)
- Heading hierarchy
- Alt text
- Focus indicators

Fix any issues found.

### 6. Performance Check
Run Lighthouse on built site:
```bash
npm run build && npm run preview
# Then run Lighthouse in Chrome DevTools
```

Target scores:
- Performance: > 90
- Accessibility: > 95
- Best Practices: > 90
- SEO: > 90

### 7. Final Polish
- Smooth page transitions (if not already)
- Consistent spacing
- Print styles (optional)
- 404 page

## Completion Criteria

1. [ ] Chicago page exists with recommendations
2. [ ] Service worker registers and caches pages
3. [ ] Site works offline (at least shows cached content)
4. [ ] PWA manifest is valid
5. [ ] Lighthouse accessibility > 95
6. [ ] All pages pass manual a11y check
7. [ ] `npm run validate` passes

## Output

When complete:
```bash
git add -A  
git commit -m "feat: Phase 3 complete - polish and offline"
git push origin main
```

<promise>PHASE3_DONE</promise>
