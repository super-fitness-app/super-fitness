import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/validation_error_extension.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_state.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/forgot_password_button.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_footer.dart';
import 'package:super_fitness/features/auth/presentation/widgets/social_auth_buttons.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              key: const Key('loginEmailField'),
              label: l10n.email,
              hint: l10n.email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              errorText: state.emailError?.toLocalizedMessage(context),
              errorValidator: (_) => state.emailError,
              onChanged: (val) =>
                  context.read<LoginCubit>().doEvent(EmailChangedEvent(val)),
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('loginPasswordField'),
              label: l10n.password,
              hint: l10n.password,
              errorMaxLines: 3,
              obscureText: !state.isPasswordVisible,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => context
                    .read<LoginCubit>()
                    .doEvent(const TogglePasswordVisibilityEvent()),
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.white,
                ),
              ),
              errorText: state.passwordError?.toLocalizedMessage(context),
              errorValidator: (_) => state.passwordError,
              onChanged: (val) =>
                  context.read<LoginCubit>().doEvent(PasswordChangedEvent(val)),
            ),
            const SizedBox(height: 12),
            const ForgotPasswordButton(),
            const SizedBox(height: 20),
            SocialAuthButtons(
              onFacebookTap: state.isLoading
                  ? null
                  : () => context
                      .read<LoginCubit>()
                      .signInWithFacebookIntent(),
              onGoogleTap: state.isLoading
                  ? null
                  : () => context
                      .read<LoginCubit>()
                      .signInWithGoogleIntent(),
            ),
            const SizedBox(height: 24),
            AppButton(
              key: const Key('loginSubmitButton'),
              text: l10n.login,
              isLoading: state.isLoading,
              onPressed: () =>
                  context.read<LoginCubit>().doEvent(const SubmitLoginEvent()),
            ),
            const SizedBox(height: 24),
            const LoginFooter(),
          ],
        );
      },
    );
  }
}
