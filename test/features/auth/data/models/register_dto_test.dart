import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';

void main() {
  group('RegisterDto Tests', () {
    const testDto = RegisterDto(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      password: 'Password123!',
      rePassword: 'Password123!',
      gender: 'male',
      height: 180,
      weight: 75,
      age: 25,
      goal: 'muscle',
      activityLevel: 'intermediate',
    );

    test('fromDomain and toDomain convert correctly between DTO and Domain', () {
      const params = RegisterParams(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'Password123!',
        rePassword: 'Password123!',
        gender: 'male',
        height: 180,
        weight: 75,
        age: 25,
        goal: 'muscle',
        activityLevel: 'intermediate',
      );

      final dto = RegisterDto.fromDomain(params);
      expect(dto, equals(testDto));

      final convertedParams = dto.toDomain();
      expect(convertedParams, equals(params));
    });

    test('toJson generates correct JSON map', () {
      final json = testDto.toJson();

      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Doe');
      expect(json['email'], 'john.doe@example.com');
      expect(json['password'], 'Password123!');
      expect(json['rePassword'], 'Password123!');
      expect(json['gender'], 'male');
      expect(json['height'], 180);
      expect(json['weight'], 75);
      expect(json['age'], 25);
      expect(json['goal'], 'muscle');
      expect(json['activityLevel'], 'intermediate');
    });

    test('fromJson parses JSON map correctly', () {
      final json = {
        'firstName': 'Jane',
        'lastName': 'Smith',
        'email': 'jane.smith@example.com',
        'password': 'SecurePassword!',
        'rePassword': 'SecurePassword!',
        'gender': 'female',
        'height': 165,
        'weight': 60,
        'age': 28,
        'goal': 'weight_loss',
        'activityLevel': 'beginner',
      };

      final dto = RegisterDto.fromJson(json);

      expect(dto.firstName, 'Jane');
      expect(dto.lastName, 'Smith');
      expect(dto.email, 'jane.smith@example.com');
      expect(dto.gender, 'female');
      expect(dto.height, 165);
      expect(dto.weight, 60);
      expect(dto.age, 28);
      expect(dto.goal, 'weight_loss');
      expect(dto.activityLevel, 'beginner');
    });

    test('copyWith updates specified fields only', () {
      final updated = testDto.copyWith(
        firstName: 'Johnny',
        weight: 80,
      );

      expect(updated.firstName, 'Johnny');
      expect(updated.weight, 80);
      expect(updated.lastName, 'Doe');
      expect(updated.email, 'john.doe@example.com');
    });

    test('props equality works as expected', () {
      const duplicateDto = RegisterDto(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'Password123!',
        rePassword: 'Password123!',
        gender: 'male',
        height: 180,
        weight: 75,
        age: 25,
        goal: 'muscle',
        activityLevel: 'intermediate',
      );

      expect(testDto, equals(duplicateDto));
    });
  });
}

