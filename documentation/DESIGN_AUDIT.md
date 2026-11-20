# ExpiryAlert — Design Audit

## Project Overview

**Product Name:** ExpiryAlert  
**Goal:** Convert Stitch AI designs into a fully functional Flutter mobile application for expiry date and product management.

**Author:** Senior Flutter Architect  
**Date:** 2026-11-20

---

## 1. Stitch Design Inventory

### Design System: "Vigilant Calm"

The design system is documented in `expiryalert_mobile_app_design/vigilant_calm/DESIGN.md` and provides the complete visual language for the application.

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Surface | `#FCF8FF` | App background canvas |
| Surface Dim | `#DBD8E6` | Subtle background dimming |
| Surface Bright | `#FCF8FF` | Primary surface color |
| Surface Container Lowest | `#FFFFFF` | Clean white containers |
| Surface Container Low | `#F5F2FF` | Secondary containers |
| Surface Container | `#EFECFA` | Main content containers |
| Surface Container High | `#E9E6F5` | Elevated surfaces |
| Surface Container Highest | `#E3E1EF` | Highest elevation surfaces |
| On Surface | `#1B1B24` | Primary text on light backgrounds |
| On Surface Variant | `#484554` | Secondary text, metadata |
| Inverse Surface | `#302F3A` | Inverse text backgrounds |
| Inverse On Surface | `#F2EFFD` | Text on inverse surfaces |
| Outline | `#797585` | Dividers, subtle separators |
| Outline Variant | `#C9C4D6` | Disabled outlines |
| Surface Tint | `#5D48CB` | Interactive surface hints |
| **Primary** | `#5B45C8` | Primary CTA buttons, navigation tabs |
| On Primary | `#FFFFFF` | Text on primary |
| Primary Container | `#7460E3` | Card backgrounds with primary tint |
| On Primary Container | `#FFF BFF` | Text on primary container |
| **Inverse Primary** | `#C8BFFF` | Alternative primary states |
| **Secondary** | `#006C49` | Secondary actions, chips |
| On Secondary | `#FFFFFF` | Text on secondary |
| Secondary Container | `#6CF8BB` | Secondary card backgrounds |
| On Secondary Container | `#00714D` | Text on secondary container |
| **Tertiary** | `#825100` | Tertiary actions, accents |
| On Tertiary | `#FFFFFF` | Text on tertiary |
| Tertiary Container | `#A36700` | Tertiary card backgrounds |
| On Tertiary Container | `#FFF BFF` | Text on tertiary container |
| **Error** | `#BA1A1A` | Error states, destructive actions |
| On Error | `#FFFFFF` | Text on error |
| Error Container | `#FFDAD6` | Error backgrounds |
| On Error Container | `#93000A` | Text on error container |
| **Primary Fixed** | `#E5DEFF` | Fixed primary backgrounds |
| **Primary Fixed Dim** | `#C8BFFF` | Disabled primary states |
| **On Primary Fixed** | `#1A0063` | Text on primary fixed |
| **Primary Fixed Variant** | `#452BB2` | Primary variant states |
| **Secondary Fixed** | `#6FFBFF` | Fixed secondary backgrounds |
| **Secondary Fixed Dim** | `#4EDEA3` | Disabled secondary states |
| **On Secondary Fixed** | `#002113` | Text on secondary fixed |
| **Secondary Fixed Variant** | `#005236` | Secondary variant states |
| **Tertiary Fixed** | `#FFDDBA` | Fixed tertiary backgrounds |
| **Tertiary Fixed Dim** | `#FFB95F` | Disabled tertiary states |
| **On Tertiary Fixed** | `#2A1700` | Text on tertiary fixed |
| **Tertiary Fixed Variant** | `#653E00` | Tertiary variant states |
| **Background** | `#FCF8FF` | Overall app background |
| **On Background** | `#1B1B24` | Text on background |

### Status Severity Colors (Semantic)

| Status | Hex | Description |
|--------|-----|-------------|
| Safe / Fresh | `#10B981` | > 7 days remaining |
| Expiring Soon | `#F59E0B` | 2–7 days remaining |
| Expires Today | `#EF4444` | 0 days remaining |
| Expired | `#991B1B` | Negative days remaining |

### Typography: Plus Jakarta Sans

All typography uses the **Plus Jakarta Sans** font family with the following styles:

| Style | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| Headline XL | 32px | 700 | 40px | -0.02em |
| Headline XL (Mobile) | 26px | 700 | 34px | -0.015em |
| Headline LG | 24px | 600 | 32px | -0.01em |
| Headline MD | 20px | 600 | 28px | — |
| Headline SM | 16px | 600 | 24px | — |
| Body LG | 16px | 400 | 24px | — |
| Body MD | 14px | 400 | 20px | — |
| Body SM | 12px | 400 | 18px | — |
| Label LG | 14px | 600 | 20px | +0.01em |
| Label MD | 12px | 600 | 16px | +0.02em |
| Label SM | 11px | 700 | 14px | +0.03em |
| Numeric Countdown | 18px | 700 | 22px | — |

### Layout & Spacing

**Gutter System:**
- Gutter: `1rem` (16px)
- Gutter Compact: `0.75rem` (12px)
- Margin: `1rem` (16px)
- Margin Tablet: `1.5rem` (24px)
- Space XS: `0.25rem` (4px)
- Space SM: `0.5rem` (8px)
- Space MD: `0.75rem` (12px)
- Space LG: `1rem` (16px)
- Space XL: `1.5rem` (24px)
- Space 2XL: `2rem` (32px)

**Screen Layout Model:**
- Mobile: 4-column fluid layout with 1rem edge margin
- Tablet: 8-column layout with 1.5rem margins
- Vertical cadence: `space-md` (12px) for form fields, `space-xl` (24px) for global sections

### Elevation & Depth

| Level | Description |
|-------|-------------|
| Level 0 | App canvas: `#F8F8FC` flat tone |
| Level 1 | Cards, list items, chips: `#FFFFFF` with ambient shadow |
| Level 2 | Active drag states, FAB: `0 8px 24px -4px rgba(121,101,232,0.18)` |
| Level 3 | Modals, quick-add bottom sheets: `0 -8px 32px 0 rgba(32,32,42,0.08)` with 40% opacity backdrop blur |

### Shapes & Rounded Corners

| Component | Radius |
|-----------|--------|
| Cards & Modal Sheets | `rounded-lg` (16px) |
| Buttons & Input Elements | 8px radius |
| Badges, Filter Pills, FAB | `full` (9999px) — pill shape |

### Components

#### Buttons

- **Primary Button:** `#7965E8` background, `#FFFFFF` text, 0.5rem radius, min-height 48px. Active state drops brightness by 10%.
- **Secondary / Tertiary Button:** `#F0EEFC` background with `#7965E8` text. Ghost buttons: transparent with `#777787` icon/text.
- **Icon Quick-Action Button:** Square 44×44px or 48px circle. Used for barcode scanning or camera ingestion.

#### Product & Expiry Cards

- **Card Container:** `#FFFFFF` background, 1rem radius, Level 1 ambient shadow, 1rem internal padding.
- **Urgency Indicator Rail:** 4px vertical strip along leading edge, colored by status severity.
- **Layout:** Leading product icon/thumbnail (40×40px, rounded), product name (`headline-sm`), category label (`body-sm`), trailing vertical stack with days counter (`numeric-countdown`) and status pill.

#### Status Badges & Category Chips

- **Status Badges:** Pill-shaped, compact padding (4px vertical, 8px horizontal). 12% tint backgrounds matching status color with solid foreground text.
- **Category Filter Chips:** Horizontal scrolling pill tags. Unselected: `#FFFFFF` fill, `#777787` text. Selected: `#7965E8` fill, `#FFFFFF` text with subtle brand shadow.

#### Input Fields & Selectors

- **Form Controls:** 48px fixed height, `#FFFFFF` background, 1.5px subtle border `#E5E5EE`, 8px radius. Text in `#20202A`.
- **Focus State:** 2px solid `#7965E8` ring with 2px outer glow `rgba(121,101,232,0.2)`.
- **Date Picker Trigger:** Integrated icon adornment on trailing edge; displays calculated remaining days next to selected date.

#### Checkboxes & List Toggles

- **Consumed/Discarded Checkbox:** 22px rounded square (6px radius). Checked state transitions to `#7965E8` with white checkmark. Crossed-out text style with 50% opacity fade.

---

## 2. Available Screens from Stitch Designs

| Screen Name | HTML File | Key Features |
|-------------|-----------|--------------|
| **Home Dashboard** | `expiryalert_home_dashboard/code.html` | Metrics grid, expiring soon list, recently added, quick action pills |
| **All Products Inventory** | `all_products_inventory/code.html` | Search bar, category chips, status filter dropdown, grouped product list, offline sync indicator |
| **Add Product** | `add_new_product/code.html` | Product name (required), category selector, expiry date picker, barcode scanning, OCR for expiry date, brand (optional), barcode/GTIN, purchase date, quantity & unit, product photo, storage notes, reminder cadence |
| **Settings Data Management** | `settings_data_management/code.html` | Profile section, notification reminders cadence, SQLite export/clear, Supabase cloud sync, theme selector (light/dark/system), about, logout |
| **Vigilant Calm Design System** | `vigilant_calm/DESIGN.md` | Full design system documentation — colors, typography, layout, elevation, shapes, components |

### Missing Screens (to be designed consistently with design system)

- Onboarding flow (welcome screens)
- Product Details screen
- Edit Product screen
- Barcode Scanner screen
- Expiry OCR Scanner screen
- Notification Preferences screen
- Login / Registration screens
- Profile screen
- Forgot Password screen

---

## 3. Extracted Assets

### Images (from HTML, sourced from Googleusercontent)

| Asset | Alt Text | Usage |
|-------|----------|-------|
| ExpiryAlert Logo | `aida/ALJJyrD_tp79JarSJJ-VsLYRj2fv1dYxUZtgsWYpgkJDqmVd9BojlI5ac6eA0dmLhphPqvEc4KoGoSiKionWEpiF3xweCxkTltYsCkkohK1Jc5TbvGIWDlkfcjxs_UM2Q5gVtGA9Gu9xFq52U_2fNoBEXTdM4qn0N3sg72-t8cy74rYGFpxpt7k4veFf5vN0hCvJfkuRj-8nMCQvy3cU9QkeSPZFMJqejTqff81qz64nlPq-` | App bar logo, bottom nav |
| Profile Image (Sarah) | `aida-public/AB6AXuB2haEO_q7ZlMkEbjum66hlYxpLO_7UAk-IsXtnVb6f3VMk-xi-QxpOlH2kiCsSi18-oCBQ83s-vzPHhhqMc4aEnT8B85pI8lr1olQa8VeIYbiRCwzzYVx01Dkf2KXku0gltuhPAFVEwtW2ixLo-numECHD-qMalUKdYt7mW7kfk6f6QoZFAcz_nFLYHghZRZ888ZpSyxYa2rWrB_XnaJYZjJkQp18N7QrCEaPR1Kw` | User profile header |
| Greek Yogurt Image | `aida-public/AB6AXuBeIFssDw_1t9JAYUS4mYEf20CCw4D7B07BkXIny3EIKWSX1tVE2m4k-oK73pZpeB2nkVhdLBIHntn-DCo5O-ZSFe_uoIFOqWiDo0AXtQbC0tJLGYadbbLDNw7dgPVlklhIHkXbyU_7IOFfDQnAup9inUZ_u92MqRkEDMiNZNEbQMwh00s3JMHJbybh7LoeCJE6vjWKsEeQZwMVczAaEXy1m73E47HKY6sZqxGmwVY` | Home dashboard - Dairy product |
| Amoxicillin Image | `aida-public/AB6AXuAbWxn8aqDN8qezvvMbwlwQXx_hEJ-4mPiNt5MxnLPkGaHV_M4Vl_svTA_jBJnmmRJG4WOP1sr1E_NEGxvfChbItFegGKHR7e0sjlZ0fFwMkhYvFQBZSoj3DJfgHbngC7iNKqZWlJ14va7-fj5c1k-M6LFXXATaxZN84DrcBpm5ZtSRLY3W850BT79cAdJAaiUSiz2Oz-AFSRgXHtxkIlmB7IAE91lUY_b3ZH_JADE` | Home dashboard - Medicine |
| Baby Spinach Image | `aida-public/AB6AXuDVb8H1xU68AkLjXIONVizWs2citbd4Ypun19VZNSWRXu6AgR3182SdLxXRR9XI5i7dzz0yO24aPE0jDU5QmQlUMY2edvKy_l66eNpuhcUMC2OjltzvSKI1LOnO6wEjiZD7IA-r1ocEb6nrMovELoestxGj0dgsWPOPrECBVkjN2nYFUmnkPzeiEcF-_tD1lh5_RRiWOAdrQn3-lb-m_mljm3lurRZRlMcjZD-Ipn4` | Home dashboard - Produce |
| Vitamin D3 Image | `aida-public/AB6AXuAlcFBMhV_CWuT4RvwTTRbjUXDwnu4rZYbfuL_ZrPUNEN9_YZhHHd7s6osFuliyheF4pvnWZLJdKntCGlz3WacjYZTnCDRQanAWDEfzAU_WlrGTd-A-UpyFpNqR9LZkrmT8vSQqS2LIpW1UuCF5Git4ysFlP40EvotrzFRme6mflPmrTcNGcDIp_9mgxcWogSunXF3ZgHK74bYOwJmVHSfuYE94KHUQzbDL0zBf-EQ` | Home dashboard - Supplements |
| Coffee Image | `aida-public/AB6AXuBw0RyZ_taAA4AdzL7VzbWXx0CrRdi3w-epf1OedAlXT4IZUrxeYajY9BmqCKilPlMs4MU0rZC6P2msVk6FpIbPmdPrC6PbjPUCpUC_lTnr13DwE8__Z-ZOCTIacZmJuSeAuS2SRw_EjTCTjv6rMXWFzAByIqzqUSzWyWAoed_Klu9nINTJGxp6uYdLmnlPvE4SxJm6roHzFUaTEMT88FnEzRgOCGwQzBNh0AA3amE` | Home dashboard - Beverages |
| Sunscreen Image | `aida-public/AB6AXuDqgLIaf36qKLiQJM_tppaUa7ulBYKFpPxlc8EortlBNyh59LAF26dKiD5qEUkHTp6Y8DddHzLzTWdnchJt4oE9762AhBfeuwxNv94KsAh26eHrenOk3sebSuasY2iXQpSwyCuvKufONBcot2hxCw0iqxLOtds7128JZC9pLV8c7MzucMqBa9mWCOxbVkqpDWcF9WHa7mooKckacIV7-vEbdSCNnnMfvK3FXrTXvVw` | Home dashboard - Skincare |
| Product Placeholder Images | Various `aida-public/...` URLs | Product cards, form preview |

### Fonts

- **Primary Font:** Plus Jakarta Sans (imported from `https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap`)
- **Icon Font:** Material Symbols Outlined (imported from `https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=swap`)

### Color References (from HTML Tailwind config)

The HTML files contain a complete Tailwind CSS config with the full color palette, border radius values, and spacing system. All values have been documented in Section 1 above.

### Typography References

- Font family: `Plus Jakarta Sans`
- All text styles documented in the DESIGN.md and HTML font-size/line-height specifications
- Material Symbols Outlined for icons

---

## 4. Design Observations

### Visual Style

The ExpiryAlert design system employs a **Modern Warm Minimalism** aesthetic with the following characteristics:

- **Bright canvas** (`#F8F8FC` / `#FCF8FF`) with cool lavender-white tint to reduce optical glare
- **Pure white surfaces** (`#FFFFFF`) for crisp separation
- **Intentional semantic color system** using purple primary, amber/red/green status colors
- **Soft, approachable curvature** with 16px radius for cards and 9999px (full pill) for badges/chips
- **Shadow-based elevation** rather than outlines, with primary-hued tints

### Navigation Structure (from HTML bottom nav)

The bottom navigation bar has 5 items (from the home dashboard HTML):

1. **Home** (active) - `home` icon + label
2. **Products** - `inventory_2` icon + label
3. **Add** - FAB-style button (larger, circular, primary-colored)
4. **Insights** - `bar_chart` icon + label
5. **Settings** - `settings` icon + label

**Note:** The FAB-style "Add" button is integrated into the bottom nav rather than being a separate floating action button in the center. The design uses a relative positioning (`-top-5`) to lift the add button above the nav.

### Key UI Patterns

1. **Metric Cards:** 4-grid summary at dashboard top showing total products, expiring soon count, expires today count, expired count
2. **Urgency Rail:** 4px vertical color strip on card leading edge indicating expiry status
3. **Grouped Product Lists:** Products grouped by status (Expires Today, Expiring Soon, Safe, Expired) with section headers
4. **Quick Action Pill Buttons:** Horizontal row of action buttons below the greeting section
5. **Category Chips:** Horizontal scrollable chips for product category filtering
6. **Status Filter Dropdown:** Popover menu for filtering by expiry status
7. **Sort Options Popover:** Menu for sorting product list
8. **Reminder Cadence Toggles:** Grid of toggle buttons for notification timing
9. **Master/Sub Toggle Pattern:** Master checkbox with sub-checkboxes (seen in reminders section)
10. **Theme Segmented Control:** 3-option selector for light/dark/system theme

### OCR & Barcode Flow (from Add Product screen)

1. **Barcode Button:** Scans barcode, populates product info from Open Food Facts, asks for expiry date
2. **OCR Button:** Camera capture, extracts text, identifies date formats, asks user to confirm
3. **Quick Date Chips:** +3 days, +1 week, +1 month, +6 months presets
4. **Reminder Schedule:** Master toggle with 7d/3d/1d/expiry day sub-toggle

### Form Fields (from Add Product screen)

- Product Name (required, with `*` marker)
- Category (required, pill selector with 9 categories + Other)
- Expiry Date (required, date picker with countdown badge)
- Brand (optional)
- Barcode / GTIN (optional, with verified status)
- Purchase Date (optional, default to today)
- Quantity & Unit (stepper + dropdown: pcs, bottles, packs, boxes, kg, g, ml, L)
- Product Photo (camera/upload with preview)
- Storage & Usage Notes (textarea)

### Notification Flow (from Settings screen)

- Default reminder cadence: 7 days before, 3 days before, 1 day before, on expiry day
- Daily alert time selector (e.g., 09:00 AM)
- Test local push notification button
- Notification banner preview on test

### Data Persistence (from Settings screen)

- SQLite local mirror ("Offline-ready • SQLite local mirror")
- 24 items stored locally
- Storage usage: 4.2 MB (database + cached images)
- CSV export functionality
- Clear local data with double-tap confirmation

### Cloud Sync (from Settings screen)

- Supabase Row Level Security (RLS) active
- Automatic two-way delta sync
- Last synced indicator (e.g., "12 mins ago")
- Cloud backup toggle (switch)
- Account security banner

### Appearance (from Settings screen)

- Theme selector: Light / Dark / System
- Date format selector (shown as YYYY-MM-DD)
- About section with app version (v1.0.0)
- Privacy policy & terms link
- Logout button

---

## 5. Proposed Flutter Architecture

Based on the design inventory and the ExpiryAlert feature requirements, the following architecture is proposed:

### Directory Structure

```
lib/
  main.dart

  app/
    app.dart
    router.dart
    theme/
    constants/

  core/
    database/
    errors/
    notifications/
    services/
    utils/
    widgets/

  features/
    onboarding/
    home/
    products/
    add_product/
    product_details/
    barcode_scanner/
    expiry_ocr/
    notifications/
    authentication/
    settings/
    synchronization/

  models/
  repositories/

assets/
  images/
  icons/
  fonts/

test/
```

### Key Architecture Principles

1. **Feature-First Organization:** Features are grouped by domain, not by layer
2. **Separation of Concerns:** UI, business logic, state management, database, and API integrations are separate
3. **Reusable Widgets:** All layout components are extracted to `core/widgets/`
4. **Centralized Theme:** M3 theme with custom styling from design system
5. **Offline-First:** SQLite local persistence; Supabase for cloud sync
6. **Riverpod for State Management:** Notifier/provider pattern for all state
7. **GoRouter for Navigation:** Declarative routing with deep link support

### State Management Approach

- **Riverpod** with `ref.watch` for read-only access
- **Notifier** pattern for forms and interactive screens
- **AsyncValue** pattern for loading/error states
- **Repository pattern** for database and API abstraction

### Navigation Routes

| Route | Page |
|-------|------|
| `/` | SplashScreen |
| `/onboarding` | Onboarding |
| `/home` | HomeDashboard |
| `/products` | ProductsList |
| `/add-product` | AddProductForm |
| `/product-details/:id` | ProductDetails |
| `/edit-product/:id` | EditProductForm |
| `/barcode-scanner` | BarcodeScanner |
| `/expiry-ocr` | ExpiryOCRScanner |
| `/notifications` | NotificationPreferences |
| `/login` | LoginScreen |
| `/register` | RegisterScreen |
| `/settings` | SettingsScreen |

### Required Dependencies

| Package | Purpose | Version Hint |
|---------|---------|--------------|
| `flutter/material3` | Material Design 3 | Stable |
| `riverpod` | State management | ^2.5.0 |
| `go_router` | Navigation | ^13.2.0 |
| `supabase_flutter` | Backend / Auth | ^2.7.0 |
| `sqflite` | SQLite persistence | ^2.3.0 |
| `flutter_local_notifications` | Local notifications | ^18.0.1 |
| `mobile_scanner` | Barcode scanning | ^4.2.1 |
| `google_mlkit_text_recognition` | OCR | ^0.9.0 |
| `image_picker` | Image selection | ^1.1.2 |
| `flutter_secure_storage` | Secure storage | ^9.2.0 |
| `uuid` | UUID generation | ^4.4.0 |
| `intl` | Internationalization | ^0.18.0 |

### Missing Design Information

1. Onboarding screen visuals — No Stitch designs; will use design system colors/typography
2. Product Details screen — Partially in All Products Inventory; full design needed
3. Edit Product screen — Based on Add Product form, read-only mode
4. Barcode Scanner UI — Camera preview with overlay; scan result display
5. Expiry OCR UI — Camera preview with detected text overlay
6. Notification deep link handling — When tapped, should open relevant product details
7. Login/Registration flows — No Stitch designs; design consistently with system
8. CSV export format — Not visually specified; will follow data structure
9. Date format locales — Intl support needed; default YYYY-MM-DD for database, locale-aware display
10. Empty states — All lists need proper empty states designed with system typography/colors
11. Error states — Network errors, database errors, OCR failures need visual treatment
12. Splash screen — No design; will use ExpiryAlert logo + app name
13. App bar variations — Subtle differences between screens (profile badge, notification badge, etc.)
14. Keyboard handling — No specific design; standard Flutter safe area + keyboard avoidance
15. Drag & drop interactions — Not in designs; native scroll/click interactions

---

## 6. Next Implementation Step

**Phase 01: Project Initialization & Design System Setup**

1. Initialize Flutter project at `./expiry_alert`
2. Create `documentation/ARCHITECTURE.md`
3. Create `DEVELOPMENT_PROGRESS.md`
4. Set up Flutter project structure
5. Implement centralized theme (M3 + custom Vigilant Calm colors)
6. Define reusable widgets (product card, status badge, category chip)
7. Set up routing with GoRouter
8. Run `flutter analyze` to verify no errors
9. Update DEVELOPMENT_PROGRESS.md with completion status

**Output:** Flutter project scaffold with design system theming, basic navigation, and working project structure.