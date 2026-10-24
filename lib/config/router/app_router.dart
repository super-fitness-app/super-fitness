import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_activity_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_age_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_gender_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_goal_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_height_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_weight_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const selectGender = '/select-gender';
  static const selectAge = '/select-age';
  static const selectWeight = '/select-weight';
  static const selectHeight = '/select-height';
  static const selectGoal = '/select-goal';
  static const selectActivity = '/select-activity';
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
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<RegisterCubit>(
            create: (context) => getIt<RegisterCubit>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const RegisterView(),
          ),
          GoRoute(
            path: AppRoutes.selectGender,
            builder: (context, state) => const SelectGenderView(),
          ),
          GoRoute(
            path: AppRoutes.selectAge,
            builder: (context, state) => const SelectAgeView(),
          ),
          GoRoute(
            path: AppRoutes.selectWeight,
            builder: (context, state) => const SelectWeightView(),
          ),
          GoRoute(
            path: AppRoutes.selectHeight,
            builder: (context, state) => const SelectHeightView(),
          ),
          GoRoute(
            path: AppRoutes.selectGoal,
            builder: (context, state) => const SelectGoalView(),
          ),
          GoRoute(
            path: AppRoutes.selectActivity,
            builder: (context, state) => const SelectActivityView(),
          ),
        ],
      ),
    ],
  );
}
