// ignore_for_file: unused_field

import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';

@injectable
class AiChatCubit extends BaseCubit<AiChatState, BaseEvent> {
  final SendMessageUseCase _sendMessageUseCase;
  final ClearChatUseCase _clearChatUseCase;

  AiChatCubit(
    this._sendMessageUseCase,
    this._clearChatUseCase,
  ) : super(const AiChatState());

  @override
  void doEvent(Object event) {
    switch (event) {
      case LoadChatHistoryEvent():
        _onLoadChatHistory();
      case SendChatMessageEvent(:final message):
        _onSendMessage(message);
      case ClearChatHistoryEvent():
        _onClearChat();
      default:
        break;
    }
  }

  void _onLoadChatHistory() {}

  void _onSendMessage(String message) {}

  void _onClearChat() {}
}
