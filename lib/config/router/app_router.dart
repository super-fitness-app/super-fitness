import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/exercise_view.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/food_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/food_details_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const workout = '/workout';
  static const exercise = '/exercise';
  static const food = '/food';
  static const foodDetails = '/food-details';
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
      GoRoute(
        path: AppRoutes.workout,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WorkoutView(),
      ),
      GoRoute(
        path: AppRoutes.exercise,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExerciseView(),
      ),
      GoRoute(
        path: AppRoutes.food,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FoodView(),
      ),
      GoRoute(
        path: AppRoutes.foodDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FoodDetailsView(),
      ),
    ],
  );
}
