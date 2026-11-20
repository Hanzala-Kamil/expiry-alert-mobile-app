/// Application-wide constants for ExpiryAlert.

/// Feature flags and configuration
class AppConstants {
  AppConstants._();

  /// Whether to enable cloud synchronization (Supabase)
  static const bool enableCloudSync = true;

  /// Whether to enable local SQLite persistence
  static const bool enableLocalPersistence = true;

  /// Maximum days to look ahead for expiry notifications
  static const int maxExpiryLookAheadDays = 365;

  /// Minimum days remaining to trigger "Expiring Soon" status
  static const int expiringSoonThresholdDays = 7;

  /// Days remaining to trigger "Expires Today" status
  static const int expiresTodayThresholdDays = 1;

  /// Default reminder cadence in days
  static const List<int> defaultReminderCadence = [7, 3, 1];

  /// Open Food Facts API base URL
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org/api/v2';

  /// Open Food Facts product lookup endpoint
  static const String openFoodFactsProductPath = '/product';

  /// Timeout for Open Food Facts API calls in milliseconds
  static const int openFoodFactsApiTimeoutMs = 15000;

  /// Maximum retry attempts for network operations
  static const int maxRetryAttempts = 3;

  /// Base retry delay in milliseconds
  static const int retryBaseDelayMs = 1000;

  /// Maximum retry delay in milliseconds (exponential backoff cap)
  static const int retryMaxDelayMs = 10000;

  /// Supabase configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  /// UI constants
  static const double quickActionButtonSize = 56.0;
  static const double productCardPadding = 16.0;
  static const double metricCardPadding = 16.0;
  static const double formFieldHeight = 48.0;
  static const double bottomNavBarHeight = 60.0;
  static const double safeAreaPadding = 16.0;

  /// Notification constants
  static const String notificationChannelSafe = 'safe_expiries';
  static const String notificationChannelExpiring = 'expiring_soon';
  static const String notificationChannelToday = 'expires_today';
  static const String notificationChannelExpired = 'expired';

  /// Database constants
  static const String databaseName = 'expiry_alert.db';
  static const int databaseVersion = 1;

  /// Sync constants
  static const Duration syncRetryDelay = Duration(minutes: 15);
  static const Duration syncMaxRetryDelay = Duration(hours: 24);
}