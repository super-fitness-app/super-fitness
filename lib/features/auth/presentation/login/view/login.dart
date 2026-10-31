import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class LoginView extends StatefulWidget {
  final LoginCubit? cubit;
  const LoginView({super.key, this.cubit});

  static LoginCubit createFallbackCubit() {
    return LoginCubit(
      LoginUseCase(const _FallbackAuthRepo()),
      _FallbackSessionService(),
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with BaseViewMixin<LoginView, LoginCubit, BaseEvent> {
  LoginCubit? _fallbackCubit;

  @override
  LoginCubit get cubit {
    if (widget.cubit != null) return widget.cubit!;
    try {
      return context.read<LoginCubit>();
    } catch (_) {
      return _fallbackCubit ??= LoginView.createFallbackCubit();
    }
  }

  @override
  void dispose() {
    _fallbackCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>.value(
      value: cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppImages.background, fit: BoxFit.cover),

            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: AppColors.background.withValues(alpha: 0.35),
                ),
              ),
            ),

            const SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12),
                    LoginHeaderSection(),
                    SizedBox(height: 28),
                    LoginCard(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackAuthRepo implements AuthRepo {
  const _FallbackAuthRepo();

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }
}

class _FallbackSessionService implements SessionService {
  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {}

  @override
  Future<void> clearSession() async {}

  @override
  Future<String> getRefreshToken() async => '';

  @override
  Future<String> getToken() async => '';

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => true;

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> setRememberMe(bool value) async {}

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {}
}
