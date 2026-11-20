import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../utils/date_helpers.dart';

// Plus Jakarta Sans font family declaration
const _plusJakartaSansFontFamily = 'Plus Jakarta Sans';

// Color extensions for the Vigilant Calm design system
extension ColorEx on ColorScheme {
  /// Vigilant Calm light color scheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF5B45C8),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF7460E3),
    onPrimaryContainer: Color(0xFFFFFBFF),
    secondary: Color(0xFF006C49),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF6CF8BB),
    onSecondaryContainer: Color(0xFF00714D),
    tertiary: Color(0xFF825100),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA36700),
    onTertiaryContainer: Color(0xFFFFFBFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    background: Color(0xFFFCF8FF),
    onBackground: Color(0xFF1B1B24),
    surface: Color(0xFFFCF8FF),
    onSurface: Color(0xFF1B1B24),
    surfaceVariant: Color(0xFFE3E1EF),
    onSurfaceVariant: Color(0xFF484554),
    inverseSurface: Color(0xFF302F3A),
    onInverseSurface: Color(0xFFF2EFFD),
    outline: Color(0xFF797585),
    outlineVariant: Color(0xFFC9C4D6),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  /// Vigilant Calm dark color scheme
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA5C1FF),
    onPrimary: Color(0xFF1A0063),
    primaryContainer: Color(0xFF3A2860),
    onPrimaryContainer: Color(0xFFE5DEFF),
    secondary: Color(0xFF4A988A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF2A6D5E),
    onSecondaryContainer: Color(0xFF6CF8BB),
    tertiary: Color(0xFFAA7020),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF573300),
    onTertiaryContainer: Color(0xFFFFDDBA),
    error: Color(0xFFEB5757),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF411616),
    onErrorContainer: Color(0xFFFFCFCF),
    background: Color(0xFF18171B),
    onBackground: Color(0xFFEDECF1),
    surface: Color(0xFF1E1D22),
    onSurface: Color(0xFFEDECF1),
    surfaceVariant: Color(0xFF2A2930),
    onSurfaceVariant: Color(0xFFD0CBCF),
    inverseSurface: Color(0xFF4A4854),
    onInverseSurface: Color(0xFFD9D7DF),
    outline: Color(0xFF8A8292),
    outlineVariant: Color(0xFF605669),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}

/// Typographic styles for the Vigilant Calm design system
/// Creates a TextTheme from the Plus Jakarta Sans font family
TextTheme get lightTextTheme => TextTheme(
      displayLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w700,
        height: 40.0 / 32.0,
        letterSpacing: -0.02,
      ),
      displayMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 32.0 / 24.0,
        letterSpacing: -0.01,
      ),
      headlineLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 28.0 / 20.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        height: 24.0 / 16.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 24.0 / 16.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 20.0 / 14.0,
      ),
      bodySmall: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 12.0,
      ),
      labelLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        height: 20.0 / 14.0,
        letterSpacing: 0.01,
      ),
      labelMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        height: 16.0 / 12.0,
        letterSpacing: 0.02,
      ),
      labelSmall: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w700,
        height: 14.0 / 11.0,
        letterSpacing: 0.03,
      ),
      displaySmall: const TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        height: 22.0 / 18.0,
      ),
    );

TextTheme get darkTextTheme => TextTheme(
      displayLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w700,
        height: 40.0 / 32.0,
        letterSpacing: -0.02,
      ),
      displayMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 32.0 / 24.0,
        letterSpacing: -0.01,
      ),
      headlineLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 28.0 / 20.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        height: 24.0 / 16.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 24.0 / 16.0,
      ),
      bodyMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 20.0 / 14.0,
      ),
      bodySmall: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 18.0 / 12.0,
      ),
      labelLarge: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        height: 20.0 / 14.0,
        letterSpacing: 0.01,
      ),
      labelMedium: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        height: 16.0 / 12.0,
        letterSpacing: 0.02,
      ),
      labelSmall: TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w700,
        height: 14.0 / 11.0,
        letterSpacing: 0.03,
      ),
      displaySmall: const TextStyle(
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        height: 22.0 / 18.0,
      ),
    );

/// App theme definitions using Material 3 with Vigilant Calm custom styling
class AppTheme {
  /// Light theme matching Vigilant Calm design system
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorEx.light,
    textTheme: lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF1B1B24),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Color(0xFF1B1B24),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFFCF8FF),
      selectedItemColor: Color(0xFF5B45C8),
      unselectedItemColor: Color(0xFF484554),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x047965E8),
      surfaceTintColor: Color(0xFF5B45C8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusRadius.lg,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5B45C8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFF5B45C8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xFF5B45C8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color(0xFF777787),
        fontFamily: _plusJakartaSansFontFamily,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E5EE), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE5E5EE), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF7965E8), width: 2),
        borderRadius: BorderRadiusRadius.lg,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFBA1A1A), width: 2),
        borderRadius: BorderRadiusRadius.lg,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceMd,
      ),
    ),
    chipTheme: const ChipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      side: BorderSide(color: Color(0xFFE5E5EE), width: 1),
      backgroundColor: Colors.white,
      secondaryTextStyle: TextStyle(
        color: Color(0xFF1B1B24),
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      deleteIconColor: Color(0xFFBA1A1A),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF1B1B24),
      size: 24,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF5B45C8),
    ),
  );

  /// Dark theme matching Vigilant Calm design system
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorEx.dark,
    textTheme: darkTextTheme,
    scaffoldBackgroundColor: const Color(0xFF18171B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFEDECF1),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Color(0xFFEDECF1),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF18171B),
      selectedItemColor: Color(0xFFA5C1FF),
      unselectedItemColor: Color(0xFFD0CBCF),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1D22),
      elevation: 2,
      shadowColor: const Color(0x047965E8),
      surfaceTintColor: Color(0xFFA5C1FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusRadius.lg,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA5C1FF),
        foregroundColor: Color(0xFF1A0063),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFFA5C1FF),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xFFA5C1FF),
        foregroundColor: Color(0xFF1A0063),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusRadius.lg,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color(0xFF777787),
        fontFamily: _plusJakartaSansFontFamily,
      ),
      filled: true,
      fillColor: const Color(0xFF2A2930),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2A2930), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2A2930), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFA5C1FF), width: 2),
        borderRadius: BorderRadiusRadius.lg,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEB5757), width: 1.5),
        borderRadius: BorderRadiusRadius.lg,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEB5757), width: 2),
        borderRadius: BorderRadiusRadius.lg,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceMd,
      ),
    ),
    chipTheme: const ChipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      side: BorderSide(color: Color(0xFF2A2930), width: 1),
      backgroundColor: const Color(0xFF1E1D22),
      secondaryTextStyle: TextStyle(
        color: Color(0xFFEDECF1),
        fontFamily: _plusJakartaSansFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      deleteIconColor: Color(0xFFEB5757),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFEDECF1),
      size: 24,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFA5C1FF),
    ),
  );
}

/// Helper class for border radii from the design system
class BorderRadiusRadius {
  static const BorderRadius sm = BorderRadiusRadius(4);
  static const BorderRadius lg = BorderRadiusRadius(16);
  static const BorderRadius xl = BorderRadiusRadius(24);
  static const BorderRadius full = BorderRadiusRadius(9999);

  final double value;

  const BorderRadiusRadius(this.value);

  static BorderRadius radius(double value) => BorderRadius.circular(value);
}

/// Spacing constants from the design system
class AppSpacing {
  static const double gutter = 16.0;
  static const double gutterCompact = 12.0;
  static const double margin = 16.0;
  static const double marginTablet = 24.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
}