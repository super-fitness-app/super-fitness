import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/previous_conversations_drawer.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_glass_card.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_top_bar.dart';

class SmartCoachWelcomeView extends StatelessWidget {
  final AiChatCubit? cubit;

  const SmartCoachWelcomeView({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: const _WelcomeBlocConsumer(),
      );
    }
    if (getIt.isRegistered<AiChatCubit>()) {
      return BlocProvider(
        create: (_) => getIt<AiChatCubit>(),
        child: const _WelcomeBlocConsumer(),
      );
    }
    return const _WelcomeBody(userName: 'Athlete');
  }
}

class _WelcomeBlocConsumer extends StatelessWidget {
  const _WelcomeBlocConsumer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatCubit, AiChatState>(
      builder: (context, state) {
        return _WelcomeBody(userName: state.userName);
      },
    );
  }
}

class _WelcomeBody extends StatelessWidget {
  final String userName;

  const _WelcomeBody({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const PreviousConversationsDrawer(isFromWelcomeScreen: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. الخلفية
          const _BackgroundLayer(),

          // 2. المحتوى محمي داخل Scaffold و Layout مرن
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Builder(
                  builder: (scaffoldContext) => WelcomeTopBar(
                    userName: userName,
                    onMenuTap: () =>
                        Scaffold.of(scaffoldContext).openEndDrawer(),
                  ),
                ),

                // ترك مساحة مرنة للروبوت ليتقلص حسب مقاس الشاشة
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Image.asset(
                        AppImages.robot,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const _RobotFallbackIcon(),
                      ),
                    ),
                  ),
                ),

                // الكارت مع تقليل الـ bottom padding ليتناسب مع البار السفلي دون overflow
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                    end: 24,
                    bottom: 90,
                  ),
                  child: WelcomeGlassCard(
                    onGetStarted: () {
                      context.push(AppRoutes.smartCoachChat);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.background1,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Image.asset(
            AppImages.background,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: AppColors.background),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background.withValues(alpha: 0.3),
                AppColors.background.withValues(alpha: 0.5),
                AppColors.background.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _RobotFallbackIcon extends StatelessWidget {
  const _RobotFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.smart_toy_rounded,
          size: 100,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
