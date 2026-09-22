import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_motion.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';

/// Builds one row of a paged list. Receives the item itself, so callers never
/// index back into the source list.
typedef PagedItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

/// Sliver half of the paged list, and the only real implementation.
///
/// Drop it into any `CustomScrollView` — beside a `SliverAppBar`, for example.
/// [AppPagedListView] is a thin box wrapper around this same widget, so the two
/// never drift apart.
///
/// Performance notes:
/// - Items are built on demand by `SliverChildBuilderDelegate`; never hand this
///   widget a pre-mapped `List<Widget>`.
/// - No extra `RepaintBoundary` is added: `SliverChildBuilderDelegate` already
///   wraps every child in one (`addRepaintBoundaries` defaults to true).
/// - [onLoadMore] fires from the item builder rather than a `ScrollController`,
///   so it works identically in a box list and inside a caller's scroll view.
class AppPagedSliverList<T> extends StatefulWidget {
  const AppPagedSliverList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.keyProvider,
    this.footer,
    this.itemSpacing = AppSpacing.s,
    this.prefetchThreshold = 3,
    this.itemExtent,
    this.prototypeItem,
    this.animateEntrance = true,
  }) : assert(
         itemExtent == null || prototypeItem == null,
         'Pass at most one of itemExtent / prototypeItem.',
       );

  /// The items already loaded. Pass the raw domain objects, not widgets.
  final List<T> items;

  final PagedItemBuilder<T> itemBuilder;

  /// Called once when the builder reaches within [prefetchThreshold] items of
  /// the end. Fired after the frame, so it is safe to mutate state from it.
  final VoidCallback? onLoadMore;

  /// Stable key per item, e.g. `(post) => ValueKey(post.id)`. Supply it when
  /// items can be inserted, removed or reordered so the element tree is reused
  /// instead of rebuilt by position.
  final Key? Function(T item)? keyProvider;

  /// Rendered after the last item — a progress indicator or an inline retry.
  final Widget? footer;

  /// Vertical gap inserted between items (not after the last one).
  final double itemSpacing;

  /// How many items before the end to trigger [onLoadMore].
  final int prefetchThreshold;

  /// Fixed row height, when every row is the same known height. Lets the
  /// viewport resolve scroll offsets without measuring children.
  final double? itemExtent;

  /// A sample row measured once to derive a fixed extent. Use instead of
  /// [itemExtent] when the height is uniform but not known up front.
  final Widget? prototypeItem;

  /// Staggered fade/slide for the first [AppMotion.maxStaggeredItems] rows.
  final bool animateEntrance;

  @override
  State<AppPagedSliverList<T>> createState() => _AppPagedSliverListState<T>();
}

class _AppPagedSliverListState<T> extends State<AppPagedSliverList<T>> {
  bool _loadMoreScheduled = false;

  void _maybeLoadMore(int index) {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || _loadMoreScheduled) return;
    if (index < widget.items.length - widget.prefetchThreshold) return;

    _loadMoreScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMoreScheduled = false;
      if (!mounted) return;
      onLoadMore();
    });
  }

  Widget? _buildChild(BuildContext context, int index) {
    if (index >= widget.items.length) return widget.footer;

    _maybeLoadMore(index);

    final item = widget.items[index];
    Widget child = widget.itemBuilder(context, item, index);

    if (widget.itemSpacing > 0 && index != widget.items.length - 1) {
      child = Padding(
        padding: EdgeInsets.only(bottom: widget.itemSpacing),
        child: child,
      );
    }
    if (widget.animateEntrance) {
      child = child.entranceAt(context, index);
    }

    final key = widget.keyProvider?.call(item);
    return key == null ? child : KeyedSubtree(key: key, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final delegate = SliverChildBuilderDelegate(
      _buildChild,
      childCount: widget.items.length + (widget.footer != null ? 1 : 0),
    );

    final itemExtent = widget.itemExtent;
    if (itemExtent != null) {
      return SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent);
    }
    final prototypeItem = widget.prototypeItem;
    if (prototypeItem != null) {
      return SliverPrototypeExtentList(delegate: delegate, prototypeItem: prototypeItem);
    }
    return SliverList(delegate: delegate);
  }
}

/// Box (non-sliver) paged list: [AppPagedSliverList] inside a scroll view, with
/// optional pull-to-refresh. Use this for a plain screen; reach for
/// [AppPagedSliverList] directly when the screen has a `SliverAppBar`.
class AppPagedListView<T> extends StatelessWidget {
  const AppPagedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.onRefresh,
    this.keyProvider,
    this.footer,
    this.padding = AppSpacing.pagePadding,
    this.itemSpacing = AppSpacing.s,
    this.prefetchThreshold = 3,
    this.itemExtent,
    this.prototypeItem,
    this.animateEntrance = true,
    this.controller,
    this.physics,
  });

  final List<T> items;
  final PagedItemBuilder<T> itemBuilder;
  final VoidCallback? onLoadMore;

  /// Wires a [RefreshIndicator] when supplied.
  final Future<void> Function()? onRefresh;

  final Key? Function(T item)? keyProvider;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final int prefetchThreshold;
  final double? itemExtent;
  final Widget? prototypeItem;
  final bool animateEntrance;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      controller: controller,
      // Always scrollable so pull-to-refresh still works on a short list.
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: AppPagedSliverList<T>(
            items: items,
            itemBuilder: itemBuilder,
            onLoadMore: onLoadMore,
            keyProvider: keyProvider,
            footer: footer,
            itemSpacing: itemSpacing,
            prefetchThreshold: prefetchThreshold,
            itemExtent: itemExtent,
            prototypeItem: prototypeItem,
            animateEntrance: animateEntrance,
          ),
        ),
      ],
    );

    final onRefresh = this.onRefresh;
    if (onRefresh == null) return scrollView;
    return RefreshIndicator(onRefresh: onRefresh, child: scrollView);
  }
}
