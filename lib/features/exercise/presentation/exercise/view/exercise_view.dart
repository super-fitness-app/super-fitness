import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_state.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/exercise_header.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/exercise_list_view.dart';

class ExerciseView extends StatefulWidget {
  final ExerciseCubit? cubit;

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
  static const String _primeMoverMuscleId = '69d982ef85f6bfa972bf2248';

  // static const List<String> _difficultyIds = [
  //   '69d982ed85f6bfa972bf2216',
  //   '69d982ed85f6bfa972bf221c',
  //   '69d982ed85f6bfa972bf2222',
  // ];

  void _loadExercisesForTab(int index) {
    final levels = _cubit.state.data?.levels ?? [];

    if (levels.isEmpty) return;

    final difficultyLevelId = levels[index].id;

    _cubit.getExercisesByMuscleAndDifficulty(
      language: 'en',
      primeMoverMuscleId: _primeMoverMuscleId,
      difficultyLevelId: difficultyLevelId,
    );
  }

  @override
  void initState() {
    // Initialize the Cubit before BaseViewMixin accesses it.
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else {
      _cubit = getIt<ExerciseCubit>();
      _ownsCubit = true;
    }

    // Call this only after _cubit has been initialized.
    super.initState();

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _cubit.getAllDifficultyLevels(language: 'en');

    if (!mounted) return;

    _loadExercisesForTab(0);
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                height: 355,
                child: Image.asset(AppImages.bodyBuilder, fit: BoxFit.cover),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 355,
                color: const Color.fromARGB(85, 0, 0, 0),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '30 Min',
                              style: AppTextStyles.regular12.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '120 Cal',
                              style: AppTextStyles.regular12.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      TabBar(
                        onTap: (index) {
                          _loadExercisesForTab(index);
                        },
                        indicatorPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
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
                        tabs: const [
                          Tab(text: 'Beginner'),
                          Tab(text: 'Intermediate'),
                          Tab(text: 'Advanced'),
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
                                      'Failed to load exercises',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.regular16,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    _cubit.getExercisesByMuscleAndDifficulty(
                                      language: 'en',
                                      primeMoverMuscleId:
                                          '69d982ef85f6bfa972bf2248',
                                      difficultyLevelId:
                                          '69d982ed85f6bfa972bf2222',
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        // Initial or success state
                        final exercises = state.data?.exercises ?? [];
                        final muscles = state.data?.muscles ?? [];

                        if (exercises.isEmpty) {
                          return const Center(
                            child: Text('No exercises found'),
                          );
                        }

                        return ExerciseListView(
                          muscles: muscles,
                          exercises: exercises,
                        );
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
