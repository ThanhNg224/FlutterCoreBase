import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/utils/form_validators.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/core/widgets/app_snackbar.dart';
import 'package:flutter_core_base/core/widgets/app_text_field.dart';
import 'package:flutter_core_base/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final result = await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // On success the router's redirect takes over; there is nothing to do here.
    result.fold(
      (failure) => AppSnackbar.showError(context, failure.localizedMessage(context.l10n)),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: SingleChildScrollView(
              padding: AppSpacing.pagePadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.loginTitle, style: textTheme.displayLarge, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      l10n.loginSubtitle,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: l10n.emailLabel,
                            hint: l10n.emailHint,
                            controller: _emailController,
                            prefixIcon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            validator: FormValidators.email(context),
                          ),
                          const SizedBox(height: AppSpacing.m),
                          AppTextField(
                            label: l10n.passwordLabel,
                            hint: l10n.passwordHint,
                            controller: _passwordController,
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _submit(),
                            validator: FormValidators.compose([
                              FormValidators.required(context),
                              FormValidators.minLength(context, 6),
                            ]),
                          ),
                          const SizedBox(height: AppSpacing.l),
                          AppButton(
                            label: l10n.loginButton,
                            icon: Icons.login_rounded,
                            isLoading: _isSubmitting,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      l10n.demoCredentialsHint,
                      style: textTheme.bodySmall?.copyWith(color: context.colors.textHint),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
