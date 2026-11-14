import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "age")
  final int age;
  @JsonKey(name: "weight")
  final double? weight;
  @JsonKey(name: "height")
  final double? height;
  @JsonKey(name: "activityLevel")
  final String activityLevel;
  @JsonKey(name: "goal")
  final String goal;
  @JsonKey(name: "photo")
  final String photo;
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.age,
    this.weight,
    this.height,
    required this.activityLevel,
    required this.goal,
    required this.photo,
    required this.id,
    required this.createdAt,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? activityLevel,
    String? goal,
    String? photo,
    String? id,
    DateTime? createdAt,
  }) => UserModel(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    activityLevel: activityLevel ?? this.activityLevel,
    goal: goal ?? this.goal,
    photo: photo ?? this.photo,
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    firstName: entity.firstName ?? '',
    lastName: entity.lastName ?? '',
    email: entity.email ?? '',
    gender: entity.gender ?? '',
    age: entity.age ?? 0,
    weight: entity.weight,
    height: entity.height,
    activityLevel: entity.activityLevel ?? '',
    goal: entity.goal ?? '',
    photo: entity.photo ?? '',
    id: entity.id ?? '',
    createdAt: entity.createdAt ?? DateTime.now(),
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    gender: gender,
    age: age,
    weight: weight,
    height: height,
    activityLevel: activityLevel,
    goal: goal,
    photo: photo,
    createdAt: createdAt,
  );
}