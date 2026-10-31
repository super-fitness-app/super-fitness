import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? rePassword;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? goal;
  final String? photo;
  final DateTime? createdAt;

  const UserEntity({
    this.id,
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
    this.photo,
    this.createdAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'rePassword': rePassword,
    'gender': gender,
    'age': age,
    'weight': weight,
    'height': height,
    'activityLevel': activityLevel,
    'goal': goal,
    'photo': photo,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'] as String?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    email: json['email'] as String?,
    password: json['password'] as String?,
    rePassword: json['rePassword'] as String?,
    gender: json['gender'] as String?,
    age: (json['age'] as num?)?.toInt(),
    weight: (json['weight'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    activityLevel: json['activityLevel'] as String?,
    goal: json['goal'] as String?,
    photo: json['photo'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String)
        : null,
  );

  @override
  List<Object?> get props => [
    id,
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
    photo,
    createdAt,
  ];
}
