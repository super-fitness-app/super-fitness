import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? greeting;
  final String? title;
  final String avatarUrl;
  final VoidCallback? onAvatarTap;

  const HomeHeaderWidget({
    super.key,
    this.greeting,
    this.title,
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting ?? context.l10n.hiAhmed,
                style:
                    context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey30,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ) ??
                    const TextStyle(
                      color: AppColors.grey30,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title ?? context.l10n.letsStartYourDay,
                style:
                    context.textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ) ??
                    const TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onAvatarTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.grey80, width: 1.5),
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.grey40,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
