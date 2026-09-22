import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/pagination/paged_state.dart';
import 'package:flutter_core_base/core/pagination/paginator.dart';
import 'package:flutter_test/flutter_test.dart';

class _Item {
  const _Item(this.id);
  final int id;
}

Paginator<_Item, int> _makePaginator({int pageSize = 10}) =>
    Paginator<_Item, int>(pageSize: pageSize, idOf: (item) => item.id);

List<_Item> _itemsFrom(int start, int count) => List.generate(count, (i) => _Item(start + i));

void main() {
  group('Paginator reload', () {
    test('a full first page reports hasMore and lands on page 1', () {
      final paginator = _makePaginator();
      paginator.beginReload();

      final state = paginator.onFirstPage(_itemsFrom(1, 10));

      expect(state.items.length, 10);
      expect(state.hasMore, isTrue);
      expect(paginator.currentPage, 1);
    });

    test('a short first page reports no more pages', () {
      final paginator = _makePaginator();
      paginator.beginReload();

      expect(paginator.onFirstPage(_itemsFrom(1, 4)).hasMore, isFalse);
    });

    test('an older reload token is stale once a newer reload starts', () {
      final paginator = _makePaginator();
      final first = paginator.beginReload();
      final second = paginator.beginReload();

      expect(paginator.isReloadStale(first), isTrue);
      expect(paginator.isReloadStale(second), isFalse);
    });
  });

  group('Paginator canLoadMore', () {
    test('allows a load when the state is idle with more pages', () {
      final paginator = _makePaginator();
      const state = PagedState<_Item>(hasMore: true);

      expect(paginator.canLoadMore(state, isLoading: false, hasError: false), isTrue);
    });

    test('blocks while a reload is in flight', () {
      final paginator = _makePaginator();
      paginator.beginReload(tracksInFlight: true);
      const state = PagedState<_Item>(hasMore: true);

      expect(paginator.canLoadMore(state, isLoading: false, hasError: false), isFalse);

      paginator.endReload();
      expect(paginator.canLoadMore(state, isLoading: false, hasError: false), isTrue);
    });

    test('blocks when there is no state, no more pages, or a load already running', () {
      final paginator = _makePaginator();

      expect(paginator.canLoadMore(null, isLoading: false, hasError: false), isFalse);
      expect(
        paginator.canLoadMore(const PagedState<_Item>(hasMore: false), isLoading: false, hasError: false),
        isFalse,
      );
      expect(
        paginator.canLoadMore(const PagedState<_Item>(isLoadingMore: true), isLoading: false, hasError: false),
        isFalse,
      );
      expect(paginator.canLoadMore(const PagedState<_Item>(), isLoading: true, hasError: false), isFalse);
      expect(paginator.canLoadMore(const PagedState<_Item>(), isLoading: false, hasError: true), isFalse);
    });
  });

  group('Paginator onNextPage', () {
    test('appends unique items and advances the page cursor', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));

      final second = paginator.onNextPage(first, _itemsFrom(11, 10), page: paginator.nextPage);

      expect(second.items.length, 20);
      expect(second.isLoadingMore, isFalse);
      expect(second.paginationFailure, isNull);
      expect(paginator.currentPage, 2);
    });

    test('drops ids already present in the accumulated list', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));

      final second = paginator.onNextPage(first, _itemsFrom(6, 10), page: paginator.nextPage);

      expect(second.items.length, 15);
      expect(second.items.map((e) => e.id).toSet().length, 15);
    });

    test('drops items the user deleted while the page was in flight', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));
      final afterDelete = paginator.onItemRemoved(first, 12);

      final second = paginator.onNextPage(afterDelete!, _itemsFrom(11, 10), page: paginator.nextPage);

      expect(second.items.any((e) => e.id == 12), isFalse);
    });

    test('an older page token is stale once the list mutates', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final token = paginator.pageToken;
      final first = paginator.onFirstPage(_itemsFrom(1, 10));

      paginator.onItemRemoved(first, 3);

      expect(paginator.isPageStale(token), isTrue);
    });
  });

  group('Paginator mutations', () {
    test('an inserted item goes to the front and clears its tombstone', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));
      final afterDelete = paginator.onItemRemoved(first, 5);

      final afterInsert = paginator.onItemInserted(afterDelete, const _Item(5));

      expect(afterInsert!.items.first.id, 5);
      expect(afterInsert.items.where((e) => e.id == 5).length, 1);

      final next = paginator.onNextPage(afterInsert, [const _Item(5), const _Item(99)], page: paginator.nextPage);
      expect(next.items.where((e) => e.id == 5).length, 1);
      expect(next.items.any((e) => e.id == 99), isTrue);
    });

    test('a mutation clears any pending pagination failure', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));
      final failed = first.copyWith(paginationFailure: const Failure.server(message: 'boom'), isLoadingMore: true);

      final afterInsert = paginator.onItemInserted(failed, const _Item(77));

      expect(afterInsert!.paginationFailure, isNull);
      expect(afterInsert.isLoadingMore, isFalse);
    });

    test('a fresh reload forgets previous tombstones', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      final first = paginator.onFirstPage(_itemsFrom(1, 10));
      paginator.onItemRemoved(first, 4);

      paginator.beginReload();
      final reloaded = paginator.onFirstPage(_itemsFrom(1, 10));
      final next = paginator.onNextPage(reloaded, [const _Item(4)], page: paginator.nextPage);

      expect(next.items.where((e) => e.id == 4).length, 1);
    });

    test('a delete with no state on screen still tombstones the id', () {
      final paginator = _makePaginator();
      paginator.beginReload();

      expect(paginator.onItemRemoved(null, 3), isNull);

      // Never goes through onFirstPage (which would itself clear the
      // tombstone) so this exercises only the null-state path of
      // onItemRemoved.
      const current = PagedState<_Item>(items: [_Item(1), _Item(2)], hasMore: true);
      final next = paginator.onNextPage(current, [const _Item(3), const _Item(4)], page: paginator.nextPage);

      expect(next.items.any((e) => e.id == 3), isFalse);
      expect(next.items.any((e) => e.id == 4), isTrue);
    });

    test('an insert with no state on screen still clears the tombstone', () {
      final paginator = _makePaginator();
      paginator.beginReload();
      paginator.onItemRemoved(null, 3);

      expect(paginator.onItemInserted(null, const _Item(3)), isNull);

      // Same reasoning as above: skip onFirstPage so the clear performed by
      // onItemInserted(null, ...) is what actually lets id 3 back in below.
      const current = PagedState<_Item>(items: [_Item(1), _Item(2)], hasMore: true);
      final next = paginator.onNextPage(current, [const _Item(3)], page: paginator.nextPage);

      expect(next.items.any((e) => e.id == 3), isTrue);
    });
  });
}
