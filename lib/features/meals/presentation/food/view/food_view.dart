import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_category_filter.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_category_shimmer.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_grid_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_header_section.dart';

class FoodView extends StatefulWidget {
  final FoodCubit? cubit;
  const FoodView({super.key, this.cubit});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView>
    with BaseViewMixin<FoodView, FoodCubit, BaseEvent> {
  late final FoodCubit _cubit;
  bool _ownsCubit = false;

  @override
  FoodCubit get cubit => _cubit;

  @override
  void initState() {
    _initCubit();
    super.initState();
    _cubit.doEvent(const LoadFoodDataEvent());
  }

  void _initCubit() {
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else if (getIt.isRegistered<FoodCubit>()) {
      _cubit = getIt<FoodCubit>();
      _ownsCubit = false;
    } else {
      _cubit = context.read<FoodCubit>();
      _ownsCubit = false;
    }
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _cubit.doEvent(const RefreshFoodEvent());
  }

  void _onCategorySelected(String categoryName) {
    _cubit.doEvent(SelectCategoryEvent(categoryName));
  }

  void _onMealTapped(MealEntity meal) {
    _cubit.doEvent(MealClickedEvent(meal));
  }

  void _onLoadMore() {
    _cubit.doEvent(const LoadMoreMealsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _FoodBackgroundLayer(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FoodHeaderSection(),
                  _CategorySection(onCategorySelected: _onCategorySelected),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onRefresh: _onRefresh,
                      child: _MealsSection(
                        onMealTapped: _onMealTapped,
                        onRetry: () => _cubit.doEvent(const LoadFoodDataEvent()),
                        onLoadMore: _onLoadMore,
                      ),
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

class _FoodBackgroundLayer extends StatelessWidget {
  const _FoodBackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.food,
          fit: BoxFit.cover,
        ),
        ColoredBox(
          color: AppColors.background.withValues(alpha: 0.75),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final ValueChanged<String> onCategorySelected;

  const _CategorySection({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.selectedCategory != current.selectedCategory ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const FoodCategoryShimmer();
        }
        return FoodCategoryFilter(
          categories: state.categories,
          selectedCategory: state.selectedCategory,
          onCategorySelected: onCategorySelected,
        );
      },
    );
  }
}

class _MealsSection extends StatelessWidget {
  final ValueChanged<MealEntity> onMealTapped;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;

  const _MealsSection({
    required this.onMealTapped,
    required this.onRetry,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        return FoodGridView(
          isLoading: state.isLoading,
          isLoadingMore: state.isLoadingMore,
          failure: state.failure,
          meals: state.displayedMeals,
          onMealTapped: onMealTapped,
          onRetry: onRetry,
          onLoadMore: onLoadMore,
        );
      },
    );
  }
}


