import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_text_field.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';

class CreatePostBottomSheet extends StatefulWidget {
  final Future<bool> Function({required String title, required String body}) onSubmit;

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
    final success = await widget.onSubmit(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        final l10n = AppLocalizations.of(context);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.postCreatedSuccessMessage ?? 'Post created successfully!')),
        );
      }
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
              validator: (v) => (v == null || v.trim().isEmpty) ? (l10n?.titleRequiredValidation ?? 'Title is required') : null,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              controller: _bodyController,
              label: l10n?.postBodyFieldLabel ?? 'Content',
              hint: l10n?.postBodyFieldHint ?? 'Enter post body content...',
              maxLines: 4,
              validator: (v) => (v == null || v.trim().isEmpty) ? (l10n?.contentRequiredValidation ?? 'Content is required') : null,
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
