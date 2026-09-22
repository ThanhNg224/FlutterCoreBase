import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core_base/core/theme/app_motion.dart';

import '../../support/widget_harness.dart';

Future<Widget> _entranceUnder(
  WidgetTester tester, {
  required int index,
  required bool disableAnimations,
}) async {
  late Widget result;

  await tester.pumpWidget(
    harness(
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Builder(
          builder: (context) {
            result = const Text('a').entranceAt(context, index);
            return result;
          },
        ),
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  return result;
}

void main() {
  group('entranceAt', () {
    testWidgets('animates a leading item when the platform allows motion', (tester) async {
      final result = await _entranceUnder(tester, index: 0, disableAnimations: false);

      expect(result, isA<Animate>());
      expect(find.byType(Animate), findsOneWidget);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('returns the item untouched under reduced motion', (tester) async {
      final result = await _entranceUnder(tester, index: 0, disableAnimations: true);

      expect(result, isNot(isA<Animate>()));
      expect(find.byType(Animate), findsNothing);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('returns the item untouched past the stagger cap', (tester) async {
      // Delay grows with the index, so an unbounded paged list would leave deep
      // items blank for many seconds. Past the cap they must render instantly.
      final result = await _entranceUnder(
        tester,
        index: AppMotion.maxStaggeredItems,
        disableAnimations: false,
      );

      expect(result, isNot(isA<Animate>()));
      expect(find.byType(Animate), findsNothing);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('still animates the last item below the cap', (tester) async {
      final result = await _entranceUnder(
        tester,
        index: AppMotion.maxStaggeredItems - 1,
        disableAnimations: false,
      );

      expect(result, isA<Animate>());
    });
  });
}
