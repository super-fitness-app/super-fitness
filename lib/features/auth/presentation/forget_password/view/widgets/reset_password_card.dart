import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

class ResetPasswordCard extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  const ResetPasswordCard({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ResetPasswordCard> createState() => _ResetPasswordCardState();
}

class _ResetPasswordCardState extends State<ResetPasswordCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _submit() {
    if (widget.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    widget.onSubmit(_passwordController.text);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(44),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  key: const Key('resetPasswordField1'),
                  controller: _passwordController,
                  label: l10n.password,
                  hint: l10n.password,
                  errorMaxLines: 3,
                  obscureText: _obscurePassword,
                  readOnly: widget.isLoading,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  errorValidator: AppValidators.validatePassword,
                ),

                const SizedBox(height: 24),

                AppTextField(
                  key: const Key('resetPasswordField2'),
                  controller: _confirmPasswordController,
                  label: l10n.password,
                  hint: 'Confirm password',
                  errorMaxLines: 3,
                  obscureText: _obscureConfirmPassword,
                  readOnly: widget.isLoading,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  errorValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    if (value != _passwordController.text) {
                      // Replace with your project's matching
                      // ValidationError if available.
                      return null;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                AppButton(
                  isLoading: widget.isLoading,
                  text: 'Done',
                  onPressed: widget.isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
