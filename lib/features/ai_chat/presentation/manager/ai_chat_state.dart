import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';

class AiChatState extends Equatable {
  final BaseState<List<ChatMessageEntity>> chatHistoryState;
  final BaseState<ChatMessageEntity> sendMessageState;
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final String? activeToolName;

  const AiChatState({
    this.chatHistoryState = const BaseState.initial(),
    this.sendMessageState = const BaseState.initial(),
    this.messages = const [],
    this.isTyping = false,
    this.activeToolName,
  });

  bool get isLoading => chatHistoryState.isLoading || sendMessageState.isLoading;

  AiChatState copyWith({
    BaseState<List<ChatMessageEntity>>? chatHistoryState,
    BaseState<ChatMessageEntity>? sendMessageState,
    List<ChatMessageEntity>? messages,
    bool? isTyping,
    Object? activeToolName = unset,
  }) {
    return AiChatState(
      chatHistoryState: chatHistoryState ?? this.chatHistoryState,
      sendMessageState: sendMessageState ?? this.sendMessageState,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      activeToolName: identical(activeToolName, unset)
          ? this.activeToolName
          : activeToolName as String?,
    );
  }

  @override
  List<Object?> get props => [
        chatHistoryState,
        sendMessageState,
        messages,
        isTyping,
        activeToolName,
      ];
}
