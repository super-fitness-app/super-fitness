import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'register_text_field.dart';

class RegisterPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const RegisterPasswordField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<RegisterPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RegisterTextField(
      controller: widget.controller,
      hint: l10n.password,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.white,
          size: 20,
        ),
        onPressed: _toggleVisibility,
        splashRadius: 20,
      ),
    );
  }
}
