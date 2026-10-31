import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final int age;
  final double weight;
  final double height;
  final String activityLevel;
  final String goal;
  final String photo;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goal,
    required this.photo,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
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
        createdAt,
      ];
}
