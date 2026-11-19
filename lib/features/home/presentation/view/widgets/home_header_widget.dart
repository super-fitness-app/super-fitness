import 'dart:io';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? greeting;
  final String? title;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const HomeHeaderWidget({
    super.key,
    this.greeting,
    this.title,
    this.avatarUrl,
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
              child: _buildAvatar(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl == null || avatarUrl!.trim().isEmpty) {
      return Image.asset(
        AppImages.defaultAvatar,
        fit: BoxFit.cover,
        width: 48,
        height: 48,
      );
    }

    final url = avatarUrl!.trim();
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 48,
          height: 48,
        ),
      );
    } else if (url.startsWith('/') || url.startsWith('file://')) {
      final path = url.startsWith('file://')
          ? url.replaceFirst('file://', '')
          : url;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 48,
          height: 48,
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 48,
          height: 48,
        ),
      );
    }
  }
}
