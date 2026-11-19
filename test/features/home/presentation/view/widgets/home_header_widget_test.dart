import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/home_header_widget.dart';

void main() {
  Widget buildWidget({
    String? greeting,
    String? userName,
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
          userName: userName,
          title: title,
          avatarUrl: avatarUrl,
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

    testWidgets('renders dynamic user name when userName is provided', (tester) async {
      await tester.pumpWidget(buildWidget(userName: 'Mohamed'));
      await tester.pump();

      expect(find.text('Hi Mohamed ,'), findsOneWidget);
    });

    testWidgets('renders dynamic user name in Arabic locale', (tester) async {
      await tester.pumpWidget(
        buildWidget(userName: 'هادي', locale: const Locale('ar')),
      );
      await tester.pump();

      expect(find.text('مرحباً هادي ،'), findsOneWidget);
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

    testWidgets('renders default solid avatar asset when avatarUrl is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(avatarUrl: null));
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders network image when avatarUrl is http URL', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(avatarUrl: 'https://example.com/avatar.png'),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate((w) => w is Image && w.image is NetworkImage),
        findsOneWidget,
      );
    });
  });
}
