class AiChatException implements Exception {
  final String message;
  final dynamic originalError;

  const AiChatException(this.message, [this.originalError]);

  @override
  String toString() => 'AiChatException: $message';
}
