import 'package:injectable/injectable.dart';
import 'package:super_fitness/core/const/api_params.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';

@LazySingleton(as: FitnessLocalDataSource)
class FitnessLocalDataSourceImpl implements FitnessLocalDataSource {
  const FitnessLocalDataSourceImpl();

  static const Map<String, Map<String, dynamic>> _mockExercisesDb = {
    'bench press': {
      'title': 'Barbell Bench Press',
      'target_muscle': 'Chest (Pectoralis Major)',
      'subtitle': 'Compound upper body press',
      'metrics': {
        'Sets & Reps': '4 sets x 8-10 reps',
        'Rest Time': '90-120 seconds',
        'Target RPE': '8 / 10',
      },
      'bullet_points': [
        'Retract your scapula and maintain a slight natural arch.',
        'Lower the bar with control to your mid-sternum.',
        'Drive through your heels and press back up explosively.',
      ],
    },
    'squat': {
      'title': 'Barbell Back Squat',
      'target_muscle': 'Quadriceps & Glutes',
      'subtitle': 'Primary lower body compound builder',
      'metrics': {
        'Sets & Reps': '4 sets x 6-8 reps',
        'Rest Time': '120 seconds',
        'Target RPE': '8.5 / 10',
      },
      'bullet_points': [
        'Set feet shoulder-width apart with toes slightly flared.',
        'Brace your core deep into your belt before descending.',
        'Break at hips and knees simultaneously down to parallel.',
      ],
    },
    'deadlift': {
      'title': 'Conventional Deadlift',
      'target_muscle': 'Posterior Chain & Back',
      'subtitle': 'Total body power and pulling foundation',
      'metrics': {
        'Sets & Reps': '3 sets x 5 reps',
        'Rest Time': '180 seconds',
        'Target RPE': '9 / 10',
      },
      'bullet_points': [
        'Stand with bar over mid-foot, shins touching.',
        'Engage lats, push the floor away without rounding lower back.',
        'Lock out by driving hips through at the top.',
      ],
    },
  };

  static const Map<String, Map<String, dynamic>> _mockMealsDb = {
    'chicken': {
      'title': 'Grilled Chicken Breast & Jasmine Rice',
      'subtitle': 'High-protein lean muscle recovery meal',
      'goal': 'Muscle Gain / Lean Bulk',
      'metrics': {
        'Calories': '580 kcal',
        'Protein': '48g',
        'Carbs': '65g',
        'Fats': '9g',
      },
      'bullet_points': [
        '200g skinless chicken breast marinated in herbs and olive oil.',
        '180g steamed jasmine or basmati white rice.',
        'Side of steamed broccoli or asparagus for micronutrients.',
      ],
    },
    'oatmeal': {
      'title': 'Power Athlete Protein Oats',
      'subtitle': 'Sustained energy breakfast bowl',
      'goal': 'Pre-Workout Fuel',
      'metrics': {
        'Calories': '460 kcal',
        'Protein': '32g',
        'Carbs': '58g',
        'Fats': '11g',
      },
      'bullet_points': [
        '70g rolled oats cooked with unsweetened almond milk.',
        '1 scoop whey isolate protein powder stirred in.',
        'Topped with a handful of blueberries and 10g crushed walnuts.',
      ],
    },
    'salmon': {
      'title': 'Pan-Seared Salmon & Sweet Potato',
      'subtitle': 'Omega-3 rich recovery dinner',
      'goal': 'Cutting / Health Optimization',
      'metrics': {
        'Calories': '520 kcal',
        'Protein': '42g',
        'Carbs': '40g',
        'Fats': '18g',
      },
      'bullet_points': [
        '180g wild Atlantic salmon fillet pan-seared with lemon.',
        '200g baked sweet potato wedges.',
        'Mixed garden green salad drizzled with flaxseed oil.',
      ],
    },
  };

  @override
  Future<Map<String, dynamic>> getExerciseDetails({
    required String exerciseName,
    String? targetMuscle,
  }) async {
    final query = exerciseName.toLowerCase().trim();
    for (final entry in _mockExercisesDb.entries) {
      if (query.contains(entry.key) || entry.key.contains(query)) {
        final data = Map<String, dynamic>.from(entry.value);
        data[ApiParams.cardType] = 'exercise';
        return data;
      }
    }

    return {
      ApiParams.cardType: 'exercise',
      'title': exerciseName.toUpperCase(),
      'subtitle': 'Customized movement analysis',
      'badge': targetMuscle ?? 'Full Body',
      'metrics': {
        'Sets & Reps': '3-4 sets x 8-12 reps',
        'Rest Time': '60-90 seconds',
        'Target RPE': '8 / 10',
      },
      'bullet_points': [
        'Execute each repetition with controlled eccentric tempo.',
        'Maintain steady diaphragmatic breathing under tension.',
        'Focus on full range of motion without momentum.',
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> getMealNutrition({
    required String mealName,
    String? goal,
  }) async {
    final query = mealName.toLowerCase().trim();
    for (final entry in _mockMealsDb.entries) {
      if (query.contains(entry.key) || entry.key.contains(query)) {
        final data = Map<String, dynamic>.from(entry.value);
        data[ApiParams.cardType] = 'meal';
        return data;
      }
    }

    return {
      ApiParams.cardType: 'meal',
      'title': mealName.toUpperCase(),
      'subtitle': 'Macronutrient breakdown & nutrition protocol',
      'badge': goal ?? 'Balanced',
      'metrics': {
        'Calories': '500 kcal',
        'Protein': '35g',
        'Carbs': '50g',
        'Fats': '15g',
      },
      'bullet_points': [
        'Opt for whole, nutrient-dense unprocessed ingredients.',
        'Pair protein sources with fibrous carbohydrates.',
        'Stay hydrated with 500ml water accompanying the meal.',
      ],
    };
  }
}
