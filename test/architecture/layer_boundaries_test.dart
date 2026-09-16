@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _importPattern = RegExp("^\\s*import\\s+'package:flutter_core_base/([^']+)'");

/// Every `import 'package:flutter_core_base/...'` line in [file], as the path
/// after the package prefix (e.g. `features/posts/domain/entities/post.dart`).
List<String> _internalImports(File file) {
  return file.readAsLinesSync().map((line) => _importPattern.firstMatch(line)?.group(1)).whereType<String>().toList();
}

List<File> _dartFilesUnder(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) return const [];
  return dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
}

String? _featureOf(String path) {
  final match = RegExp(r'features/([^/]+)/').firstMatch(path);
  return match?.group(1);
}

void main() {
  group('layer boundaries (docs/ARCHITECTURE.md dependency matrix)', () {
    test('no feature imports another feature', () {
      final violations = <String>[];
      for (final file in _dartFilesUnder('lib/features')) {
        final owner = _featureOf(file.path);
        if (owner == null) continue;
        for (final import in _internalImports(file)) {
          final imported = _featureOf(import);
          if (imported != null && imported != owner) {
            violations.add('${file.path} -> $import');
          }
        }
      }
      expect(violations, isEmpty, reason: 'cross-feature imports:\n${violations.join('\n')}');
    });

    test('core never imports a feature or the app layer', () {
      final violations = <String>[];
      for (final file in _dartFilesUnder('lib/core')) {
        for (final import in _internalImports(file)) {
          if (import.startsWith('features/') || import.startsWith('app/')) {
            violations.add('${file.path} -> $import');
          }
        }
      }
      expect(violations, isEmpty, reason: 'core reaching outward:\n${violations.join('\n')}');
    });

    test('domain layers stay pure Dart', () {
      const forbiddenPackages = [
        'package:flutter/',
        'package:dio/',
        'package:shared_preferences/',
        'package:flutter_secure_storage/',
        'package:go_router/',
        'package:connectivity_plus/',
        'package:google_fonts/',
        'package:flutter_riverpod/',
        'package:riverpod_annotation/',
      ];
      final violations = <String>[];

      for (final file in _dartFilesUnder('lib/features')) {
        if (!file.path.contains('/domain/')) continue;
        if (file.path.endsWith('.freezed.dart') || file.path.endsWith('.g.dart')) continue;

        for (final line in file.readAsLinesSync()) {
          if (!line.trimLeft().startsWith('import ')) continue;
          for (final forbidden in forbiddenPackages) {
            if (line.contains(forbidden)) violations.add('${file.path} -> $forbidden');
          }
          if (line.contains('/data/') || line.contains('/presentation/')) {
            violations.add('${file.path} -> ${line.trim()}');
          }
        }
      }

      expect(violations, isEmpty, reason: 'impure domain:\n${violations.join('\n')}');
    });

    test('presentation never reaches into another feature\'s data layer', () {
      final violations = <String>[];
      for (final file in _dartFilesUnder('lib/features')) {
        if (!file.path.contains('/presentation/')) continue;
        final owner = _featureOf(file.path);
        for (final import in _internalImports(file)) {
          if (!import.contains('/data/')) continue;
          if (_featureOf(import) != owner) violations.add('${file.path} -> $import');
        }
      }
      expect(violations, isEmpty, reason: 'cross-feature data access:\n${violations.join('\n')}');
    });

    test('the guard actually sees the source tree', () {
      // Without this, a broken path silently turns every assertion above into
      // "no files scanned, therefore no violations".
      expect(_dartFilesUnder('lib/features').length, greaterThan(10));
      expect(_dartFilesUnder('lib/core').length, greaterThan(10));
    });
  });
}
