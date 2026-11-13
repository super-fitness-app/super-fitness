import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, BaseEvent> {
  final ProfileRepo? _profileRepo;

  ProfileCubit([this._profileRepo])
      : super(BaseState<ProfileData>.success(const ProfileData()));

  @override
  void doEvent(Object event) {
    switch (event) {
      case UpdateWeightEvent():
        _onUpdateWeight(event);
      case UpdateGoalEvent():
        _onUpdateGoal(event);
      case UpdateActivityEvent():
        _onUpdateActivity(event);
      case SaveProfileEvent():
        _onSaveProfile(event);
      default:
        break;
    }
  }

  void updateFirstName(String value) {
    final current = state.data ?? const ProfileData();
    emit(BaseState.success(current.copyWith(firstName: value)));
  }

  void updateLastName(String value) {
    final current = state.data ?? const ProfileData();
    emit(BaseState.success(current.copyWith(lastName: value)));
  }

  void _onUpdateWeight(UpdateWeightEvent event) {
    final current = state.data ?? const ProfileData();
    emit(BaseState.success(current.copyWith(weight: event.weight)));
  }

  void _onUpdateGoal(UpdateGoalEvent event) {
    final current = state.data ?? const ProfileData();
    emit(BaseState.success(current.copyWith(goal: event.goal)));
  }

  void _onUpdateActivity(UpdateActivityEvent event) {
    final current = state.data ?? const ProfileData();
    emit(BaseState.success(current.copyWith(activityLevel: event.activityLevel)));
  }

  void _onSaveProfile(SaveProfileEvent event) {
    final current = state.data;
    if (current == null) return;
    _profileRepo?.updateProfile(
      firstName: current.firstName,
      lastName: current.lastName,
      weight: current.weight,
      goal: current.goal,
      activityLevel: current.activityLevel,
    );
  }
}
