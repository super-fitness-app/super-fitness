import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_styles.dart';
import 'package:super_fitness/core/ui/extensions/validation_error_extension.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
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
    this.labelStyle,
    this.hintStyle,
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
    final pillRadius = BorderRadius.circular(100);
    final effectiveHint = hint.isNotEmpty ? hint : label;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: AppStyles.regular16.copyWith(color: AppColors.white),
      validator: (val) =>
          errorValidator?.call(val)?.toLocalizedMessage(context),
      decoration: InputDecoration(
        isDense: true,
        labelText: label.isNotEmpty ? label : null,
        labelStyle:
            labelStyle ??
            AppStyles.regular12.copyWith(
              color: AppColors.white.withValues(alpha: 0.6),
            ),
        hintText: effectiveHint,
        hintStyle:
            hintStyle ??
            AppStyles.regular14.copyWith(
              color: AppColors.white.withValues(alpha: 0.6),
            ),
        prefixIcon: prefixIcon != null
            ? _AppFieldPrefixIcon(child: prefixIcon!)
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 36,
          maxHeight: 36,
        ),
        suffixIcon: suffixIcon != null
            ? _AppFieldSuffixIcon(child: suffixIcon!)
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 36,
          maxHeight: 36,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        border: OutlineInputBorder(
          borderRadius: pillRadius,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: pillRadius,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: pillRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: pillRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: pillRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
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
