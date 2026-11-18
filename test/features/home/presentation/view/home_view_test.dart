import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/category_section_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/floating_bottom_nav_bar.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/home_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/popular_training_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/recommendation_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/upcoming_workouts_section.dart';

void main() {
  Widget buildTestWidget({Locale locale = const Locale('en')}) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const HomeView(showBottomNavBar: true),
    );
  }

  group('HomeView & Custom Modular Widgets Tests', () {
    testWidgets('renders HomeView with all required sections and widgets', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(HomeHeaderWidget), findsOneWidget);
      expect(find.byType(CategorySectionWidget), findsOneWidget);
      expect(find.byType(UpcomingWorkoutsSection), findsOneWidget);
      expect(find.byType(FloatingBottomNavBar), findsOneWidget);
      expect(find.byType(SectionHeaderWidget), findsWidgets);
      expect(find.byType(RecommendationCardWidget), findsWidgets);
      expect(find.byType(PopularTrainingCardWidget), findsWidgets);
    });

    testWidgets('renders localized Arabic texts when locale is ar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget(locale: const Locale('ar')));
      await tester.pump();

      expect(find.text('لنبدأ يومك'), findsOneWidget);
      expect(find.text('الفئات'), findsOneWidget);
      expect(find.text('توصيات اليوم'), findsOneWidget);
      expect(find.text('التمارين القادمة'), findsOneWidget);
      expect(find.text('موصى به لك'), findsOneWidget);
      expect(find.text('التدريبات الشائعة'), findsOneWidget);
    });
  });
}
