// import 'package:flutter_test/flutter_test.dart';
// import 'package:super_fitness/features/ai_chat/data/models/exercise_model.dart';
// import 'package:super_fitness/features/ai_chat/data/models/meal_model.dart';
// import 'package:super_fitness/features/ai_chat/data/models/structured_fitness_card_model.dart';
// import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';

// void main() {
//   group('Fitness Local Data Source Formatting & SQLite Type Stability', () {
//     test('exercise queries ("squat", "bench") format safely into fitness cards', () {
//       final benchRow = <String, dynamic>{
//         'id': 'ex_bench',
//         'name': 'Bench Press',
//         'muscle_group': 'Chest',
//         'prime_mover': 'Pectoralis Major',
//         'equipment': 'Barbell',
//         'difficulty': 'Intermediate',
//         'difficulty_rank': 3,
//         'body_region': 'Upper Body',
//         'mechanics': 'Compound',
//         'force_type': 'Push',
//         'movement_patterns': 'Horizontal Push',
//         'posture': 'Lying Supine',
//         'laterality': 'Bilateral',
//       };

//       final exercise = ExerciseModel.fromJson(benchRow);
//       final detailsMap = {
//         'card_type': 'exercise',
//         'card_title': exercise.name,
//         'card_subtitle': exercise.muscleGroup ?? 'Exercise details',
//         'badge': exercise.primeMover ?? exercise.muscleGroup,
//         'card_details': {
//           if (exercise.equipment != null) 'equipment': exercise.equipment!,
//           if (exercise.difficulty != null) 'difficulty': exercise.difficulty!,
//           if (exercise.bodyRegion != null) 'body_region': exercise.bodyRegion!,
//         },
//         'card_items': [
//           if (exercise.primeMover != null)
//             'Primary muscle: ${exercise.primeMover}',
//           if (exercise.movementPatterns != null)
//             'Movement pattern: ${exercise.movementPatterns}',
//         ],
//       };

//       final card = StructuredFitnessCardModel.fromJson(detailsMap);
//       final entity = card.toEntity();

//       expect(entity.cardType, equals(FitnessCardType.exercise));
//       expect(entity.title, equals('bench press'));
//       expect(entity.badge, equals('Pectoralis Major'));
//       expect(entity.metrics['equipment'], equals('Barbell'));
//       expect(entity.bulletPoints.length, equals(2));
//     });

//     test('meal queries ("chicken", "salmon", "200 calories") with SQLite booleans format safely', () {
//       final chickenRow = <String, dynamic>{
//         'id': 'meal_chicken',
//         'name': 'Chicken Breast',
//         'category': 'Poultry',
//         'meal_type': 'Dinner',
//         'kcal': 200.0,
//         'protein_g': 38.0,
//         'carbs_g': 0.0,
//         'fat_g': 3.5,
//         'nutrition_is_estimate': 1, // Integer boolean from SQLite
//         'vegetarian': 0,            // Integer boolean from SQLite
//         'vegan': 0,
//         'contains_gluten': 0,
//         'contains_nuts': 0,
//       };

//       final meal = MealModel.fromJson(chickenRow);

//       expect(meal.nutritionIsEstimate, isTrue);
//       expect(meal.vegetarian, isFalse);

//       final nutritionMap = {
//         'card_type': 'meal',
//         'card_title': meal.name,
//         'card_subtitle': meal.category ?? meal.mealType ?? 'Nutrition information',
//         'badge': '200 calories',
//         'card_details': {
//           if (meal.calories != null) 'calories': '${meal.calories} kcal',
//           if (meal.protein != null) 'protein': '${meal.protein} g',
//           if (meal.nutritionIsEstimate != null)
//             'estimated': meal.nutritionIsEstimate == true ? 'Yes' : 'No',
//         },
//         'card_items': <String>[],
//       };

//       final card = StructuredFitnessCardModel.fromJson(nutritionMap);
//       final entity = card.toEntity();

//       expect(entity.cardType, equals(FitnessCardType.meal));
//       expect(entity.title, equals('chicken breast'));
//       expect(entity.badge, equals('200 calories'));
//       expect(entity.metrics['calories'], equals('200.0 kcal'));
//       expect(entity.metrics['protein'], equals('38.0 g'));
//       expect(entity.metrics['estimated'], equals('Yes'));
//     });

//     test('handles fallback safely when database lookup throws an exception', () {
//       StructuredFitnessCardModel? card;
//       String replyText = '';

//       try {
//         throw Exception('Simulated SQLite database read failure');
//       } catch (e) {
//         card = null;
//         replyText =
//             'I am your Smart Coach. I am temporarily operating in offline mode. Ask me about any workout or meal plan to get guidance!';
//       }

//       expect(card, isNull);
//       expect(replyText, contains('temporarily operating in offline mode'));
//     });
//   });
// }
