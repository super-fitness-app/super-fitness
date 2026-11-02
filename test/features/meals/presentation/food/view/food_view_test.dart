import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food/view/food_view.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_card.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_category_shimmer.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_header_section.dart';
import 'package:super_fitness/features/meals/presentation/food/view/widgets/food_shimmer_loading.dart';

class MockFoodCubit extends BaseCubit<FoodState, BaseEvent>
    implements FoodCubit {
  final List<Object> dispatchedEvents = [];
  MockFoodCubit([super.initialState = const FoodState()]);

  @override
  void doEvent(Object event) => dispatchedEvents.add(event);
}

Widget _buildTestWidget(MockFoodCubit cubit, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: FoodView(cubit: cubit),
  );
}

void main() {
  group('FoodView Widget Tests', () {
    const testCategories = [
      CategoryEntity(id: '1', name: 'Breakfast'),
      CategoryEntity(id: '2', name: 'Lunch'),
      CategoryEntity(id: '3', name: 'Dinner'),
    ];

    const testMeals = [
      MealEntity(id: '1', name: 'Pasta With Chicks', imageUrl: ''),
      MealEntity(id: '2', name: 'Grilled Chicken', imageUrl: ''),
    ];

    testWidgets('renders category and meals shimmer when state isLoading is true',
        (tester) async {
      final cubit = MockFoodCubit(
        const FoodState(baseState: BaseState.loading()),
      );

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pump();

      expect(find.byType(FoodCategoryShimmer), findsOneWidget);
      expect(find.byType(FoodShimmerLoading), findsOneWidget);
      await cubit.close();
    });

    testWidgets('renders header, categories, back button, and cards on success',
        (tester) async {
      final cubit = MockFoodCubit(
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          displayedMeals: testMeals,
          selectedCategory: 'Dinner',
        ),
      );

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(FoodHeaderSection), findsOneWidget);
      expect(find.byKey(const Key('food_header_back_button')), findsOneWidget);
      expect(find.text('Food Recommendation'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.byType(FoodCard), findsNWidgets(2));
      expect(find.text('Pasta With Chicks'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('tapping category tag dispatches SelectCategoryEvent', (
      tester,
    ) async {
      final cubit = MockFoodCubit(
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          displayedMeals: testMeals,
          selectedCategory: 'Dinner',
        ),
      );

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Breakfast'));
      await tester.pump();

      expect(
        cubit.dispatchedEvents.any(
          (e) => e is SelectCategoryEvent && e.categoryName == 'Breakfast',
        ),
        isTrue,
      );
      await cubit.close();
    });

    testWidgets('scrolling near bottom dispatches LoadMoreMealsEvent', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final manyMeals = List.generate(
        20,
        (i) => MealEntity(id: '$i', name: 'Meal $i', imageUrl: ''),
      );
      final cubit = MockFoodCubit(
        FoodState(
          baseState: BaseState.success(manyMeals),
          categories: testCategories,
          displayedMeals: manyMeals,
          selectedCategory: 'Dinner',
        ),
      );

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3500));
      await tester.pumpAndSettle();

      expect(
        cubit.dispatchedEvents.any((e) => e is LoadMoreMealsEvent),
        isTrue,
      );
      await cubit.close();
    });

    testWidgets('tapping meal card dispatches MealClickedEvent', (
      tester,
    ) async {
      final cubit = MockFoodCubit(
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          displayedMeals: testMeals,
          selectedCategory: 'Dinner',
        ),
      );

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FoodCard).first);
      await tester.pump();

      expect(
        cubit.dispatchedEvents.any(
          (e) => e is MealClickedEvent && e.meal == testMeals.first,
        ),
        isTrue,
      );
      await cubit.close();
    });

    testWidgets('renders correctly in Arabic RTL without error', (
      tester,
    ) async {
      final cubit = MockFoodCubit(
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          displayedMeals: testMeals,
          selectedCategory: 'Dinner',
        ),
      );

      await tester.pumpWidget(
        _buildTestWidget(cubit, locale: const Locale('ar')),
      );
      await tester.pumpAndSettle();

      expect(find.text('توصيات الطعام'), findsOneWidget);
      await cubit.close();
    });
  });
}
