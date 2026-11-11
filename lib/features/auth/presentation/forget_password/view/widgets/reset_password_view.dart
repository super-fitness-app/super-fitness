import 'package:flutter/material.dart';

import 'package:super_fitness/features/auth/presentation/forget_password/view/widgets/reset_password_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class ResetPasswordView extends StatelessWidget {
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  const ResetPasswordView({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        LoginHeaderSection(
          firstTitle: "make sure its 8 characters or more",
          secondTitlel: "Create New Password",
          anotherHeight: 88,
        ),
        const SizedBox(height: 28),
        ResetPasswordCard(onSubmit: onSubmit, isLoading: isLoading),
        const SizedBox(height: 16),
      ],
    );
  }
}
