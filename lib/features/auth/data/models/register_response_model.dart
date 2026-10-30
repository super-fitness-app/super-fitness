import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/auth/data/models/user_model.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';

export 'package:super_fitness/features/auth/data/models/user_model.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final String message;
  final UserModel user;
  final String token;

  RegisterResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  RegisterResponseModel copyWith({
    String? message,
    UserModel? user,
    String? token,
  }) => RegisterResponseModel(
    message: message ?? this.message,
    user: user ?? this.user,
    token: token ?? this.token,
  );

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);

  RegisterEntity toEntity() => RegisterEntity(
    message: message,
    token: token,
    user: user.toEntity(),
  );
}
