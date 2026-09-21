import 'package:flutter/services.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(AppEnvironment.resetForTest);

  group('resolve', () {
    test('dart-define wins over the native flavor', () {
      expect(AppEnvironment.resolve(dartDefine: 'dev', flavor: 'prod'), Environment.development);
      expect(AppEnvironment.resolve(dartDefine: 'prod', flavor: 'dev'), Environment.production);
    });

    test('falls back to the native flavor when no dart-define is supplied', () {
      expect(AppEnvironment.resolve(dartDefine: '', flavor: 'dev'), Environment.development);
      expect(AppEnvironment.resolve(dartDefine: '', flavor: 'prod'), Environment.production);
    });

    test('accepts the long form and ignores case and padding', () {
      expect(AppEnvironment.resolve(dartDefine: '  DEVELOPMENT ', flavor: null), Environment.development);
      expect(AppEnvironment.resolve(dartDefine: 'Dev', flavor: null), Environment.development);
    });

    test('defaults to production when nothing is supplied', () {
      expect(AppEnvironment.resolve(dartDefine: '', flavor: null), Environment.production);
    });

    test('an unrecognised token fails safe to production', () {
      expect(AppEnvironment.resolve(dartDefine: 'staging', flavor: null), Environment.production);
      expect(AppEnvironment.resolve(dartDefine: 'qa', flavor: 'qa'), Environment.production);
    });
  });

  group('build', () {
    test('agrees with resolve applied to the real compile-time inputs', () {
      expect(
        AppEnvironment.build,
        AppEnvironment.resolve(dartDefine: AppEnvironment.dartDefine, flavor: appFlavor),
      );
    });

    test('this project does not use native flavors, so appFlavor is null by default', () {
      expect(appFlavor, isNull);
    });

    test('APP_ENV resolves correctly or defaults to production', () {
      switch (AppEnvironment.dartDefine.toLowerCase()) {
        case 'dev':
          expect(AppEnvironment.build, Environment.development);
        default:
          expect(AppEnvironment.build, Environment.production);
      }
    });
  });

  group('the test seam', () {
    test('setForTest pins the environment and resetForTest restores it', () {
      final natural = AppEnvironment.build;

      AppEnvironment.setForTest(Environment.production);
      expect(AppEnvironment.build, Environment.production);

      AppEnvironment.setForTest(Environment.development);
      expect(AppEnvironment.build, Environment.development);

      AppEnvironment.resetForTest();
      expect(AppEnvironment.build, natural);
    });
  });

  group('verifyReleaseSafety', () {
    test('throws when a release build resolved to a non-production environment', () {
      expect(
        () => AppEnvironment.verifyReleaseSafety(
          isReleaseBuild: true,
          environment: Environment.development,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('permits a release build that resolved to production', () {
      expect(
        () => AppEnvironment.verifyReleaseSafety(
          isReleaseBuild: true,
          environment: Environment.production,
        ),
        returnsNormally,
      );
    });

    test('permits any environment in a non-release build', () {
      for (final environment in Environment.values) {
        expect(
          () => AppEnvironment.verifyReleaseSafety(isReleaseBuild: false, environment: environment),
          returnsNormally,
        );
      }
    });

    test('the error message names the flag that fixes it', () {
      try {
        AppEnvironment.verifyReleaseSafety(isReleaseBuild: true, environment: Environment.development);
        fail('expected a StateError');
      } on StateError catch (e) {
        expect(e.message, contains('APP_ENV=prod'));
      }
    });
  });
}
