import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';
import 'package:super_fitness/features/home/presentation/manager/home_cubit.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/category_section_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/floating_bottom_nav_bar.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/home_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/popular_training_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/recommendation_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/upcoming_workouts_section.dart';

class RecommendationItemModel {
  final String title;
  final String imageUrl;

  const RecommendationItemModel({required this.title, required this.imageUrl});
}

class PopularTrainingItemModel {
  final String title;
  final String taskCountText;
  final String levelText;
  final String imageUrl;
  final Color? levelColor;

  const PopularTrainingItemModel({
    required this.title,
    required this.taskCountText,
    required this.levelText,
    required this.imageUrl,
    this.levelColor,
  });
}

class HomeView extends StatefulWidget {
  final HomeCubit? cubit;
  const HomeView({super.key, this.cubit});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with BaseViewMixin<HomeView, HomeCubit, BaseEvent> {
  late final HomeCubit _cubit;
  bool _ownsCubit = false;
  int _currentNavIndex = 0;

  @override
  HomeCubit get cubit => _cubit;

  @override
  void initState() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<HomeCubit>()) {
      _cubit = getIt<HomeCubit>();
      _ownsCubit = false;
    } else {
      _cubit = HomeCubit();
      _ownsCubit = true;
    }
    super.initState();
    _cubit.doEvent(const GetHomeDataEvent());
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  List<RecommendationItemModel> _getTodayFallback(BuildContext context) {
    return [
      RecommendationItemModel(
        title: context.l10n.jogging,
        imageUrl:
            'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=300',
      ),
      RecommendationItemModel(
        title: context.l10n.pushUp,
        imageUrl:
            'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=300',
      ),
      RecommendationItemModel(
        title: context.l10n.squat,
        imageUrl:
            'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=300',
      ),
    ];
  }

  List<RecommendationItemModel> _getMealsFallback(BuildContext context) {
    return [
      RecommendationItemModel(
        title: context.l10n.breakfast,
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=300',
      ),
      RecommendationItemModel(
        title: context.l10n.lunch,
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
      ),
      RecommendationItemModel(
        title: context.l10n.dinner,
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300',
      ),
    ];
  }

  List<PopularTrainingItemModel> _getPopularTrainings(BuildContext context) {
    return [
      PopularTrainingItemModel(
        title: context.l10n.exercisesThatStrengthenYourChest,
        taskCountText: context.l10n.tasksCount(24),
        levelText: context.l10n.beginner,
        levelColor: AppColors.primaryColor,
        imageUrl:
            'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500',
      ),
      PopularTrainingItemModel(
        title: context.l10n.exercisesThatStrengthenYourBack,
        taskCountText: context.l10n.tasksCount(36),
        levelText: context.l10n.intermediate,
        levelColor: const Color(0xFFFF9500),
        imageUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500',
      ),
    ];
  }

  Widget _buildLoadingCards() {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) => Container(
          width: 125,
          height: 145,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        bottomNavigationBar: FloatingBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
        ),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final homeData = state.data;
              final popularTrainings = _getPopularTrainings(context);

              // 1. Recommendation Today data
              final isTodayLoading = homeData?.isRandomMusclesLoading ?? false;
              final todayMuscles = homeData?.randomMuscles ?? [];

              // 2. Upcoming Workouts data
              final muscleGroups = homeData?.muscleGroups ?? [];
              final selectedGroupId = homeData?.selectedMuscleGroupId;
              final selectedGroupIndex = muscleGroups.indexWhere(
                (g) => g.id == selectedGroupId,
              );
              final groupMuscles = homeData?.musclesByGroup ?? [];
              final isGroupMusclesLoading =
                  homeData?.isMusclesByGroupLoading ?? false;

              // 3. Recommendation For You (Meals) data
              final isMealsLoading = homeData?.isMealCategoriesLoading ?? false;
              final mealCategories = homeData?.mealCategories ?? [];

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header Section
                    const HomeHeaderWidget(),
                    const SizedBox(height: 24),

                    // 2. Category Section
                    const CategorySectionWidget(),
                    const SizedBox(height: 24),

                    // 3. Recommendation To Day Section (Random Prime Mover Muscles)
                    SectionHeaderWidget(
                      title: context.l10n.recommendationToday,
                    ),
                    const SizedBox(height: 14),
                    if (isTodayLoading && todayMuscles.isEmpty)
                      _buildLoadingCards()
                    else
                      SizedBox(
                        height: 145,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: todayMuscles.isNotEmpty
                              ? todayMuscles.length
                              : _getTodayFallback(context).length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            if (todayMuscles.isNotEmpty) {
                              final muscle = todayMuscles[index];
                              return RecommendationCardWidget(
                                title: muscle.name,
                                imageUrl: muscle.imageUrl,
                              );
                            }
                            final fallback = _getTodayFallback(context)[index];
                            return RecommendationCardWidget(
                              title: fallback.title,
                              imageUrl: fallback.imageUrl,
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),

                    // 4. Upcoming Workouts Section (Muscle Groups & Group Muscles)
                    UpcomingWorkoutsSection(
                      filterOptions: muscleGroups.isNotEmpty
                          ? muscleGroups.map((g) => g.name).toList()
                          : null,
                      selectedFilterIndex: selectedGroupIndex >= 0
                          ? selectedGroupIndex
                          : 0,
                      isLoadingWorkouts: isGroupMusclesLoading,
                      workouts: groupMuscles.isNotEmpty
                          ? groupMuscles
                                .map(
                                  (m) => WorkoutCardData(
                                    title: m.name,
                                    imageUrl: m.imageUrl,
                                  ),
                                )
                                .toList()
                          : null,
                      onFilterChanged: (index) {
                        if (index >= 0 && index < muscleGroups.length) {
                          _cubit.doEvent(
                            SelectMuscleGroupEvent(muscleGroups[index].id),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // 5. Recommendation For You Section (Meals Categories)
                    SectionHeaderWidget(
                      title: context.l10n.recommendationForYou,
                      actionTitle: context.l10n.seeAll,
                      onActionTap: () {},
                    ),
                    const SizedBox(height: 14),
                    if (isMealsLoading && mealCategories.isEmpty)
                      _buildLoadingCards()
                    else
                      SizedBox(
                        height: 145,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: mealCategories.isNotEmpty
                              ? mealCategories.length
                              : _getMealsFallback(context).length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            if (mealCategories.isNotEmpty) {
                              final meal = mealCategories[index];
                              return RecommendationCardWidget(
                                title: meal.name,
                                imageUrl: meal.thumbnailUrl,
                              );
                            }
                            final fallback = _getMealsFallback(context)[index];
                            return RecommendationCardWidget(
                              title: fallback.title,
                              imageUrl: fallback.imageUrl,
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),

                    // 6. Popular Training Section
                    SectionHeaderWidget(title: context.l10n.popularTraining),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: popularTrainings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final item = popularTrainings[index];
                          return PopularTrainingCardWidget(
                            title: item.title,
                            taskCountText: item.taskCountText,
                            levelText: item.levelText,
                            levelColor: item.levelColor,
                            imageUrl: item.imageUrl,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
