import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/delete_chat_confirmation_dialog.dart';

class PreviousConversationsDrawer extends StatelessWidget {
  final bool isFromWelcomeScreen;

  const PreviousConversationsDrawer({
    super.key,
    this.isFromWelcomeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.72;
    const radius = BorderRadiusDirectional.horizontal(start: Radius.circular(24));

    return Drawer(
      width: width,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withValues(alpha: 0.88),
              border: BorderDirectional(
                start: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.0,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DrawerHeader(),
                    const SizedBox(height: 16),
                    _NewChatButton(isFromWelcomeScreen: isFromWelcomeScreen),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _SessionsList(isFromWelcomeScreen: isFromWelcomeScreen),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.smartCoachPreviousConversations,
          style: AppTextStyles.bold16.copyWith(color: AppColors.white),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.grey30, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _NewChatButton extends StatelessWidget {
  final bool isFromWelcomeScreen;

  const _NewChatButton({required this.isFromWelcomeScreen});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        final cubit = context.read<AiChatCubit>();
        cubit.doEvent(const CreateNewSessionEvent());
        Navigator.of(context).pop();
        if (isFromWelcomeScreen) {
          context.push(AppRoutes.smartCoachChat);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.smartCoachStartNewChat,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionsList extends StatelessWidget {
  final bool isFromWelcomeScreen;

  const _SessionsList({required this.isFromWelcomeScreen});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AiChatCubit, AiChatState>(
      buildWhen: (prev, curr) =>
          prev.sessions != curr.sessions ||
          prev.currentSessionId != curr.currentSessionId,
      builder: (context, state) {
        if (state.sessions.isEmpty) {
          return Center(
            child: Text(
              l10n.smartCoachNoPreviousChats,
              style: AppTextStyles.regular12.copyWith(color: AppColors.grey40),
            ),
          );
        }

        return ListView.separated(
          itemCount: state.sessions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final session = state.sessions[index];
            final isSelected = session.id == state.currentSessionId;

            return _SessionTile(
              session: session,
              isSelected: isSelected,
              isFromWelcomeScreen: isFromWelcomeScreen,
            );
          },
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  final ChatSessionEntity session;
  final bool isSelected;
  final bool isFromWelcomeScreen;

  const _SessionTile({
    required this.session,
    required this.isSelected,
    required this.isFromWelcomeScreen,
  });

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (_) => const DeleteChatConfirmationDialog(),
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(session.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.white, size: 20),
      ),
      onDismissed: (_) {
        context.read<AiChatCubit>().doEvent(DeleteChatSessionEvent(session.id));
      },
      child: InkWell(
        onTap: () {
          final cubit = context.read<AiChatCubit>();
          cubit.doEvent(SelectChatSessionEvent(session.id));
          Navigator.of(context).pop();
          if (isFromWelcomeScreen) {
            context.push(AppRoutes.smartCoachChat, extra: session.id);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  session.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular13.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey20,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _DeleteSessionButton(
                onDelete: () async {
                  final confirmed = await _confirmDelete(context);
                  if (confirmed == true && context.mounted) {
                    context.read<AiChatCubit>().doEvent(DeleteChatSessionEvent(session.id));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteSessionButton extends StatelessWidget {
  final VoidCallback onDelete;

  const _DeleteSessionButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDelete,
      borderRadius: BorderRadius.circular(14),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white38),
      ),
    );
  }
}
