import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/core/theme/app_motion.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_controller.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/create_post_bottom_sheet.dart';
import 'package:flutter_core_base/features/posts/presentation/widgets/post_card.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsControllerProvider);
    final controller = ref.read(postsControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.postsFeedTitle ?? 'Posts & Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: AsyncValueWidget<List<Post>>(
            value: postsAsync,
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: AppSpacing.pagePadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          'No articles found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        AppButton(
                          label: 'Create First Post',
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
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Post'),
                          content: Text('Are you sure you want to delete "${post.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(postsControllerProvider.notifier).deletePost(post.id);
                      }
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
                  itemCount: animatedItems.length + (controller.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < animatedItems.length) {
                      return animatedItems[index];
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                      child: Center(child: CircularProgressIndicator.adaptive()),
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
        label: const Text('New Post'),
      ),
    );
  }
}
