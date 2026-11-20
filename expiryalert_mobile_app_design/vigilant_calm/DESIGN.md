---
name: Vigilant Calm
colors:
  surface: '#fcf8ff'
  surface-dim: '#dbd8e6'
  surface-bright: '#fcf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f2ff'
  surface-container: '#efecfa'
  surface-container-high: '#e9e6f5'
  surface-container-highest: '#e3e1ef'
  on-surface: '#1b1b24'
  on-surface-variant: '#484554'
  inverse-surface: '#302f3a'
  inverse-on-surface: '#f2effd'
  outline: '#797585'
  outline-variant: '#c9c4d6'
  surface-tint: '#5d48cb'
  primary: '#5b45c8'
  on-primary: '#ffffff'
  primary-container: '#7460e3'
  on-primary-container: '#fffbff'
  inverse-primary: '#c8bfff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5deff'
  primary-fixed-dim: '#c8bfff'
  on-primary-fixed: '#1a0063'
  on-primary-fixed-variant: '#452bb2'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#fcf8ff'
  on-background: '#1b1b24'
  surface-variant: '#e3e1ef'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.03em
  numeric-countdown:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 22px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-compact: 0.75rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
  space-2xl: 2rem
---

## Brand & Style

This design system embodies mindful organization, domestic serenity, and quiet competence. Designed for everyday inventory management, personal wellness, pantry control, and medication tracking, the interface shifts the mental burden of tracking dates from human memory to an unobtrusive digital companion.

The aesthetic blends **Modern Warm Minimalism** with **Functional Micro-Clarity**:
- **Personality:** Attentive, calm, dependable, lightweight, and optimistic. It eliminates frantic alarmism while keeping urgency unmistakably perceptible.
- **Target Audience:** Households, busy professionals, meal planners, and medication managers who seek order, reduced food waste, and effortless pantry-to-medicine cabinet oversight.
- **Emotional Response:** Reassurance, control, and visual satisfaction upon clearing, auditing, or managing essential items.

## Colors

The palette relies on a bright canvas punctuated by an intentional semantic status system. The primary purple provides an approachable, tech-forward anchor that dissociates the interface from conventional sterile utilities.

### Palette Architecture
- **Primary Canvas (`#F8F8FC`):** An airy, cool lavender-white tint that softens optical glare and prevents high-contrast eye fatigue.
- **Surface Elevation (`#FFFFFF`):** Pure white container base providing crisp separation from the tinted background.
- **Brand Violet (`#7965E8`):** The primary brand and action tone for primary CTA buttons, selection rings, interactive toggles, and main navigation tabs.
- **Primary Text (`#20202A`):** Deep ink charcoal delivering high legibility without the harshness of pure black.
- **Muted Text (`#777787`):** Balanced slate grey reserved for metadata, timestamps, batch tags, and input placeholder states.

### Status Severity Hierarchy
- **Safe / Fresh (`#10B981`):** Balanced emerald indicating abundant shelf-life (> 7 days).
- **Expiring Soon (`#F59E0B`):** Warm amber signaling moderate urgency (2–7 days remaining).
- **Expires Today (`#EF4444`):** Vibrant coral-red driving immediate action without panic.
- **Expired (`#991B1B`):** Deep crimson communicating archived or obsolete items requiring disposal or renewal.

## Typography

The typography uses **Plus Jakarta Sans** across all levels. Its balanced geometric construction, wide apertures, and humanist undertones keep data-dense mobile screens legible and friendly.

- **Numerics & Expiry Counters:** Days-remaining callouts leverage semibold and bold weights with tabular numeric settings (`tnum`) to eliminate layout jitter during list re-sorting or rapid scanning.
- **Hierarchy:** High-density mobile lists rely on `body-md` for product names and `label-sm` or `label-md` for status badges, tags, and category labels.
- **Scaling:** Top-level dashboard summary numbers scale down from `headline-xl` to `headline-xl-mobile` on narrow viewport devices (<380px) to preserve horizontal spacing.

## Layout & Spacing

The layout is built for quick thumb reachability, fluid single-handed mobile operation, and glanceable content parsing.

### Screen Layout Model
- **Mobile Foundation:** A 4-column fluid layout with an edge margin of `1rem` (16px) and internal column gutters of `1rem`. On devices below 360px width, margins reduce to `0.75rem`.
- **Tablet / Responsive Extensions:** Automatically expands to 8 columns with `1.5rem` margins, allowing side-by-side master-detail splits (e.g., inventory category tree on the left, product list and item inspector on the right).
- **Vertical Spacing Cadence:** Form fields and stacked cards standardise on `space-md` (12px) separation, creating compact visual groupings. Global module groupings use `space-xl` (24px) for distinct section breaks.

## Elevation & Depth

Visual hierarchy combines pure white surface elevation with low-opacity, chromatic drop shadows tinted with the primary hue rather than neutral grey.

- **Level 0 (App Canvas):** Flat `#F8F8FC` tone.
- **Level 1 (Cards, List Items, Chips):** Solid `#FFFFFF` background with a subtle ambient shadow: `box-shadow: 0 2px 8px -2px rgba(32, 32, 42, 0.04), 0 4px 16px -4px rgba(121, 101, 232, 0.06)`. Outlines are avoided; visual separation relies on shadow spread against the canvas.
- **Level 2 (Active Drag States, Floating Action Buttons):** Lifted surfaces utilize `box-shadow: 0 8px 24px -4px rgba(121, 101, 232, 0.18)`.
- **Level 3 (Modals, Quick-Add Bottom Sheets):** Anchored modal overlays feature `box-shadow: 0 -8px 32px 0 rgba(32, 32, 42, 0.08)`, supported by a 40% opacity darkened backdrop blur (`backdrop-filter: blur(8px)`).

## Shapes

The interface features soft, approachable curvature that feels modern and friendly while maximizing screen real estate.

- **Cards & Modal Sheets:** Uniformly use `rounded-lg` (16px) to reinforce tactile containment.
- **Buttons & Input Elements:** Built with standard rounded corners (8px) for structural reliability and clear tap targets.
- **Badges, Filter Pills, and Floating Buttons:** Always use full pill radii (9999px) to signal micro-tags, non-text controls, and rapid filter selection.

## Components

### Buttons
- **Primary Button:** `#7965E8` background, `#FFFFFF` text, `0.5rem` border radius, min-height 48px for accessible touch target. Active state drops brightness by 10%.
- **Secondary / Tertiary Button:** `#F0EEFC` background with `#7965E8` text for secondary actions. Ghost buttons use transparent backgrounds with `#777787` icon/text.
- **Icon Quick-Action Button:** Square 44x44px button with 8px radius or 48px circle, used for rapid barcode scanning or camera-based receipt ingestion.

### Product & Expiry Cards
- **Card Container:** `#FFFFFF` background, `1rem` radius, ambient Level 1 elevation, `1rem` internal padding.
- **Urgency Indicator Rail:** A 4px vertical indicator strip along the card's leading edge colored strictly by status severity (`#10B981`, `#F59E0B`, `#EF4444`, or `#991B1B`).
- **Layout:** Leading product icon or thumbnail (40x40px, rounded-md), followed by product name (`headline-sm`), category label (`body-sm`), and a trailing vertical stack containing the remaining days counter (`numeric-countdown`) and status pill.

### Status Badges & Category Chips
- **Status Badges:** Pill-shaped, compact padding (4px vertical, 8px horizontal). Rendered with 12% tint backgrounds matching the status color and solid foreground text (e.g., `#EF4444` foreground over `#FEE2E2` background for "Expires Today").
- **Category Filter Chips:** Horizontal scrolling pill tags. Unselected: `#FFFFFF` fill, `#777787` text. Selected: `#7965E8` fill, `#FFFFFF` text, subtle brand shadow.

### Input Fields & Selectors
- **Form Controls:** 48px fixed height, pure `#FFFFFF` background, 1.5px subtle border in `#E5E5EE`, 8px radius. Text in `#20202A`.
- **Focus State:** 2px solid `#7965E8` ring with a 2px outer glow (`rgba(121, 101, 232, 0.2)`).
- **Date Picker Trigger:** Integrated icon adornment on the trailing edge; dynamically displays the calculated remaining days next to the selected date.

### Checkboxes & List Toggles
- **Consumed / Discarded Checkbox:** 22px rounded square (6px radius). Checked state transitions smoothly to `#7965E8` with a white checkmark icon; crossed-out text style applied to primary title with 50% opacity fade.