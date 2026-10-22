import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            AppStrings.forgetPassword,
            style: AppTextStyles.appTitle,
          ),
        ),
      ),
    );
  }
}
