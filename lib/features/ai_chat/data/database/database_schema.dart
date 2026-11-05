abstract final class DatabaseSchema {
  static const String chatMessagesTable = 'chat_messages';

  static const String columnId = 'id';
  static const String columnContent = 'content';
  static const String columnRole = 'role';
  static const String columnTimestamp = 'timestamp';
  static const String columnToolCalls = 'tool_calls';

  static const String createChatMessagesTableQuery = '''
    CREATE TABLE IF NOT EXISTS $chatMessagesTable (
      $columnId TEXT PRIMARY KEY,
      $columnContent TEXT NOT NULL,
      $columnRole TEXT NOT NULL,
      $columnTimestamp TEXT NOT NULL,
      $columnToolCalls TEXT
    )
  ''';
}
