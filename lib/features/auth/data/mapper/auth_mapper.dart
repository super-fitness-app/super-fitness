import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

abstract final class AuthMapper {
  static LoginEntity toLoginEntity(LoginResponse response) {
    return LoginEntity(
      message: response.message,
      token: response.token,
      user: UserEntity(
        id: response.user.id,
        firstName: response.user.firstName,
        lastName: response.user.lastName,
        email: response.user.email,
        gender: response.user.gender,
        age: response.user.age,
        weight: response.user.weight,
        height: response.user.height,
        activityLevel: response.user.activityLevel,
        goal: response.user.goal,
        photo: response.user.photo,
        createdAt: response.user.createdAt,
      ),
    );
  }
}