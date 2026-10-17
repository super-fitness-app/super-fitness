import 'package:flutter/material.dart';
import 'package:super_fitness/core/ui/extensions/validation_error_extension.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final ValidationError? Function(String?)? errorValidator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.errorValidator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: (val) =>
          errorValidator?.call(val)?.toLocalizedMessage(context),
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        hintText: hint.isNotEmpty ? hint : label,
        prefixIcon: prefixIcon != null
            ? _AppFieldPrefixIcon(child: prefixIcon!)
            : null,
        suffixIcon: suffixIcon != null
            ? _AppFieldSuffixIcon(child: suffixIcon!)
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 36,
          maxHeight: 36,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 36,
          maxHeight: 36,
        ),
      ),
    );
  }
}

class _AppFieldPrefixIcon extends StatelessWidget {
  final Widget child;

  const _AppFieldPrefixIcon({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 14, end: 8),
      child: IconTheme(
        data: IconThemeData(
          color: AppColors.white.withValues(alpha: 0.9),
          size: 18,
        ),
        child: child,
      ),
    );
  }
}

class _AppFieldSuffixIcon extends StatelessWidget {
  final Widget child;

  const _AppFieldSuffixIcon({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, end: 14),
      child: IconTheme(
        data: IconThemeData(
          color: AppColors.white.withValues(alpha: 0.9),
          size: 18,
        ),
        child: child,
      ),
    );
  }
}
