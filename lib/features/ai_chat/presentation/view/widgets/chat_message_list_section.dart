import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_bubble_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/coach_robot_avatar.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/empty_chat_placeholder.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/thinking_status_capsule.dart';

class ChatMessageListSection extends StatelessWidget {
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final bool isHistoryLoading;
  final ScrollController scrollController;
  final ValueChanged<String> onPromptTap;

  const ChatMessageListSection({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.isHistoryLoading,
    required this.scrollController,
    required this.onPromptTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (isHistoryLoading) {
      child = const Center(
        key: ValueKey('chat_history_loading'),
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (messages.isEmpty && !isTyping) {
      child = EmptyChatPlaceholder(
        key: const ValueKey('chat_empty_placeholder'),
        onPromptTap: onPromptTap,
      );
    } else {
      child = _MessagesListView(
        key: const ValueKey('chat_messages_list'),
        messages: messages,
        isTyping: isTyping,
        scrollController: scrollController,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}

class _MessagesListView extends StatelessWidget {
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  final ScrollController scrollController;

  const _MessagesListView({
    super.key,
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
          padding: const EdgeInsetsDirectional.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CoachRobotAvatar(size: 36),
              const SizedBox(width: 8),
              ThinkingStatusCapsule(status: l10n.smartCoachThinking),
            ],
          ),
        );
      },
    );
  }
}
