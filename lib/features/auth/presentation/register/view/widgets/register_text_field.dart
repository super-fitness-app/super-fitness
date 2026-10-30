import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  static const _borderRadius = BorderRadius.all(Radius.circular(50));
  static const _defaultBorder = OutlineInputBorder(
    borderRadius: _borderRadius,
    borderSide: BorderSide(color: Colors.white, width: 1),
  );
  static const _errorBorder = OutlineInputBorder(
    borderRadius: _borderRadius,
    borderSide: BorderSide(color: Colors.redAccent, width: 1),
  );

  final String hint;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const RegisterTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.transparent, // Completely transparent, NO grey tint
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 10),
          child: IconTheme(
            data: const IconThemeData(color: Colors.white, size: 20),
            child: prefixIcon,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: 6, end: 14),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.white.withValues(alpha: 0.85),
                    size: 20,
                  ),
                  child: suffixIcon!,
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: _defaultBorder,
        enabledBorder: _defaultBorder,
        focusedBorder: _defaultBorder,
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
      ),
    );
  }
}
