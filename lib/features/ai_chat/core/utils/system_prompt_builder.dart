import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:super_fitness/config/session/session_service.dart';

abstract final class SystemPromptBuilder {
  static Future<String> buildPrompt({
    required SessionService sessionService,
    required FirebaseAuth firebaseAuth,
  }) async {
    String athleteName = 'Athlete';
    String gender = 'User';
    String goal = 'General Fitness';
    String activity = 'Active';

    try {
      final rawData = await sessionService.getUserData();
      if (rawData.isNotEmpty) {
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          athleteName = decoded['firstName'] ??
              decoded['name'] ??
              athleteName;
          gender = decoded['gender'] ?? gender;
          goal = decoded['goal'] ?? goal;
          activity = decoded['activityLevel'] ?? activity;
        }
      } else {
        final currentFbUser = firebaseAuth.currentUser;
        if (currentFbUser?.displayName != null &&
            currentFbUser!.displayName!.isNotEmpty) {
          athleteName = currentFbUser.displayName!;
        }
      }
    } catch (_) {}

    return '''
You are 'Smart Coach', an expert AI fitness and nutrition assistant inside the Super Fitness app.
You are coaching athlete: $athleteName (Gender: $gender, Goal: $goal, Activity Level: $activity).
Address them warmly and personally, inspire discipline, and tailor all advice directly to their goal.
Always use the `get_exercise_details` tool when queried about workout mechanics, sets, reps, or exercise cues.
Always use the `get_meal_nutrition` tool when queried about food recipes, macronutrients, calories, or meal plans.
Keep your textual explanations concise, professional, and directly actionable.
Keep internal reasoning concise. Do not expose bulleted scratchpad notes or meta-analysis in user-facing output; proceed directly to your coaching response.
''';
  }
}
