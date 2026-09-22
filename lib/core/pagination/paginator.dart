import 'dart:math';

import 'package:flutter_core_base/core/pagination/paged_state.dart';

/// Pure, framework-free state machine for page-based lists.
///
/// It owns the three things that make paginated controllers race-prone:
/// generation tokens (so a slow response can never overwrite a newer one),
/// tombstones for locally deleted ids (so a later page cannot resurrect a
/// deleted item), and dedupe of ids already on screen. A controller keeps one
/// instance and delegates to it instead of re-deriving the logic.
///
/// Deliberately has no Riverpod or Flutter dependency, so it is unit-testable
/// as plain Dart.
class Paginator<T, Id> {
  Paginator({required this.pageSize, required this.idOf});

  /// Number of items a full page returns. A short page means "no more pages".
  final int pageSize;

  /// Stable identity of an item, used for dedupe and tombstones.
  final Id Function(T item) idOf;

  int _currentPage = 1;
  int _reloadGeneration = 0;
  int _pageGeneration = 0;
  int _reloadsInFlight = 0;
  final Set<Id> _removedIds = <Id>{};

  /// Page number of the last successfully applied page.
  int get currentPage => _currentPage;

  /// Page number a `loadMore` should request next.
  int get nextPage => _currentPage + 1;

  /// Opens a full reload (initial build or pull-to-refresh) and resets the
  /// cursor to page 1. Returns a token to pass back to [isReloadStale] after
  /// awaiting the fetch.
  ///
  /// Pass `tracksInFlight: true` for a user-triggered refresh so that
  /// [canLoadMore] refuses to interleave a page request with it. The caller
  /// must then pair it with [endReload] in a `finally` block.
  int beginReload({bool tracksInFlight = false}) {
    ++_pageGeneration;
    _currentPage = 1;
    if (tracksInFlight) ++_reloadsInFlight;
    return ++_reloadGeneration;
  }

  /// Closes a reload opened with `tracksInFlight: true`.
  void endReload() {
    if (_reloadsInFlight > 0) --_reloadsInFlight;
  }

  /// True when a newer reload started after [token] was issued, meaning the
  /// awaited result must be discarded.
  bool isReloadStale(int token) => token != _reloadGeneration;

  /// Builds the state for a completed first page and forgets old tombstones.
  PagedState<T> onFirstPage(List<T> items) {
    _removedIds.clear();
    _currentPage = _pageFor(items.length);
    return PagedState<T>(items: items, hasMore: items.length == pageSize);
  }

  /// Token guarding an in-flight *page* request. Any list mutation or reload
  /// invalidates it.
  int get pageToken => _pageGeneration;

  /// True when the list changed after [token] was issued.
  bool isPageStale(int token) => token != _pageGeneration;

  /// Whether a `loadMore` may start right now.
  bool canLoadMore(PagedState<T>? current, {required bool isLoading, required bool hasError}) {
    if (current == null) return false;
    return !current.isLoadingMore && current.hasMore && !isLoading && !hasError && _reloadsInFlight == 0;
  }

  /// Appends [newItems] to [latest], skipping ids already on screen and ids
  /// deleted while the request was in flight, and advances the cursor to
  /// [page].
  PagedState<T> onNextPage(PagedState<T> latest, List<T> newItems, {required int page}) {
    final existingIds = latest.items.map(idOf).toSet();
    final unique = newItems.where((item) {
      final id = idOf(item);
      return !existingIds.contains(id) && !_removedIds.contains(id);
    }).toList();
    _currentPage = page;
    return latest.copyWith(
      items: [...latest.items, ...unique],
      hasMore: newItems.length == pageSize,
      isLoadingMore: false,
      paginationFailure: null,
    );
  }

  /// Puts [item] at the front of [current], replacing any existing copy.
  ///
  /// The side effects — invalidating in-flight requests and clearing [item]'s
  /// tombstone — happen even when [current] is null (no list on screen yet),
  /// because a mutation must never be silently dropped by a request that is
  /// already in flight. Returns null when there is no state to update.
  PagedState<T>? onItemInserted(PagedState<T>? current, T item) {
    _invalidateInFlight();
    final id = idOf(item);
    _removedIds.remove(id);
    if (current == null) return null;
    final items = [item, ...current.items.where((existing) => idOf(existing) != id)];
    _currentPage = _pageFor(items.length);
    return current.copyWith(items: items, isLoadingMore: false, paginationFailure: null);
  }

  /// Removes [id] from [current] and remembers it as a tombstone so a later
  /// page cannot resurrect it.
  ///
  /// Same null contract as [onItemInserted]: the tombstone and the in-flight
  /// invalidation are recorded regardless.
  PagedState<T>? onItemRemoved(PagedState<T>? current, Id id) {
    _invalidateInFlight();
    _removedIds.add(id);
    if (current == null) return null;
    final items = current.items.where((existing) => idOf(existing) != id).toList();
    _currentPage = _pageFor(items.length);
    return current.copyWith(items: items, isLoadingMore: false, paginationFailure: null);
  }

  void _invalidateInFlight() {
    ++_reloadGeneration;
    ++_pageGeneration;
  }

  int _pageFor(int itemCount) => max(1, itemCount ~/ pageSize);
}
