import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'already_have_account_row.dart';
import 'register_fields.dart';
import 'social_auth_buttons.dart';

class RegisterFormCard extends StatelessWidget {
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final bool isLoading;

  const RegisterFormCard({
    super.key,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.passwordController,
    required this.onRegisterPressed,
    required this.onLoginTap,
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(45),
        topRight: Radius.circular(45),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17.3, sigmaY: 17.3),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            28,
            28,
            28,
            bottomInset > 0 ? bottomInset + 12 : 24,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                AppStrings.register,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              RegisterFields(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(height: 20),
              SocialAuthButtons(
                onFacebookTap: onFacebookTap,
                onGoogleTap: onGoogleTap,
                onAppleTap: onAppleTap,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeBase,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          AppStrings.register,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              AlreadyHaveAccountRow(
                onLoginTap: onLoginTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
