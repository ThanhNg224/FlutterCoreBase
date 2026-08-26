import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single text-field entry point for the design system ensuring consistent
/// InputDecoration, accessibility, and styling across screens.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      helperText: helperText,
      helperMaxLines: 3,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      suffixIcon: suffix,
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      enabled: enabled,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
