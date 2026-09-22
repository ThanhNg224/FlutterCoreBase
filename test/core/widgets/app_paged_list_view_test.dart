import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/widgets/app_paged_list_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/widget_harness.dart';

void main() {
  group('AppPagedListView', () {
    testWidgets('builds only the items near the viewport, not the whole list', (tester) async {
      final builtIndices = <int>[];

      await tester.pumpWidget(
        harness(
          child: AppPagedListView<int>(
            items: List.generate(500, (i) => i),
            animateEntrance: false,
            itemBuilder: (context, item, index) {
              builtIndices.add(index);
              return SizedBox(height: 80, child: Text('item $item'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(builtIndices, isNotEmpty);
      expect(builtIndices.length, lessThan(50), reason: 'the list must stay lazy, not build all 500 items');
      expect(builtIndices.reduce((a, b) => a > b ? a : b), lessThan(50));
    });

    testWidgets('does not request another page while the end is far away', (tester) async {
      var loadMoreCalls = 0;

      await tester.pumpWidget(
        harness(
          child: AppPagedListView<int>(
            items: List.generate(500, (i) => i),
            animateEntrance: false,
            onLoadMore: () => loadMoreCalls++,
            itemBuilder: (context, item, index) => SizedBox(height: 80, child: Text('item $item')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(loadMoreCalls, 0);
    });

    testWidgets('requests another page once the tail comes into view', (tester) async {
      var loadMoreCalls = 0;

      await tester.pumpWidget(
        harness(
          child: AppPagedListView<int>(
            items: List.generate(12, (i) => i),
            animateEntrance: false,
            onLoadMore: () => loadMoreCalls++,
            itemBuilder: (context, item, index) => SizedBox(height: 80, child: Text('item $item')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      expect(loadMoreCalls, greaterThan(0));
    });

    testWidgets('renders the footer after the last item', (tester) async {
      await tester.pumpWidget(
        harness(
          child: AppPagedListView<int>(
            items: List.generate(3, (i) => i),
            animateEntrance: false,
            footer: const Text('loading-more-footer'),
            itemBuilder: (context, item, index) => SizedBox(height: 80, child: Text('item $item')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('loading-more-footer'), findsOneWidget);
    });
  });

  group('AppPagedSliverList', () {
    testWidgets('composes into a caller-owned CustomScrollView', (tester) async {
      await tester.pumpWidget(
        harness(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(title: Text('header')),
              AppPagedSliverList<int>(
                items: List.generate(5, (i) => i),
                animateEntrance: false,
                itemBuilder: (context, item, index) => SizedBox(height: 80, child: Text('item $item')),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('header'), findsOneWidget);
      expect(find.text('item 0'), findsOneWidget);
    });
  });
}
