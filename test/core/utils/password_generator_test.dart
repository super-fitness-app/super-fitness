import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/password_generator.dart';

void main() {
  group('PasswordGenerator Unit Tests', () {
    const generator = PasswordGenerator.custom(
      secretKey: 'TestSecretKey123#',
      prefix: 'SuperFit@2026#',
    );

    test('generates password with expected prefix and 10 char hash', () {
      final password = generator.generate('user_abc_123');

      expect(password.startsWith('SuperFit@2026#'), isTrue);
      expect(password.length, equals('SuperFit@2026#'.length + 10));
    });

    test('is deterministic for the same userId', () {
      final pass1 = generator.generate('user_abc_123');
      final pass2 = generator.generate('user_abc_123');

      expect(pass1, equals(pass2));
    });

    test('produces different passwords for different userIds', () {
      final pass1 = generator.generate('user_1');
      final pass2 = generator.generate('user_2');

      expect(pass1, isNot(equals(pass2)));
    });

    test('produces alphanumeric hash suffix only', () {
      final password = generator.generate('user_special!@#\$%^&*()');
      final suffix = password.substring('SuperFit@2026#'.length);

      expect(RegExp(r'^[a-zA-Z0-9]{10}$').hasMatch(suffix), isTrue);
    });
  });
}

