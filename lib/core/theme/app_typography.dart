import 'package:flutter/material.dart';

/// Typography hierarchy for the application, powered by Inter for clean, modern legibility.
///
/// Inter is bundled under `assets/fonts/` and declared in `pubspec.yaml`, not
/// fetched by `google_fonts` at runtime. A runtime fetch makes the app's own
/// typeface depend on the network on first launch: offline installs render in
/// the system font, and online ones flash when the download lands.
///
/// Only the four weights the scale below actually uses are bundled (400, 500,
/// 600, 700). Adding a weight here means adding the matching `.ttf` and a
/// `pubspec.yaml` entry, otherwise Flutter synthesises it and it looks wrong.
abstract class AppTypography {
  /// Family name as declared in `pubspec.yaml`.
  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Disclosures, captions, and legal copy that must remain readable without competing
  /// with the primary content hierarchy.
  static const TextStyle legal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
