# ExpiryAlert — Architecture Overview

## Project Structure Philosophy

This project follows a **feature-first clean architecture** with strict separation of concerns:

- **UI:** Widget composition, no business logic
- **Business Logic:** Expiry calculations, status determination, notification scheduling
- **State Management:** Riverpod providers/notifiers
- **Database:** SQLite (local persistence), Supabase (cloud sync)
- **Repositories:** Abstraction layer between features and data sources
- **API Integrations:** Open Food Facts, Supabase endpoints

## Layer Overview

### 1. `lib/core/` — Shared Infrastructure

Core utilities used across all features.

#### `database/`
- `database_helper.dart` — `sqflite` database initialization, migrations, transactions
- `product_dao.dart` — Data Access Object for product CRUD operations
- Migration scripts with `onUpgrade` support

#### `errors/`
- Custom `ExpiryAlertError` hierarchy
- `DatabaseException`, `NetworkException`, `ValidationException`
- Error handling utilities with user-friendly messages

#### `notifications/`
- `notification_service.dart` — `flutter_local_notifications` management
- Channel configuration for Android (high importance, low importance, reminders)
- Timezone-aware scheduling with `flutter_timezone`
- Notification ID management and reconciliation

#### `services/`
- `open_food_facts_service.dart` — API client for Open Food Facts
- `barcode_scanner_service.dart` — Mobile scanner wrapper
- `ocr_service.dart` — Google ML Kit Text Recognition wrapper

#### `utils/`
- `expiry_calculation.dart` — Centralized expiry status engine (see Phase 07)
- `date_helpers.dart` — Date formatting, parsing, timezone handling
- `local_storage.dart` — Shared preferences wrapper
- `string_extensions.dart` — String utilities

#### `widgets/`
Reusable UI components used across multiple screens:

- `product_card.dart` — Card with urgency rail, suitable for list display
- `status_badge.dart` — Pill-shaped status indicator (Safe/Expiring Soon/Expires Today/Expired)
- `category_chip.dart` — Filter pill with selection state
- `primary_button.dart — Primary CTA button
- `secondary_button.dart` — Secondary action button
- `error_state_widget.dart` — Generic error display with retry
- `empty_state_widget.dart` — Empty list state with illustration/text
- `loading_state_widget.dart` — Skeleton loading or progress indicator
- `top_metrics_bar.dart` — 4-card summary grid (total, expiring soon, expires today, expired)
- `quick_action_pills.dart` — Horizontal action button row
- `notification_toggle.dart` — Master/sub reminder toggle pattern

### 2. `lib/app/` — App-Wide Configuration

#### `app.dart` — Application root, initialization setup
- Riverpod scope provider
- Default app configuration
- Permission request handling

#### `router.dart` — GoRouter declaration
- All route definitions
- Navigation guards (auth checks)
- Deep link handling for notification taps
- Android back navigation overrides

### 3. `lib/features/` — Feature Modules

Each feature is a self-contained module with its own UI, state, and logic. No feature imports another feature's internal state.

#### `onboarding/`
- `onboarding_screen.dart` — Welcome screens (3-4 steps)
- `onboarding_provider.dart` — Step tracking

#### `home/`
- `home_dashboard.dart` — Main dashboard screen
- `home_provider.dart` — Dashboard data loading, expiry recalculation on resume
- `metrics_bar_widget.dart` — 4-stat summary grid
- `expiring_list_widget.dart` — Grouped product list by status
- `recently_added_widget.dart` — Recently added products carousel

#### `products/`
- `products_list.dart` — Products list with search/filter/sort
- `product_form_widget.dart` — Shared form component
- `product_card_detail.dart` — Detail view card

#### `add_product/`
- `add_product_screen.dart` — Add product form
- `add_product_provider.dart` — Form state management
- Category selector, barcode integration, OCR integration

#### `product_details/`
- `product_details_screen.dart` — Product detail view
- `product_details_provider.dart` — Detail state

#### `barcode_scanner/`
- `barcode_scanner_screen.dart` — MobileScanner wrapper
- `barcode_scanner_provider.dart` — Scan result handling

#### `expiry_ocr/`
- `expiry_ocr_screen.dart` — OCR camera wrapper
- `expiry_ocr_provider.dart` — Text extraction result handling

#### `notifications/`
- `notification_preferences_screen.dart` — Reminder cadence settings
- `notification_service.dart` — Used also by core layer

#### `authentication/`
- `login_screen.dart` — Login form
- `register_screen.dart` — Registration form
- `auth_controller.dart` — Auth state management

#### `settings/`
- `settings_screen.dart` — Main settings page
- `theme_settings_widget.dart` — Light/dark/system selector
- `notification_settings_widget.dart` — Reminder cadence
- `data_settings_widget.dart` — SQLite/Supabase sync options

#### `synchronization/`
- `sync_manager.dart` — Supabase sync logic
- `sync_controller.dart` — Trigger and status tracking

### 4. `lib/models/` — Data Models

#### `product.dart` — Main Product model with all fields
- `id`, `name`, `category`, `brand`, `barcode`
- `expiryDate`, `purchaseDate`, `quantity`, `unit`
- `notes`, `imagePath`, `reminderPreferences`
- `createdAt`, `updatedAt`, `deletedAt`
- `syncStatus` (local, synced, pending, error)

#### `expiry_status.dart` — Calculated status fields
- `status` (SAFE, EXPIRING_SOON, EXPIRES_TODAY, EXPIRED)
- `daysRemaining`, `expiryLabel`
- `statusColor`

#### `notification_preference.dart` — Reminder settings
- Global defaults (7d/3d/1d/expiry)
- Per-product overrides

#### `supabase_user.dart` — Auth user model

### 5. `lib/repositories/` — Repository Pattern

#### `product_repository.dart` — Abstracts database + sync
- Offline-first: local SQLite is primary source
- Sync: upload local → download cloud → reconcile
- RLS: users only access their own records

#### `auth_repository.dart` — Auth state management
- Session persistence
- Token management

### 6. `lib/main.dart` — App Entry Point

- `runApp()` with Riverpod scope
- Initialization sequence
- Router configuration

---

## Data Flow

### Product Creation Flow

```
User taps FAB → AddProductScreen
  ↓
addProductProvider validates fields
  ↓
if valid → show barcode/OCR options
  ↓
User scans barcode OR captures OCR
  ↓
Open Food Facts API lookup (optional, not assumed to provide expiry)
  ↓
Populate form with extracted data
  ↓
User edits fields as needed
  ↓
Form submission → Product saved to SQLite
  ↓
Notification schedule calculated
  ↓
Dashboard refreshes (expiry status recalculation)
```

### Expiry Status Flow

```
Product saved with expiryDate
  ↓
Database stores date as YYYY-MM-DD (date-only)
  ↓
 onAppForeground / periodic trigger
  ↓
expiryCalculationEngine.getExpiryStatus(purchaseDate, expiryDate)
  ↓
Returns: {status, daysRemaining, expiryLabel, statusColor}
  ↓
Dashboard displays updated status cards
  ↓
Notifications scheduled based on status
```

### Notification Flow

```
Product saved with expiryDate + reminderPreferences
  ↓
notificationService.calculateReminderTimes(status, expiryDate)
  ↓
Schedules notifications at:
  - 7 days before expiry
  - 3 days before expiry
  - 1 day before expiry
  - On expiry day
  ↓
Notification ID stored in product record
  ↓
On product edit/reschedule: cancel old, reschedule new
  ↓
On product deletion: cancel notifications
  ↓
On app restart: reconcile scheduled notifications
```

### Sync Flow (Local ↔ Cloud)

```
App startup → syncManager.checkForUpdates()
  ↓
If online:
  - Download cloud records → merge with local
  - Upload local changes (new/modified/deleted)
  - Track last sync timestamp
  ↓
If offline:
  - Use local SQLite as source of truth
  - Queue sync for when connectivity restores
  ↓
Conflict resolution: cloud timestamp vs local timestamp
  - newer timestamp wins
  - RLS ensures user-only access
```

---

## State Management Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    RIVERPOD PROVIDERS                       │
├─────────────────────────────────────────────────────────────┤
│  appProvider (appInit, theme, locale)                       │
│  homeProvider (products, loading, error)                    │
│  addProductProvider (formState, validation)                 │
│  productDetailsProvider (selectedProduct, editingMode)      │
│  barcodeScannerProvider (result, scanning)                  │
│  expiryOCRProvider (ocrResult, confirmed)                   │
│  notificationPreferencesProvider (reminderCadence)           │
│  syncManagerProvider (status, lastSync)                     │
│  settingsProvider (theme, dateFormat, notifications)        │
└─────────────────────────────────────────────────────────────┘
           ▲                   ▲                   ▲
           │                   │                   │
           └──────┬────────────┼─────────────┬─────┘
                   │           │           │
          Widgets.watch   │   Context.watch
                          │           │
                  (Rebuild on     (Rebuild on
                   provider change) provider change)
```

---

## Initialization Sequence

1. `main.dart` → `runApp(AppProvider(scope: widget))`
2. `AppProvider` initializes:
   - Riverpod scope
   - `DatabaseHelper` (create/open SQLite database)
   - `NotificationService` (request permissions)
   - `SyncManager` (check initial state)
3. `GoRouter` evaluates initial location:
   - If no session → `/login`
   - If anonymous → `/onboarding` or `/home` (limited)
   - If authenticated → `/home`
4. App displays appropriate first screen

---

## Offline-First Strategy

### Core Principle

**Local SQLite is the source of truth. Cloud (Supabase) is synchronized.**

### When Online

1. App performs initial sync on startup
2. Local changes are uploaded to Supabase
3. Cloud changes are downloaded and merged
4. Conflict resolution: newer `updatedAt` timestamp wins

### When Offline

1. All product CRUD operations use SQLite
2. UI reads from local database
3. Changes are queued for later sync
4. Notification scheduling continues locally

### Sync Conflict Resolution

| Scenario | Resolution |
|----------|-----------|
| Local updatedAt > Cloud updatedAt | Local changes win |
| Cloud updatedAt > Local updatedAt | Cloud changes win (merge) |
| Same timestamp, different data | User prompted to choose |
| Deleted on cloud, not local | Local record marked `deletedAt` |
| Deleted locally, not on cloud | Record marked `deletedAt`, visible in UI with "cloud restored" indicator |

---

## Route Map

| Route Pattern | Page Title | Guards |
|---------------|-----------|--------|
| `/` | SplashScreen | None |
| `/onboarding` | Onboarding | None (anonymous users) |
| `/login` | Login | anon-only |
| `/register` | Register | anon-only |
| `/home` | HomeDashboard | auth-required |
| `/products` | ProductsList | auth-required |
| `/add-product` | AddProductForm | auth-required |
| `/product-details/:id` | ProductDetails | auth-required |
| `/edit-product/:id` | EditProductForm | auth-required |
| `/barcode-scanner` | BarcodeScanner | auth-required |
| `/expiry-ocr` | ExpiryOCRScanner | auth-required |
| `/notifications` | NotificationPreferences | auth-required |
| `/settings` | SettingsScreen | auth-required |

### Android Back Navigation

- GoRouter will handle back button presses
- `/` (Splash) will pop to exit
- `/home` will show exit confirmation on second back press
- Deep link notification taps will navigate to relevant product

### Notification Deep Links

When a notification is tapped:
1. Extract product ID from notification payload
2. Navigate to `/product-details/:id`
3. Highlight the expiring product in the list
4. Show local notification

---

## QA Test Strategy

### Unit Tests

- `expiry_calculation.dart` — all boundary conditions
- `date_helpers.dart` — formatting, parsing, timezone
- `product_dao.dart` — CRUD operations (in-memory mock)
- `notification_service.dart` — scheduling/cancellation

### Widget Tests

- Metrics bar displays correct counts
- Status badges show correct color/text
- Category chips filter correctly
- Empty states render appropriately

### Integration Tests (if device available)

- Product lifecycle: add → edit → delete
- Notification scheduling and taps
- Barcode scanner permission flow
- OCR text recognition
- SQLite migration on app upgrade
- Sync workflow online/offline

---

## Migration Plan from Existing Android Project

The existing `./expiry_alert/app/` directory contains an Android Compose project. This will be:

1. **Removed:** Android-specific Compose code, Gradle configurations for Android-only
2. **Replaced:** Flutter project initialized at `./expiry_alert/`
3. **Preserved:** Any working functionality, package configurations that translate to Flutter

The Flutter project will have its own `pubspec.yaml`, `android/`, and `ios/` directories generated by `flutter create`.

---

## Design System Implementation Checklist

- [x] Color palette from Vigilant Calm DESIGN.md
- [x] Typography: Plus Jakarta Sans, all weights
- [x] Layout: gutter, margin, spacing system
- [x] Elevation: shadow levels 0-3
- [x] Shapes: card radius 16px, pill radius 9999px
- [x] Buttons: primary, secondary, tertiary, icon action
- [x] Product & expiry cards with urgency rail
- [x] Status badges and category chips
- [x] Input fields with focus state
- [x] Checkboxes with smooth transitions
- [x] Metrics summary grid (4 cards)
- [x] Quick action pills
- [x] Theme: light/dark/system
- [x] Date format handling
- [x] Onboarding flow (to be designed)