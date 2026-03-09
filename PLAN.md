# Website Feedback Implementation Plan

---

## 1. FAQ Content Updates (`src/data/faq.json`)

**a. "What time should I arrive?"** — Change answer to: *"It's uncouth to be early, but don't be fashionably late."*

**b. "Where should I stay?"** — Keep the room block info but add: *"There are also a bunch of other hotels and Airbnb options in the area."*

**c. Food options** — Change answer to: *"In addition to offering a vegetarian option, we can accommodate any allergen or restriction. Please let us know when you RSVP and we'll make sure you're taken care of."*

**d. Photos/toasts** — Remove "toasts" from the photos answer → *"Just be mindful during special moments."*

**e. NEW: Music FAQ** — Add new item: Q: *"What's the music situation?"* A: *"We will have a lot of live musicians celebrating with us. Because of that, there will not be requests. But you're in good hands."*

---

## 2. Remove Dollar Signs from Hotel Cards

- Remove the `priceRange` badge from `HotelCard.astro` (delete the `$$$`/`$$` span)
- Remove `priceRange` prop from the component interface
- Stop passing it from `travel.astro`

---

## 3. RSVP Page Restructure (`src/pages/rsvp.astro`)

**a. Move schedule & transport ABOVE the form.** Current order: Form → Schedule → Getting There → Getting Home. New order: Schedule → Transport → Form.

**b. Condense "Getting There" + "Getting Home" into one "Transport" section.** Warmer, casual tone: *"Get yourself there — we recommend rideshare or CTA. We'll have shuttles running back to the hotel blocks all evening to get you home."*

**c. Strip "Fulton Market"** — Just reference Chicago, not the neighborhood.

**d. Update schedule intro** — Add a line like *"We want you there at 6 to get the party started"* near the cocktail hour.

**e. Remove "Song requests" from the note placeholder** — Since there won't be requests, change placeholder to just *"Well wishes, etc."*

---

## 4. Details Page — Condense Transport (`src/pages/details.astro`)

Merge "Getting There" and "Getting Home" into a single lighter **"Transport"** section. Shorter than RSVP — just the essentials: *"We recommend rideshare or CTA to the venue. Shuttles will run from the venue back to the hotel blocks throughout the evening."* Remove Fulton Market.

---

## 5. Strip "Fulton Market" from FAQ

The parking and "how do I get to the venue" FAQ answers mention Fulton Market. Remove those references — just say "Street parking is limited" without naming the neighborhood.

---

## 6. Text Size & Orphan Line Fixes

**Text size:** Audit all `text-[0.8rem]`, `text-[0.85rem]`, `text-[0.9rem]` occurrences in body/description text. Bump small secondary text up (minimum `text-[0.95rem]` for readable body text). Leave UI labels/badges small — only bump paragraph/description text.

**Orphan lines:** Add `text-pretty` (Tailwind's `text-wrap: pretty`) to paragraph elements site-wide via a base style rule, which prevents orphan lines.

---

## 7. RSVP Password Protection

There's no existing StatiCrypt setup in the codebase. For now, I'll add a simple client-side password gate to the RSVP page — a prompt for the password "turtletime" that must be entered before the RSVP form is shown. This keeps it simple and doesn't require a build-time encryption step.

---

## 8. RSVP Flagging System (Name Lookup Toggle)

Add a `rsvpEnabled` flag to `src/data/meals.json` (or a new config file). When `false`:
- The guest search input is hidden
- A message is shown instead: *"RSVP will open soon — check back after you receive your invitation!"*
- This lets you send the site URL before invites go out without people looking up names

I'll set it to `false` by default so it's off until you flip it.

---

## 9. "Ask Alexis about the wording"

Skipping — this is a personal reminder, not a code task.

---

## Order of Execution
1. FAQ content updates + music FAQ
2. Hotel card dollar sign removal
3. RSVP page restructure (move sections, condense transport, tone)
4. Details page transport condensing
5. Strip Fulton Market from FAQ
6. Text size / orphan line fixes
7. RSVP password protection
8. RSVP flagging system
9. Validate (build + typecheck + lint)
10. Commit and push
