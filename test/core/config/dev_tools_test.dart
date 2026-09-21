import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/dev_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(DevTools.resetForTest);

  test('is enabled under flutter test, which is a debug build', () {
    expect(DevTools.isEnabled, isTrue);
  });

  test('the rule: only a production release build turns them off', () {
    expect(
      DevTools.computeEnabled(isReleaseBuild: true, environment: Environment.production),
      isFalse,
      reason: 'the one case that must be off',
    );
    expect(DevTools.computeEnabled(isReleaseBuild: true, environment: Environment.development), isTrue);
    expect(DevTools.computeEnabled(isReleaseBuild: false, environment: Environment.production), isTrue);
    expect(DevTools.computeEnabled(isReleaseBuild: false, environment: Environment.development), isTrue);
  });

  test('the test override wins in both directions', () {
    DevTools.setEnabledForTest(false);
    expect(DevTools.isEnabled, isFalse);

    DevTools.setEnabledForTest(true);
    expect(DevTools.isEnabled, isTrue);
  });

  test('resetForTest restores the build-derived value', () {
    DevTools.setEnabledForTest(false);
    DevTools.resetForTest();
    expect(DevTools.isEnabled, isTrue);
  });
}
