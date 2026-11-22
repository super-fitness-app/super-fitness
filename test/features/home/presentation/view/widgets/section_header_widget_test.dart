import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';

void main() {
  Widget buildWidget({
    required String title,
    String? actionTitle,
    VoidCallback? onActionTap,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: SectionHeaderWidget(
          title: title,
          actionTitle: actionTitle,
          onActionTap: onActionTap,
        ),
      ),
    );
  }

  group('SectionHeaderWidget Tests', () {
    testWidgets(
      'renders title and does not show action when onActionTap is null',
      (tester) async {
        await tester.pumpWidget(buildWidget(title: 'Top Exercises'));
        await tester.pump();

        expect(find.text('Top Exercises'), findsOneWidget);
        expect(find.text('See All'), findsNothing);
      },
    );

    testWidgets(
      'shows localized "See All" when onActionTap is provided without custom actionTitle',
      (tester) async {
        bool actionTapped = false;

        await tester.pumpWidget(
          buildWidget(
            title: 'Upcoming Workouts',
            onActionTap: () {
              actionTapped = true;
            },
          ),
        );
        await tester.pump();

        expect(find.text('Upcoming Workouts'), findsOneWidget);
        expect(find.text('See All'), findsOneWidget);

        await tester.tap(find.text('See All'));
        await tester.pump();

        expect(actionTapped, isTrue);
      },
    );

    testWidgets('renders custom actionTitle and triggers callback on tap', (
      tester,
    ) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        buildWidget(
          title: 'Special Diets',
          actionTitle: 'View More',
          onActionTap: () {
            actionTapped = true;
          },
        ),
      );
      await tester.pump();

      expect(find.text('View More'), findsOneWidget);

      await tester.tap(find.text('View More'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });
  });
}
