import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class DeleteChatConfirmationDialog extends StatelessWidget {
  const DeleteChatConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12, width: 0.8),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WarningIcon(),
            SizedBox(height: 16),
            _DialogTitle(),
            SizedBox(height: 8),
            _DialogContent(),
            SizedBox(height: 24),
            _DialogActions(),
          ],
        ),
      ),
    );
  }
}

class _WarningIcon extends StatelessWidget {
  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent.withValues(alpha: 0.1),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.delete_forever_rounded,
        color: Colors.redAccent,
        size: 36,
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Text(
      l10n.smartCoachDeleteChatTitle,
      style: AppTextStyles.bold20.copyWith(
        fontSize: 17,
        color: AppColors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Text(
      l10n.smartCoachDeleteChatConfirm,
      style: AppTextStyles.regular13.copyWith(
        color: Colors.white70,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.smartCoachCancel,
              style: AppTextStyles.regular14.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
              shape: const StadiumBorder(),
            ),
            child: Text(
              l10n.smartCoachDelete,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
