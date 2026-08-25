import 'package:flutter/material.dart';

/// Semantic and palette color tokens with contrast-compliant foreground variants.
abstract class AppColors {
  // Brand Primary
  static const Color primary = Color(0xFF1E56A0);
  static const Color primaryLight = Color(0xFF4376C5);
  static const Color primaryDark = Color(0xFF0F3A70);

  // Secondary & Accents
  static const Color secondary = Color(0xFF2C3E50);
  static const Color accent = Color(0xFF00ADB5);
  static const Color inactive = Color(0xFFEAEAEA);

  // Semantic Status (Fills)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  /// Contrast-tuned status colors for text and icons on light surfaces (WCAG >= 4.5:1).
  static const Color errorOnLight = Color(0xFFD51A0F);
  static const Color warningOnLight = Color(0xFF886711);
  static const Color successOnLight = Color(0xFF0D7A54);

  /// Status colors tuned for dark surfaces.
  static const Color successOnDark = Color(0xFF34D399);

  /// Foreground ink on light fills.
  static const Color onLightFill = Color(0xFFFFFFFF);

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF5C5C5C);
  static const Color textHintLight = Color(0xFF6B6A6A);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF0B0F19);
  static const Color surfaceDark = Color(0xFF151C2C);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textHintDark = Color(0xFF7F8EA3);
  static const Color borderDark = Color(0xFF222F43);
}
