import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:super_fitness/core/const/api_params.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';

class ChatSessionModel extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalTokens;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.totalTokens = 0,
  });

  factory ChatSessionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final rawCreated = data[ApiParams.createdAt];
    final rawUpdated = data[ApiParams.updatedAt];

    DateTime parseTime(dynamic raw) {
      if (raw is Timestamp) return raw.toDate();
      if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
      if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
      return DateTime.now();
    }

    return ChatSessionModel(
      id: doc.id,
      title: (data[ApiParams.title] as String?) ?? 'Chat Session',
      createdAt: parseTime(rawCreated),
      updatedAt: parseTime(rawUpdated),
      totalTokens: (data[ApiParams.totalTokens] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      ApiParams.title: title,
      ApiParams.createdAt: Timestamp.fromDate(createdAt),
      ApiParams.updatedAt: FieldValue.serverTimestamp(),
      ApiParams.totalTokens: totalTokens,
    };
  }

  ChatSessionEntity toEntity() => ChatSessionEntity(
    id: id,
    title: title,
    createdAt: createdAt,
    updatedAt: updatedAt,
    totalTokens: totalTokens,
  );

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt, totalTokens];
}
