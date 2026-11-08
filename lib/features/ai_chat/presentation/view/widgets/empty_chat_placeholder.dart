import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class EmptyChatPlaceholder extends StatelessWidget {
  final ValueChanged<String> onPromptTap;

  const EmptyChatPlaceholder({
    super.key,
    required this.onPromptTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _RobotAvatarGlow(),
            const SizedBox(height: 16),
            const _PlaceholderHeader(),
            const SizedBox(height: 24),
            _PromptSuggestionsList(onPromptTap: onPromptTap),
          ],
        ),
      ),
    );
  }
}

class _RobotAvatarGlow extends StatelessWidget {
  const _RobotAvatarGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          AppImages.robot,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.smart_toy_rounded,
            size: 42,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _PlaceholderHeader extends StatelessWidget {
  const _PlaceholderHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.smartCoachEmptyTitle,
          style: AppTextStyles.bold20.copyWith(
            fontSize: 18,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.smartCoachEmptySubtitle,
          style: AppTextStyles.regular13.copyWith(
            color: Colors.white60,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PromptSuggestionsList extends StatelessWidget {
  final ValueChanged<String> onPromptTap;

  const _PromptSuggestionsList({required this.onPromptTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suggestions = [
      l10n.smartCoachPromptWorkout,
      l10n.smartCoachPromptNutrition,
      l10n.smartCoachPromptForm,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: suggestions.map((prompt) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 10),
          child: _PromptChip(
            prompt: prompt,
            onTap: () => onPromptTap(prompt),
          ),
        );
      }).toList(),
    );
  }
}

class _PromptChip extends StatelessWidget {
  final String prompt;
  final VoidCallback onTap;

  const _PromptChip({
    required this.prompt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white12,
            width: 0.8,
          ),
        ),
        child: Text(
          prompt,
          style: AppTextStyles.regular13.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
