import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_dialog.dart';
import 'package:flutter_core_base/core/widgets/app_snackbar.dart';
import 'package:flutter_core_base/core/widgets/app_text_field.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';
import 'package:fpdart/fpdart.dart' hide State;

class CreatePostBottomSheet extends StatefulWidget {
  final Future<Either<Failure, Post>> Function({required String title, required String body}) onSubmit;

  const CreatePostBottomSheet({super.key, required this.onSubmit});

  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final result = await widget.onSubmit(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      final l10n = AppLocalizations.of(context);
      result.fold(
        (failure) => AppDialog.showResultDialog(
          context: context,
          title: l10n?.somethingWentWrongMessage ?? 'Something went wrong',
          message: l10n == null ? 'Unable to create the post' : failure.localizedMessage(l10n),
          isSuccess: false,
        ),
        (_) {
          Navigator.of(context).pop();
          AppSnackbar.showSuccess(context, l10n?.postCreatedSuccessMessage ?? 'Post created successfully!');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.l,
        bottom: AppSpacing.l + bottomInset,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.post_add_rounded, size: 24),
                const SizedBox(width: AppSpacing.s),
                Text(l10n?.createPostTitle ?? 'Create New Post', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              controller: _titleController,
              label: l10n?.postTitleFieldLabel ?? 'Title',
              hint: l10n?.postTitleFieldHint ?? 'Enter post title',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? (l10n?.titleRequiredValidation ?? 'Title is required') : null,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              controller: _bodyController,
              label: l10n?.postBodyFieldLabel ?? 'Content',
              hint: l10n?.postBodyFieldHint ?? 'Enter post body content...',
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? (l10n?.contentRequiredValidation ?? 'Content is required') : null,
            ),
            const SizedBox(height: AppSpacing.l),
            AppButton(
              label: l10n?.publishPostButton ?? 'Publish Post',
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
