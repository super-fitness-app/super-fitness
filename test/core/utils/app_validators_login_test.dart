import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

void main() {
  group('AppValidators.validateLoginPassword', () {
    test('returns empty for null or empty string', () {
      expect(AppValidators.validateLoginPassword(null), ValidationError.empty);
      expect(AppValidators.validateLoginPassword(''), ValidationError.empty);
    });

    test('returns invalidLoginPassword when length is less than 6', () {
      expect(
        AppValidators.validateLoginPassword('P1a'),
        ValidationError.invalidLoginPassword,
      );
      expect(
        AppValidators.validateLoginPassword('Pass1'),
        ValidationError.invalidLoginPassword,
      );
    });

    test('returns invalidLoginPassword when uppercase letter is missing', () {
      expect(
        AppValidators.validateLoginPassword('password123'),
        ValidationError.invalidLoginPassword,
      );
    });

    test('returns invalidLoginPassword when number is missing', () {
      expect(
        AppValidators.validateLoginPassword('PasswordABC'),
        ValidationError.invalidLoginPassword,
      );
    });

    test('returns null when password satisfies all criteria', () {
      expect(AppValidators.validateLoginPassword('Pass12'), isNull);
      expect(AppValidators.validateLoginPassword('StrongPass1'), isNull);
    });
  });
}
