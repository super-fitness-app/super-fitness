import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_category_item.dart';

class FoodCategoryFilter extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const FoodCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  List<String> get _categoryNames {
    return categories
        .map((c) => c.name ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final names = _categoryNames;
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.only(
          start: AppDimensions.defaultScreenPadding,
          end: AppDimensions.defaultScreenPadding,
          bottom: AppDimensions.categoryBottomPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: names.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppDimensions.categorySpacing),
        itemBuilder: (context, index) => FoodCategoryItem(
          categoryName: names[index],
          isSelected: names[index] == selectedCategory,
          onTap: () => onCategorySelected(names[index]),
        ),
      ),
    );
  }
}
