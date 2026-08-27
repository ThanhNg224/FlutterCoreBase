import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography hierarchy for the application, powered by Inter for clean, modern legibility.
abstract class AppTypography {
  /// Base font family name
  static final String? fontFamily = GoogleFonts.inter().fontFamily;

  static final TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static final TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static final TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Disclosures, captions, and legal copy that must remain readable without competing
  /// with the primary content hierarchy.
  static final TextStyle legal = GoogleFonts.inter(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
