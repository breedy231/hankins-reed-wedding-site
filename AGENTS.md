# AGENTS.md - AI Agent Configuration

## Project Overview

You are building a wedding website for Brendan & Scott's wedding (~150-175 guests, Allium in Fulton Market, Chicago, September 12, 2026).

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
  {description && <p class="text-text-muted">{description}</p>}
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

### Color Palette — Cool Blue

| Token | Hex | Usage |
|-------|-----|-------|
| `coral` | `#4A6FA5` | **Primary** — CTA buttons, links, accents |
| `coral-bright` | `#6B8FC2` | Decorative gradients, placeholders |
| `coral-dark` | `#3A5A8A` | Hover states for primary |
| `navy` | `#0D1240` | Dark text, footer backgrounds |
| `navy-light` | `#1a2050` | Footer gradient end |
| `cream` | `#fdf8f2` | Page background |
| `light-cream` | `#faf6f1` | Card sections, alternating backgrounds |
| `butter` | `#D6E5F3` | Light accent, highlights, tags |
| `dusty-rose` | `#8BABC4` | Soft accent, borders, hover tints |
| `salmon` | `#7BA7CC` | Secondary accent, gradients |
| `warm-orange` | `#5C8AB5` | Blue highlight, icons |
| `text-muted` | `#686e77` | Secondary text, captions |
| `light-gray` | `#dde1e4` | Card borders, dividers |

### Fonts

| Token | Family | Usage |
|-------|--------|-------|
| `font-display` | Cormorant Garamond (serif) | Headings, couple names, page titles |
| `font-body` | Nunito (sans-serif) | Body text, paragraphs |
| `font-ui` | Space Grotesk (sans-serif) | Nav links, buttons, labels, eyebrow text |

### Typography Scale

| Element | Font | Size | Weight | Extras |
|---------|------|------|--------|--------|
| Names (hero) | display | clamp(3.5rem, 12vw, 5.5rem) | 400 | — |
| Page titles | display | 2.5rem | 400 | — |
| Section titles | display | 2.2rem | 400 | — |
| Card titles | display | 1.3rem | 600 | — |
| Body text | body | 18px (1.125rem) | 400 | line-height: 1.7 |
| Nav links | ui | 0.85rem | 600 | uppercase, ls: 1.5px |
| Buttons | ui | 0.95rem | 600 | uppercase, ls: 1px |
| Eyebrow/Labels | ui | 0.8-0.9rem | 500-600 | uppercase, ls: 3-4px |

### Component Patterns

- **Buttons**: `rounded-full` (pill), coral bg, white text, `font-ui`
- **Cards**: `rounded-2xl`, white bg, 2px transparent border, hover → translateY(-4px) + shadow + coral border
- **Sections**: `py-24` padding, alternating cream/white/light-cream backgrounds
- **Touch targets**: `min-h-12 min-w-12` (48px minimum)

## When Things Go Wrong

### Build Fails
1. Read the FULL error message
2. Check if it's a TypeScript error (fix types)
3. Check if it's a missing import
4. Check if it's a syntax error
5. If unclear, `git stash` and isolate the problem
