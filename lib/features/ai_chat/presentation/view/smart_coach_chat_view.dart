import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_view_mixin.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_background_stack.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_bubble_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_input_field.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_top_bar.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/previous_conversations_drawer.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/thinking_status_capsule.dart';
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
                        return _MessageListSection(
                          messages: state.messages,
                          isTyping: state.isTyping,
                          scrollController: _scrollController,
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

class _MessageListSection extends StatelessWidget {
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final ScrollController scrollController;

  const _MessageListSection({
    required this.messages,
    required this.isTyping,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return ChatBubbleWidget(message: messages[index]);
        }
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 44, bottom: 12),
          child: ThinkingStatusCapsule(status: l10n.smartCoachThinking),
        );
      },
    );
  }
}
