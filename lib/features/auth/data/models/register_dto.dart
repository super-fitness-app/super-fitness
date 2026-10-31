import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final int height;
  final int weight;
  final int age;
  final String goal;
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

  factory RegisterDto.fromDomain(RegisterParams params) => RegisterDto(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        password: params.password,
        rePassword: params.rePassword,
        gender: params.gender,
        height: params.height,
        weight: params.weight,
        age: params.age,
        goal: params.goal,
        activityLevel: params.activityLevel,
      );

  RegisterParams toDomain() => RegisterParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        rePassword: rePassword,
        gender: gender,
        height: height,
        weight: weight,
        age: age,
        goal: goal,
        activityLevel: activityLevel,
      );

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
