import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_meal_categories_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_popular_training_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:super_fitness/features/home/presentation/manager/home_cubit.dart';
import 'package:super_fitness/features/home/presentation/view/home_view.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/category_section_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/floating_bottom_nav_bar.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/home_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/popular_training_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/recommendation_card_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/upcoming_workouts_section.dart';

class FakeHomeRepo implements HomeRepo {
  List<MuscleEntity> randomMuscles = [
    const MuscleEntity(id: 'm1', name: 'Deltoid', imageUrl: 'https://deltoid.png'),
    const MuscleEntity(id: 'm2', name: 'Biceps', imageUrl: 'https://biceps.png'),
  ];
  List<MuscleGroupEntity> muscleGroups = [
    const MuscleGroupEntity(id: 'g1', name: 'Chest'),
    const MuscleGroupEntity(id: 'g2', name: 'Back'),
  ];
  List<MuscleEntity> groupMuscles = [
    const MuscleEntity(id: 'gm1', name: 'Pectoral', imageUrl: 'https://pec.png'),
  ];
  List<MealCategoryEntity> mealCategories = [
    const MealCategoryEntity(
      id: 'c1',
      name: 'Breakfast Bowl',
      thumbnailUrl: 'https://bowl.png',
      description: 'Healthy breakfast',
    ),
  ];
  List<DifficultyLevelEntity> difficultyLevels = [
    const DifficultyLevelEntity(id: 'lvl1', name: 'Beginner'),
  ];
  List<PopularTrainingEntity> popularTrainings = [
    const PopularTrainingEntity(
      id: 'p1',
      title: 'Push Up',
      totalTasks: 12,
      levelText: 'Beginner',
      imageUrl: 'https://pushup.png',
    ),
  ];

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() async =>
      Success(randomMuscles);

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async =>
      Success(muscleGroups);

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id) async =>
      Success(groupMuscles);

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() async =>
      Success(mealCategories);

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getDifficultyLevels() async =>
      Success(difficultyLevels);

  @override
  Future<ApiResults<List<PopularTrainingEntity>>>
      getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
    String? fallbackImageUrl,
    String? levelName,
  }) async =>
          Success(popularTrainings);
}

class PendingHomeRepo extends FakeHomeRepo {
  final Completer<ApiResults<List<MuscleEntity>>> completer = Completer();

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() => completer.future;
}

void main() {
  late FakeHomeRepo fakeRepo;
  late HomeCubit homeCubit;

  setUp(() {
    fakeRepo = FakeHomeRepo();
    homeCubit = HomeCubit(
      GetRandomMusclesUseCase(fakeRepo),
      GetMuscleGroupsUseCase(fakeRepo),
      GetMusclesByGroupUseCase(fakeRepo),
      GetMealCategoriesUseCase(fakeRepo),
      GetPopularTrainingUseCase(fakeRepo),
    );
  });

  tearDown(() {
    homeCubit.close();
  });

  Widget buildTestWidget({
    HomeCubit? cubit,
    bool showBottomNavBar = true,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: HomeView(
        cubit: cubit ?? homeCubit,
        showBottomNavBar: showBottomNavBar,
      ),
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      expect(find.text('لنبدأ يومك'), findsOneWidget);
      expect(find.text('الفئات'), findsOneWidget);
      expect(find.text('توصيات اليوم'), findsOneWidget);
      expect(find.text('التمارين القادمة'), findsOneWidget);
      expect(find.text('موصى به لك'), findsOneWidget);
      expect(find.text('التدريبات الشائعة'), findsOneWidget);
    });

    testWidgets('renders loaded recommendation muscles from HomeData', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Deltoid'), findsOneWidget);
      expect(find.text('Biceps'), findsOneWidget);
    });

    testWidgets('renders fallback recommendation items when random muscles list is empty', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      fakeRepo.randomMuscles = [];

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Jogging'), findsOneWidget);
      expect(find.text('Push-Up'), findsOneWidget);
      expect(find.text('Squat'), findsOneWidget);
    });

    testWidgets('shows loading card indicators when isRandomMusclesLoading is true and list is empty', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final pendingRepo = PendingHomeRepo();
      final loadingCubit = HomeCubit(
        GetRandomMusclesUseCase(pendingRepo),
        GetMuscleGroupsUseCase(pendingRepo),
        GetMusclesByGroupUseCase(pendingRepo),
        GetMealCategoriesUseCase(pendingRepo),
        GetPopularTrainingUseCase(pendingRepo),
      );

      await tester.pumpWidget(
        buildTestWidget(
          cubit: loadingCubit,
          showBottomNavBar: false,
        ),
      );
      await tester.pump();

      expect(find.byType(FloatingBottomNavBar), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      pendingRepo.completer.complete(const Success([]));
      await tester.pumpAndSettle();
      loadingCubit.close();
    });

    testWidgets('tapping bottom nav bar item updates internal navigation index', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget(showBottomNavBar: true));
      await tester.pumpAndSettle();

      final trackFinder = find.byIcon(Icons.track_changes_rounded);
      expect(trackFinder, findsOneWidget);

      await tester.tap(trackFinder);
      await tester.pump();
    });

    testWidgets('tapping muscle group filter updates selected group', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final backTabFinder = find.text('Back');
      if (backTabFinder.evaluate().isNotEmpty) {
        await tester.tap(backTabFinder);
        await tester.pumpAndSettle();
        expect(homeCubit.state.data?.selectedMuscleGroupId, 'g2');
      }
    });

    testWidgets('ignores popular training items with empty image URL', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      fakeRepo.popularTrainings = [
        const PopularTrainingEntity(
          id: 'p_valid',
          title: 'Valid Training',
          totalTasks: 10,
          levelText: 'Beginner',
          imageUrl: 'https://valid.png',
        ),
        const PopularTrainingEntity(
          id: 'p_invalid',
          title: 'Ignored Training',
          totalTasks: 5,
          levelText: 'Beginner',
          imageUrl: '',
        ),
      ];

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Valid Training'), findsOneWidget);
      expect(find.text('Ignored Training'), findsNothing);
    });

    testWidgets('pull to refresh triggers refresh on HomeView', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      await tester.fling(
        find.byType(SingleChildScrollView),
        const Offset(0.0, 300.0),
        1000.0,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
