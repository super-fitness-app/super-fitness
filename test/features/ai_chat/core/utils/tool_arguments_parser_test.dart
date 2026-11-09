import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/core/utils/tool_arguments_parser.dart';

void main() {
  const parser = ToolArgumentParser();

  group('ToolArgumentParser Tests', () {
    test('getString returns trimmed non-empty string or null', () {
      expect(parser.getString({'key': ' value '}, 'key'), equals('value'));
      expect(parser.getString({'key': '   '}, 'key'), isNull);
      expect(parser.getString({}, 'missing'), isNull);
    });

    test('getDouble handles numbers, numeric strings, and invalid inputs', () {
      expect(parser.getDouble({'val': 42}, 'val'), equals(42.0));
      expect(parser.getDouble({'val': 3.14}, 'val'), equals(3.14));
      expect(parser.getDouble({'val': ' 99.5 '}, 'val'), equals(99.5));
      expect(parser.getDouble({'val': 'invalid'}, 'val'), isNull);
      expect(parser.getDouble({}, 'missing'), isNull);
    });

    test('getInt handles ints, doubles, strings, and invalid inputs', () {
      expect(parser.getInt({'val': 42}, 'val'), equals(42));
      expect(parser.getInt({'val': 42.9}, 'val'), equals(42));
      expect(parser.getInt({'val': ' 100 '}, 'val'), equals(100));
      expect(parser.getInt({'val': 'invalid'}, 'val'), isNull);
      expect(parser.getInt({}, 'missing'), isNull);
    });

    test('getBool handles boolean, integers, and boolean strings', () {
      expect(parser.getBool({'val': true}, 'val'), isTrue);
      expect(parser.getBool({'val': false}, 'val'), isFalse);
      expect(parser.getBool({'val': 1}, 'val'), isTrue);
      expect(parser.getBool({'val': 0}, 'val'), isFalse);
      expect(parser.getBool({'val': 'true'}, 'val'), isTrue);
      expect(parser.getBool({'val': 'false'}, 'val'), isFalse);
      expect(parser.getBool({'val': 'invalid'}, 'val'), isNull);
    });

    test('getStringList handles List<dynamic> and comma-separated String', () {
      final listArgs = {
        'items': ['chest', 'triceps', ''],
      };
      expect(parser.getStringList(listArgs, 'items'), equals(['chest', 'triceps']));

      final stringArgs = {
        'items': 'squat, deadlift, bench press , ',
      };
      expect(
        parser.getStringList(stringArgs, 'items'),
        equals(['squat', 'deadlift', 'bench press']),
      );

      expect(parser.getStringList({'items': ''}, 'items'), isEmpty);
      expect(parser.getStringList({}, 'missing'), isEmpty);
    });

    test('requireString returns string or throws ArgumentError', () {
      expect(parser.requireString({'name': 'Squat'}, 'name'), equals('Squat'));
      expect(() => parser.requireString({}, 'name'), throwsArgumentError);
      expect(() => parser.requireString({'name': '   '}, 'name'), throwsArgumentError);
    });

    test('requireInt returns int or throws ArgumentError', () {
      expect(parser.requireInt({'reps': 10}, 'reps'), equals(10));
      expect(() => parser.requireInt({}, 'reps'), throwsArgumentError);
      expect(() => parser.requireInt({'reps': 'abc'}, 'reps'), throwsArgumentError);
    });
  });
}
