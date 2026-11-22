part of 'home_cubit.dart';

typedef HomeState = BaseState<HomeData>;

class HomeData extends Equatable {
  // Recommendation Today (Random Muscles)
  final List<MuscleEntity> randomMuscles;
  final bool isRandomMusclesLoading;

  // Upcoming Workouts (Muscle Groups & Selected Group Muscles)
  final List<MuscleGroupEntity> muscleGroups;
  final String? selectedMuscleGroupId;
  final List<MuscleEntity> musclesByGroup;
  final bool isMusclesByGroupLoading;

  // Recommendation For You (Meal Categories)
  final List<MealCategoryEntity> mealCategories;
  final bool isMealCategoriesLoading;

  // Popular Training (Exercises by Random Level & Prime Mover Muscle)
  final List<PopularTrainingEntity> popularTrainings;
  final bool isPopularTrainingsLoading;

  const HomeData({
    this.randomMuscles = const [],
    this.isRandomMusclesLoading = false,
    this.muscleGroups = const [],
    this.selectedMuscleGroupId,
    this.musclesByGroup = const [],
    this.isMusclesByGroupLoading = false,
    this.mealCategories = const [],
    this.isMealCategoriesLoading = false,
    this.popularTrainings = const [],
    this.isPopularTrainingsLoading = false,
  });

  HomeData copyWith({
    List<MuscleEntity>? randomMuscles,
    bool? isRandomMusclesLoading,
    List<MuscleGroupEntity>? muscleGroups,
    String? selectedMuscleGroupId,
    List<MuscleEntity>? musclesByGroup,
    bool? isMusclesByGroupLoading,
    List<MealCategoryEntity>? mealCategories,
    bool? isMealCategoriesLoading,
    List<PopularTrainingEntity>? popularTrainings,
    bool? isPopularTrainingsLoading,
  }) {
    return HomeData(
      randomMuscles: randomMuscles ?? this.randomMuscles,
      isRandomMusclesLoading:
          isRandomMusclesLoading ?? this.isRandomMusclesLoading,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      selectedMuscleGroupId:
          selectedMuscleGroupId ?? this.selectedMuscleGroupId,
      musclesByGroup: musclesByGroup ?? this.musclesByGroup,
      isMusclesByGroupLoading:
          isMusclesByGroupLoading ?? this.isMusclesByGroupLoading,
      mealCategories: mealCategories ?? this.mealCategories,
      isMealCategoriesLoading:
          isMealCategoriesLoading ?? this.isMealCategoriesLoading,
      popularTrainings: popularTrainings ?? this.popularTrainings,
      isPopularTrainingsLoading:
          isPopularTrainingsLoading ?? this.isPopularTrainingsLoading,
    );
  }

  @override
  List<Object?> get props => [
    randomMuscles,
    isRandomMusclesLoading,
    muscleGroups,
    selectedMuscleGroupId,
    musclesByGroup,
    isMusclesByGroupLoading,
    mealCategories,
    isMealCategoriesLoading,
    popularTrainings,
    isPopularTrainingsLoading,
  ];
}
