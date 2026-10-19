import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';

abstract final class AppRoutes {
  static const login = '/';
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
        builder: (context, state) => const LoginView(),
      ),
    ],
  );
}
