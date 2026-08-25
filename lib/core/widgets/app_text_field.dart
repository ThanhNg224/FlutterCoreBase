import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single text-field entry point for the design system ensuring consistent
/// InputDecoration and styling across screens.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
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
    this.inputFormatters,
    this.controller,
    this.initialValue,
    this.onChanged,
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
      initialValue: initialValue,
      decoration: decoration,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}
