
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String message;
  final LoginUser user;
  final String token;

  const LoginResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
 
@JsonSerializable()
class LoginUser {
  @JsonKey(name: '_id')
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

  const LoginUser({
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

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}
