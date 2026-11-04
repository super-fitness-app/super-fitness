import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

void main() {
  group('AuthMapper Unit Tests', () {
    final now = DateTime(2025, 1, 1);

    final loginUser = LoginUser(
      id: 'u1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      gender: 'male',
      age: 30,
      weight: 80.5,
      height: 182.0,
      activityLevel: 'active',
      goal: 'fitness',
      photo: 'avatar.png',
      createdAt: now,
    );

    final loginResponse = LoginResponse(
      message: 'success',
      token: 'jwt_test_token',
      user: loginUser,
    );

    final userEntity = UserEntity(
      id: 'u1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      gender: 'male',
      age: 30,
      weight: 80.5,
      height: 182.0,
      activityLevel: 'active',
      goal: 'fitness',
      photo: 'avatar.png',
      createdAt: now,
    );

    test('toLoginEntity correctly maps LoginResponse to LoginEntity', () {
      final entity = AuthMapper.toLoginEntity(loginResponse);

      expect(entity.message, 'success');
      expect(entity.token, 'jwt_test_token');
      expect(entity.user.id, 'u1');
      expect(entity.user.firstName, 'John');
      expect(entity.user.lastName, 'Doe');
      expect(entity.user.email, 'john@example.com');
      expect(entity.user.gender, 'male');
      expect(entity.user.age, 30);
      expect(entity.user.weight, 80.5);
      expect(entity.user.height, 182.0);
      expect(entity.user.activityLevel, 'active');
      expect(entity.user.goal, 'fitness');
      expect(entity.user.photo, 'avatar.png');
      expect(entity.user.createdAt, now);
    });

    test('userEntityToModel maps UserEntity to UserModel', () {
      final model = AuthMapper.userEntityToModel(userEntity);

      expect(model.id, 'u1');
      expect(model.firstName, 'John');
      expect(model.lastName, 'Doe');
      expect(model.email, 'john@example.com');
      expect(model.weight, 80.5);
      expect(model.height, 182.0);
    });

    test('userEntityToJson and userEntityFromJson round-trip correctly', () {
      final json = AuthMapper.userEntityToJson(userEntity);
      expect(json['_id'], 'u1');
      expect(json['firstName'], 'John');
      expect(json['email'], 'john@example.com');
      expect(json['weight'], 80.5);
      expect(json['height'], 182.0);

      final restoredEntity = AuthMapper.userEntityFromJson(json);
      expect(restoredEntity.id, userEntity.id);
      expect(restoredEntity.firstName, userEntity.firstName);
      expect(restoredEntity.lastName, userEntity.lastName);
      expect(restoredEntity.email, userEntity.email);
      expect(restoredEntity.weight, userEntity.weight);
      expect(restoredEntity.height, userEntity.height);
    });
  });
}
