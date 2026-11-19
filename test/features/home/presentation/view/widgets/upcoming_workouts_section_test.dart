import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/upcoming_workouts_section.dart';

void main() {
  Widget buildWidget({
    VoidCallback? onSeeAllTap,
    List<String>? filterOptions,
    List<WorkoutCardData>? workouts,
    int? selectedFilterIndex,
    bool isLoadingWorkouts = false,
    ValueChanged<int>? onFilterChanged,
    ValueChanged<WorkoutCardData>? onWorkoutTap,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: SingleChildScrollView(
          child: UpcomingWorkoutsSection(
            onSeeAllTap: onSeeAllTap,
            filterOptions: filterOptions,
            workouts: workouts,
            selectedFilterIndex: selectedFilterIndex,
            isLoadingWorkouts: isLoadingWorkouts,
            onFilterChanged: onFilterChanged,
            onWorkoutTap: onWorkoutTap,
          ),
        ),
      ),
    );
  }

  group('UpcomingWorkoutsSection Tests', () {
    testWidgets('renders section header, filter chips, and default workout items', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Upcoming Workouts'), findsOneWidget);
      expect(find.text('Full Body'), findsOneWidget);
      expect(find.text('Chest'), findsWidgets);
      expect(find.text('Arm'), findsOneWidget);
    });

    testWidgets('triggers onSeeAllTap when "See All" is tapped', (tester) async {
      bool seeAllTapped = false;

      await tester.pumpWidget(
        buildWidget(
          onSeeAllTap: () {
            seeAllTapped = true;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.text('See All'));
      await tester.pump();

      expect(seeAllTapped, isTrue);
    });

    testWidgets('triggers onFilterChanged when a filter option is tapped', (
      tester,
    ) async {
      int? selectedIndex;

      await tester.pumpWidget(
        buildWidget(
          filterOptions: ['All', 'Upper', 'Lower'],
          onFilterChanged: (index) {
            selectedIndex = index;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Lower'));
      await tester.pump();

      expect(selectedIndex, 2);
    });

    testWidgets('triggers onWorkoutTap when a workout card is tapped', (
      tester,
    ) async {
      WorkoutCardData? tappedWorkout;
      const customWorkouts = [
        WorkoutCardData(
          title: 'Heavy Bench',
          imageUrl: 'https://example.com/bench.png',
        ),
      ];

      await tester.pumpWidget(
        buildWidget(
          workouts: customWorkouts,
          onWorkoutTap: (workout) {
            tappedWorkout = workout;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Heavy Bench'));
      await tester.pump();

      expect(tappedWorkout, isNotNull);
      expect(tappedWorkout?.title, 'Heavy Bench');
    });

    testWidgets('shows loading cards when isLoadingWorkouts is true and workouts is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          isLoadingWorkouts: true,
          workouts: [],
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });
}
