export 'package:super_fitness/core/errors/app_failure.dart' show AiChatFailure, AppFailure;

class AiChatException implements Exception {
  final String message;
  final dynamic originalError;

  const AiChatException(this.message, [this.originalError]);

  @override
  String toString() => 'AiChatException: $message';
}
