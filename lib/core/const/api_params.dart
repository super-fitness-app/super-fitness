abstract final class ApiParams {
  // Error parsing keys
  static const String message = 'message';
  static const String error = 'error';
  static const String msg = 'msg';
  static const String errors = 'errors';

  // Smart Coach & Ollama Keys
  static const String role = 'role';
  static const String content = 'content';
  static const String model = 'model';
  static const String stream = 'stream';
  static const String tools = 'tools';
  static const String messages = 'messages';
  static const String toolCalls = 'tool_calls';
  static const String function = 'function';
  static const String name = 'name';
  static const String arguments = 'arguments';
  static const String format = 'format';

  // Tool Specific Params
  static const String exerciseName = 'exercise_name';
  static const String targetMuscle = 'target_muscle';
  static const String mealName = 'meal_name';
  static const String goal = 'goal';

  // Chat Persistence Metadata
  static const String timestamp = 'timestamp';
  static const String metadata = 'metadata';
  static const String fitnessCard = 'fitness_card';
  static const String cardType = 'card_type';
  static const String cardTitle = 'card_title';
  static const String cardSubtitle = 'card_subtitle';
  static const String cardDetails = 'card_details';
  static const String cardItems = 'card_items';

  // Chat Session Keys
  static const String title = 'title';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String totalTokens = 'total_tokens';
}
