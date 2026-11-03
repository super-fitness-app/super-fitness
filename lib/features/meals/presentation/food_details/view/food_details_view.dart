import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_error_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_header.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_info_section.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_ingredients_section.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_macro_pills.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_shimmer.dart';

class FoodDetailsView extends StatefulWidget {
  final FoodDetailsCubit? cubit;
  final String? mealId;

  const FoodDetailsView({
    super.key,
    this.cubit,
    this.mealId,
  });

  @override
  State<FoodDetailsView> createState() => _FoodDetailsViewState();
}

class _FoodDetailsViewState extends State<FoodDetailsView>
    with BaseViewMixin<FoodDetailsView, FoodDetailsCubit, BaseEvent> {
  late final FoodDetailsCubit _cubit;

  @override
  FoodDetailsCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? context.read<FoodDetailsCubit>();
    super.initState();
  }

  void _onRetry() {
    final id = widget.mealId ?? _cubit.state.data?.id;
    if (id != null && id.isNotEmpty) {
      _cubit.doEvent(LoadMealDetailsEvent(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _FoodDetailsBackgroundLayer(),
          BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const FoodDetailsShimmer();
              }
              if (state.failure != null && state.data == null) {
                return FoodDetailsErrorView(
                  failure: state.failure,
                  onRetry: _onRetry,
                );
              }
              if (state.data != null) {
                return _FoodDetailsContent(meal: state.data!);
              }
              return const FoodDetailsShimmer();
            },
          ),
        ],
      ),
    );
  }
}

class _FoodDetailsBackgroundLayer extends StatelessWidget {
  const _FoodDetailsBackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.food,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppDimensions.blurRadius8,
            sigmaY: AppDimensions.blurRadius8,
          ),
          child: ColoredBox(
            color: Colors.black.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _FoodDetailsContent extends StatelessWidget {
  final MealDetailsEntity meal;

  const _FoodDetailsContent({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoodDetailsHeader(
            imageUrl: meal.imageUrl,
            youtubeUrl: meal.youtubeUrl,
            title: meal.name ?? '',
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
            padding: const EdgeInsets.all(
              AppDimensions.defaultScreenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FoodDetailsInfoSection(
                  title: meal.name ?? '',
                  instructions: meal.instructions,
                ),
                const SizedBox(height: 20),
                FoodDetailsMacroPills(
                  energy: meal.energy,
                  protein: meal.protein,
                  carbs: meal.carbs,
                  fat: meal.fat,
                ),
                const SizedBox(height: 28),
                FoodDetailsIngredientsSection(
                  ingredients: meal.ingredients,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
