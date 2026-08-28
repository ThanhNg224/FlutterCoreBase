import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/utils/form_validators.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_dialog.dart';
import 'package:flutter_core_base/core/widgets/app_snackbar.dart';
import 'package:flutter_core_base/core/widgets/app_text_field.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
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
      final l10n = context.l10n;
      result.fold(
        (failure) => AppDialog.showResultDialog(
          context: context,
          title: l10n.somethingWentWrongMessage,
          message: failure.localizedMessage(l10n),
          isSuccess: false,
        ),
        (_) {
          Navigator.of(context).pop();
          AppSnackbar.showSuccess(context, l10n.postCreatedSuccessMessage);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _titleController,
            label: l10n.postTitleFieldLabel,
            hint: l10n.postTitleFieldHint,
            validator: FormValidators.required(context),
          ),
          const SizedBox(height: AppSpacing.m),
          AppTextField(
            controller: _bodyController,
            label: l10n.postBodyFieldLabel,
            hint: l10n.postBodyFieldHint,
            maxLines: 4,
            validator: FormValidators.required(context),
          ),
          const SizedBox(height: AppSpacing.l),
          AppButton(
            label: l10n.publishPostButton,
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
