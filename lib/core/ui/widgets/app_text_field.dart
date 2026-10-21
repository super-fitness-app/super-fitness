import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/validation_error_extension.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

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
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? style;

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
    this.fillColor,
    this.hintStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: style,
      validator: (val) {
        final error = errorValidator?.call(val);
        if (error == null || !context.mounted) return null;
        final l10n = AppLocalizations.of(context);
        if (l10n == null) return null;
        return error.toLocalizedMessage(context);
      },
      decoration: InputDecoration(
        fillColor: fillColor,
        labelText: label.isNotEmpty ? label : null,
        hintText: hint.isNotEmpty ? hint : label,
        hintStyle: hintStyle,
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
