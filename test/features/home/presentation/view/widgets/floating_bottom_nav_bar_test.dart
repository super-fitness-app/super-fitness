import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/floating_bottom_nav_bar.dart';

void main() {
  Widget buildWidget({
    required int currentIndex,
    required ValueChanged<int> onTap,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        bottomNavigationBar: FloatingBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  group('FloatingBottomNavBar Tests', () {
    testWidgets('renders all navigation items and highlights current index', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          currentIndex: 0,
          onTap: (_) {},
        ),
      );
      await tester.pump();

      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.track_changes_rounded), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('triggers onTap callback when a navigation item is tapped', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildWidget(
          currentIndex: 0,
          onTap: (index) {
            tappedIndex = index;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.fitness_center_rounded));
      await tester.pump();

      expect(tappedIndex, 2);
    });
  });
}
