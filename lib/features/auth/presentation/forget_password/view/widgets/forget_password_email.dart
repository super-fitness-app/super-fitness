import 'package:flutter/material.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/widgets/forget_password_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class ForgetPasswordEmail extends StatelessWidget {
  final ValueChanged<String> onSubmit;
  final bool isLoading;

  const ForgetPasswordEmail({
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
          firstTitle: "Enter Your Email",
          secondTitlel: "Forget password",
          anotherHeight: 88,
        ),
        const SizedBox(height: 28),
        ForgetPasswordCard(onSubmit: onSubmit, isLoading: isLoading),
        const SizedBox(height: 16),
      ],
    );
  }
}
