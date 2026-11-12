import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';

const Object _unset = Object();

class AiChatState extends Equatable {
  final BaseState<List<ChatMessageEntity>> historyState;
  final BaseState<ChatMessageEntity> sendMessageState;
  final BaseState<List<ChatSessionEntity>> sessionsState;
  final List<ChatMessageEntity> messages;
  final List<ChatSessionEntity> sessions;
  final bool isTyping;
  final bool isHistoryLoading;
  final String? activeToolName;
  final String userName;
  final String currentSessionId;
  final int currentSessionTokens;

  const AiChatState({
    this.historyState = const BaseState.initial(),
    this.sendMessageState = const BaseState.initial(),
    this.sessionsState = const BaseState.initial(),
    this.messages = const [],
    this.sessions = const [],
    this.isTyping = false,
    this.isHistoryLoading = false,
    this.activeToolName,
    this.userName = 'Athlete',
    this.currentSessionId = 'default_session',
    this.currentSessionTokens = 0,
  });

  bool get isLoading =>
      historyState.isLoading ||
      sendMessageState.isLoading ||
      sessionsState.isLoading;

  bool get isApproachingTokenLimit =>
      currentSessionTokens >= 2000 && currentSessionTokens < 3000;

  bool get isSessionLocked => currentSessionTokens >= 3000;

  AiChatState copyWith({
    BaseState<List<ChatMessageEntity>>? historyState,
    BaseState<ChatMessageEntity>? sendMessageState,
    BaseState<List<ChatSessionEntity>>? sessionsState,
    List<ChatMessageEntity>? messages,
    List<ChatSessionEntity>? sessions,
    bool? isTyping,
    bool? isHistoryLoading,
    Object? activeToolName = _unset,
    String? userName,
    String? currentSessionId,
    int? currentSessionTokens,
  }) {
    return AiChatState(
      historyState: historyState ?? this.historyState,
      sendMessageState: sendMessageState ?? this.sendMessageState,
      sessionsState: sessionsState ?? this.sessionsState,
      messages: messages ?? this.messages,
      sessions: sessions ?? this.sessions,
      isTyping: isTyping ?? this.isTyping,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      activeToolName: identical(activeToolName, _unset)
          ? this.activeToolName
          : activeToolName as String?,
      userName: userName ?? this.userName,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      currentSessionTokens: currentSessionTokens ?? this.currentSessionTokens,
    );
  }

  @override
  List<Object?> get props => [
    historyState,
    sendMessageState,
    sessionsState,
    messages,
    sessions,
    isTyping,
    isHistoryLoading,
    activeToolName,
    userName,
    currentSessionId,
    currentSessionTokens,
  ];
}
