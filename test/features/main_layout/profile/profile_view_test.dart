import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/session/user_profile_notifier.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/main_layout/profile/profile_view.dart';

void main() {
  setUp(() {
    UserProfileNotifier.clear();
  });

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
    testWidgets('renders ProfileView with avatar and Change Photo button', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Change Photo'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('changing photo updates UserProfileNotifier', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(UserProfileNotifier.userPhoto.value, isNull);

      // Tap Change Photo to open bottom sheet
      await tester.tap(find.text('Change Photo'));
      await tester.pump();

      expect(find.text('Change Profile Photo'), findsOneWidget);

      await UserProfileNotifier.updatePhoto('https://test-photo.png');
      await tester.pump();

      expect(UserProfileNotifier.userPhoto.value, 'https://test-photo.png');
    });
  });
}
