import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class NavBarItemWidget extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItemWidget({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: isSelected
              ? Column(
                  key: const ValueKey(true),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      color: AppColors.primary,
                      colorBlendMode: BlendMode.srcIn,
                      width: AppDimensions.defaultIconSize,
                      height: AppDimensions.defaultIconSize,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          style: AppTextStyles.bottomNavSelected,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  key: const ValueKey(false),
                  child: Image.asset(
                    iconPath,
                    color: AppColors.grey30,
                    colorBlendMode: BlendMode.srcIn,
                    width: AppDimensions.defaultIconSize,
                    height: AppDimensions.defaultIconSize,
                  ),
                ),
        ),
      ),
    );
  }
}
