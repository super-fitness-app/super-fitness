import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/view/onboarding_view.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/complete_register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/main_layout_view.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const completeRegister = '/complete-register';
  static const selectGender = '/complete-register';
  static const selectAge = '/complete-register';
  static const selectWeight = '/complete-register';
  static const selectHeight = '/complete-register';
  static const selectGoal = '/complete-register';
  static const selectActivity = '/complete-register';
  static const forgetPassword = '/forget-password';
  static const home = '/home';
  static const main = '/main';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter({
    required StorageService storageService,
    String initialLocation = AppRoutes.onboarding,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation,
      redirect: (context, state) async {
        final hasSeen = await storageService.get(
          AppConstants.hasSeenOnboardingKey,
        );
        final isGoingToOnboarding =
            state.matchedLocation == AppRoutes.onboarding;

        if (hasSeen != 'true' && !isGoingToOnboarding) {
          return AppRoutes.onboarding;
        }

        if (hasSeen == 'true' && isGoingToOnboarding) {
          return AppRoutes.login;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<OnboardingCubit>(),
            child: const OnboardingView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<RegisterCubit>(),
            child: const RegisterView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.completeRegister,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final cubit = state.extra is RegisterCubit
                ? state.extra! as RegisterCubit
                : getIt<RegisterCubit>();
            return BlocProvider.value(
              value: cubit,
              child: const CompleteRegisterView(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.forgetPassword,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const ForgetPasswordView(),
        ),
        GoRoute(
          path: AppRoutes.main,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<MainLayoutCubit>(),
            child: const MainLayoutView(),
          ),
        ),
      ],
    );
  }

  static final GoRouter router = createRouter(
    storageService: getIt<StorageService>(),
  );
}
