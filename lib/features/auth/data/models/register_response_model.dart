import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'register_response_model.g.dart';

RegisterResponseModel registerResponseModelFromJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RegisterResponseModel {
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "user")
  final User user;
  @JsonKey(name: "token")
  final String token;

  RegisterResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  RegisterResponseModel copyWith({
    String? message,
    User? user,
    String? token,
  }) => RegisterResponseModel(
    message: message ?? this.message,
    user: user ?? this.user,
    token: token ?? this.token,
  );

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

@JsonSerializable()
class User {
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
  final int weight;
  @JsonKey(name: "height")
  final int height;
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

  User({
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
    required this.id,
    required this.createdAt,
  });

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    int? age,
    int? weight,
    int? height,
    String? activityLevel,
    String? goal,
    String? photo,
    String? id,
    DateTime? createdAt,
  }) => User(
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
