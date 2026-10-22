import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'register_password_field.dart';
import 'register_text_field.dart';

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
    return Column(
      children: [
        RegisterTextField(
          controller: firstNameController,
          hint: AppStrings.firstName,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? AppStrings.firstNameRequired : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          controller: lastNameController,
          hint: AppStrings.lastName,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? AppStrings.lastNameRequired : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          controller: emailController,
          hint: AppStrings.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline),
          validator: (val) {
            final error = AppValidators.validateEmail(val);
            return error != null ? AppStrings.invalidEmail : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterPasswordField(
          controller: passwordController,
          validator: (val) {
            final error = AppValidators.validatePassword(val);
            return error != null ? AppStrings.passwordMinLength : null;
          },
        ),
      ],
    );
  }
}
