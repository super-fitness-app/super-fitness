import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class AlreadyHaveAccountRow extends StatefulWidget {
  final VoidCallback onLoginTap;

  const AlreadyHaveAccountRow({super.key, required this.onLoginTap});

  @override
  State<AlreadyHaveAccountRow> createState() => _AlreadyHaveAccountRowState();
}

class _AlreadyHaveAccountRowState extends State<AlreadyHaveAccountRow> {
  late final TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = _onTap;
  }

  void _onTap() {
    widget.onLoginTap();
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: RichText(
        text: TextSpan(
          text: l10n.alreadyHaveAnAccount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: l10n.login,
              style: const TextStyle(
                color: AppColors.orangeBase,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.orangeBase,
              ),
              recognizer: _tapRecognizer,
            ),
          ],
        ),
      ),
    );
  }
}
