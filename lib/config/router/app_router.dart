import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/utils/video_player/app_video_player.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/exercise_view.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food/view/food_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/food_details_view.dart';

abstract final class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const workout = '/workout';
  static const exercise = '/exercise';
  static const food = '/food';
  static const foodDetails = '/food-details';
  static const appVideoPlayer = '/app-video-player';
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
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FoodCubit>(),
          child: const FoodView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.foodDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final mealId = switch (state.extra) {
            String id => id,
            _ => '',
          };
          return BlocProvider(
            create: (_) => getIt<FoodDetailsCubit>()
              ..doEvent(LoadMealDetailsEvent(mealId)),
            child: FoodDetailsView(mealId: mealId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.appVideoPlayer,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final videoUrl = args?['videoUrl'] as String?;
          final title = args?['title'] as String?;
          if (videoUrl == null || title == null) {
            return const SizedBox.shrink();
          }
          return AppVideoPlayer(videoUrl: videoUrl, title: title);
        },
      ),
    ],
  );
}
