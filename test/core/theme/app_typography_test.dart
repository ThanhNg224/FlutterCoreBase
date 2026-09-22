import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_base/core/theme/app_theme.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Every weight declared for the `Inter` family in `pubspec.yaml`, paired
  /// with the `FontWeight` the scale uses it for.
  const bundledWeights = <String, FontWeight>{
    'assets/fonts/Inter-Regular.ttf': FontWeight.w400,
    'assets/fonts/Inter-Medium.ttf': FontWeight.w500,
    'assets/fonts/Inter-SemiBold.ttf': FontWeight.w600,
    'assets/fonts/Inter-Bold.ttf': FontWeight.w700,
  };

  group('the Inter family is bundled, not fetched', () {
    // A wrong asset path or a deleted .ttf does not throw at runtime: Flutter
    // silently falls back to the platform font and the app merely looks wrong.
    // These tests turn that silent failure into a red build.
    for (final path in bundledWeights.keys) {
      test('$path is declared and loadable from the bundle', () async {
        final data = await rootBundle.load(path);

        expect(data.lengthInBytes, greaterThan(50000), reason: '$path looks truncated');
        // TrueType files start with the version tag 0x00010000.
        expect(data.getUint32(0), 0x00010000, reason: '$path is not a TrueType font');
      });
    }

    test('every weight the scale asks for has a bundled file', () {
      final used = <FontWeight>{
        AppTypography.displayLarge.fontWeight!,
        AppTypography.headlineMedium.fontWeight!,
        AppTypography.titleLarge.fontWeight!,
        AppTypography.titleMedium.fontWeight!,
        AppTypography.bodyLarge.fontWeight!,
        AppTypography.bodyMedium.fontWeight!,
        AppTypography.labelMedium.fontWeight!,
        AppTypography.caption.fontWeight!,
        AppTypography.legal.fontWeight!,
      };

      expect(
        used.difference(bundledWeights.values.toSet()),
        isEmpty,
        reason:
            'a style asks for a weight with no .ttf behind it, so Flutter '
            'would synthesise it -- add the file and a pubspec entry',
      );
    });
  });

  group('the family name reaches the widgets', () {
    test('the name matches what pubspec.yaml declares', () {
      // Without this the suite is circular: every other assertion compares
      // AppTypography.fontFamily against itself, so renaming it to 'Intre'
      // keeps them all green while the app silently renders in the platform
      // font. pubspec.yaml is the only external authority on the name.
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final declared = RegExp(
        r'^\s*-\s*family:\s*(\S+)\s*$',
        multiLine: true,
      ).allMatches(pubspec).map((m) => m.group(1)).toList();

      expect(declared, isNotEmpty, reason: 'pubspec.yaml declares no font family at all');
      expect(
        declared,
        contains(AppTypography.fontFamily),
        reason: 'AppTypography.fontFamily is "${AppTypography.fontFamily}" but pubspec declares $declared',
      );
    });

    test('every style names the bundled family', () {
      final styles = <TextStyle>[
        AppTypography.displayLarge,
        AppTypography.headlineMedium,
        AppTypography.titleLarge,
        AppTypography.titleMedium,
        AppTypography.bodyLarge,
        AppTypography.bodyMedium,
        AppTypography.labelMedium,
        AppTypography.caption,
        AppTypography.legal,
      ];

      for (final style in styles) {
        expect(style.fontFamily, AppTypography.fontFamily);
      }
    });

    test('both themes inherit it', () {
      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.fontFamily);
        expect(theme.textTheme.titleLarge?.fontFamily, AppTypography.fontFamily);
      }
    });
  });
}
