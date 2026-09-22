import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_dialog.dart';
import 'package:flutter_core_base/core/widgets/app_paged_list_view.dart';
import 'package:flutter_core_base/core/widgets/app_shimmer.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_controller.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_state.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/create_post_bottom_sheet.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/post_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  void _showCreateBottomSheet(BuildContext context, WidgetRef ref) {
    AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.createPostTitle,
      icon: Icons.post_add_rounded,
      builder: (context) => CreatePostBottomSheet(
        onSubmit: ({required String title, required String body}) {
          return ref.read(postsControllerProvider.notifier).createPost(title: title, body: body);
        },
      ),
    );
  }

  Future<void> _deletePost(BuildContext context, WidgetRef ref, int id) async {
    final l10n = context.l10n;
    final result = await ref.read(postsControllerProvider.notifier).deletePost(id);
    if (!context.mounted) return;

    result.fold(
      (failure) => AppDialog.showResultDialog(
        context: context,
        title: l10n.somethingWentWrongMessage,
        message: failure.localizedMessage(l10n),
        isSuccess: false,
      ),
      (_) {},
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Post post) {
    final l10n = context.l10n;
    AppDialog.showActionDialog(
      context: context,
      icon: Icons.delete_outline_rounded,
      title: l10n.deletePostTitle,
      message: l10n.deletePostConfirmation(post.title),
      primaryLabel: l10n.deleteButton,
      secondaryLabel: l10n.cancelButton,
      onPrimary: () => _deletePost(context, ref, post.id),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: context.colors.textHint),
            const SizedBox(height: AppSpacing.m),
            Text(l10n.noPostsFound, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.m),
            AppButton(
              label: l10n.createFirstPostButton,
              onPressed: () => _showCreateBottomSheet(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// Inline progress / retry rendered under the last loaded page. A failed page
  /// must never blank out the posts already on screen.
  Widget? _buildFooter(BuildContext context, WidgetRef ref, PostsState postsState) {
    if (postsState.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final failure = postsState.paginationFailure;
    if (failure == null) return null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Center(
        child: TextButton.icon(
          onPressed: () => ref.read(postsControllerProvider.notifier).loadMore(),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(failure.localizedMessage(context.l10n)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.postsFeedTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.refreshTooltip,
            onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: AsyncValueWidget<PostsState>(
            value: postsAsync,
            loading: AppShimmerList.new,
            data: (postsState) {
              if (postsState.items.isEmpty) {
                return _buildEmptyState(context, ref);
              }

              return AppPagedListView<Post>(
                items: postsState.items,
                keyProvider: (post) => ValueKey(post.id),
                onRefresh: () => ref.read(postsControllerProvider.notifier).refresh(),
                onLoadMore: () => ref.read(postsControllerProvider.notifier).loadMore(),
                footer: _buildFooter(context, ref, postsState),
                itemBuilder: (context, post, index) => PostCard(
                  post: post,
                  onTap: () => context.push('${RoutePaths.posts}/${post.id}'),
                  onDelete: () => _confirmDelete(context, ref, post),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBottomSheet(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newPostButton),
      ),
    );
  }
}
