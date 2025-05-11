import 'package:flutter/material.dart';

class AppTextStyles {
  // Styles de base avec Faustina
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Faustina',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Faustina',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Faustina',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Styles pour les titres avec News Gothic
  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'NewsGothicExtraCondensed',
    fontSize: 42,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  // Styles spéciaux
  static const TextStyle button = TextStyle(
    fontFamily: 'Faustina',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Faustina',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  // Méthode pour obtenir un style avec une couleur spécifique
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Méthode pour obtenir un style avec une opacité spécifique
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }
}
