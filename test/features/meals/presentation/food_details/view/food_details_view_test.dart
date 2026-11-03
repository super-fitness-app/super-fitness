import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/food_details_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_error_view.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_header.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_ingredients_section.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_macro_pills.dart';
import 'package:super_fitness/features/meals/presentation/food_details/view/widgets/food_details_shimmer.dart';

class MockFoodDetailsCubit extends BaseCubit<FoodDetailsState, BaseEvent>
    implements FoodDetailsCubit {
  final List<Object> dispatchedEvents = [];
  MockFoodDetailsCubit([super.initialState = const BaseState.initial()]);

  @override
  void doEvent(Object event) => dispatchedEvents.add(event);
}

Widget _buildTestWidget(
  MockFoodDetailsCubit cubit, {
  Locale locale = const Locale('en'),
  String? mealId,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: FoodDetailsView(cubit: cubit, mealId: mealId),
  );
}

void main() {
  group('FoodDetailsView Widget Tests', () {
    const testMeal = MealDetailsEntity(
      id: '53380',
      name: 'Apple cake',
      instructions: 'Preheat oven to 180C',
      imageUrl: '',
      youtubeUrl: 'https://www.youtube.com/watch?v=vZy-7UyPdjM',
      ingredients: [
        MealIngredientEntity(name: 'Eggs', measure: '4'),
        MealIngredientEntity(name: 'Sugar', measure: '200g'),
      ],
    );

    testWidgets('Renders background layer with blur and overlay',
        (tester) async {
      final cubit = MockFoodDetailsCubit(const BaseState.loading());

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
      final backdrop = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      expect(
        backdrop.filter,
        ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      );
      await cubit.close();
    });

    testWidgets('FoodDetailsShimmer is displayed during loading state',
        (tester) async {
      final cubit = MockFoodDetailsCubit(const BaseState.loading());

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pump();

      expect(find.byType(FoodDetailsShimmer), findsOneWidget);
      await cubit.close();
    });

    testWidgets('Renders header, macro pills, and ingredients on success',
        (tester) async {
      final cubit = MockFoodDetailsCubit(const BaseState.success(testMeal));

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pump();

      expect(find.byType(FoodDetailsHeader), findsOneWidget);
      expect(find.byType(FoodDetailsMacroPills), findsOneWidget);
      expect(find.byType(FoodDetailsIngredientsSection), findsOneWidget);

      expect(find.text('Apple cake'), findsOneWidget);
      expect(find.text('100 K'), findsOneWidget);
      expect(find.text('Energy'), findsOneWidget);
      expect(find.text('Eggs'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('FoodDetailsErrorView is displayed on failure and retries',
        (tester) async {
      final cubit = MockFoodDetailsCubit(
        const BaseState.failure(NetworkFailure(AppError.noConnection)),
      );

      await tester.pumpWidget(_buildTestWidget(cubit, mealId: '53380'));
      await tester.pump();

      expect(find.byType(FoodDetailsErrorView), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      cubit.dispatchedEvents.clear();
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(cubit.dispatchedEvents.length, 1);
      expect(cubit.dispatchedEvents.first, isA<LoadMealDetailsEvent>());
      await cubit.close();
    });

    testWidgets('RTL Arabic layout renders successfully without overflow',
        (tester) async {
      final cubit = MockFoodDetailsCubit(const BaseState.success(testMeal));

      await tester.pumpWidget(_buildTestWidget(
        cubit,
        locale: const Locale('ar'),
      ));
      await tester.pump();

      expect(find.byType(FoodDetailsHeader), findsOneWidget);
      expect(find.text('طاقة'), findsOneWidget);
      expect(find.text('المكونات'), findsOneWidget);
      await cubit.close();
    });
  });
}
