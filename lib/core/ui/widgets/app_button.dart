import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.textColor,
    this.disabledTextColor,
    this.isLoading = false,
    this.padding,
    this.textStyle,
    this.width = double.infinity,
    this.height = 38,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.orangeButton;
    final effectiveFg = textColor ?? AppColors.white;
    final effectiveDisabledBg = disabledBackgroundColor ?? AppColors.grey70;
    final effectiveDisabledFg = disabledTextColor ?? AppColors.grey40;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveFg,
          disabledBackgroundColor: effectiveDisabledBg,
          disabledForegroundColor: effectiveDisabledFg,
          shape: const StadiumBorder(),
          elevation: 0,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          padding:
              padding ?? const EdgeInsetsDirectional.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? _AppButtonLoading(color: effectiveFg)
            : _AppButtonText(
                text: text,
                style: (textStyle ?? AppStyles.buttonText).copyWith(
                  color: onPressed != null ? effectiveFg : effectiveDisabledFg,
                ),
              ),
      ),
    );
  }
}

class _AppButtonLoading extends StatelessWidget {
  final Color color;

  const _AppButtonLoading({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _AppButtonText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _AppButtonText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: TextAlign.center, style: style);
  }
}
