import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/coach_avatar_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/fitness_card_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/thinking_status_capsule.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) const _AssistantAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: _BubbleContainer(isUser: isUser, message: message),
          ),
          const SizedBox(width: 8),
          if (isUser) const _UserAvatar(),
        ],
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar();

  @override
  Widget build(BuildContext context) {
    return const CoachAvatarWidget();
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.primaryLight, width: 1.2),
      ),
      child: const Icon(Icons.person, color: AppColors.white, size: 20),
    );
  }
}

class _BubbleContainer extends StatelessWidget {
  final bool isUser;
  final ChatMessageEntity message;

  const _BubbleContainer({required this.isUser, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.chatUserBubble
            : AppColors.chatAssistantBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        border: Border.all(color: AppColors.chatBubbleStroke, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isThinking)
            ThinkingStatusCapsule(status: message.thinkingStatus)
          else ...[
            if (message.content.isNotEmpty)
              _BubbleMessageContent(message: message),
            if (message.fitnessCard != null)
              FitnessCardWidget(card: message.fitnessCard!),
          ],
        ],
      ),
    );
  }
}

class _BubbleMessageContent extends StatelessWidget {
  final ChatMessageEntity message;

  const _BubbleMessageContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.regular14.copyWith(
      color: AppColors.white,
      height: 1.35,
    );

    if (message.isStreaming) {
      return Text.rich(
        TextSpan(
          text: message.content,
          style: baseStyle,
          children: [
            TextSpan(
              text: ' ▌',
              style: AppTextStyles.extraBold14.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Text(message.content, style: baseStyle);
  }
}
