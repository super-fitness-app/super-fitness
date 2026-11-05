import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';

class FoodDetailsIngredientsSection extends StatelessWidget {
  final List<MealIngredientEntity> ingredients;

  const FoodDetailsIngredientsSection({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.ingredients),
        const SizedBox(height: AppDimensions.spacing8),
        if (ingredients.isEmpty)
          _EmptyIngredients(message: l10n.noIngredientsAvailable)
        else
          _IngredientsList(ingredients: ingredients),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bold20,
      textAlign: TextAlign.start,
    );
  }
}

class _EmptyIngredients extends StatelessWidget {
  final String message;

  const _EmptyIngredients({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTextStyles.regular13.copyWith(color: AppColors.grey30),
      textAlign: TextAlign.start,
    );
  }
}

class _IngredientsList extends StatelessWidget {
  final List<MealIngredientEntity> ingredients;

  const _IngredientsList({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius / 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ingredients.length,
        separatorBuilder: (_, _) => const Divider(
          color: AppColors.divider,
          height: 16,
          thickness: 0.8,
        ),
        itemBuilder: (context, index) => _IngredientRow(
          ingredient: ingredients[index],
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final MealIngredientEntity ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              ingredient.name,
              style: AppTextStyles.medium16,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          if (ingredient.measure != null &&
              ingredient.measure!.trim().isNotEmpty) ...[
            const SizedBox(width: 12),
            Text(
              ingredient.measure!.trim(),
              style: AppTextStyles.medium14.copyWith(color: AppColors.primary),
              textAlign: TextAlign.end,
            ),
          ],
        ],
      ),
    );
  }
}
