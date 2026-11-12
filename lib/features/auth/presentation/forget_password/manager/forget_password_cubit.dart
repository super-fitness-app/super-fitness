import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, BaseEvent> {
  ForgetPasswordCubit(
    this._forgetPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(const ForgetPasswordState());

  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  Timer? _timer;

  @override
  void doEvent(Object event) {
    if (event is CheckEmailEvent) {
      _onCheckEmail(event);
    } else if (event is VerifyOtpEvent) {
      _onVerifyOtp(event);
    } else if (event is ResendOtpEvent) {
      _onResendOtp();
    } else if (event is ResetPasswordEvent) {
      _onResetPassword(event);
    } else if (event is OtpChangedEvent) {
      _onOtpChanged(event);
    } else if (event is StartOtpTimerEvent) {
      _onStartOtpTimer();
    } else if (event is TickOtpTimerEvent) {
      _onTickOtpTimer();
    }
  }

  // Check Email
  Future<void> _onCheckEmail(CheckEmailEvent event) async {
    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.checkEmail,
        failure: null,
      ),
    );

    final result = await _forgetPasswordUseCase.execute(email: event.email);

    if (result is Success) {
      emit(
        state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.otp,
          operation: ForgetPasswordOperation.checkEmail,
          email: event.email,
          otp: '',
          remainingSeconds: 30,
          failure: null,
        ),
      );

      _onStartOtpTimer();
    } else if (result is Failure) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.checkEmail,
          failure: result.failure,
        ),
      );
      emitEvent(DisplayError.fromFailure(result.failure));
    }
  }

  // Resend OTP
  Future<void> _onResendOtp() async {
    if (state.email == null || !state.canResend || state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.resendOtp,
        failure: null,
      ),
    );

    final result = await _forgetPasswordUseCase.execute(email: state.email!);

    if (result is Success) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resendOtp,
          remainingSeconds: 30,
          failure: null,
        ),
      );

      _onStartOtpTimer();
    } else if (result is Failure) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resendOtp,
          failure: result.failure,
        ),
      );
      emitEvent(DisplayError.fromFailure(result.failure));
    }
  }

  // Verify OTP
  Future<void> _onVerifyOtp(VerifyOtpEvent event) async {
    if (state.email == null || state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.verifyOtp,
        otp: event.otp,
        failure: null,
      ),
    );

    final result = await _verifyOtpUseCase.execute(
      email: state.email!,
      otp: event.otp,
    );

    if (result is Success<Map<String, dynamic>>) {
      emit(
        state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.resetPassword,
          operation: ForgetPasswordOperation.verifyOtp,
          otpToken: result.data['otpToken']?.toString() ?? '',
          failure: null,
        ),
      );
    } else if (result is Failure<Map<String, dynamic>>) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.verifyOtp,
          failure: result.failure,
        ),
      );
    }
  }

  // Reset Password
  Future<void> _onResetPassword(ResetPasswordEvent event) async {
    if (state.otpToken.isEmpty || state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        operation: ForgetPasswordOperation.resetPassword,
        failure: null,
      ),
    );

    final result = await _resetPasswordUseCase.execute(
      otpToken: state.otpToken,
      password: event.password,
      confirmPassword: event.password,
    );

    if (result is Success) {
      _timer?.cancel();

      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resetPassword,
          failure: null,
        ),
      );
    } else if (result is Failure) {
      emit(
        state.copyWith(
          isLoading: false,
          operation: ForgetPasswordOperation.resetPassword,
          failure: result.failure,
        ),
      );
    }
  }

  // OTP Changed
  void _onOtpChanged(OtpChangedEvent event) {
    emit(state.copyWith(otp: event.otp, failure: null));
  }

  // Start Timer
  void _onStartOtpTimer() {
    _timer?.cancel();

    emit(state.copyWith(remainingSeconds: 30));

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _onTickOtpTimer(),
    );
  }

  // Timer Tick
  void _onTickOtpTimer() {
    if (state.remainingSeconds <= 1) {
      _timer?.cancel();

      emit(state.copyWith(remainingSeconds: 0));

      return;
    }

    emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
