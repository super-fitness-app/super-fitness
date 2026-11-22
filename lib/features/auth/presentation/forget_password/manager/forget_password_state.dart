import 'package:super_fitness/core/errors/app_failure.dart';

import '../../../../../config/base/base_state.dart';

enum ForgetPasswordStep { email, otp, resetPassword }

enum ForgetPasswordOperation {
  none,
  checkEmail,
  resendOtp,
  verifyOtp,
  resetPassword,
}

class ForgetPasswordState extends BaseState<dynamic> {
  final ForgetPasswordStep step;
  final ForgetPasswordOperation operation;
  final String otp;
  final String otpToken;
  final String? email;
  final int remainingSeconds;

  const ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.operation = ForgetPasswordOperation.none,
    this.otp = '',
    this.otpToken = '',
    this.email,
    this.remainingSeconds = 30,
    super.isLoading = false,
    super.failure,
    super.data,
  });

  bool get canResend => remainingSeconds == 0 && !isLoading;

  @override
  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    ForgetPasswordOperation? operation,
    String? otp,
    String? otpToken,
    String? email,
    int? remainingSeconds,
    bool? isLoading,
    Object? failure = unset,
    Object? data = unset,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      operation: operation ?? this.operation,
      otp: otp ?? this.otp,
      otpToken: otpToken ?? this.otpToken,
      email: email ?? this.email,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      failure: identical(failure, unset)
          ? this.failure
          : failure as AppFailure?,
      data: identical(data, unset) ? this.data : data,
    );
  }

  @override
  List<Object?> get props => [
    step,
    operation,
    otp,
    otpToken,
    email,
    remainingSeconds,
    isLoading,
    failure,
    data,
  ];
}
