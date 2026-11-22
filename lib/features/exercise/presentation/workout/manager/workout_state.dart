part of 'workout_cubit.dart';

typedef WorkoutState = BaseState<WorkoutData>;

class WorkoutData extends Equatable {
  final List<MuscleGroupEntity> groups;
  final String? selectedGroupId;
  final List<MuscleEntity> muscles;

  const WorkoutData({
    this.groups = const [],
    this.selectedGroupId,
    this.muscles = const [],
  });

  WorkoutData copyWith({
    List<MuscleGroupEntity>? groups,
    Object? selectedGroupId = _sentinel,
    List<MuscleEntity>? muscles,
  }) {
    return WorkoutData(
      groups: groups ?? this.groups,
      selectedGroupId: identical(selectedGroupId, _sentinel)
          ? this.selectedGroupId
          : selectedGroupId as String?,
      muscles: muscles ?? this.muscles,
    );
  }

  @override
  List<Object?> get props => [groups, selectedGroupId, muscles];
}

const Object _sentinel = Object();
