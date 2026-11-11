import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

class ForgetPasswordCard extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  const ForgetPasswordCard({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ForgetPasswordCard> createState() => _ForgetPasswordCardState();
}

class _ForgetPasswordCardState extends State<ForgetPasswordCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  void _submit() {
    if (widget.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSubmit(_emailController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                  key: const Key('forgetpasswordEmailField'),
                  controller: _emailController,
                  label: l10n.email,
                  hint: l10n.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  readOnly: widget.isLoading,
                  errorValidator: AppValidators.validateEmail,
                ),
                const SizedBox(height: 24),

                // if (widget.isLoading) ...[
                //   const Center(
                //     child: CircularProgressIndicator(),
                //   ),
                //   const SizedBox(height: 12),
                // ],
                AppButton(
                  isLoading: widget.isLoading,
                  text: widget.isLoading ? 'Sending...' : 'Send OTP',
                  onPressed: widget.isLoading ? () {} : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
