import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

void main() {
  group('AppValidators Comprehensive Test Matrix', () {
    group('validateRequired', () {
      test('returns empty for null, empty or whitespace strings', () {
        expect(AppValidators.validateRequired(null), ValidationError.empty);
        expect(AppValidators.validateRequired(''), ValidationError.empty);
        expect(AppValidators.validateRequired('   '), ValidationError.empty);
      });

      test('returns null for non-empty text', () {
        expect(AppValidators.validateRequired('valid'), isNull);
        expect(AppValidators.validateRequired(' a '), isNull);
      });
    });

    group('validateEmail', () {
      test('returns empty for null or blank input', () {
        expect(AppValidators.validateEmail(null), ValidationError.empty);
        expect(AppValidators.validateEmail('  '), ValidationError.empty);
      });

      test('returns invalidEmail for malformed emails', () {
        expect(
          AppValidators.validateEmail('plainaddress'),
          ValidationError.invalidEmail,
        );
        expect(
          AppValidators.validateEmail('@missingusername.com'),
          ValidationError.invalidEmail,
        );
        expect(
          AppValidators.validateEmail('username@.com'),
          ValidationError.invalidEmail,
        );
        expect(
          AppValidators.validateEmail('username@domain'),
          ValidationError.invalidEmail,
        );
        expect(
          AppValidators.validateEmail('username@domain.c'),
          ValidationError.invalidEmail,
        );
      });

      test('returns null for valid emails (including trimmed input)', () {
        expect(AppValidators.validateEmail('test@example.com'), isNull);
        expect(
          AppValidators.validateEmail('user.name+tag@domain.co.uk'),
          isNull,
        );
        expect(AppValidators.validateEmail('  clean@domain.org  '), isNull);
      });
    });

    group('validatePhone', () {
      test('returns empty for null or blank input', () {
        expect(AppValidators.validatePhone(null), ValidationError.empty);
        expect(AppValidators.validatePhone(''), ValidationError.empty);
      });

      test('returns invalidPhone for boundary lengths and bad prefixes', () {
        // 10 digits (too short)
        expect(
          AppValidators.validatePhone('0101234567'),
          ValidationError.invalidPhone,
        );
        // 12 digits (too long)
        expect(
          AppValidators.validatePhone('010123456789'),
          ValidationError.invalidPhone,
        );
        // Invalid prefixes (013, 014, 016, 019)
        expect(
          AppValidators.validatePhone('01312345678'),
          ValidationError.invalidPhone,
        );
        expect(
          AppValidators.validatePhone('01412345678'),
          ValidationError.invalidPhone,
        );
        expect(
          AppValidators.validatePhone('01612345678'),
          ValidationError.invalidPhone,
        );
        // Contains letters or special characters
        expect(
          AppValidators.validatePhone('0101234567a'),
          ValidationError.invalidPhone,
        );
        expect(
          AppValidators.validatePhone('010-12345678'),
          ValidationError.invalidPhone,
        );
      });

      test(
        'returns null for valid Egyptian mobile numbers (010, 011, 012, 015)',
        () {
          expect(AppValidators.validatePhone('01012345678'), isNull);
          expect(AppValidators.validatePhone('01112345678'), isNull);
          expect(AppValidators.validatePhone('01212345678'), isNull);
          expect(AppValidators.validatePhone('01512345678'), isNull);
          expect(AppValidators.validatePhone('  01099998888  '), isNull);
        },
      );
    });

    group('validateNationalId', () {
      test('returns empty for null or blank input', () {
        expect(AppValidators.validateNationalId(null), ValidationError.empty);
        expect(AppValidators.validateNationalId(''), ValidationError.empty);
      });

      test(
        'returns invalidNationalId for non-14 digits or non-numeric input',
        () {
          // 13 digits (boundary minus 1)
          expect(
            AppValidators.validateNationalId('1234567890123'),
            ValidationError.invalidNationalId,
          );
          // 15 digits (boundary plus 1)
          expect(
            AppValidators.validateNationalId('123456789012345'),
            ValidationError.invalidNationalId,
          );
          // Special characters or letters
          expect(
            AppValidators.validateNationalId('1234567890123a'),
            ValidationError.invalidNationalId,
          );
          expect(
            AppValidators.validateNationalId('1234-5678-90123'),
            ValidationError.invalidNationalId,
          );
        },
      );

      test('returns null for exact 14 digits', () {
        expect(AppValidators.validateNationalId('12345678901234'), isNull);
        expect(AppValidators.validateNationalId('29901011234567'), isNull);
        expect(AppValidators.validateNationalId('  29901011234567  '), isNull);
      });
    });

    group('validatePassword', () {
      test('returns empty for null or empty input', () {
        expect(AppValidators.validatePassword(null), ValidationError.empty);
        expect(AppValidators.validatePassword(''), ValidationError.empty);
      });

      test('returns weakPassword if any requirement is unmet', () {
        // Too short (< 8 chars)
        expect(
          AppValidators.validatePassword('Aa1!'),
          ValidationError.weakPassword,
        );
        // Missing uppercase
        expect(
          AppValidators.validatePassword('lower123!@'),
          ValidationError.weakPassword,
        );
        // Missing lowercase
        expect(
          AppValidators.validatePassword('UPPER123!@'),
          ValidationError.weakPassword,
        );
        // Missing number
        expect(
          AppValidators.validatePassword('NoNumbers!@'),
          ValidationError.weakPassword,
        );
        // Missing special character
        expect(
          AppValidators.validatePassword('NoSpecialChar12'),
          ValidationError.weakPassword,
        );
      });

      test('returns null for strong password satisfying all rules', () {
        expect(AppValidators.validatePassword('StrongPass1@'), isNull);
        expect(AppValidators.validatePassword('Abcd#1234'), isNull);
      });
    });

    group('validatePasswordDetailed', () {
      test('returns granular failure reasons accurately', () {
        expect(
          AppValidators.validatePasswordDetailed(null),
          ValidationError.empty,
        );
        expect(
          AppValidators.validatePasswordDetailed(''),
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
    });

    group('validateConfirmPassword', () {
      test('returns empty when confirm password is null or empty', () {
        expect(
          AppValidators.validateConfirmPassword(null, 'password'),
          ValidationError.empty,
        );
        expect(
          AppValidators.validateConfirmPassword('', 'password'),
          ValidationError.empty,
        );
      });

      test('returns passwordMismatch when passwords differ', () {
        expect(
          AppValidators.validateConfirmPassword('pass1', 'pass2'),
          ValidationError.passwordMismatch,
        );
      });

      test('returns null when passwords match', () {
        expect(
          AppValidators.validateConfirmPassword('Password123!', 'Password123!'),
          isNull,
        );
      });
    });

    group('validateDropdown & validateFile', () {
      test('validateDropdown requires non-null selection', () {
        expect(
          AppValidators.validateDropdown(null),
          ValidationError.dropdownRequired,
        );
        expect(AppValidators.validateDropdown('Option'), isNull);
        expect(AppValidators.validateDropdown(123), isNull);
      });

      test(
        'validateFile requires file presence with fallback customization',
        () {
          expect(
            AppValidators.validateFile(null),
            ValidationError.fileRequired,
          );
          expect(
            AppValidators.validateFile(null, ValidationError.empty),
            ValidationError.empty,
          );
          expect(AppValidators.validateFile(File('path/file.png')), isNull);
        },
      );
    });

    group('validate & validateRegex caching', () {
      test(
        'validate matches regex pattern correctly and caches compiled RegExp',
        () {
          expect(AppValidators.validate(r'^\d+$', '12345'), isTrue);
          expect(AppValidators.validate(r'^\d+$', 'abc'), isFalse);
          // Call second time to hit cache
          expect(AppValidators.validate(r'^\d+$', '999'), isTrue);
        },
      );

      test('validateRegex uses pre-compiled RegExp directly', () {
        expect(
          AppValidators.validateRegex(
            AppValidators.emailRegex,
            'test@example.com',
          ),
          isTrue,
        );
        expect(
          AppValidators.validateRegex(AppValidators.emailRegex, 'bad'),
          isFalse,
        );
      });
    });
  });
}
