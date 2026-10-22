import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/data/models/user_model.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel Tests', () {
    final testDate = DateTime(2025, 1, 15);
    final userModel = UserModel(
      firstName: 'Alex',
      lastName: 'Morgan',
      email: 'alex@example.com',
      gender: 'female',
      age: 26,
      weight: 65,
      height: 172,
      activityLevel: 'advanced',
      goal: 'endurance',
      photo: 'alex_avatar.png',
      id: 'user_id_999',
      createdAt: testDate,
    );

    test('toEntity maps all matching fields to UserEntity', () {
      final entity = userModel.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.firstName, 'Alex');
      expect(entity.lastName, 'Morgan');
      expect(entity.email, 'alex@example.com');
      expect(entity.gender, 'female');
      expect(entity.age, 26);
      expect(entity.weight, 65);
      expect(entity.height, 172);
      expect(entity.activityLevel, 'advanced');
      expect(entity.goal, 'endurance');
    });

    test('copyWith updates specified fields only', () {
      final updated = userModel.copyWith(
        firstName: 'Alexandra',
        weight: 63,
      );

      expect(updated.firstName, 'Alexandra');
      expect(updated.weight, 63);
      expect(updated.lastName, 'Morgan');
      expect(updated.id, 'user_id_999');
    });

    test('toJson produces expected map', () {
      final json = userModel.toJson();

      expect(json['firstName'], 'Alex');
      expect(json['lastName'], 'Morgan');
      expect(json['email'], 'alex@example.com');
      expect(json['_id'], 'user_id_999');
      expect(json['photo'], 'alex_avatar.png');
    });
  });
}

