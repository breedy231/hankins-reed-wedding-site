# PROMPT.md - Phase 6: New Features & Polish

## Context

You are adding the final features and polish to the wedding website for Brendan & Scott's wedding. Phase 4 overhauled the design system and Phase 5 rebuilt all components and pages. Now you add missing sections (Registry, RSVP), update the service worker, and do a final accessibility/performance audit.

Read `CLAUDE.md` for project context. Read `AGENTS.md` for operating constraints and design system reference.

## Your Mission

Add the Registry and RSVP pages that were flagged as missing. Update the service worker and PWA manifest for the new design. Run a final audit pass for accessibility, performance, and polish.

## Tasks (in priority order)

### 1. Create Registry Page (`src/pages/registry.astro`)

A placeholder registry page that will be filled in when registry details are finalized.

**Layout:**
- Navigation
- Simple Hero: "Registry" title, "A few places we're registered" subtitle
- Content section (centered, max-w-2xl):
  - Brief intro paragraph: "Your presence is the greatest gift. For those who wish to honor us with a gift, we're registered at the following stores."
  - Registry cards (even if only one for now):
    - **Crate & Barrel** — card with store name, brief description, and a CTA button "View Registry →" (link can be `#` placeholder)
    - Leave room for 1-2 more registry cards to be added later
  - Optional: "We also have a honeymoon fund" section with placeholder text
- Footer

**Design:**
- Registry cards: white background, rounded-2xl, coral border on hover, centered layout
- CTA buttons: coral pill buttons matching the site style
- Keep it simple — this page will be updated when registry links are finalized

### 2. Create RSVP Page (`src/pages/rsvp.astro`)

A placeholder RSVP page, future-proofed for embedding an external RSVP service (like Zola, WithJoy, Google Forms, etc.).

**Layout:**
- Navigation
- Simple Hero: "RSVP" title, "We can't wait to celebrate with you" subtitle
- Content section (centered, max-w-xl):
  - Status message: "RSVP will open in Spring 2026" (or similar placeholder)
  - Brief text: "When RSVPs open, you'll be able to respond right here. We'll send details in your invitation."
  - Placeholder area for future embed: a styled container with dashed border where the RSVP form/embed will go
  - RSVP deadline reminder: "Please respond by July 1, 2026"
  - Contact fallback: "Having trouble? Email us at [email]"
- Footer

**Design:**
- Clean, minimal layout — the RSVP form embed will be the main content
- Placeholder container: dashed border (2px, coral at 30% opacity), rounded-2xl, padding, centered text
- Include a `<!-- RSVP_EMBED_HERE -->` comment in the HTML where the future embed will go

**Future-proofing:**
- The page structure should make it easy to drop in an `<iframe>` or script embed later
- Keep the surrounding content minimal so the embed is the focus

### 3. Update Navigation Links

Update `src/components/Navigation.astro` to include the new pages:

**Desktop links (in order):**
Details, Travel, Chicago, FAQ, Our Story, Registry, RSVP

**Notes:**
- "RSVP" remains the pill button (far right)
- "Registry" is a regular nav link
- Mobile menu also includes both new links
- Ensure the active state works for the new pages

### 4. Update Service Worker (`public/sw.js`)

Update the precache list to include the new pages:

```js
const PRECACHE_URLS = [
  '/',
  '/details/',
  '/travel/',
  '/chicago/',
  '/faq/',
  '/our-story/',
  '/registry/',    // NEW
  '/rsvp/',        // NEW
  '/offline/',
  // ... fonts and other assets
];
```

Also update the cache version/name so returning visitors get the fresh cache:
```js
const CACHE_NAME = 'wedding-v2';  // Bump from v1
```

Update font file references in the precache list to match the new font files:
- Remove: dancing-script-*, quicksand-*
- Add: cormorant-garamond-*, nunito-*, space-grotesk-*

### 5. Update PWA Manifest (`public/manifest.json`)

Update colors to match the new palette:
```json
{
  "theme_color": "#F96854",
  "background_color": "#fdf8f2"
}
```

Verify `name`, `short_name`, and `description` are appropriate:
```json
{
  "name": "Brendan & Scott's Wedding",
  "short_name": "B & S Wedding"
}
```

### 6. Accessibility Audit

Run through every page and verify:

**Contrast ratios (WCAG AA = 4.5:1 for body text, 3:1 for large text):**
- Coral (#F96854) on white → check ratio, may need darker coral for text links
- Coral (#F96854) as button background with white text → check ratio
- Navy (#0D1240) on cream (#fdf8f2) → should pass easily
- Muted text (#686e77) on white/cream → check ratio (may need darkening)
- White text on navy footer → should pass easily

If any contrast ratio fails:
- For body text links, consider using `--color-coral-dark` (#e0573f) or even darker
- For muted text, darken to at least `#595f67` if needed
- Test with a contrast checker tool or calculate manually

**Touch targets:**
- All buttons: min 48x48px (check padding)
- All nav links: min 48px height
- Accordion question buttons: min 48px height
- Card links: entire card should be clickable

**Keyboard navigation:**
- Tab through every page — focus visible on all interactive elements
- Focus ring: 2px coral outline, 2px offset
- Mobile menu: focus trap when open
- Accordion: Enter/Space toggles, focus stays logical
- Skip link: "Skip to main content" works

**Screen reader:**
- Landmark regions: `<nav>`, `<main>`, `<footer>` all present
- Headings: logical h1 → h2 → h3 hierarchy on every page
- Images/placeholders: appropriate alt text
- Links: descriptive text (no "click here")
- Accordion: `aria-expanded` state announced

**Reduced motion:**
- `prefers-reduced-motion: reduce` disables all animations/transitions
- Verify the media query in `global.css` still works with new components

### 7. Performance Check

Verify the site meets its performance budget:

**JavaScript budget: < 50KB total (gzipped)**
```bash
# After build, check JS output
ls -la dist/_astro/*.js 2>/dev/null || echo "No JS bundles (good!)"
# Or check the build output for sizes
npm run build 2>&1 | grep -i "js\|size"
```

**LCP target: < 2.5s on 3G**
- Fonts are preloaded (3 font files)
- No blocking JS
- Images use lazy loading (where applicable)
- CSS is minimal

**Checks:**
```bash
# Build and check output sizes
npm run build

# Check for unexpectedly large assets
find dist -name "*.js" -exec ls -la {} \; 2>/dev/null
find dist -name "*.css" -exec ls -la {} \; 2>/dev/null
```

### 8. Final Polish

- Verify all internal links work (no broken links to new pages)
- Check that 404 page matches new design
- Verify favicon still works
- Test print styles if any exist
- Spell-check visible copy for typos
- Ensure consistent spacing across all pages

## Completion Criteria

Before declaring Phase 6 complete, verify ALL:

1. [ ] `npm run build` exits with code 0
2. [ ] `npm run typecheck` exits with code 0
3. [ ] `npm run lint` exits with code 0
4. [ ] `/registry/` page exists and renders correctly
5. [ ] `/rsvp/` page exists with embed placeholder area
6. [ ] Navigation includes Registry and RSVP links on all pages
7. [ ] Service worker precache list includes new pages and new font files
8. [ ] PWA manifest colors updated to coral/cream
9. [ ] All color contrast ratios meet WCAG AA (4.5:1 body text, 3:1 large text)
10. [ ] All interactive elements have 48px minimum touch targets
11. [ ] Keyboard navigation works across all pages (tab order, focus visible)
12. [ ] `prefers-reduced-motion` disables animations
13. [ ] Total JS < 50KB gzipped (or zero JS — even better)
14. [ ] No broken internal links
15. [ ] No console errors on any page

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
git commit -m "feat: Phase 6 complete - new features and polish"
```

Then output:
<promise>PHASE6_DONE</promise>
