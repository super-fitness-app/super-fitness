import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/features/splash/presentation/view/splash_view.dart';

abstract final class AppRoutes {
  static const splash = '/';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashView(),
      ),
    ],
  );
}
