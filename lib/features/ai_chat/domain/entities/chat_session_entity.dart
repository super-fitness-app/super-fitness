import 'package:equatable/equatable.dart';

class ChatSessionEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalTokens;

  const ChatSessionEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.totalTokens = 0,
  });

  ChatSessionEntity copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalTokens,
  }) {
    return ChatSessionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalTokens: totalTokens ?? this.totalTokens,
    );
  }

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt, totalTokens];
}
