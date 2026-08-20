import 'package:flutter/material.dart';

/// Semantic and palette color tokens
abstract class AppColors {
  // Brand Primary
  static const Color primary = Color(0xFF1E56A0);
  static const Color primaryLight = Color(0xFF4376C5);
  static const Color primaryDark = Color(0xFF0F3A70);

  // Secondary & Accents
  static const Color secondary = Color(0xFF00ADB5);
  static const Color accent = Color(0xFFF68712);

  // Semantic Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF0B0F19);
  static const Color surfaceDark = Color(0xFF151C2C);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF222F43);
}
