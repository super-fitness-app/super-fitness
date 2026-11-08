import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_background_stack.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_input_field.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_message_list_section.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_top_bar.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/previous_conversations_drawer.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/token_status_banner.dart';

class SmartCoachChatView extends StatefulWidget {
  final AiChatCubit? cubit;
  final String? sessionId;

  const SmartCoachChatView({super.key, this.cubit, this.sessionId});

  @override
  State<SmartCoachChatView> createState() => _SmartCoachChatViewState();
}

class _SmartCoachChatViewState extends State<SmartCoachChatView>
    with BaseViewMixin<SmartCoachChatView, AiChatCubit, BaseEvent> {
  late final AiChatCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  AiChatCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = widget.cubit ?? getIt<AiChatCubit>();
    super.initState();
    if (widget.sessionId != null) {
      _cubit.doEvent(SelectChatSessionEvent(widget.sessionId!));
    } else {
      _cubit.doEvent(const LoadChatHistoryEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.cubit == null) {
      _cubit.close();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        endDrawer: const PreviousConversationsDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const ChatBackgroundStack(),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Builder(
                    builder: (scaffoldContext) => ChatTopBar(
                      onMenuTap: () => Scaffold.of(scaffoldContext).openEndDrawer(),
                      onClearChat: () =>
                          _cubit.doEvent(const ClearChatHistoryEvent()),
                    ),
                  ),
                  BlocBuilder<AiChatCubit, AiChatState>(
                    bloc: _cubit,
                    buildWhen: (prev, curr) =>
                        prev.currentSessionTokens != curr.currentSessionTokens ||
                        prev.isSessionLocked != curr.isSessionLocked ||
                        prev.isApproachingTokenLimit != curr.isApproachingTokenLimit,
                    builder: (context, state) => TokenStatusBanner(
                      totalTokens: state.currentSessionTokens,
                      isApproachingLimit: state.isApproachingTokenLimit,
                      isLocked: state.isSessionLocked,
                      onStartNewChat: () =>
                          _cubit.doEvent(const CreateNewSessionEvent()),
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<AiChatCubit, AiChatState>(
                      bloc: _cubit,
                      listenWhen: (prev, curr) {
                        if (prev.messages.length != curr.messages.length) {
                          return true;
                        }
                        if (prev.messages.isNotEmpty &&
                            curr.messages.isNotEmpty) {
                          final p = prev.messages.last;
                          final c = curr.messages.last;
                          if (p.content != c.content || p.thought != c.thought) {
                            return true;
                          }
                        }
                        return prev.isTyping != curr.isTyping;
                      },
                      listener: (_, _) => _scrollToBottom(),
                      builder: (context, state) {
                        return ChatMessageListSection(
                          messages: state.messages,
                          isTyping: state.isTyping,
                          isHistoryLoading: state.isHistoryLoading,
                          scrollController: _scrollController,
                          onPromptTap: (prompt) =>
                              _cubit.doEvent(SendChatMessageEvent(prompt)),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<AiChatCubit, AiChatState>(
                    bloc: _cubit,
                    buildWhen: (prev, curr) =>
                        prev.isTyping != curr.isTyping ||
                        prev.isSessionLocked != curr.isSessionLocked,
                    builder: (context, state) {
                      return ChatInputField(
                        isEnabled: !state.isTyping && !state.isSessionLocked,
                        onSend: (msg) {
                          _cubit.doEvent(SendChatMessageEvent(msg));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
