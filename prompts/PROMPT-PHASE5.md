# PROMPT.md - Phase 5: Component & Page Redesign

## Context

You are redesigning the wedding website for Brendan & Scott's wedding. Phase 4 swapped the design tokens (fonts, colors, data). Now you rebuild every component and page to match the mockup layout and new visual direction.

Read `CLAUDE.md` for project context. Read `AGENTS.md` for operating constraints and design system reference. Read `DESIGN-SPEC.md` for detailed component specs, type scale, and page layouts.

**Reference mockup:** `public/mockup-main-character.html` — open it in browser for visual reference. Your output should match its layout patterns, adapted to the warm sunset palette from Phase 4.

## Your Mission

Rebuild all components and pages to match the mockup's structure using the warm sunset palette. The tone is warm, approachable, and traditionally elegant — not overly playful or cutesy.

## Design System Reference (Quick)

These tokens were set up in Phase 4. Use them:

| Token | Value | Usage |
|-------|-------|-------|
| `--color-coral` | `#F96854` | Primary — buttons, links, accents |
| `--color-navy` | `#0D1240` | Dark text, footer backgrounds |
| `--color-cream` | `#fdf8f2` | Page background |
| `--color-light-cream` | `#faf6f1` | Alternating section backgrounds |
| `--color-text-muted` | `#686e77` | Secondary text |
| `--color-butter` | `#FDEC82` | Highlight accents |
| `--color-dusty-rose` | `#E58B8B` | Soft accents, borders |
| `--color-salmon` | `#F4845F` | Secondary accent, gradients |
| `--color-warm-orange` | `#E8891B` | Icons, warm highlights |
| `--font-display` | Cormorant Garamond | Headings, couple names |
| `--font-body` | Nunito | Body text |
| `--font-ui` | Space Grotesk | Nav, buttons, labels |

## Tasks (in priority order)

### 1. Rebuild Navigation (`src/components/Navigation.astro`)

Replace the existing bottom-mobile / top-desktop nav with a mockup-style fixed top nav.

**Desktop (>= 768px):**
- Fixed top, `backdrop-filter: blur(12px)`, cream background at 97% opacity
- Left: "B & S" logo in `font-display` (Cormorant Garamond), semi-bold, letter-spacing 2px
- Center/Right: Links in `font-ui` (Space Grotesk), uppercase, 0.85rem, 600 weight, letter-spacing 1.5px
- Links: Details, Travel, Chicago, FAQ, Our Story, Registry
- Far right: "RSVP" pill button — coral background, white text, rounded-full
- Link hover: text turns coral
- RSVP hover: darker coral, slight translateY(-1px)
- Border-bottom: `1px solid rgba(13, 18, 64, 0.08)`

**Mobile (< 768px):**
- Centered "B & S" logo only
- Hamburger menu icon (right side) that opens a full-screen overlay or slide-in menu
- Menu items: all nav links + RSVP button
- Close button in menu
- Ensure 48px touch targets

**Accessibility:**
- `<nav aria-label="Main navigation">`
- `aria-expanded` on mobile menu toggle
- Keyboard-navigable links
- Focus trap in mobile menu when open

### 2. Rebuild Footer (`src/components/Footer.astro`)

Two-part footer matching the mockup:

**Part 1 — CTA Section:**
- Dark navy gradient background: `linear-gradient(135deg, #0D1240 0%, #1a2050 100%)`
- Centered: "Kindly Respond" in `font-display`, 2.5rem, white
- Subtitle: "RSVP by July 1, 2026" in muted white (60% opacity)
- CTA button: white background, navy text, rounded-full, hover → coral background + white text
- Padding: `py-24`

**Part 2 — Contact Bar:**
- Solid navy background
- Simple centered text: "Questions? Contact us" with email link
- Muted white text (50% opacity), coral link color
- Padding: `py-10`

### 3. Rebuild Hero Component (`src/components/Hero.astro`)

Rebuild to match the mockup's hero layout. Accept props for flexibility across pages.

**Homepage hero structure (top to bottom):**
1. Eyebrow text: "Together with their families" — `font-ui`, uppercase, letter-spacing 4px, coral color, with decorative stars
2. Names: "Brendan" / "&" / "Scott" — `font-display`, clamp(3.5rem, 12vw, 5.5rem), navy text. Ampersand: italic, coral, smaller (0.5em), displayed as block
3. Tagline: "Request your presence" — `font-ui`, uppercase, letter-spacing 4px, muted text
4. Photo placeholder: 320x220px, gradient placeholder (coral → salmon), rounded-2xl, box-shadow
5. Date: "September 12, 2026" — `font-display`, 1.5rem, semi-bold
6. Location: "FULTON MARKET, CHICAGO" — uppercase, letter-spacing 2px, muted text, 0.9rem
7. CTA button: "View Details →" — coral background, white text, rounded-full, `font-ui`, uppercase

**Background decorations:**
- Subtle gradient blobs (`::before` and `::after` pseudo-elements)
- Top-right: 500px circle, coral-to-salmon gradient, 6% opacity
- Bottom-left: 400px circle, salmon-to-coral gradient, 5% opacity

**For non-homepage pages**, the Hero should accept a `title` and optional `subtitle` prop and render a simpler header.

### 4. Create Venue Section Component (`src/components/VenueFeature.astro`)

New component for the homepage venue showcase (replaces or supplements VenueCard):

- White background section, `py-24`
- Section label: "The Venue" — `font-ui`, 0.8rem, uppercase, letter-spacing 3px, coral
- Heading: "Allium" — `font-display`, 2.5rem
- Tagline: venue description — muted text, max-width 500px, centered
- Photo placeholder: full-width (max 900px), 400px height, gradient placeholder, rounded-2xl
- Details grid: 4 items in a row (flex, centered, gap-16, wrap on mobile)
  - Each item: label (`font-ui`, 0.75rem, uppercase, muted) + value (`font-display`, 1.3rem)
  - Items: Ceremony / 4:00 PM, Cocktails / 5:00 PM, Reception / 6:00 PM, Address / 333 N. Ogden Ave

Read venue data from `src/data/venues.json`.

### 5. Rebuild Info Cards Section

Update or replace the existing card components for the "The Details" section on the homepage:

- Light cream background section (`--color-light-cream`)
- Section title: "The Details" — `font-display`, 2.2rem, centered
- Subtitle: "Everything you need to know" — muted text
- 4-column grid (desktop), 2-column (mobile), gap-6
- Each card:
  - White background, rounded-2xl (16px), padding 2.5rem desktop / 1.75rem mobile
  - Emoji icon (2rem)
  - Title: `font-display`, 1.3rem, 600 weight
  - Subtitle: `font-body`, 0.95rem, muted
  - Border: 2px solid transparent
  - Hover: translateY(-4px), shadow, coral border
  - Cards link to their respective pages

Cards:
1. Getting There (link to /details)
2. Where to Stay (link to /travel)
3. Dress Code (link to /faq)
4. Explore Chicago (link to /chicago)

### 6. Rebuild Accordion Component (`src/components/Accordion.astro`)

Update to match mockup FAQ style:

- White background, rounded-2xl, 2px border (navy at 10% opacity)
- Question: `font-ui`, 600 weight, 1rem, with +/- icon in coral
- Answer: `font-body`, muted text color, line-height 1.7
- Hover: coral border, subtle shadow
- Open state: coral border, subtle gradient background (white to light gray)
- Animate open/close with CSS transitions (max-height or details/summary)
- Use `<details>` / `<summary>` for no-JS accessibility

### 7. Rebuild All Pages

#### 7a. Homepage (`src/pages/index.astro`)

Compose using components in this order:
1. Navigation
2. Hero (homepage variant with names, photo, CTA)
3. VenueFeature section
4. Info Cards section ("The Details")
5. FAQ Preview (3-4 questions using Accordion, with "See all questions →" link)
6. Footer (with RSVP CTA section)

#### 7b. Details Page (`src/pages/details.astro`)

- Simple Hero: "The Details" title
- Ceremony section: Allium details, time, dress code
- Reception section: same venue, timeline
- Timeline visualization (keep existing Timeline component, restyle)
- Map embed (keep existing Leaflet integration, restyle container)
- "Getting There" section: rideshare tips, parking, public transit

#### 7c. Travel Page (`src/pages/travel.astro`)

- Simple Hero: "Where to Stay" title, "Hotel blocks and getting around" subtitle
- Hotel blocks section (restyle HotelCard with new card style)
- Transportation section: airport info, rideshare, parking, CTA transit tips
- Area map

#### 7d. FAQ Page (`src/pages/faq.astro`)

- Simple Hero: "Questions & Answers" title
- Full accordion list (all questions)
- Contact CTA at bottom: "Still have questions?" with email link
- Max-width: 700px for readability

#### 7e. Our Story Page (`src/pages/our-story.astro`)

- Simple Hero: "Our Story" title
- Timeline layout with milestone markers
- Placeholder text — warm, personal tone
- Photo placeholders interspersed

#### 7f. Chicago Guide (`src/pages/chicago.astro`)

- Simple Hero: "Our Chicago" title, "Our favorite spots in the city" subtitle
- Category sections: Food, Drinks, Coffee, Sights
- Card-based layout for each recommendation
- Map with pins (Leaflet)
- Insider tips with personality

#### 7g. 404 Page (`src/pages/404.astro`)

- Restyle with new fonts/colors
- Friendly message, link back to homepage

### 8. Copy & Tone Guidelines

Apply these across all pages:

**Do:**
- Write with warmth and clarity
- Be direct and informative
- Address guests as "you"
- Keep paragraphs short (mobile = scanning)
- Match the elegant-but-approachable tone

**Don't:**
- Use wedding cliches ("two souls becoming one")
- Be overly casual or slangy
- Write walls of text

**Headline style:**
| Generic | Preferred |
|---------|-----------|
| "Frequently Asked Questions" | "Questions & Answers" |
| "Event Details" | "The Details" |
| "Accommodations" | "Where to Stay" |
| "Contact Us" | "Get in Touch" |

## Completion Criteria

Before declaring Phase 5 complete, verify ALL:

1. [ ] `npm run build` exits with code 0
2. [ ] `npm run typecheck` exits with code 0
3. [ ] `npm run lint` exits with code 0
4. [ ] Navigation: fixed top nav on desktop, hamburger menu on mobile
5. [ ] Navigation: "B & S" logo visible, RSVP pill button present
6. [ ] Hero: Names display in Cormorant Garamond, coral accents visible
7. [ ] Venue section: "Allium" with ceremony/cocktails/reception/address grid
8. [ ] Info cards: 4-column grid desktop, 2-column mobile, hover effects work
9. [ ] FAQ: Accordion opens/closes, styled with new design
10. [ ] Footer: Dark navy CTA section + contact bar
11. [ ] All 7 pages render without errors
12. [ ] All pages use new color palette (no fuchsia/old colors visible)
13. [ ] Mobile responsive: test at 375px width — all content readable, touch targets 48px
14. [ ] Keyboard navigation works on nav, accordion, all interactive elements
15. [ ] No console errors

## Backpressure

After EACH component rebuild, run:
```bash
npm run build && echo "Build OK" || echo "Build FAILED"
```

Do NOT proceed if build fails. Fix it first.

## Output

When all criteria are met, commit your changes:
```bash
git add -A
git commit -m "feat: Phase 5 complete - component and page redesign"
```

Then output:
<promise>PHASE5_DONE</promise>
