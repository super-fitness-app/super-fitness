import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppTheme Unit & Widget Tests', () {
    test('darkTheme has expected core configurations', () {
      final theme = AppTheme.darkTheme;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('darkTheme configures component themes properly', () {
      final theme = AppTheme.darkTheme;

      expect(theme.appBarTheme.backgroundColor, AppColors.background);
      expect(theme.appBarTheme.centerTitle, isTrue);
      expect(theme.appBarTheme.elevation, 0);

      expect(theme.cardTheme.color, AppColors.surface);
      expect(theme.cardTheme.elevation, 0);

      expect(theme.chipTheme.backgroundColor, AppColors.surface);
      expect(theme.chipTheme.selectedColor, AppColors.primary);

      expect(
        theme.bottomNavigationBarTheme.selectedItemColor,
        AppColors.primary,
      );
      expect(
        theme.bottomNavigationBarTheme.unselectedItemColor,
        AppColors.grey40,
      );

      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(theme.inputDecorationTheme.fillColor, Colors.transparent);
      expect(theme.inputDecorationTheme.isDense, isTrue);
    });

    testWidgets('darkTheme applies styles to MaterialApp widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Title')),
            body: const Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text('Button'),
              ),
            ),
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final theme = Theme.of(tester.element(find.byType(Scaffold)));

      expect(scaffold.backgroundColor, isNull);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.brightness, Brightness.dark);
    });
  });
}
