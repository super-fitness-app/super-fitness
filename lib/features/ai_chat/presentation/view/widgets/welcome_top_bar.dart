import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_intent.dart';

class WelcomeTopBar extends StatelessWidget {
  final String userName;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;

  const WelcomeTopBar({
    super.key,
    required this.userName,
    this.onBack,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LeadingOrangeCircle(onTap: onBack ?? () => _handleBack(context)),
          Expanded(
            child: _CenterTitles(userName: userName),
          ),
          _TrailingMenuButton(onTap: onMenuTap),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context) {
    try {
      final mainCubit = context.read<MainLayoutCubit>();
      mainCubit.doEvent(const ChangeTabIntent(0));
    } catch (_) {
      Navigator.of(context).maybePop();
    }
  }
}

class _LeadingOrangeCircle extends StatelessWidget {
  final VoidCallback onTap;

  const _LeadingOrangeCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _CenterTitles extends StatelessWidget {
  final String userName;

  const _CenterTitles({required this.userName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.smartCoachGreeting(userName),
          style: AppTextStyles.bold16.copyWith(
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          l10n.smartCoachSubtitle,
          style: AppTextStyles.medium18.copyWith(
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TrailingMenuButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _TrailingMenuButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
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
