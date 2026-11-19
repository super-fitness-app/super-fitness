import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/home_header_widget.dart';

void main() {
  Widget buildWidget({
    String? greeting,
    String? title,
    String? avatarUrl,
    VoidCallback? onAvatarTap,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: HomeHeaderWidget(
          greeting: greeting,
          title: title,
          avatarUrl: avatarUrl ??
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          onAvatarTap: onAvatarTap,
        ),
      ),
    );
  }

  group('HomeHeaderWidget Tests', () {
    testWidgets('renders default localized greeting and title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Hi Ahmed ,'), findsOneWidget);
      expect(find.text("Let's Start Your Day"), findsOneWidget);
    });

    testWidgets('renders custom greeting and title', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          greeting: 'Welcome back, Sarah',
          title: 'Ready for today’s workout?',
        ),
      );
      await tester.pump();

      expect(find.text('Welcome back, Sarah'), findsOneWidget);
      expect(find.text('Ready for today’s workout?'), findsOneWidget);
    });

    testWidgets('tapping avatar triggers onAvatarTap callback', (tester) async {
      bool avatarTapped = false;

      await tester.pumpWidget(
        buildWidget(
          onAvatarTap: () {
            avatarTapped = true;
          },
        ),
      );
      await tester.pump();

      final avatarFinder = find.byType(GestureDetector);
      expect(avatarFinder, findsOneWidget);

      await tester.tap(avatarFinder);
      await tester.pump();

      expect(avatarTapped, isTrue);
    });
  });
}
