import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/coach_avatar_widget.dart';

class ChatTopBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClearChat;
  final VoidCallback? onMenuTap;

  const ChatTopBar({super.key, this.onBack, this.onClearChat, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoachAvatarWidget(size: 32),
              const SizedBox(width: 8),
              Text(
                l10n.smartCoach,
                style: AppTextStyles.bold20.copyWith(color: AppColors.white),
              ),
            ],
          ),
          if (onMenuTap != null)
            _TrailingMenuButton(onTap: onMenuTap!)
          else
            _MoreActionMenu(onClearChat: onClearChat),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}

class _TrailingMenuButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TrailingMenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        child: const Icon(
          Icons.menu_rounded,
          color: AppColors.primary,
          size: 28,
        ),
      ),
    );
  }
}

class _MoreActionMenu extends StatelessWidget {
  final VoidCallback? onClearChat;

  const _MoreActionMenu({this.onClearChat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu_rounded, color: AppColors.primary, size: 26),
      color: AppColors.surface,
      onSelected: (val) {
        if (val == 'clear' && onClearChat != null) {
          onClearChat!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.smartCoachClearChat,
                style: AppTextStyles.regular14.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
