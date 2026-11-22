import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/main_layout/profile/profile_view.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const ProfileView(),
    );
  }

  group('ProfileView Tests', () {
    testWidgets('renders ProfileView with profile title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
