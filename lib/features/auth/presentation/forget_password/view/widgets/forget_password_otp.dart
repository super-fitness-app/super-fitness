import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class ForgetPasswordOtp extends StatefulWidget {
  const ForgetPasswordOtp({super.key});

  @override
  State<ForgetPasswordOtp> createState() => _ForgetPasswordOtpState();
}

class _ForgetPasswordOtpState extends State<ForgetPasswordOtp> {
  static const int _otpLength = 4;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isOtpComplete = false;

  String get _currentOtp =>
      _controllers.map((controller) => controller.text).join();

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_otpLength, (_) => TextEditingController());

    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    for (final controller in _controllers) {
      controller.addListener(_updateOtpState);
    }

    for (final focusNode in _focusNodes) {
      focusNode.addListener(_updateOtpState);
    }
  }

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  bool _isVerifying(ForgetPasswordState state) {
    return state.isLoading &&
        state.operation == ForgetPasswordOperation.verifyOtp;
  }

  bool _isResending(ForgetPasswordState state) {
    return state.isLoading &&
        state.operation == ForgetPasswordOperation.resendOtp;
  }

  bool _isOtpLoading(ForgetPasswordState state) {
    return _isVerifying(state) || _isResending(state);
  }

  // ---------------------------------------------------------------------------
  // OTP handling
  // ---------------------------------------------------------------------------

  void _updateOtpState() {
    if (!mounted) return;

    final isComplete = _controllers.every(
      (controller) => controller.text.length == 1,
    );

    if (_isOtpComplete != isComplete) {
      setState(() {
        _isOtpComplete = isComplete;
      });
    } else {
      setState(() {});
    }
  }

  void _onOtpChanged(String value, int index) {
    context.read<ForgetPasswordCubit>().doEvent(OtpChangedEvent(_currentOtp));

    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _updateOtpState();
  }

  void _handlePaste(String value, int startIndex) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return;

    for (int i = 0; i < digits.length && startIndex + i < _otpLength; i++) {
      _controllers[startIndex + i].value = TextEditingValue(
        text: digits[i],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }

    context.read<ForgetPasswordCubit>().doEvent(OtpChangedEvent(_currentOtp));

    final firstEmptyIndex = _controllers.indexWhere(
      (controller) => controller.text.isEmpty,
    );

    if (firstEmptyIndex == -1) {
      _focusNodes[_otpLength - 1].unfocus();
    } else {
      _focusNodes[firstEmptyIndex].requestFocus();
    }

    _updateOtpState();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _onConfirm(ForgetPasswordState state) {
    if (!_isOtpComplete || state.isLoading) return;

    FocusScope.of(context).unfocus();

    context.read<ForgetPasswordCubit>().doEvent(VerifyOtpEvent(_currentOtp));
  }

  void _onResendCode(ForgetPasswordState state) {
    if (!state.canResend || state.isLoading) return;

    FocusScope.of(context).unfocus();

    context.read<ForgetPasswordCubit>().doEvent(const ResendOtpEvent());
  }

  // ---------------------------------------------------------------------------
  // Timer
  // ---------------------------------------------------------------------------

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.removeListener(_updateOtpState);
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.removeListener(_updateOtpState);
      focusNode.dispose();
    }

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final isVerifying = _isVerifying(state);
        final isResending = _isResending(state);
        final isOtpLoading = _isOtpLoading(state);

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoginHeaderSection(
                firstTitle: 'OTP CODE',
                secondTitlel: 'Enter Your OTP Check your email',
              ),

              const SizedBox(height: 32),

              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),

                        // OTP Fields
                        Row(
                          children: List.generate(
                            _otpLength,
                            (index) => Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end: index == _otpLength - 1 ? 0 : 12,
                                ),
                                child: _buildOtpField(
                                  index,
                                  enabled: !isOtpLoading,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Error Message
                        if (state.failure != null) ...[
                          Text(
                            state.errorMessage ?? 'Something went wrong',
                            style: AppTextStyles.regular13.copyWith(
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Confirm Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isOtpComplete && !isOtpLoading
                                ? () => _onConfirm(state)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: AppColors.primary
                                  .withValues(alpha: 0.35),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: isVerifying
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Text(
                                    'Confirm',
                                    style: AppTextStyles.buttonText,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "Didn't Receive Verification Code?",
                          style: AppTextStyles.regular13.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Resend Button
                        TextButton(
                          onPressed: state.canResend && !isOtpLoading
                              ? () => _onResendCode(state)
                              : null,
                          child: isResending
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sending...',
                                      style: AppTextStyles.linkText,
                                    ),
                                  ],
                                )
                              : Text(
                                  state.canResend
                                      ? 'Resend Code'
                                      : 'Resend Code (${_formatTime(state.remainingSeconds)})',
                                  style: AppTextStyles.linkText.copyWith(
                                    decoration: TextDecoration.none,
                                    color: state.canResend
                                        ? AppColors.primary
                                        : AppColors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // OTP Field
  // ---------------------------------------------------------------------------

  Widget _buildOtpField(int index, {required bool enabled}) {
    final hasValue = _controllers[index].text.isNotEmpty;
    final isFocused = _focusNodes[index].hasFocus;

    final underlineColor = (hasValue || isFocused)
        ? AppColors.primary
        : AppColors.borderLight;

    return SizedBox(
      height: 65,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: enabled,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textInputAction: index == _otpLength - 1
            ? TextInputAction.done
            : TextInputAction.next,
        style: AppTextStyles.bold20.copyWith(color: AppColors.primary),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.only(bottom: 8),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2.5),
          ),
        ),
        onChanged: (value) => _onOtpChanged(value, index),
      ),
    );
  }
}
