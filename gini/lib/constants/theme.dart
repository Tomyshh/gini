import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Star Wars Colors
  static const Color darkSide = Color.fromARGB(255, 0, 0, 0);
  static const Color lightSide = Color(0xFFF5F5F5);
  static const Color rebellionRed = Color(0xFFE51013);
  static const Color imperialBlue = Color(0xFF005BC5);
  static const Color jediGreen = Color(0xFF2FF924);
  static const Color tatooineGold = Color(0xFFffe919);
  static const Color sithPurple = Color(0xFF7A00CC);
  static const Color deathStarGray = Color(0xFF333333);

  // Light theme (Republic/Rebellion)
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.light(
      primary: imperialBlue,
      onPrimary: Colors.white,
      primaryContainer: imperialBlue.withOpacity(0.15),
      onPrimaryContainer: imperialBlue.withOpacity(0.8),
      secondary: rebellionRed,
      onSecondary: Colors.white,
      secondaryContainer: rebellionRed.withOpacity(0.15),
      onSecondaryContainer: rebellionRed.withOpacity(0.8),
      tertiary: jediGreen,
      onTertiary: Colors.white,
      tertiaryContainer: jediGreen.withOpacity(0.15),
      onTertiaryContainer: jediGreen.withOpacity(0.8),
      error: rebellionRed,
      background: lightSide,
      onBackground: const Color.fromARGB(255, 0, 0, 0),
      surface: Colors.white,
      onSurface: darkSide,
      surfaceVariant: const Color(0xFFEEF2F6),
      onSurfaceVariant: const Color(0xFF4C576A),
    );

    var baseTheme = ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.primary.withOpacity(0.2),
        thickness: 1.5,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  // Dark theme (Empire/Sith)
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: tatooineGold,
      onPrimary: darkSide,
      primaryContainer: tatooineGold.withOpacity(0.15),
      onPrimaryContainer: tatooineGold.withOpacity(0.8),
      secondary: rebellionRed,
      onSecondary: Colors.white,
      secondaryContainer: rebellionRed.withOpacity(0.15),
      onSecondaryContainer: rebellionRed.withOpacity(0.8),
      tertiary: sithPurple,
      onTertiary: Colors.white,
      tertiaryContainer: sithPurple.withOpacity(0.15),
      onTertiaryContainer: sithPurple.withOpacity(0.8),
      error: rebellionRed,
      background: darkSide,
      onBackground: lightSide,
      surface: deathStarGray,
      onSurface: lightSide,
      surfaceVariant: const Color(0xFF252525),
      onSurfaceVariant: const Color(0xFFB0B0B0),
    );

    var baseTheme = ThemeData.dark(useMaterial3: true);

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: colorScheme.primary.withOpacity(0.5),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.primary.withOpacity(0.2),
        thickness: 1.5,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
