import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_icons.dart';
import 'package:super_fitness/features/main_layout/body_layout/view/widgets/nav_bar_item_widget.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimensions.bottomNavBarHorizontalMargin,
          ),
          child: ConstrainedBox(
            key: const Key(AppConstants.floatingNavBarConstrainedBoxKey),
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.bottomNavBarMaxWidth,
            ),
            child: Container(
              height: AppDimensions.bottomNavBarHeight,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  AppDimensions.bottomNavBarRadius,
                ),
                border: Border.all(color: AppColors.surfaceVariant, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.overlay,
                    blurRadius: AppDimensions.bottomNavBarElevation,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  NavBarItemWidget(
                    iconPath: AppIcons.explore,
                    label: l10n.explore,
                    isSelected: currentIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  NavBarItemWidget(
                    iconPath: AppIcons.smartCoach,
                    label: l10n.smartCoach,
                    isSelected: currentIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                  NavBarItemWidget(
                    iconPath: AppIcons.workout,
                    label: l10n.workouts,
                    isSelected: currentIndex == 2,
                    onTap: () => onTabSelected(2),
                  ),
                  NavBarItemWidget(
                    iconPath: AppIcons.profile,
                    label: l10n.profile,
                    isSelected: currentIndex == 3,
                    onTap: () => onTabSelected(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
