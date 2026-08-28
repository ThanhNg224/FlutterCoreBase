import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/theme/app_motion.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_dialog.dart';
import 'package:flutter_core_base/core/widgets/app_shimmer.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_controller.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_state.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/create_post_bottom_sheet.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/post_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(postsControllerProvider.notifier).loadMore();
    }
  }

  void _showCreateBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXL)),
      ),
      builder: (context) => CreatePostBottomSheet(
        onSubmit: ({required String title, required String body}) {
          return ref.read(postsControllerProvider.notifier).createPost(title: title, body: body);
        },
      ),
    );
  }

  Future<void> _deletePost(int id) async {
    final result = await ref.read(postsControllerProvider.notifier).deletePost(id);
    if (!mounted) return;

    final l10n = context.l10n;
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

  @override
  Widget build(BuildContext context) {
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
              final posts = postsState.items;
              if (posts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: AppSpacing.pagePadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: context.colors.textHint),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          l10n.noPostsFound,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        AppButton(
                          label: l10n.createFirstPostButton,
                          onPressed: _showCreateBottomSheet,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final postWidgets = posts.map<Widget>((post) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s),
                  child: PostCard(
                    post: post,
                    onTap: () => context.push('${RoutePaths.posts}/${post.id}'),
                    onDelete: () {
                      AppDialog.showActionDialog(
                        context: context,
                        icon: Icons.delete_outline_rounded,
                        title: l10n.deletePostTitle,
                        message: l10n.deletePostConfirmation(post.title),
                        primaryLabel: l10n.deleteButton,
                        secondaryLabel: l10n.cancelButton,
                        onPrimary: () => _deletePost(post.id),
                      );
                    },
                  ),
                );
              }).toList();

              final animatedItems = postWidgets.staggeredEntrance(context);

              return RefreshIndicator(
                onRefresh: () => ref.read(postsControllerProvider.notifier).refresh(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: AppSpacing.pagePadding,
                  itemCount:
                      animatedItems.length + (postsState.isLoadingMore || postsState.paginationFailure != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < animatedItems.length) {
                      return animatedItems[index];
                    }
                    if (postsState.isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                        child: Center(child: CircularProgressIndicator.adaptive()),
                      );
                    }
                    final failure = postsState.paginationFailure!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: () => ref.read(postsControllerProvider.notifier).loadMore(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            failure.localizedMessage(l10n),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateBottomSheet,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newPostButton),
      ),
    );
  }
}
