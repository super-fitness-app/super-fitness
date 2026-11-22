import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';

class CategoryItemData {
  final String label;
  final String imagePath;
  final bool isAsset;

  const CategoryItemData({
    required this.label,
    required this.imagePath,
    this.isAsset = true,
  });
}

class CategorySectionWidget extends StatelessWidget {
  final String? sectionTitle;
  final List<CategoryItemData>? categories;
  final ValueChanged<int>? onCategoryTap;

  const CategorySectionWidget({
    super.key,
    this.sectionTitle,
    this.categories,
    this.onCategoryTap,
  });

  List<CategoryItemData> _getDefaultCategories(BuildContext context) {
    return [
      CategoryItemData(
        label: context.l10n.gym,
        imagePath: 'assets/home/gym.png',
      ),
      CategoryItemData(
        label: context.l10n.fitness,
        imagePath: 'assets/home/fitness.png',
      ),
      CategoryItemData(
        label: context.l10n.yoga,
        imagePath: 'assets/home/yoga.png',
      ),
      CategoryItemData(
        label: context.l10n.aerobics,
        imagePath: 'assets/home/aerobics.png',
      ),
      CategoryItemData(
        label: context.l10n.trainer,
        imagePath: 'assets/home/trainer.png',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = categories ?? _getDefaultCategories(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(title: sectionTitle ?? context.l10n.category),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onCategoryTap?.call(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 52,
                        width: 52,
                        child: item.isAsset
                            ? Image.asset(
                                item.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.fitness_center,
                                      color: AppColors.grey40,
                                      size: 28,
                                    ),
                              )
                            : Image.network(
                                item.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.fitness_center,
                                      color: AppColors.grey40,
                                      size: 28,
                                    ),
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style:
                            context.textTheme.labelMedium?.copyWith(
                              color: AppColors.grey30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ) ??
                            const TextStyle(
                              color: AppColors.grey30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
