import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String? message;
  final String? token;
  final UserEntity? user;

  const RegisterEntity({
    this.message,
    this.token,
    this.user,
  });

  @override
  List<Object?> get props => [message, token, user];
}

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final int? age;
  final int? weight;
  final int? height;
  final String? activityLevel;
  final String? goal;
  final String? photo;
  final String? id;
  final DateTime? createdAt;

  const UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
    this.photo,
    this.id,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    gender,
    age,
    weight,
    height,
    activityLevel,
    goal,
    photo,
    id,
    createdAt,
  ];
}

