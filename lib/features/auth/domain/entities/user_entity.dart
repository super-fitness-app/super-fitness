import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? rePassword;
  final String? gender;
  final int? age;
  final int? weight;
  final int? height;
  final String? activityLevel;
  final String? goal;

  const UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
    gender,
    age,
    weight,
    height,
    activityLevel,
    goal,
  ];
}
