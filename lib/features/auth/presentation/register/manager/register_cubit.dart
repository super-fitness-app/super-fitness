import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, BaseEvent> {
  final RegisterUseCase _registerUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final PasswordGenerator _passwordGenerator;

  RegisterCubit(
    this._registerUseCase,
    this._signInWithGoogleUseCase,
    this._passwordGenerator,
  ) : super(const RegisterState());

  @override
  void doEvent(Object event) {
    if (event is! RegisterEvent) return;
    switch (event) {
      case SubmitBasicInfoEvent():
        _onSubmitBasicInfo(event);
      case SignInWithGoogleEvent():
        _onSignInWithGoogle();
      case UpdateGenderEvent():
        _onUpdateGender(event);
      case UpdateAgeEvent():
        _onUpdateAge(event);
      case UpdateWeightEvent():
        _onUpdateWeight(event);
      case UpdateHeightEvent():
        _onUpdateHeight(event);
      case UpdateGoalEvent():
        _onUpdateGoal(event);
      case UpdateActivityLevelEvent():
        _onUpdateActivityLevel(event);
      case SubmitFinalRegistrationEvent():
        _onSubmitFinalRegistration();
      case ResetRegistrationEvent():
        _onResetRegistration();
    }
  }

  // ===========================================================================
  // Step 1: Basic Info
  // ===========================================================================

  void _onSubmitBasicInfo(SubmitBasicInfoEvent event) {
    final updatedData = state.data.copyWith(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      rePassword: event.rePassword ?? event.password,
    );

    emit(state.copyWith(data: updatedData));
  }

  void submitBasicInfoIntent({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? rePassword,
  }) {
    doEvent(
      SubmitBasicInfoEvent(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        rePassword: rePassword,
      ),
    );
  }

  // ===========================================================================
  // Step 2: Gender Selection
  // ===========================================================================

  void _onUpdateGender(UpdateGenderEvent event) {
    emit(state.copyWith(data: state.data.copyWith(gender: event.gender)));
  }

  void updateGenderIntent(String gender) {
    doEvent(UpdateGenderEvent(gender));
  }

  // ===========================================================================
  // Step 3: Age Selection
  // ===========================================================================

  void _onUpdateAge(UpdateAgeEvent event) {
    emit(state.copyWith(data: state.data.copyWith(age: event.age)));
  }

  void updateAgeIntent(int age) {
    doEvent(UpdateAgeEvent(age));
  }

  // ===========================================================================
  // Step 4: Weight Selection
  // ===========================================================================

  void _onUpdateWeight(UpdateWeightEvent event) {
    emit(state.copyWith(data: state.data.copyWith(weight: event.weight)));
  }

  void updateWeightIntent(int weight) {
    doEvent(UpdateWeightEvent(weight));
  }

  // ===========================================================================
  // Step 5: Height Selection
  // ===========================================================================

  void _onUpdateHeight(UpdateHeightEvent event) {
    emit(state.copyWith(data: state.data.copyWith(height: event.height)));
  }

  void updateHeightIntent(int height) {
    doEvent(UpdateHeightEvent(height));
  }

  // ===========================================================================
  // Step 6: Fitness Goal
  // ===========================================================================

  void _onUpdateGoal(UpdateGoalEvent event) {
    emit(state.copyWith(data: state.data.copyWith(goal: event.goal)));
  }

  void updateGoalIntent(String goal) {
    doEvent(UpdateGoalEvent(goal));
  }

  // ===========================================================================
  // Step 7: Activity Level
  // ===========================================================================

  void _onUpdateActivityLevel(UpdateActivityLevelEvent event) {
    emit(state.copyWith(data: state.data.copyWith(activityLevel: event.activityLevel)));
  }

  void updateActivityLevelIntent(String activityLevel) {
    doEvent(UpdateActivityLevelEvent(activityLevel));
  }

  // ===========================================================================
  // Step 8: Final Submission API Call
  // ===========================================================================

  Future<void> _onSubmitFinalRegistration() async {
    final params = state.data.toParams();
    if (params == null) {
      emit(
        state.copyWith(
          registerState: BaseState.error(AppStrings.missingRegistrationData),
        ),
      );
      emitEvent(const DisplayError(AppStrings.missingRegistrationData));
      return;
    }

    emit(state.copyWith(registerState: BaseState.loading()));

    final result = await _registerUseCase(params);
    switch (result) {
      case Success():
        emit(state.copyWith(registerState: BaseState.success(null)));
        emitEvent(const DisplaySuccess(AppStrings.registeredSuccessfully));
      case FailureResponse(:final failure):
        emit(state.copyWith(registerState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> submitFinalRegistrationIntent() => _onSubmitFinalRegistration();

  // ===========================================================================
  // Reset Flow
  // ===========================================================================

  void _onResetRegistration() {
    emit(const RegisterState());
  }

  void resetRegistrationIntent() {
    doEvent(const ResetRegistrationEvent());
  }

  // ===========================================================================
  // Social Auth: Google Sign-In
  // ===========================================================================

  Future<void> _onSignInWithGoogle() async {
    emit(state.copyWith(registerState: BaseState.loading()));

    final googleResult = await _signInWithGoogleUseCase();
    switch (googleResult) {
      case Success(:final data):
        // Validate Google user ID to prevent null/empty issues
        final userId = data.id;
        if (userId == null || userId.trim().isEmpty) {
          emit(
            state.copyWith(
              registerState: BaseState.error(AppStrings.googleAccountIdMissing),
            ),
          );
          emitEvent(const DisplayError(AppStrings.googleAccountIdMissing));
          return;
        }

        // 1. Generate deterministic password: prefix + Hash(userId + secretKey)
        final generatedPassword = _passwordGenerator.generate(userId);

        // 2. Parse display name into firstName and lastName
        final names = data.displayName.trim().split(RegExp(r'\s+'));
        final firstName = names.isNotEmpty && names.first.isNotEmpty
            ? names.first
            : (state.data.firstName ?? 'User');
        final lastName = names.length > 1
            ? names.sublist(1).join(' ')
            : (state.data.lastName ?? firstName);

        // 3. Save name, email, and generated password into Cubit's state (RegisterData)
        final updatedData = state.data.copyWith(
          firstName: firstName,
          lastName: lastName,
          email: data.email,
          password: generatedPassword,
          rePassword: generatedPassword,
        );

        emit(
          state.copyWith(
            data: updatedData,
            registerState: BaseState.success(null),
          ),
        );
        emitEvent(
          const DisplaySuccess(AppStrings.googleAccountConnected),
        );
        emitEvent(
          NavigateEvent(AppRoutes.completeRegister, extra: this),
        );

      case FailureResponse(:final failure):
        emit(state.copyWith(registerState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> signInWithGoogleIntent() => _onSignInWithGoogle();
}
