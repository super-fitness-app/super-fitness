import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';

void main() {
  group('RegisterResponseModel Tests', () {
    final testUser = UserModel(
      firstName: 'Sam',
      lastName: 'Wilson',
      email: 'sam@example.com',
      gender: 'male',
      age: 30,
      weight: 80,
      height: 185,
      activityLevel: 'intermediate',
      goal: 'fitness',
      photo: 'sam.png',
      id: 'sam_123',
      createdAt: DateTime(2025, 2, 1),
    );

    final responseModel = RegisterResponseModel(
      message: 'User registered successfully',
      token: 'jwt_secure_token_abc',
      user: testUser,
    );

    test('toEntity maps cleanly to RegisterEntity and nested UserEntity', () {
      final entity = responseModel.toEntity();

      expect(entity, isA<RegisterEntity>());
      expect(entity.message, 'User registered successfully');
      expect(entity.token, 'jwt_secure_token_abc');
      expect(entity.user, isNotNull);
      expect(entity.user?.firstName, 'Sam');
      expect(entity.user?.email, 'sam@example.com');
      expect(entity.user?.goal, 'fitness');
    });

    test('copyWith updates specified fields only', () {
      final updated = responseModel.copyWith(message: 'Updated message');

      expect(updated.message, 'Updated message');
      expect(updated.token, 'jwt_secure_token_abc');
      expect(updated.user.id, 'sam_123');
    });

    test('toJson generates expected map structure', () {
      final json = responseModel.toJson();

      expect(json['message'], 'User registered successfully');
      expect(json['token'], 'jwt_secure_token_abc');
      expect(json['user'], isNotNull);
    });
  });
}
