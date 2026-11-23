import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/core/utils/thought_parser.dart';

void main() {
  group('ThoughtParser', () {
    test('stripThinkingTags removes <think> blocks completely', () {
      const input =
          '<think>\n1. Analyzing request\n2. Goal: Hypertrophy\n</think>Here is your plan:';
      final clean = ThoughtParser.stripThinkingTags(input);
      expect(clean, equals('Here is your plan:'));
    });

    test('stripThinkingTags removes Thinking Process block', () {
      const input =
          'Thinking Process:\n- Evaluating reps\n- Choosing bench press\n\nHere is your plan:';
      final clean = ThoughtParser.stripThinkingTags(input);
      expect(clean, equals('Here is your plan:'));
    });

    test('extractActiveStep extracts bold title correctly', () {
      const thought =
          'Initial text\n**Analyzing target muscle groups**\nCalculating volume';
      final step = ThoughtParser.extractActiveStep(thought);
      expect(step, equals('Analyzing target muscle groups'));
    });

    test('extractActiveStep extracts numbered item when no bold', () {
      const thought = '1. Reviewing protein intake requirements';
      final step = ThoughtParser.extractActiveStep(thought);
      expect(step, equals('Reviewing protein intake requirements'));
    });

    test('extractActiveStep extracts markdown header', () {
      const thought = '### Formulating optimal 4-day split';
      final step = ThoughtParser.extractActiveStep(thought);
      expect(step, equals('Formulating optimal 4-day split'));
    });

    test('extractActiveStep returns default title for empty input', () {
      final step = ThoughtParser.extractActiveStep('   ');
      expect(step, equals(ThoughtParser.defaultThinkingTitle));
    });

    test(
      'parseStream returns isThinking: true and empty content while inside <think>',
      () {
        const raw = '<think>\n**Assessing recovery time**\nLet me check';
        final result = ThoughtParser.parseStream(rawAccumulated: raw);

        expect(result.isThinking, isTrue);
        expect(result.content, isEmpty);
        expect(result.rawThought, contains('Assessing recovery time'));
        expect(result.activeStep, equals('Assessing recovery time'));
      },
    );

    test(
      'parseStream returns clean content and isThinking: false after </think>',
      () {
        const raw =
            '<think>Done thinking</think>Bench press 4x8 reps with 2 min rest.';
        final result = ThoughtParser.parseStream(rawAccumulated: raw);

        expect(result.isThinking, isFalse);
        expect(result.content, equals('Bench press 4x8 reps with 2 min rest.'));
        expect(result.rawThought, equals('Done thinking'));
        expect(result.activeStep, isNull);
      },
    );

    test('parseStream handles pure text without reasoning tags', () {
      const raw = 'Direct coaching advice without thinking tags.';
      final result = ThoughtParser.parseStream(rawAccumulated: raw);

      expect(result.isThinking, isFalse);
      expect(
        result.content,
        equals('Direct coaching advice without thinking tags.'),
      );
      expect(result.rawThought, isNull);
      expect(result.activeStep, isNull);
    });

    test(
      'parseStream handles separate accumulatedThinking parameter during stream',
      () {
        final result = ThoughtParser.parseStream(
          rawAccumulated: '',
          accumulatedThinking: '**Formulating macro breakdown**',
        );

        expect(result.isThinking, isTrue);
        expect(result.content, isEmpty);
        expect(result.rawThought, equals('**Formulating macro breakdown**'));
        expect(result.activeStep, equals('Formulating macro breakdown'));
      },
    );
  });
}
