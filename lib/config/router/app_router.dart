import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const home = '/home';
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
      GoRoute(
        path: AppRoutes.home,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
