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
