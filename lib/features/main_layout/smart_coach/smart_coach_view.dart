import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class SmartCoachView extends StatelessWidget {
  const SmartCoachView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(l10n.smartCoach, style: AppTextStyles.headline24),
    );
  }
}
