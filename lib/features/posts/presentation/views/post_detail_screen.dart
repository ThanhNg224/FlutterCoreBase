import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/post_detail_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailControllerProvider(postId));
    final textTheme = Theme.of(context).textTheme;
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.postDetailTitle(postId)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: AsyncValueWidget<Post>(
            value: postAsync,
            data: (post) {
              return SingleChildScrollView(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: colors.brandAccent.withValues(alpha: 0.15),
                                child: Icon(Icons.person_outline_rounded, color: colors.brandAccent),
                              ),
                              const SizedBox(width: AppSpacing.s),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.authorIdLabel(post.userId),
                                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    l10n.publishedArticleLabel,
                                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.xl),
                          Text(
                            post.title,
                            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.m),
                          Text(
                            post.body,
                            style: textTheme.bodyLarge?.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: AppSpacing.l),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: post.tags.map((tag) {
                              return Chip(
                                label: Text(tag, style: textTheme.labelSmall),
                                backgroundColor: colors.surface,
                                side: BorderSide(color: colors.border),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
