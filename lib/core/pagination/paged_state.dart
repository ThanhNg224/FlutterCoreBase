import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged_state.freezed.dart';

/// UI-facing state of a page-based list: the accumulated items plus the
/// status of the *next* page request.
///
/// [paginationFailure] is deliberately separate from `AsyncValue.error`: a
/// failed "load more" must not blank out the pages already on screen, so it
/// travels inside the data state and is rendered as an inline retry footer.
@freezed
abstract class PagedState<T> with _$PagedState<T> {
  const factory PagedState({
    @Default(<Never>[]) List<T> items,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? paginationFailure,
  }) = _PagedState<T>;
}
