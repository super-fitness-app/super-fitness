import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class ProfileSettingsCard extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangePassword;
  final ValueChanged<bool>? onLanguageChanged;
  final VoidCallback? onSecurity;
  final VoidCallback? onPrivacyPolicy;
  final VoidCallback? onHelp;
  final VoidCallback? onLogout;

  const ProfileSettingsCard({
    super.key,
    this.onEditProfile,
    this.onChangePassword,
    this.onLanguageChanged,
    this.onSecurity,
    this.onPrivacyPolicy,
    this.onHelp,
    this.onLogout,
  });

  static const Color _accentColor = AppColors.orangeShade900;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.grey90,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRow(
                icon: Icons.person_outline_rounded,
                title: localization.editProfile,
                onTap: onEditProfile,
              ),

              _buildDivider(),

              _buildRow(
                icon: Icons.autorenew_rounded,
                title: localization.changePassword,
                onTap: onChangePassword,
              ),

              _buildDivider(),

              _buildLanguageRow(
                localization: localization,
                isEnglish: isEnglish,
              ),

              _buildDivider(),

              _buildRow(
                icon: Icons.settings_suggest_outlined,
                title: localization.security,
                onTap: onSecurity,
              ),

              _buildDivider(),

              _buildRow(
                icon: Icons.gpp_maybe_outlined,
                title: localization.privacyPolicy,
                onTap: onPrivacyPolicy,
              ),

              _buildDivider(),

              _buildRow(
                icon: Icons.support_rounded,
                title: localization.help,
                onTap: onHelp,
              ),

              _buildDivider(),

              _buildRow(
                icon: Icons.logout_rounded,
                title: localization.logout,
                isLogout: true,
                onTap: onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.white.withValues(alpha: 0.05),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: _accentColor.withValues(alpha: 0.1),
        highlightColor: AppColors.white.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: _accentColor, size: 21),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isLogout
                        ? _accentColor
                        : AppColors.white.withValues(alpha: 0.92),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: _accentColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageRow({
    required AppLocalizations localization,
    required bool isEnglish,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          const Icon(Icons.language_rounded, color: _accentColor, size: 21),

          const SizedBox(width: 16),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withValues(alpha: 0.92),
                  letterSpacing: 0.2,
                ),
                children: [
                  TextSpan(text: localization.selectLanguage),
                  TextSpan(
                    text: isEnglish
                        ? localization.english
                        : localization.arabic,
                    style: const TextStyle(color: _accentColor),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              onLanguageChanged?.call(!isEnglish);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: 48,
              height: 26,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isEnglish ? _accentColor : AppColors.grey60,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: isEnglish
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
