import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/exercise_view.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/food_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/food_details_view.dart';
import 'package:super_fitness/features/profile/presentation/view/activity_edit_view.dart';
import 'package:super_fitness/features/profile/presentation/view/edit_profile_view.dart';
import 'package:super_fitness/features/profile/presentation/view/goal_edit_view.dart';
import 'package:super_fitness/features/profile/presentation/view/weight_edit_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const workout = '/workout';
  static const exercise = '/exercise';
  static const food = '/food';
  static const foodDetails = '/food-details';
  static const editProfile = '/edit-profile';
  static const weightEdit = '/weight-edit';
  static const goalEdit = '/goal-edit';
  static const activityEdit = '/activity-edit';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.editProfile,
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
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: AppRoutes.weightEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WeightEditView(),
      ),
      GoRoute(
        path: AppRoutes.goalEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GoalEditView(),
      ),
      GoRoute(
        path: AppRoutes.activityEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ActivityEditView(),
      ),
    ],
  );
}
