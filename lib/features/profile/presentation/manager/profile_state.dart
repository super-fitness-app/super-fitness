part of 'profile_cubit.dart';

typedef ProfileState = BaseState<ProfileData>;

class ProfileData extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final double weight;
  final String goal;
  final String activityLevel;

  const ProfileData({
    this.firstName = 'Ahmed',
    this.lastName = 'Mohamed',
    this.email = 'Ahmed@Gmail',
    this.weight = 90,
    this.goal = 'Gain Weight',
    this.activityLevel = 'Rookie',
  });

  ProfileData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    double? weight,
    String? goal,
    String? activityLevel,
  }) {
    return ProfileData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, email, weight, goal, activityLevel];
}
