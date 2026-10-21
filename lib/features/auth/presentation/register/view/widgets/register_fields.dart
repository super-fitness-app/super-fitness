import 'package:flutter/material.dart';
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
          hint: 'First Name',
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? 'First name is required' : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          controller: lastNameController,
          hint: 'Last Name',
          prefixIcon: const Icon(Icons.person_outline),
          validator: (val) {
            final error = AppValidators.validateRequired(val);
            return error != null ? 'Last name is required' : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterTextField(
          controller: emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline),
          validator: (val) {
            final error = AppValidators.validateEmail(val);
            return error != null ? 'Please enter a valid email' : null;
          },
        ),
        const SizedBox(height: 20),
        RegisterPasswordField(
          controller: passwordController,
          validator: (val) {
            final error = AppValidators.validatePassword(val);
            return error != null ? 'Password must be at least 8 characters' : null;
          },
        ),
      ],
    );
  }
}
