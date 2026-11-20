import 'dart:math';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';

/// Date helper utilities for ExpiryAlert.
/// Provides date formatting, parsing, timezone handling, and comparison utilities.

/// Formats a [DateTime] to a string using the specified format.
/// Supports both standard and locale-aware formatting.
String formatDate({
  required DateTime date,
  required String format,
  required Locale locale,
}) {
  final dateFormat = DateFormat(format, locale.languageCode);
  return dateFormat.format(date);
}

/// Formats a date-only value (YYYY-MM-DD) to a readable string.
/// Supported formats: DD/MM/YYYY, MM/DD/YYYY, YYYY-MM-DD, DD-MM-YYYY, DD.MM.YYYY,
/// Month DD, YYYY, DD Month YYYY
String formatDateOnly({
  required String dateString, // YYYY-MM-DD format from database
  required String format,
}) {
  final date = _parseDateOnly(dateString);
  if (date == null) return dateString;

  switch (format.toLowerCase()) {
    case 'dd/mm/yyyy':
      return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
    case 'mm/dd/yyyy':
      return '${_twoDigits(date.month)}/${_twoDigits(date.day)}/${date.year}';
    case 'yyyy-mm-dd':
      return dateFormat('yyyy-MM-dd', locale: const Locale('en', ''));
    case 'dd-mm-yyyy':
      return '${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}';
    case 'dd.mm.yyyy':
      return '${_twoDigits(date.day)}.${_twoDigits(date.month)}.${date.year}';
    case 'month dd, yyyy':
      final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${monthNames[date.month - 1]} ${_twoDigits(date.day)}, ${date.year}';
    case 'dd month yyyy':
      final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${monthNames[date.month - 1]} ${_twoDigits(date.day)}, ${date.year}';
    default:
      return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }
}

/// Parses a date string in various formats to [DateTime].
/// Returns null if the date cannot be parsed.
DateTime? parseDateString(String dateString) {
  if (dateString.isEmpty) {
    return null;
  }

  // Try YYYY-MM-DD format (ISO)
  final isoRegex = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  final isoMatch = isoRegex.firstMatch(dateString);
  if (isoMatch != null) {
    try {
      final year = int.parse(isoMatch.group(1)!);
      final month = int.parse(isoMatch.group(2)!);
      final day = int.parse(isoMatch.group(3)!);
      return DateTime.tryParse('$year-$month-$day') ??
          _validateAndParseDate(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // Try DD/MM/YYYY format
  final dmyRegex = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');
  final dmyMatch = dmyRegex.firstMatch(dateString);
  if (dmyMatch != null) {
    try {
      final day = int.parse(dmyMatch.group(1)!);
      final month = int.parse(dmyMatch.group(2)!);
      final year = int.parse(dmyMatch.group(3)!);
      return _validateAndParseDate(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // Try MM/DD/YYYY format
  final mdyRegex = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');
  final mdyMatch = mdyRegex.firstMatch(dateString);
  if (mdyMatch != null) {
    try {
      final month = int.parse(mdyMatch.group(1)!);
      final day = int.parse(mdyMatch.group(2)!);
      final year = int.parse(mdyMatch.group(3)!);
      return _validateAndParseDate(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // Try DD-MM-YYYY format
  final dmyDashRegex = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');
  final dmyDashMatch = dmyDashRegex.firstMatch(dateString);
  if (dmyDashMatch != null) {
    try {
      final day = int.parse(dmyDashMatch.group(1)!);
      final month = int.parse(dmyDashMatch.group(2)!);
      final year = int.parse(dmyDashMatch.group(3)!);
      return _validateAndParseDate(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // Try DD.MM.YYYY format
  final dmyDotRegex = RegExp(r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$');
  final dmyDotMatch = dmyDotRegex.firstMatch(dateString);
  if (dmyDotMatch != null) {
    try {
      final day = int.parse(dmyDotMatch.group(1)!);
      final month = int.parse(dmyDotMatch.group(2)!);
      final year = int.parse(dmyDotMatch.group(3)!);
      return _validateAndParseDate(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // Try Month DD, YYYY format (e.g., "June 15, 2024")
  final monthNameRegex = RegExp(r'^([A-Za-z]+)\s+(\d{1,2}),\s*(\d{4})$');
  final monthNameMatch = monthNameRegex.firstMatch(dateString);
  if (monthNameMatch != null) {
    try {
      final monthStr = monthNameMatch.group(1)!;
      final day = int.parse(monthNameMatch.group(2)!);
      final year = int.parse(monthNameMatch.group(3)!);

      // Convert month name to number
      final monthNum = _monthNameToNumber(monthStr);
      if (monthNum == null) return null;

      return _validateAndParseDate(year, monthNum, day);
    } catch (e) {
      return null;
    }
  }

  // Try DD Month YYYY format (e.g., "15 June 2024")
  final dayMonthNameRegex = RegExp(r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$');
  final dayMonthNameMatch = dayMonthNameRegex.firstMatch(dateString);
  if (dayMonthNameMatch != null) {
    try {
      final day = int.parse(dayMonthNameMatch.group(1)!);
      final monthStr = dayMonthNameMatch.group(2)!;
      final year = int.parse(dayMonthNameMatch.group(3)!);

      final monthNum = _monthNameToNumber(monthStr);
      if (monthNum == null) return null;

      return _validateAndParseDate(year, monthNum, day);
    } catch (e) {
      return null;
    }
  }

  return null;
}

/// Converts a month name to its numeric representation.
/// Handles full names (January) and abbreviations (Jan).
int? _monthNameToNumber(String monthName) {
  final lower = monthName.toLowerCase();
  final monthMap = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4,
    'may': 5, 'jun': 6, 'jul': 7, 'aug': 8,
    'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };
  return monthMap[lower];
}

/// Converts a numeric month (1-12) to its full name.
String monthToName(int month) {
  final months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month - 1] + (month == 1 || month == 21 || month == 31 ? '' : '');
}

/// Converts a numeric month (1-12) to its abbreviated name.
String monthAbbreviation(int month) {
  final abbreviations = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return abbreviations[month - 1];
}

/// Validates and parses a date with the given year, month, and day.
/// Handles month boundaries and leap years.
DateTime _validateAndParseDate(int year, int month, int day) {
  // Handle month boundaries
  final daysInMonth = _daysInMonth(year, month);
  if (day < 1 || day > daysInMonth) {
    return null;
  }

  // Leap year handling is automatic in DateTime construction,
  // but we explicitly validate February 29
  if (month == 2 && day == 29 && year % 4 != 0) {
    return null;
  }

  return DateTime(year, month, day);
}

/// Returns the number of days in a given month/year.
/// Handles leap years correctly.
int _daysInMonth(int year, int month) {
  if (month == 2) {
    // Leap year: divisible by 4, except centuries not divisible by 400
    return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
  }
  return _monthDays[month] ?? 31;
}

/// Fixed map of month days (for quick lookup, February handled separately)
static final Map<int, int> _monthDays = {
  1: 31, // January
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

/// Two-digit string padding for single-digit numbers.
String _twoDigits(int n) => n.toString().padLeft(2, '0');

/// Calculates the number of days between two date strings.
/// Supported formats: YYYY-MM-DD, DD/MM/YYYY, MM/DD/YYYY, etc.
int daysBetweenDates({
  required String startDate,
  required String endDate,
}) {
  final start = parseDateString(startDate);
  final end = parseDateString(endDate);

  if (start == null || end == null) {
    return 0;
  }

  /// Normalize to start of day (midnight) for both dates
  final startNormalized = DateTime(start.year, start.month, start.day);
  final endNormalized = DateTime(end.year, end.month, end.day);

  /// Calculate difference in days
  return endNormalized.difference(startNormalized).inDays;

/// Calculates the expiry status for given dates.
/// Returns a map with status information.
Map<String, dynamic> calculateExpiryStatusMap({
  required String purchaseDate,
  required String expiryDate,
}) {
  final purchase = parseDateString(purchaseDate);
  final expiry = parseDateString(expiryDate);

  if (purchase == null || expiry == null) {
    return {
      'status': 'error',
      'daysRemaining': 0,
      'expiryLabel': 'Invalid date',
      'statusColor': '#BA1A1A',
      'isNegative': false,
    };
  }

  // Calculate days remaining from today to expiry
  /// Normalize today to start of day (midnight)
  final todayNormalized = DateTime.now().day > 0 ? DateTime.now() : DateTime(2026, 1, 1);
  final todayDate = DateTime(todayNormalized.year, todayNormalized.month, todayNormalized.day);
  final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);
  final daysRemaining = expiryDate.difference(todayDate).inDays;

  // Determine status
  String status;
  String label;
  Color? statusColor;
  bool isNegative = false;

  if (daysRemaining >= AppConstants.expiringSoonThresholdDays) {
    status = 'safe';
    label = 'Safe';
    statusColor = const Color(0xFF10B981);
  } else if (daysRemaining >= 1) {
    status = 'expiring_soon';
    label = 'Expiring Soon';
    statusColor = const Color(0xFFF59E0B);
  } else if (daysRemaining == 0) {
    status = 'expires_today';
    label = 'Expires Today';
    statusColor = const Color(0xFFEF4444);
  } else {
    status = 'expired';
    label = 'Expired';
    statusColor = const Color(0xFF991B1B);
    isNegative = true;
  }

  return {
    'status': status,
    'daysRemaining': daysRemaining,
    'expiryLabel': label,
    'statusColor': statusColor?.value ?? 0xFFBA1A1A,
    'isNegative': isNegative,
  };
}

/// Gets the greeting text based on the time of day.
String getGreetingForTime() {
  final hour = now().hour;

  if (hour >= 5 && hour < 12) {
    return 'Good morning';
  } else if (hour >= 12 && hour < 18) {
    return 'Good afternoon';
  } else if (hour >= 18 && hour < 22) {
    return 'Good evening';
  } else {
    return 'Good night';
  }
}

/// Returns the current [DateTime] in the local timezone.
DateTime now() => DateTime.now();

/// Formats a [DateTime] to a simple, readable string.
/// Examples: "Nov 20, 2026", "Today", "Yesterday"
String formatSimpleDate(DateTime date) {
  final today = DateTime.now();
  final target = DateTime(date.year, date.month, date.day);
  final todayNormalized = DateTime(today.year, today.month, today.day);

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'Today';
  }

  final yesterday = todayNormalized.subtract(const Duration(days: 1));
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Yesterday';
  }

  final diff = date.difference(today).inDays;
  if (diff == 1) {
    return 'Tomorrow';
  }

  if (diff >= -6 && diff <= 6 && diff != 0 && diff != 1) {
    // Within a week range (excluding today/yesterday/tomorrow)
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${monthNames[date.month - 1]} ${_twoDigits(date.day)}, ${date.year}';
  }

  // Full date format
  final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${monthNames[date.month - 1]} ${_twoDigits(date.day)}, ${date.year}';
}

/// Checks if two dates (in YYYY-MM-DD format) are the same day.
bool isSameDay(String dateA, String dateB) {
  final parsedA = parseDateString(dateA);
  final parsedB = parseDateString(dateB);

  if (parsedA == null || parsedB == null) {
    return false;
  }

  return parsedA.year == parsedB.year &&
      parsedA.month == parsedB.month &&
      parsedA.day == parsedB.day;
}

/// Checks if a date is before another date.
bool isBefore(String dateA, String dateB) {
  final parsedA = parseDateString(dateA);
  final parsedB = parseDateString(dateB);

  if (parsedA == null || parsedB == null) {
    return false;
  }

  return parsedA.isBefore(parsedB);
}

/// Checks if a date is after another date.
bool isAfter(String dateA, String dateB) {
  final parsedA = parseDateString(dateA);
  final parsedB = parseDateString(dateB);

  if (parsedA == null || parsedB == null) {
    return false;
  }

  return parsedA.isAfter(parsedB);
}