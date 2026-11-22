import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/utils/video_player/app_video_player.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/view/onboarding_view.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/complete_register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/exercise_view.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/main_layout_view.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food/view/food_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/food_details_view.dart';

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
  static const workout = '/workout';
  static const exercise = '/exercise';
  static const exerciseview = '/exercise-details';
  static const food = '/food';
  static const foodDetails = '/food-details';
  static const appVideoPlayer = '/app-video-player';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter({
    required StorageService storageService,
    required SessionService sessionService,
    String initialLocation = AppRoutes.login,
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

        final token = await sessionService.getToken();
        final isAuthenticated = token.isNotEmpty;
        final isGoingToProtected =
            state.matchedLocation == AppRoutes.main ||
            state.matchedLocation == AppRoutes.home;

        if (!isAuthenticated && isGoingToProtected) {
          return AppRoutes.login;
        }

        if (hasSeen == 'true') {
          if (isAuthenticated) {
            if (isGoingToOnboarding ||
                state.matchedLocation == AppRoutes.login) {
              return AppRoutes.main;
            }
          } else {
            if (isGoingToOnboarding) {
              return AppRoutes.login;
            }
          }
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
          builder: (context, state) => BlocProvider<ForgetPasswordCubit>(
            create: (_) => getIt<ForgetPasswordCubit>(),
            child: const ForgetPasswordView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.main,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<MainLayoutCubit>(),
            child: const MainLayoutView(),
          ),
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
          builder: (context, state) {
            final muscle = state.extra is MuscleEntity
                ? state.extra! as MuscleEntity
                : const MuscleEntity(id: '', name: '', image: '');
            return ExerciseView(muscle: muscle);
          },
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
              create: (_) =>
                  getIt<FoodDetailsCubit>()
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

  static GoRouter get router => createRouter(
    storageService: getIt<StorageService>(),
    sessionService: getIt<SessionService>(),
  );
}
