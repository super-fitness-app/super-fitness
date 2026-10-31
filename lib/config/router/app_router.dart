import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const main = '/main';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider<LoginCubit>(
          create: (_) => getIt.isRegistered<LoginCubit>()
              ? getIt<LoginCubit>()
              : LoginView.createFallbackCubit(),
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.main,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Main Screen')),
        ),
      ),
    ],
  );
}
