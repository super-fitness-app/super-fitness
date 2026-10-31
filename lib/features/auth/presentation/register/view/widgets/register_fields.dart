import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'register_password_field.dart';
import 'register_text_field.dart';

abstract final class RegisterFieldsKeys {
  static const firstName = Key('register_first_name_field');
  static const lastName = Key('register_last_name_field');
  static const email = Key('register_email_field');
  static const password = Key('register_password_field');
}

class RegisterFields extends StatelessWidget {
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const RegisterFields({
    super.key,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        RegisterTextField(
          key: RegisterFieldsKeys.firstName,
          controller: firstNameController,
          hint: l10n.firstName,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? l10n.firstNameRequired : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          key: RegisterFieldsKeys.lastName,
          controller: lastNameController,
          hint: l10n.lastName,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? l10n.lastNameRequired : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          key: RegisterFieldsKeys.email,
          controller: emailController,
          hint: l10n.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline),
          validator: (val) {
            final error = AppValidators.validateEmail(val);
            return error != null ? l10n.invalidEmail : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterPasswordField(
          key: RegisterFieldsKeys.password,
          controller: passwordController,
          validator: (val) {
            final error = AppValidators.validatePassword(val);
            return error != null ? l10n.passwordMinLength : null;
          },
        ),
      ],
    );
  }
}
