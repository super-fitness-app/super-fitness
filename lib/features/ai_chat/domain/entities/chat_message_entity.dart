import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String content;
  final String role;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, content, role, timestamp];
}
