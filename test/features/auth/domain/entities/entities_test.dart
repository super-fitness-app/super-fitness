import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

void main() {
  group('Domain Entities Tests', () {
    test('UserEntity supports value equality through props', () {
      const user1 = UserEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        gender: 'male',
        age: 25,
        weight: 75,
        height: 180,
        activityLevel: 'intermediate',
        goal: 'muscle',
      );

      const user2 = UserEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        gender: 'male',
        age: 25,
        weight: 75,
        height: 180,
        activityLevel: 'intermediate',
        goal: 'muscle',
      );

      expect(user1, equals(user2));
      expect(user1.props, equals(user2.props));
    });

    test('UserEntity handles null optional parameters safely', () {
      const user = UserEntity();

      expect(user.firstName, isNull);
      expect(user.email, isNull);
      expect(user.age, isNull);
      expect(user.props, contains(null));
    });

    test('RegisterEntity supports value equality and handles nested UserEntity', () {
      const entity1 = RegisterEntity(
        message: 'success',
        token: 'token_123',
        user: UserEntity(
          firstName: 'John',
          email: 'john@example.com',
        ),
      );

      const entity2 = RegisterEntity(
        message: 'success',
        token: 'token_123',
        user: UserEntity(
          firstName: 'John',
          email: 'john@example.com',
        ),
      );

      const entity3 = RegisterEntity(
        message: 'different',
        token: 'token_456',
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entity3)));
      expect(entity1.props, equals(['success', 'token_123', entity1.user]));
    });
  });
}

