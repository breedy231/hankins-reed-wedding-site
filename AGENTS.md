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
