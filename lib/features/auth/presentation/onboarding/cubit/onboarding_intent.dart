import 'package:equatable/equatable.dart';

sealed class OnboardingIntent extends Equatable {
  const OnboardingIntent();

  @override
  List<Object?> get props => [];
}

final class SkipOnboardingIntent extends OnboardingIntent {
  const SkipOnboardingIntent();
}

final class CompleteOnboardingIntent extends OnboardingIntent {
  const CompleteOnboardingIntent();
}

final class PageChangedIntent extends OnboardingIntent {
  final int pageIndex;

  const PageChangedIntent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
