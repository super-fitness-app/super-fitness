import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/complete_register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const completeRegister = '/complete-register';
  static const selectGender = '/complete-register';
  static const selectAge = '/complete-register';
  static const selectWeight = '/complete-register';
  static const selectHeight = '/complete-register';
  static const selectGoal = '/complete-register';
  static const selectActivity = '/complete-register';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.register,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<RegisterCubit>(),
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
    ],
  );
}
