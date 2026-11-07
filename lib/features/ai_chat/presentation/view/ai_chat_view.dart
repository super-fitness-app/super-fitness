// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:super_fitness/config/di/di.dart';
// import 'package:super_fitness/core/const/app_colors.dart';
// import 'package:super_fitness/core/const/app_text_styles.dart';
// import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
// import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
// import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_input_field.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_message_bubble.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/tool_activity_indicator.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/typing_indicator.dart';

// class AiChatView extends StatelessWidget {
//   const AiChatView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<AiChatCubit>()..doEvent(const LoadChatHistoryEvent()),
//       child: const _AiChatViewContent(),
//     );
//   }
// }

// class _AiChatViewContent extends StatelessWidget {
//   const _AiChatViewContent();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text('AI Fitness Coach', style: AppTextStyles.bold20),
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: const Column(
//         children: [
//           Expanded(child: _ChatMessageList()),
//           ChatInputField(),
//         ],
//       ),
//     );
//   }
// }

// class _ChatMessageList extends StatelessWidget {
//   const _ChatMessageList();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AiChatCubit, AiChatState>(
//       builder: (context, state) {
//         return ListView.builder(
//           padding: const EdgeInsetsDirectional.all(12),
//           itemCount: state.messages.length + (state.isTyping ? 1 : 0),
//           itemBuilder: (context, index) {
//             if (index == state.messages.length && state.isTyping) {
//               if (state.activeToolName != null) {
//                 return ToolActivityIndicator(toolName: state.activeToolName!);
//               }
//               return const TypingIndicator();
//             }
//             return ChatMessageBubble(message: state.messages[index]);
//           },
//         );
//       },
//     );
//   }
// }
