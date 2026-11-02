import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_card.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_empty_meals_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_error_meals_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_shimmer_loading.dart';

class FoodGridView extends StatefulWidget {
  final bool isLoading;
  final bool isLoadingMore;
  final AppFailure? failure;
  final List<MealEntity> meals;
  final ValueChanged<MealEntity> onMealTapped;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ScrollController? scrollController;

  const FoodGridView({
    super.key,
    required this.isLoading,
    this.isLoadingMore = false,
    required this.failure,
    required this.meals,
    required this.onMealTapped,
    required this.onRetry,
    required this.onLoadMore,
    this.scrollController,
  });

  @override
  State<FoodGridView> createState() => _FoodGridViewState();
}

class _FoodGridViewState extends State<FoodGridView> {
  late final ScrollController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _controller = widget.scrollController!;
      _ownsController = false;
    } else {
      _controller = ScrollController();
      _ownsController = true;
    }
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.hasClients &&
        _controller.position.pixels >=
            _controller.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const FoodShimmerLoading();
    }
    if (widget.failure != null && widget.meals.isEmpty) {
      return FoodErrorMealsView(
          failure: widget.failure!, onRetry: widget.onRetry);
    }
    if (widget.meals.isEmpty) {
      return const FoodEmptyMealsView();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: _MealsGrid(
        controller: _controller,
        meals: widget.meals,
        isLoadingMore: widget.isLoadingMore,
        onMealTapped: widget.onMealTapped,
      ),
    );
  }
}

class _MealsGrid extends StatelessWidget {
  final ScrollController controller;
  final List<MealEntity> meals;
  final bool isLoadingMore;
  final ValueChanged<MealEntity> onMealTapped;

  const _MealsGrid({
    required this.controller,
    required this.meals,
    required this.isLoadingMore,
    required this.onMealTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.gridSpacing,
              mainAxisSpacing: AppDimensions.gridSpacing,
              childAspectRatio: AppDimensions.cardAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => FoodCard(
                meal: meals[index],
                onTap: () => onMealTapped(meals[index]),
              ),
              childCount: meals.length,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(child: _BottomLoader()),
      ],
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EdgeInsets.symmetric(vertical: AppDimensions.defaultScreenPadding),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}


