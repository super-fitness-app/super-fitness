import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_cubit.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_event.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_state.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all password fields')),
      );
      return;
    }

    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    context.read<ProfileCubit>().doEvent(
      SubmitChangePasswordEvent(
        password: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.changePasswordApiState != current.changePasswordApiState,
      listener: (context, state) {
        final apiState = state.changePasswordApiState;

        if (apiState.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.passwordChangedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );

          context.pop();
        }

        if (apiState.isFailure) {
          final message =
              apiState.failure?.toLocalizedMessage(context) ??
              l10n.generalErrorMessage;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.authBackground,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          l10n.createNewPassword,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          l10n.makeSurePasswordIs8Characters,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildPasswordField(
                          controller: _oldPasswordController,
                          hintText: l10n.oldPassword,
                          obscureText: !state.isCurrentPasswordVisible,
                          onVisibilityTap: () {
                            context.read<ProfileCubit>().doEvent(
                              const ToggleCurrentPasswordVisibilityEvent(),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _newPasswordController,
                          hintText: l10n.newPassword,
                          obscureText: !state.isNewPasswordVisible,
                          onVisibilityTap: () {
                            context.read<ProfileCubit>().doEvent(
                              const ToggleNewPasswordVisibilityEvent(),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          hintText: l10n.confirmPassword,
                          obscureText: !state.isConfirmPasswordVisible,
                          onVisibilityTap: () {
                            context.read<ProfileCubit>().doEvent(
                              const ToggleConfirmPasswordVisibilityEvent(),
                            );
                          },
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.changePasswordApiState.isLoading
                                ? null
                                : _submit,
                            child: state.changePasswordApiState.isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.done),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onVisibilityTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        suffixIcon: IconButton(
          onPressed: onVisibilityTap,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white70,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
