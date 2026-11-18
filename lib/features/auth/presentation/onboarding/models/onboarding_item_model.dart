import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';

class OnboardingItemModel extends Equatable {
  final String image;
  final String Function(AppLocalizations l10n) titleBuilder;
  final String Function(AppLocalizations l10n) subtitleBuilder;

  const OnboardingItemModel({
    required this.image,
    required this.titleBuilder,
    required this.subtitleBuilder,
  });

  String getTitle(AppLocalizations l10n) => titleBuilder(l10n);

  String getSubtitle(AppLocalizations l10n) => subtitleBuilder(l10n);

  @override
  List<Object?> get props => [image];
}
