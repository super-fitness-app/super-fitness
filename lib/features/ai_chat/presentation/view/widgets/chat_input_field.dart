import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class ChatInputField extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isEnabled;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmitted() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF222222).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: widget.isEnabled,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.smartCoachInputHint,
                    hintStyle: AppTextStyles.regular14.copyWith(
                      color: Colors.white54,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _handleSubmitted(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SendButton(
              isEnabled: widget.isEnabled,
              onTap: _handleSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const _SendButton({
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled
          ? AppColors.primary
          : AppColors.primary.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.send_rounded,
            color: AppColors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
