import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/category_section_widget.dart';

void main() {
  Widget buildWidget({
    String? sectionTitle,
    List<CategoryItemData>? categories,
    ValueChanged<int>? onCategoryTap,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: CategorySectionWidget(
          sectionTitle: sectionTitle,
          categories: categories,
          onCategoryTap: onCategoryTap,
        ),
      ),
    );
  }

  group('CategorySectionWidget Tests', () {
    testWidgets('renders default title and 5 default category items', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Gym'), findsOneWidget);
      expect(find.text('Fitness'), findsOneWidget);
      expect(find.text('Yoga'), findsOneWidget);
      expect(find.text('Aerobics'), findsOneWidget);
      expect(find.text('Trainer'), findsOneWidget);
    });

    testWidgets('renders custom title and custom category items', (
      tester,
    ) async {
      const customItems = [
        CategoryItemData(
          label: 'Pilates',
          imagePath: 'assets/home/fitness.png',
        ),
        CategoryItemData(
          label: 'Cardio',
          imagePath: 'https://example.com/cardio.png',
          isAsset: false,
        ),
      ];

      await tester.pumpWidget(
        buildWidget(
          sectionTitle: 'Special Categories',
          categories: customItems,
        ),
      );
      await tester.pump();

      expect(find.text('Special Categories'), findsOneWidget);
      expect(find.text('Pilates'), findsOneWidget);
      expect(find.text('Cardio'), findsOneWidget);
    });

    testWidgets('triggers onCategoryTap when a category item is tapped', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildWidget(
          onCategoryTap: (index) {
            tappedIndex = index;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Yoga'));
      await tester.pump();

      expect(tappedIndex, 2);
    });
  });
}
