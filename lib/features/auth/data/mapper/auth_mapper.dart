
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/data/models/user_model.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

abstract final class AuthMapper {
  static LoginEntity toLoginEntity(LoginResponse response) {
    return LoginEntity(
      message: response.message,
      token: response.token,
      user: loginUserToEntity(response.user),
    );
  }

  static UserEntity loginUserToEntity(LoginUser user) {
    return UserEntity(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      gender: user.gender,
      age: user.age,
      weight: user.weight,
      height: user.height,
      activityLevel: user.activityLevel,
      goal: user.goal,
      photo: user.photo,
      createdAt: user.createdAt,
    );
  }

  static UserModel userEntityToModel(UserEntity entity) =>
      UserModel.fromEntity(entity);

  static Map<String, dynamic> userEntityToJson(UserEntity entity) =>
      UserModel.fromEntity(entity).toJson();

  static UserEntity userEntityFromJson(Map<String, dynamic> json) =>
      UserModel.fromJson(json).toEntity();
}
