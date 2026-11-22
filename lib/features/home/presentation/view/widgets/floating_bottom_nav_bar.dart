import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E22),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_rounded,
              label: context.l10n.explore,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavBarItem(
              icon: Icons.track_changes_rounded,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavBarItem(
              icon: Icons.fitness_center_rounded,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavBarItem(
              icon: Icons.person_outline_rounded,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color(0xFF8E8E93),
            ),
            if (isSelected && label != null) ...[
              const SizedBox(height: 3),
              Text(
                label!,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
