#!/bin/bash
# Wedding Site Setup Script
# Run this from your wedding_site repo root: ~/repos/wedding_site

set -e

echo "🎊 Setting up Reed Wedding Website..."
echo ""

# Check we're in the right place
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository. Please run from ~/repos/wedding_site"
    exit 1
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p prompts
mkdir -p scripts

# Create CLAUDE.md
echo "📝 Creating CLAUDE.md..."
cat > CLAUDE.md << 'CLAUDE_EOF'
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
CLAUDE_EOF

# Create AGENTS.md
echo "📝 Creating AGENTS.md..."
cat > AGENTS.md << 'AGENTS_EOF'
# AGENTS.md - AI Agent Configuration

## Project Overview

You are building a wedding website for Brendan's wedding (~150-175 guests, Chicago, Summer 2026).

**Primary Goal**: Create a fast, accessible, mobile-first static website that helps guests find wedding information easily.

**Tech Stack**: Astro 5.x, Tailwind CSS, Cloudflare Pages, StatiCrypt

## Operating Constraints

### MUST DO

1. **Always check backpressure before committing**:
   ```bash
   npm run build && npm run typecheck && npm run lint
   ```
   Do NOT commit if any of these fail.

2. **Mobile-first development**: Build for 375px width first, then expand.

3. **Accessibility first**: Every component must be keyboard navigable and screen reader friendly.

4. **Performance budget**: Keep total JS < 50KB gzipped. Question every npm install.

5. **Type safety**: Use TypeScript strictly. No `any` types without justification.

6. **Commit frequently**: Small, working commits. Each commit should build successfully.

7. **Read error messages completely**: Don't guess at fixes. Understand the problem first.

### MUST NOT DO

1. **DO NOT** install heavy frameworks (React, Vue, etc.) - Astro's islands are sufficient
2. **DO NOT** use Google Fonts CDN - self-host fonts for offline support
3. **DO NOT** use Google Maps API - use Leaflet + OpenStreetMap
4. **DO NOT** add analytics or tracking - privacy first
5. **DO NOT** commit secrets or passwords to git
6. **DO NOT** skip accessibility testing
7. **DO NOT** use `!important` in CSS except for print styles
8. **DO NOT** use inline styles - use Tailwind classes
9. **DO NOT** create deeply nested component structures (max 3 levels)
10. **DO NOT** hardcode content - use JSON/markdown files

## Code Style

### Astro Components
```astro
---
// TypeScript in frontmatter
interface Props {
  title: string;
  description?: string;
}

const { title, description = 'Default description' } = Astro.props;
---

<section class="py-8 md:py-12">
  <h2 class="text-2xl font-display">{title}</h2>
  {description && <p class="text-neutral-700">{description}</p>}
  <slot />
</section>
```

### File Naming
- Components: PascalCase.astro (e.g., `HeroSection.astro`)
- Pages: kebab-case.astro (e.g., `our-story.astro`)
- Data files: kebab-case.json (e.g., `wedding-data.json`)

## Testing Requirements

### Before Every Commit
```bash
npm run build         # Must pass
npm run typecheck     # Must pass
npm run lint          # Must pass
```

## Design System Quick Reference

**Colors**:
- Primary: `#d946ef` (fuchsia-500)
- Text: `#171717` (neutral-900)
- Background: `#fafafa` (neutral-50)

**Fonts**:
- Display: `font-display` (Dancing Script)
- Body: `font-body` (Quicksand)

**Touch Targets**:
- Minimum: `min-h-[48px] min-w-[48px]`

## When Things Go Wrong

### Build Fails
1. Read the FULL error message
2. Check if it's a TypeScript error (fix types)
3. Check if it's a missing import
4. Check if it's a syntax error
5. If unclear, `git stash` and isolate the problem
AGENTS_EOF

# Create Phase 1 Prompt
echo "📝 Creating prompts/PROMPT-PHASE1.md..."
cat > prompts/PROMPT-PHASE1.md << 'PHASE1_EOF'
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
PHASE1_EOF

# Create Phase 2 Prompt
echo "📝 Creating prompts/PROMPT-PHASE2.md..."
cat > prompts/PROMPT-PHASE2.md << 'PHASE2_EOF'
# PROMPT.md - Phase 2: Core Pages

## Context
Phase 1 is complete. Astro is configured, Tailwind works, BaseLayout and Navigation exist.

Read CLAUDE.md and AGENTS.md for constraints.

## Your Mission
Build the four core content pages guests need most.

## Tasks

### 1. Homepage Enhancements

**Hero Component** (src/components/Hero.astro):
- Full viewport height (100svh)
- Placeholder background (gradient or solid color for now)
- Couple names in Dancing Script
- Wedding date
- Location
- Scroll indicator

**Countdown Component** (src/components/Countdown.astro):
- Days until wedding
- Client-side JS for live updates (use client:visible)
- Shows "We're married!" after date passes

Update index.astro to use Hero and Countdown.

### 2. Details Page (src/pages/details.astro)

**Sections**:
- Schedule/Timeline (ceremony time, reception time)
- Venue info (name, address with Google Maps link)
- Dress code section
- Weather note for Chicago summer

**Components to create**:
- Timeline.astro - visual timeline
- VenueCard.astro - venue with address, map link

### 3. Travel Page (src/pages/travel.astro)

**Sections**:
- Getting to Chicago (airports)
- Hotels (placeholder for now)
- Parking info

**Components**:
- HotelCard.astro - hotel with booking link, price range, distance

Create src/data/hotels.json with 2-3 placeholder hotels.

### 4. FAQ Page (src/pages/faq.astro)

**Accordion Component** (src/components/Accordion.astro):
- Accessible (aria-expanded, keyboard nav)
- CSS-only animation preferred
- Multiple can be open

Create src/data/faq.json with these questions:
1. What's the dress code?
2. Can I bring a plus one?
3. Are kids welcome?
4. What time should I arrive?
5. Is there parking?
6. Where should I stay?
7. Will there be food options for dietary restrictions?
8. Can I take photos during the ceremony?
9. What's the weather like?
10. Who do I contact with questions?

### 5. Our Story Page (src/pages/our-story.astro)

Simple page with:
- Placeholder for couple's story
- Space for photos
- Can be minimal for now

## Completion Criteria

1. [ ] `npm run build` passes
2. [ ] Homepage has Hero and Countdown
3. [ ] Details page shows timeline and venues
4. [ ] Travel page shows hotels
5. [ ] FAQ page has working accordion
6. [ ] All pages responsive (test 375px and 1024px)
7. [ ] Accordion is keyboard accessible

## Output

When complete:
```bash
git add -A
git commit -m "feat: Phase 2 complete - core pages"
```

<promise>PHASE2_DONE</promise>
PHASE2_EOF

# Create Phase 3 Prompt  
echo "📝 Creating prompts/PROMPT-PHASE3.md..."
cat > prompts/PROMPT-PHASE3.md << 'PHASE3_EOF'
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
PHASE3_EOF

# Create ralph loop script
echo "📝 Creating scripts/ralph-loop.sh..."
cat > scripts/ralph-loop.sh << 'RALPH_EOF'
#!/bin/bash
# Ralph Wiggum Loop - OG Bash Implementation
# Usage: ./scripts/ralph-loop.sh "Your prompt here" [max_iterations]

PROMPT="$1"
MAX_ITERATIONS="${2:-50}"
ITERATION=0

echo "🍩 Starting Ralph Wiggum Loop"
echo "📝 Prompt: $PROMPT"
echo "🔄 Max iterations: $MAX_ITERATIONS"
echo ""

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔄 Iteration $ITERATION of $MAX_ITERATIONS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Run Claude with the prompt
    claude --print "$PROMPT"
    EXIT_CODE=$?
    
    # Check if Claude signaled completion (exit 0)
    if [ $EXIT_CODE -eq 0 ]; then
        echo ""
        echo "✅ Ralph completed successfully after $ITERATION iterations!"
        exit 0
    fi
    
    echo ""
    echo "⏳ Continuing to next iteration..."
    sleep 2
done

echo ""
echo "⚠️  Ralph reached max iterations ($MAX_ITERATIONS) without completing."
exit 1
RALPH_EOF

chmod +x scripts/ralph-loop.sh

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << 'GITIGNORE_EOF'
# Dependencies
node_modules/

# Build output
dist/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Astro
.astro/
GITIGNORE_EOF
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📁 Created files:"
echo "   - CLAUDE.md (AI context)"
echo "   - AGENTS.md (AI constraints)"
echo "   - prompts/PROMPT-PHASE1.md"
echo "   - prompts/PROMPT-PHASE2.md"
echo "   - prompts/PROMPT-PHASE3.md"
echo "   - scripts/ralph-loop.sh"
echo "   - .gitignore"
echo ""
echo "🚀 Next steps:"
echo "   1. Review the files (optional)"
echo "   2. Start Claude Code: claude"
echo "   3. Run: 'Execute Phase 1 from prompts/PROMPT-PHASE1.md'"
echo ""
echo "🍩 For autonomous Ralph loops (Phases 2-3):"
echo "   ./scripts/ralph-loop.sh 'Execute prompts/PROMPT-PHASE2.md' 30"
echo ""
