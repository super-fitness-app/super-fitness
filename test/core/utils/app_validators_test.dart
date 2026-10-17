import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

void main() {
  group('AppValidators Unit Tests', () {
    test('validateRequired returns empty for null or blank input', () {
      expect(AppValidators.validateRequired(null), ValidationError.empty);
      expect(AppValidators.validateRequired('   '), ValidationError.empty);
      expect(AppValidators.validateRequired('valid'), isNull);
    });

    test('validateEmail validates email formats correctly', () {
      expect(AppValidators.validateEmail(null), ValidationError.empty);
      expect(
        AppValidators.validateEmail('invalid-email'),
        ValidationError.invalidEmail,
      );
      expect(
        AppValidators.validateEmail('test@test'),
        ValidationError.invalidEmail,
      );
      expect(AppValidators.validateEmail('test@example.com'), isNull);
    });

    test('validatePhone validates Egyptian phone numbers', () {
      expect(AppValidators.validatePhone(null), ValidationError.empty);
      expect(
        AppValidators.validatePhone('12345'),
        ValidationError.invalidPhone,
      );
      expect(AppValidators.validatePhone('01012345678'), isNull);
      expect(AppValidators.validatePhone('01112345678'), isNull);
      expect(AppValidators.validatePhone('01212345678'), isNull);
      expect(AppValidators.validatePhone('01512345678'), isNull);
    });

    test('validateNationalId validates 14 digits', () {
      expect(AppValidators.validateNationalId(null), ValidationError.empty);
      expect(
        AppValidators.validateNationalId('123'),
        ValidationError.invalidNationalId,
      );
      expect(AppValidators.validateNationalId('12345678901234'), isNull);
    });

    test('validatePassword validates strong passwords', () {
      expect(AppValidators.validatePassword(null), ValidationError.empty);
      expect(
        AppValidators.validatePassword('weak'),
        ValidationError.weakPassword,
      );
      expect(AppValidators.validatePassword('StrongPass1@'), isNull);
    });

    test('validatePasswordDetailed identifies missing rules', () {
      expect(
        AppValidators.validatePasswordDetailed(null),
        ValidationError.empty,
      );
      expect(
        AppValidators.validatePasswordDetailed('short'),
        ValidationError.passwordTooShort,
      );
      expect(
        AppValidators.validatePasswordDetailed('alllowercase1@'),
        ValidationError.passwordMissingUppercase,
      );
      expect(
        AppValidators.validatePasswordDetailed('ALLUPPERCASE1@'),
        ValidationError.passwordMissingLowercase,
      );
      expect(
        AppValidators.validatePasswordDetailed('NoNumberPass@'),
        ValidationError.passwordMissingNumber,
      );
      expect(
        AppValidators.validatePasswordDetailed('NoSpecialChar12'),
        ValidationError.passwordMissingSpecialChar,
      );
      expect(AppValidators.validatePasswordDetailed('ValidPass123!'), isNull);
    });

    test('validateConfirmPassword checks match', () {
      expect(
        AppValidators.validateConfirmPassword('pass1', 'pass2'),
        ValidationError.passwordMismatch,
      );
      expect(AppValidators.validateConfirmPassword('pass1', 'pass1'), isNull);
    });

    test('validateDropdown checks null value', () {
      expect(
        AppValidators.validateDropdown(null),
        ValidationError.dropdownRequired,
      );
      expect(AppValidators.validateDropdown('Selected'), isNull);
    });
  });
}
