import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_event.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_state.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/exercise_header.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/exercise_list_view.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/get_duration_and_calories.dart';

class ExerciseView extends StatefulWidget {
  final ExerciseCubit? cubit;
  // final String primeMoverMuscleId;
  // final String bodyBuilderExerciseImage;
  // final String exerciseName;
  const ExerciseView({super.key, this.cubit});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with BaseViewMixin<ExerciseView, ExerciseCubit, BaseEvent> {
  late final ExerciseCubit _cubit;
  bool _ownsCubit = false;

  @override
  ExerciseCubit get cubit => _cubit;
  // String get _primeMoverMuscleId => widget.primeMoverMuscleId;
  static const String _primeMoverMuscleId = '69d982ef85f6bfa972bf2248';
  StreamSubscription<ExerciseState>? _stateSubscription;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else {
      _cubit = getIt<ExerciseCubit>();
      _ownsCubit = true;
    }

    super.initState();

    _listenToDifficultyLevels();

    if (_cubit.state.data?.levels.isNotEmpty == true) {
      _loadExercisesForTab(0);
    } else {
      _cubit.doEvent(GetAllDifficultyLevelsEvent(language: 'en'));
    }
  }

  void _listenToDifficultyLevels() {
    _stateSubscription = _cubit.stream.listen((state) {
      final levels = state.data?.levels ?? [];

      if (levels.isNotEmpty) {
        _stateSubscription?.cancel();
        _stateSubscription = null;

        _loadExercisesForTab(0);
      }
    });
  }

  void _loadExercisesForTab(int index) {
    final levels = _cubit.state.data?.levels ?? [];

    if (index < 0 || index >= levels.length) return;

    _cubit.doEvent(
      GetExercisesByMuscleAndDifficultyEvent(
        language: 'en',
        primeMoverMuscleId: _primeMoverMuscleId,
        difficultyLevelId: levels[index].id,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();

    if (_ownsCubit) {
      _cubit.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppImages.exerciseBackground, fit: BoxFit.cover),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.42,
                child: Image.asset(AppImages.bodyBuilder, fit: BoxFit.cover),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 355,
                color: AppColors.black.withValues(alpha: 0.3),
              ),
            ),

            Positioned(top: 50, left: 0, right: 335, child: ExerciseHeader()),

            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      AppColors.surface.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 200),

                      Text(
                        'Chest exercise',
                        style: AppTextStyles.medium20.copyWith(fontSize: 24),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Lorem ipsum dolor sit amet consectetur. '
                          'Tempus volutpat ut nisi morbi.',
                          style: AppTextStyles.regular16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      GetDurationAndCalories(localization: localization),

                      const SizedBox(height: 10),

                      TabBar(
                        onTap: (index) {
                          _loadExercisesForTab(index);
                        },
                        indicatorPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: AppColors.transparent,
                        indicator: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(33),
                        ),
                        labelColor: AppColors.white,
                        unselectedLabelColor: AppColors.whiteBase,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        tabs: [
                          Tab(text: localization.beginner),
                          Tab(text: localization.intermediate),
                          Tab(text: localization.advanced),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Expanded(
                    child: BlocBuilder<ExerciseCubit, ExerciseState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        // Loading state
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Failure state
                        if (state.failure != null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.errorMessage ??
                                      localization.failedToLoadExercises,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.regular16,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    _cubit.doEvent(
                                      GetExercisesByMuscleAndDifficultyEvent(
                                        language: 'en',
                                        primeMoverMuscleId: _primeMoverMuscleId,
                                        difficultyLevelId:
                                            state.data?.levels.first.id ?? '',
                                      ),
                                    );
                                  },
                                  child: Text(localization.retry),
                                ),
                              ],
                            ),
                          );
                        }

                        // Initial or success state
                        final exercises = state.data?.exercises ?? [];

                        if (exercises.isEmpty) {
                          return Center(
                            child: Text(localization.noExercisesFound),
                          );
                        }

                        return ExerciseListView(exercises: exercises);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
