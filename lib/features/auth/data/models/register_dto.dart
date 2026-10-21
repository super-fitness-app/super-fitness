import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'register_dto.g.dart';

RegisterDto registerDtoFromJson(String str) =>
    RegisterDto.fromJson(json.decode(str));

String registerDtoToJson(RegisterDto data) => json.encode(data.toJson());

@JsonSerializable()
class RegisterDto extends Equatable {
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "rePassword")
  final String rePassword;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "height")
  final int height;
  @JsonKey(name: "weight")
  final int weight;
  @JsonKey(name: "age")
  final int age;
  @JsonKey(name: "goal")
  final String goal;
  @JsonKey(name: "activityLevel")
  final String activityLevel;

  const RegisterDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.activityLevel,
  });

  RegisterDto copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? rePassword,
    String? gender,
    int? height,
    int? weight,
    int? age,
    String? goal,
    String? activityLevel,
  }) => RegisterDto(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    password: password ?? this.password,
    rePassword: rePassword ?? this.rePassword,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    age: age ?? this.age,
    goal: goal ?? this.goal,
    activityLevel: activityLevel ?? this.activityLevel,
  );

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
    gender,
    height,
    weight,
    age,
    goal,
    activityLevel,
  ];
}
