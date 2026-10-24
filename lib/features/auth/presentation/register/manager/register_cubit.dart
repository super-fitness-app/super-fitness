import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, BaseEvent> {
  final RegisterUseCase? _registerUseCase;

  RegisterCubit([this._registerUseCase])
    : super(const BaseState<RegisterData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case SubmitBasicInfoEvent():
        _onSubmitBasicInfo(event);
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
      default:
        break;
    }
  }

  // ===========================================================================
  // Step 1: Basic Info
  // ===========================================================================

  void _onSubmitBasicInfo(SubmitBasicInfoEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      rePassword: event.rePassword ?? event.password,
    );

    emit(BaseState.success(updatedData));
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
  // Step 2: Gender
  // ===========================================================================

  void _onUpdateGender(UpdateGenderEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      gender: event.gender,
    );
    emit(BaseState.success(updatedData));
  }

  void updateGenderIntent(String gender) {
    doEvent(UpdateGenderEvent(gender));
  }

  // ===========================================================================
  // Step 3: Age
  // ===========================================================================

  void _onUpdateAge(UpdateAgeEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      age: event.age,
    );
    emit(BaseState.success(updatedData));
  }

  void updateAgeIntent(int age) {
    doEvent(UpdateAgeEvent(age));
  }

  // ===========================================================================
  // Step 4: Weight
  // ===========================================================================

  void _onUpdateWeight(UpdateWeightEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      weight: event.weight,
    );
    emit(BaseState.success(updatedData));
  }

  void updateWeightIntent(int weight) {
    doEvent(UpdateWeightEvent(weight));
  }

  // ===========================================================================
  // Step 5: Height
  // ===========================================================================

  void _onUpdateHeight(UpdateHeightEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      height: event.height,
    );
    emit(BaseState.success(updatedData));
  }

  void updateHeightIntent(int height) {
    doEvent(UpdateHeightEvent(height));
  }

  // ===========================================================================
  // Step 6: Fitness Goal
  // ===========================================================================

  void _onUpdateGoal(UpdateGoalEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      goal: event.goal,
    );
    emit(BaseState.success(updatedData));
  }

  void updateGoalIntent(String goal) {
    doEvent(UpdateGoalEvent(goal));
  }

  // ===========================================================================
  // Step 7: Activity Level
  // ===========================================================================

  void _onUpdateActivityLevel(UpdateActivityLevelEvent event) {
    final updatedData = (state.data ?? const RegisterData()).copyWith(
      activityLevel: event.activityLevel,
    );
    emit(BaseState.success(updatedData));
  }

  void updateActivityLevelIntent(String activityLevel) {
    doEvent(UpdateActivityLevelEvent(activityLevel));
  }

  // ===========================================================================
  // Step 8: Final Submission API Call
  // ===========================================================================

  Future<void> _onSubmitFinalRegistration() async {
    final data = state.data;
    if (data == null) return;

    final dto = data.toDto();
    if (dto == null) {
      emit(BaseState.error(AppStrings.missingRegistrationData, data: data));
      emitEvent(const DisplayError(AppStrings.missingRegistrationData));
      return;
    }

    if (_registerUseCase == null) return;

    emit(BaseState.loading(data: data));

    final result = await _registerUseCase(dto);
    switch (result) {
      case Success():
        emit(BaseState.success(data));
        emitEvent(const DisplaySuccess(AppStrings.registeredSuccessfully));
      case FailureResponse(:final failure):
        emit(BaseState.failure(failure, data: data));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  void submitFinalRegistrationIntent() {
    doEvent(const SubmitFinalRegistrationEvent());
  }

  // ===========================================================================
  // Reset Flow
  // ===========================================================================

  void _onResetRegistration() {
    emit(const BaseState<RegisterData>.initial());
  }

  void resetRegistrationIntent() {
    doEvent(const ResetRegistrationEvent());
  }
}
