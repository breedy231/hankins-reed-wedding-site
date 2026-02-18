# Brendan & Scott Wedding Website — Design Specification

## Overview

A sophisticated, modern wedding website for a couple getting married at Allium in Chicago. The design uses a **warm sunset palette** with **elegant serif typography** and **clean, structured layouts**.

**Vibe:** Warm and refined — matching Allium's sophisticated aesthetic while remaining approachable and personal.

---

## Design System

### Color Palette — Warm Sunset

A 6-swatch palette from the designer, plus supporting neutrals.

```
Primary Colors
├── Coral (Primary)           #F96854   — CTA buttons, links, accents
├── Coral Dark (Hover)        #e0573f   — Hover/active states for primary
└── Dark Navy (Dark)          #0D1240   — Footer backgrounds, dark text

Warm Accents
├── Butter Yellow              #FDEC82   — Light accents, highlights, tags
├── Dusty Rose                 #E58B8B   — Soft accent, borders, hover tints
├── Salmon                     #F4845F   — Secondary accent, gradients
└── Warm Orange                #E8891B   — Icons, warm highlights

Supporting Colors
├── Cream (Background)         #fdf8f2   — Main page background
├── Light Cream (Cards BG)     #faf6f1   — Card sections, alternating backgrounds
├── Navy Light                 #1a2050   — Footer gradient end
├── Text Muted                 #686e77   — Secondary text, captions
└── Light Gray (Borders)       #dde1e4   — Card borders, dividers
```

#### Tailwind / CSS Custom Properties

```css
@theme {
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
}
```

### Typography

#### Font Stack
```
Display/Names:    Cormorant Garamond (serif)     — self-hosted
Headlines:        Cormorant Garamond (serif)     — self-hosted
Body/UI:          Nunito (sans-serif)            — self-hosted
Labels/Buttons:   Space Grotesk (sans-serif)     — self-hosted
```

#### Type Scale
| Element | Font | Size | Weight | Letter-spacing | Case |
|---------|------|------|--------|----------------|------|
| Names (hero) | Cormorant Garamond | clamp(3.5rem, 12vw, 5.5rem) | 400 | 0 | Normal |
| Page titles | Cormorant Garamond | 2.5rem | 400 | 0 | Normal |
| Section titles | Cormorant Garamond | 2.2rem | 400 | 0 | Normal |
| Card titles | Cormorant Garamond | 1.3rem | 600 | 0 | Normal |
| Body text | Nunito | 18px (1.125rem) | 400 | 0 | Normal |
| Nav links | Space Grotesk | 0.85rem | 600 | 1.5px | Uppercase |
| Buttons | Space Grotesk | 0.95rem | 600 | 1px | Uppercase |
| Eyebrow/Labels | Space Grotesk | 0.8-0.9rem | 500-600 | 3-4px | Uppercase |
| Muted text | Nunito | 0.95rem | 400 | 0 | Normal |

#### Line Heights
- Body text: 1.7
- Headlines: 1.15
- Buttons/Labels: 1

### Spacing System

Use Tailwind's default spacing scale. Key values:
- Section padding: `py-24` (6rem)
- Card padding: `p-10` (2.5rem) desktop, `p-7` (1.75rem) mobile
- Card grid gap: `gap-6` (1.5rem)
- Content max-width: `max-w-4xl` (~900px)
- FAQ max-width: `max-w-2xl` (~700px)

### Border Radius
- Buttons: `rounded-full` (pill shape)
- Cards: `rounded-2xl` (16px)
- Images/Photos: `rounded-2xl` (16px)
- FAQ items: `rounded-2xl` (16px)

### Shadows
- Cards (default): none
- Cards (hover): `0 12px 35px rgba(249, 104, 84, 0.12)`
- Buttons: `0 4px 20px rgba(249, 104, 84, 0.25)`
- Photo placeholder: `0 20px 40px rgba(249, 104, 84, 0.2)`

---

## Components

### Navigation

**Desktop:**
- Fixed position, backdrop blur
- Background: cream at 97% opacity
- Logo: "B & S" in Cormorant Garamond, semi-bold, letter-spacing 2px
- Links: Space Grotesk, uppercase, 1.5px letter-spacing
- RSVP button: Coral background, white text, pill shape
- Hover: Links turn coral, RSVP darkens with slight scale
- Border-bottom: `1px solid rgba(13, 18, 64, 0.08)`

**Mobile:**
- Centered logo only
- Hamburger menu with full-screen or slide-in overlay
- All nav links + RSVP button in menu

```css
nav {
  background: rgba(253, 248, 242, 0.97);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(13, 18, 64, 0.08);
}
```

### Primary Button

```css
.btn-primary {
  background: var(--color-coral);
  color: white;
  padding: 1.1rem 2.8rem;
  border-radius: 100px;
  font-family: 'Space Grotesk';
  font-weight: 600;
  font-size: 0.95rem;
  letter-spacing: 1px;
  text-transform: uppercase;
  box-shadow: 0 4px 20px rgba(249, 104, 84, 0.25);
  transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
}

.btn-primary:hover {
  background: var(--color-coral-dark);
  transform: translateY(-2px);
  box-shadow: 0 6px 25px rgba(249, 104, 84, 0.3);
}
```

**Button text examples:**
- "View Details →"
- "RSVP Now →"
- "RSVP"
- "View Registry →"

### Info Cards

4-column grid on desktop, 2-column on mobile.

```css
.info-card {
  background: white;
  padding: 2.5rem 2rem;
  border-radius: 16px;
  text-align: center;
  border: 2px solid transparent;
  transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
}

.info-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 35px rgba(249, 104, 84, 0.12);
  border-color: var(--color-coral);
}
```

**Card structure:**
- Emoji icon (2rem)
- Title (Cormorant Garamond, 1.3rem, 600)
- Subtitle (Nunito, 0.95rem, muted)

### FAQ Accordion

```css
.faq-item {
  background: white;
  border-radius: 16px;
  border: 2px solid rgba(13, 18, 64, 0.1);
  margin-bottom: 1rem;
  overflow: hidden;
}

.faq-item:hover {
  border-color: var(--color-coral);
  box-shadow: 0 4px 15px rgba(249, 104, 84, 0.1);
}

.faq-item.open {
  border-color: var(--color-coral);
  background: linear-gradient(to bottom, white, #faf6f1);
}

.faq-question {
  padding: 1.5rem;
  font-family: 'Space Grotesk';
  font-weight: 600;
  cursor: pointer;
}

.faq-icon {
  color: var(--color-coral);
}
```

### Background Decorations

Very subtle gradient blobs for visual interest (keep understated):

```css
/* Top-right blob */
.hero::before {
  background: linear-gradient(135deg, var(--color-coral) 0%, var(--color-salmon) 100%);
  border-radius: 50%;
  opacity: 0.06;
  width: 500px;
  height: 500px;
  position: absolute;
  top: -20%;
  right: -15%;
}

/* Bottom-left blob */
.hero::after {
  background: linear-gradient(135deg, var(--color-salmon) 0%, var(--color-coral) 100%);
  border-radius: 50%;
  opacity: 0.05;
  width: 400px;
  height: 400px;
  position: absolute;
  bottom: -25%;
  left: -10%;
}
```

---

## Page Layouts

### Homepage

```
┌─────────────────────────────────────────────────────┐
│ NAV: B & S      Details Travel Chicago ... Registry RSVP │
├─────────────────────────────────────────────────────┤
│                                                     │
│              ✦ TOGETHER WITH THEIR FAMILIES ✦       │
│                                                     │
│                  Brendan                            │
│                    &                                │
│                  Scott                              │
│                                                     │
│           REQUEST YOUR PRESENCE                     │
│                                                     │
│          ┌─────────────────────┐                    │
│          │   [Engagement       │                    │
│          │    Photo]           │                    │
│          └─────────────────────┘                    │
│                                                     │
│            September 12, 2026                       │
│           FULTON MARKET, CHICAGO                    │
│                                                     │
│            [ VIEW DETAILS → ]                       │
│                                                     │
├─────────────────────────────────────────────────────┤
│                  THE VENUE                          │
│                   Allium                            │
│   A modern celebration space in the heart of        │
│   Fulton Market with skyline views.                 │
│                                                     │
│          ┌─────────────────────┐                    │
│          │   [Venue Photo]     │                    │
│          └─────────────────────┘                    │
│                                                     │
│    CEREMONY    COCKTAILS   RECEPTION    ADDRESS     │
│     4:00 PM     5:00 PM     6:00 PM   333 N. Ogden  │
│                                                     │
├─────────────────────────────────────────────────────┤
│              THE DETAILS                            │
│        Everything you need to know                  │
│                                                     │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│   │ 📍      │ │ 🏨      │ │ 👔      │ │ 🌆      │  │
│   │Getting  │ │Where to │ │Dress    │ │Explore  │  │
│   │There    │ │Stay     │ │Code     │ │Chicago  │  │
│   └─────────┘ └─────────┘ └─────────┘ └─────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│              QUESTIONS & ANSWERS                    │
│                                                     │
│   ┌─────────────────────────────────────────────┐   │
│   │ Is there an open bar?                    +  │   │
│   └─────────────────────────────────────────────┘   │
│   ┌─────────────────────────────────────────────┐   │
│   │ Can I bring a plus one?                  −  │   │
│   │                                             │   │
│   │ Please refer to your invitation for         │   │
│   │ guest details.                              │   │
│   └─────────────────────────────────────────────┘   │
│                                                     │
├─────────────────────────────────────────────────────┤
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░ KINDLY RESPOND ░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░ by July 1, 2026 ░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░ [ RSVP NOW → ] ░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
├─────────────────────────────────────────────────────┤
│   Questions? Contact us at wedding@reedwedding.com  │
└─────────────────────────────────────────────────────┘
```

### Other Pages Structure

**Details Page:**
- Hero: "The Details"
- Ceremony section with Allium details
- Reception section
- Timeline visualization
- Map embed (Leaflet)

**Travel Page:**
- "Where to Stay" hero
- Hotel blocks with booking links
- Transportation tips (rideshare, parking, public transit)
- Airport info

**Chicago Guide:**
- "Our Chicago" hero
- Category sections: Food, Drinks, Coffee, Sights
- Map with pins
- Insider tips with personality

**FAQ Page:**
- Full accordion list
- Contact CTA at bottom

**Our Story Page:**
- Timeline layout
- Photos interspersed
- Milestone markers

**Registry Page:**
- "Registry" hero
- Registry cards (Crate & Barrel, etc.)
- Optional honeymoon fund section

**RSVP Page:**
- "RSVP" hero
- Status/placeholder for future embed
- RSVP deadline reminder
- Contact fallback

---

## Voice & Copy Guidelines

### Do:
- Write with warmth and clarity
- Be direct and informative
- Address guests as "you"
- Keep paragraphs short (mobile = scanning)
- Match the elegant tone of the venue

### Don't:
- Use wedding cliches ("two souls becoming one")
- Be overly casual or slangy
- Write walls of text
- Use passive voice
- Over-explain obvious things

### Sample Copy

**Headlines:**
| Generic | Refined Version |
|---------|-----------------|
| "Frequently Asked Questions" | "Questions & Answers" |
| "Event Details" | "The Details" |
| "Please RSVP" | "RSVP" |
| "Accommodations" | "Where to Stay" |
| "Contact Us" | "Get in Touch" |
| "Gift Registry" | "Registry" |

**FAQ Answers:**
| Question | Answer |
|----------|--------|
| "Is there an open bar?" | "Yes, we'll have a full bar throughout the evening." |
| "Can I bring kids?" | "This will be an adults-only celebration. We hope this gives you a chance to enjoy a night out." |
| "What should I wear?" | "Cocktail attire. Suits, dresses, or dressy separates all work well." |
| "Where should I park?" | "Street parking is limited. We recommend rideshare services for the easiest arrival." |

---

## Implementation Notes

### Astro/Tailwind Specific

1. **Fonts**: Self-hosted in `public/fonts/`, loaded via `src/styles/fonts.css`

2. **Tailwind Config**: Extended with custom colors and fonts via `@theme` in `global.css`

3. **Component Classes**: Use Tailwind utility classes directly; create reusable components rather than `@apply` abstractions

4. **Animations**: Use Tailwind's built-in transitions or add custom ones for:
   - Button hover (scale + translateY)
   - Card hover (translateY + shadow)
   - FAQ expand/collapse
   - Page transitions (optional)

5. **Performance**:
   - Keep JS minimal per SPEC.md requirements
   - Lazy load images
   - Use Astro's built-in image optimization

### Accessibility
- Maintain 4.5:1 contrast ratios
- 48px minimum touch targets
- Semantic HTML structure
- Focus states on all interactive elements
- Reduced motion support

### Contrast Checks
| Combo | Ratio | Pass? |
|-------|-------|-------|
| Navy (#0D1240) on cream (#fdf8f2) | ~16:1 | AA |
| Coral (#F96854) on white | ~3.5:1 | Large text only — use coral-dark for body text links |
| White on coral (#F96854) | ~3.5:1 | Large text / buttons (meets 3:1 for UI) |
| Muted (#686e77) on white | ~4.8:1 | AA |
| White on navy (#0D1240) | ~17:1 | AAA |

---

## Assets Needed

1. **Engagement photo** — Hero section, ~800x600px minimum
2. **Allium venue photos** — Get from venue or photographer
3. **Optional: Custom illustrations** — If budget allows

---

## Reference

The mockup is available at:
```
/public/mockup-main-character.html
```

View at: `http://localhost:4321/mockup-main-character.html`
