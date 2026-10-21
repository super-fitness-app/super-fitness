import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class AlreadyHaveAccountRow extends StatelessWidget {
  final VoidCallback onLoginTap;

  const AlreadyHaveAccountRow({
    super.key,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already Have An Account ? ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: AppColors.orangeBase, // exact same vibrant orange as Register button
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.orangeBase,
              ),
              recognizer: TapGestureRecognizer()..onTap = onLoginTap,
            ),
          ],
        ),
      ),
    );
  }
}
