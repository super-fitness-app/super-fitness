import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/core/utils/safe_bool_parser.dart';

void main() {
  group('safeBool parser tests', () {
    test('returns null when value is null', () {
      expect(safeBool(null), isNull);
    });

    test('returns exact boolean when value is already a bool', () {
      expect(safeBool(true), isTrue);
      expect(safeBool(false), isFalse);
    });

    test('returns correct boolean when value is a num (SQLite 0/1 integers)', () {
      expect(safeBool(1), isTrue);
      expect(safeBool(0), isFalse);
      expect(safeBool(2), isTrue);
      expect(safeBool(-1), isTrue);
      expect(safeBool(0.0), isFalse);
      expect(safeBool(1.0), isTrue);
    });

    test('returns correct boolean when value is a string representation', () {
      expect(safeBool('true'), isTrue);
      expect(safeBool('TRUE'), isTrue);
      expect(safeBool(' True '), isTrue);
      expect(safeBool('1'), isTrue);
      expect(safeBool(' 1 '), isTrue);

      expect(safeBool('false'), isFalse);
      expect(safeBool('FALSE'), isFalse);
      expect(safeBool(' False '), isFalse);
      expect(safeBool('0'), isFalse);
      expect(safeBool(' 0 '), isFalse);
    });

    test('returns null for unrecognized string values or unsupported types', () {
      expect(safeBool(''), isNull);
      expect(safeBool('yes'), isNull);
      expect(safeBool('invalid'), isNull);
      expect(safeBool(['true']), isNull);
      expect(safeBool({'key': 'val'}), isNull);
    });
  });
}
