import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../utils/date_helpers.dart';

/// Expiry status enumeration as specified in the requirements.
enum ExpiryStatus { SAFE, EXPIRING_SOON, EXPIRES_TODAY, EXPIRED }

/// Result of expiry status calculation containing all relevant information.
class ExpiryStatusResult {
  final ExpiryStatus status;
  final int daysRemaining;
  final String expiryLabel;
  final Color statusColor;
  final bool isNegative;
  final String formattedDate;

  const ExpiryStatusResult({
    required this.status,
    required this.daysRemaining,
    required this.expiryLabel,
    required this.statusColor,
    required this.isNegative,
    required this.formattedDate,
  });

  /// Human-readable string for display
  String get statusDisplay => _statusDisplay();

  String _statusDisplay() {
    switch (status) {
      case ExpiryStatus.SAFE:
        return 'Safe';
      case ExpiryStatus.EXPIRING_SOON:
        return 'Expiring Soon';
      case ExpiryStatus.EXPIRES_TODAY:
        return 'Expires Today';
      case ExpiryStatus.EXPIRED:
        return 'Expired';
    }
  }

  @override
  String toString() =>
      'ExpiryStatusResult(status: $status, days: $daysRemaining, label: $expiryLabel)';
}

/// Centralized expiry calculation engine.
/// All expiry status calculations go through this class to avoid duplication.
class ExpiryCalculationEngine {
  ExpiryCalculationEngine._();

  /// Calculates the expiry status for a product given its purchase and expiry dates.
  ///
  /// [purchaseDate] and [expiryDate] should be in YYYY-MM-DD format (date-only).
  /// Returns an [ExpiryStatusResult] with the calculated status.
  static ExpiryStatusResult calculateExpiryStatus({
    required String purchaseDate,
    required String expiryDate,
  }) {
    // Parse the dates (YYYY-MM-DD format)
    final purchase = _parseDateOnly(purchaseDate);
    final expiry = _parseDateOnly(expiryDate);

    if (purchase == null || expiry == null) {
      // Invalid date format
      return const ExpiryStatusResult(
        status: ExpiryStatus.EXPIRED,
        daysRemaining: 0,
        expiryLabel: 'Invalid date',
        statusColor: Color(0xFFBA1A1A),
        isNegative: true,
        formattedDate: 'Invalid',
      );
    }

    // Calculate days between purchase and expiry
    final purchaseDay = _dateToEpochDay(purchase);
    final expiryDay = _dateToEpochDay(expiry);
    final purchaseToExpiryDays = expiryDay - purchaseDay;

    // Calculate days remaining from today to expiry
    final today = _dateToEpochDay(_todayDate());
    final daysRemaining = expiryDay - today;

    // Determine status based on days remaining
    ExpiryStatus status;
    String label;
    Color color;
    bool isNegative;

    if (daysRemaining >= AppConstants.expiringSoonThresholdDays) {
      // SAFE: More than 7 days remaining
      status = ExpiryStatus.SAFE;
      label = 'Safe';
      color = const Color(0xFF10B981); // Safe green
      isNegative = false;
    } else if (daysRemaining >= 1) {
      // EXPIRING_SOON: 1-7 days remaining
      status = ExpiryStatus.EXPIRING_SOON;
      label = 'Expiring Soon';
      color = const Color(0xFFF59E0B); // Expiring amber
      isNegative = false;
    } else if (daysRemaining == 0) {
      // EXPIRES_TODAY: 0 days remaining
      status = ExpiryStatus.EXPIRES_TODAY;
      label = 'Expires Today';
      color = const Color(0xFFEF4444); // Expires today red
      isNegative = false;
    } else {
      // EXPIRED: Negative days remaining
      status = ExpiryStatus.EXPIRED;
      label = 'Expired';
      color = const Color(0xFF991B1B); // Expired crimson
      isNegative = true;
    }

    return ExpiryStatusResult(
      status: status,
      daysRemaining: daysRemaining,
      expiryLabel: label,
      statusColor: color,
      isNegative: isNegative,
      formattedDate: _formatDateOnly(expiry),
    );
  }

  /// Gets the number of days between two date-only values.
  static int daysBetween({
    required String startDate,
    required String endDate,
  }) {
    final start = _parseDateOnly(startDate);
    final end = _parseDateOnly(endDate);

    if (start == null || end == null) {
      return 0;
    }

    final startDay = _dateToEpochDay(start);
    final endDay = _dateToEpochDay(end);
    return endDay - startDay;
  }

  /// Determines if an expiry date is before the purchase date.
  static bool isExpiryBeforePurchase({
    required String purchaseDate,
    required String expiryDate,
  }) {
    final purchase = _parseDateOnly(purchaseDate);
    final expiry = _parseDateOnly(expiryDate);

    if (purchase == null || expiry == null) {
      return false;
    }

    final purchaseDay = _dateToEpochDay(purchase);
    final expiryDay = _dateToEpochDay(expiry);
    return expiryDay < purchaseDay;
  }

  /// Gets expiry label for a specific status.
  static String getExpiryLabel(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.SAFE:
        return 'Safe';
      case ExpiryStatus.EXPIRING_SOON:
        return 'Expiring Soon';
      case ExpiryStatus.EXPIRES_TODAY:
        return 'Expires Today';
      case ExpiryStatus.EXPIRED:
        return 'Expired';
    }
  }

  /// Gets the status color for a specific expiry status.
  static Color getStatusColor(ExpiryStatus status) {
    switch (status) {
      case ExpiryStatus.SAFE:
        return const Color(0xFF10B981);
      case ExpiryStatus.EXPIRING_SOON:
        return const Color(0xFFF59E0B);
      case ExpiryStatus.EXPIRES_TODAY:
        return const Color(0xFFEF4444);
      case ExpiryStatus.EXPIRED:
        return const Color(0xFF991B1B);
    }
  }

  /// Sorts a list of products by expiry date (nearest first).
  /// Each product map must have 'expiryDate' key in YYYY-MM-DD format.
  static List<Map<String, dynamic>> sortProductsByExpiry(
      List<Map<String, dynamic>> products) {
    final sorted = List<Map<String, dynamic>>.from(products);
    sorted.sort((a, b) {
      final dateA = a['expiryDate'] ?? '';
      final dateB = b['expiryDate'] ?? '';
      return _compareDates(dateA, dateB);
    });
    return sorted;
  }

  /// Gets products expiring today from a list.
  static List<Map<String, dynamic>> getProductsExpiringToday(
      List<Map<String, dynamic>> products) {
    return products.where((product) {
      final result = calculateExpiryStatus(
        purchaseDate: product['purchaseDate'] ?? '',
        expiryDate: product['expiryDate'] ?? '',
      );
      return result.daysRemaining == 0;
    }).toList();
  }

  /// Gets products expiring this week (1-7 days) from a list.
  static List<Map<String, dynamic>> getProductsExpiringThisWeek(
      List<Map<String, dynamic>> products) {
    return products.where((product) {
      final result = calculateExpiryStatus(
        purchaseDate: product['purchaseDate'] ?? '',
        expiryDate: product['expiryDate'] ?? '',
      );
      return result.daysRemaining > 0 &&
          result.daysRemaining <= AppConstants.expiringSoonThresholdDays;
    }).toList();
  }

  /// Gets expired products from a list.
  static List<Map<String, dynamic>> getExpiredProducts(
      List<Map<String, dynamic>> products) {
    return products.where((product) {
      final result = calculateExpiryStatus(
        purchaseDate: product['purchaseDate'] ?? '',
        expiryDate: product['expiryDate'] ?? '',
      );
      return result.daysRemaining < 0;
    }).toList();
  }

  /// Gets safe products from a list.
  static List<Map<String, dynamic>> getSafeProducts(
      List<Map<String, dynamic>> products) {
    return products.where((product) {
      final result = calculateExpiryStatus(
        purchaseDate: product['purchaseDate'] ?? '',
        expiryDate: product['expiryDate'] ?? '',
      );
      return result.daysRemaining >= AppConstants.expiringSoonThresholdDays;
    }).toList();
  }

  /// Compares two date strings in YYYY-MM-DD format.
  static int _compareDates(String dateA, String dateB) {
    final parsedA = _parseDateOnly(dateA);
    final parsedB = _parseDateOnly(dateB);

    if (parsedA == null || parsedB == null) {
      return 0;
    }

    final epochA = _dateToEpochDay(parsedA);
    final epochB = _dateToEpochDay(parsedB);
    return epochA.compareTo(epochB);
  }

  /// Parses a date string in YYYY-MM-DD format to a DateTime object.
  static DateTime? _parseDateOnly(String dateString) {
    if (dateString.isEmpty) {
      return null;
    }

    try {
      // Validate format: YYYY-MM-DD
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(dateString)) {
        return null;
      }

      // Parse and validate the date
      final parsed = DateTime.tryParse(dateString);
      if (parsed == null) {
        return null;
      }

      // Validate that it's a proper date (not Feb 31, etc.)
      final year = parsed.year;
      final month = parsed.month;
      final day = parsed.day;

      // Check month boundaries
      final daysInMonth = _daysInMonth(year, month);
      if (day < 1 || day > daysInMonth) {
        return null;
      }

      return parsed;
    } catch (e) {
      return null;
    }
  }

  /// Returns the number of days in a given month/year.
  static int _daysInMonth(int year, int month) {
    if (month == 2) {
      // Leap year check
      return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
    }
    return _monthDays[month] ?? 31;
  }

  /// Epoch day number from a DateTime (date-only, ignoring time).
  static int _dateToEpochDay(DateTime date) {
    // Normalize to midnight UTC to avoid timezone issues
    return Date.utc(
      date.year,
      date.month,
      date.day,
    ).dayNumber;
  }

  /// Gets today's date as a DateTime at midnight (UTC-safe).
  static DateTime _todayDate() {
    return DateTime.utc now();
  }

  /// Format a DateTime to YYYY-MM-DD string.
  static String _formatDateOnly(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Map of month days (index 1-12, unused index 0 = 31 default)
  static final Map<int, int> _monthDays = {
    1: 31, // January
    2: 28, // February (adjusted for leap year in _daysInMonth)
    3: 31, // March
    4: 30, // April
    5: 31, // May
    6: 30, // June
    7: 31, // July
    8: 31, // August
    9: 30, // September
    10: 31, // October
    11: 30, // November
    12: 31, // December
  };
}

/// Extension on DateTime to get the epoch day number.
extension DateTimeExtension on DateTime {
  /// Returns the epoch day number for this date (midnight-relative).
  int get dayNumber => _dateToEpochDay(this);
}