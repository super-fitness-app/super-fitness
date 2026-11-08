class ParsedThoughtResult {
  final String content;
  final String? rawThought;
  final String? activeStep;
  final bool isThinking;

  const ParsedThoughtResult({
    required this.content,
    this.rawThought,
    this.activeStep,
    required this.isThinking,
  });
}

abstract final class ThoughtParser {
  static const String defaultThinkingTitle =
      'Smart Coach is analyzing your fitness profile...';

  static final RegExp _thinkTagRegex =
      RegExp(r'<think>([\s\S]*?)(?:<\/think>|$)', caseSensitive: false);
  static final RegExp _boldStepRegex = RegExp(r'\*\*([^*]+)\*\*');
  static final RegExp _headerStepRegex = RegExp(r'(?:^|\n)\s*#{1,4}\s*([^\n\r]+)');
  static final RegExp _listStepRegex =
      RegExp(r'(?:^|\n)\s*(?:\d+\.|\*|-)\s*([^\n\r]+)');

  static String? extractActiveStep(String rawThought) {
    if (rawThought.trim().isEmpty) return defaultThinkingTitle;

    final boldMatches = _boldStepRegex.allMatches(rawThought).toList();
    if (boldMatches.isNotEmpty) {
      final text = boldMatches.last.group(1)?.trim();
      if (text != null && text.isNotEmpty) return _formatStep(text);
    }

    final headerMatches = _headerStepRegex.allMatches(rawThought).toList();
    if (headerMatches.isNotEmpty) {
      final text = headerMatches.last.group(1)?.trim();
      if (text != null && text.isNotEmpty) return _formatStep(text);
    }

    final listMatches = _listStepRegex.allMatches(rawThought).toList();
    if (listMatches.isNotEmpty) {
      final text = listMatches.last.group(1)?.trim();
      if (text != null && text.isNotEmpty) return _formatStep(text);
    }

    final lines = rawThought
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isNotEmpty) {
      return _formatStep(lines.last);
    }

    return defaultThinkingTitle;
  }

  static String _formatStep(String raw) {
    var cleaned = raw
        .replaceAll(RegExp(r'[*#_:`]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return defaultThinkingTitle;

    cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    if (cleaned.length > 45) {
      return '${cleaned.substring(0, 45)}...';
    }
    return cleaned;
  }

  static ParsedThoughtResult parseStream({
    required String rawAccumulated,
    String? accumulatedThinking,
  }) {
    if (rawAccumulated.contains('<think>')) {
      final thinkStart = rawAccumulated.indexOf('<think>') + 7;
      final thinkEnd = rawAccumulated.indexOf('</think>');
      if (thinkEnd != -1) {
        final thought = rawAccumulated.substring(thinkStart, thinkEnd).trim();
        final content = rawAccumulated.substring(thinkEnd + 8).trimLeft();
        return ParsedThoughtResult(
          content: content,
          rawThought: thought,
          activeStep: null,
          isThinking: false,
        );
      } else {
        final thought = rawAccumulated.substring(thinkStart).trim();
        return ParsedThoughtResult(
          content: '',
          rawThought: thought,
          activeStep: extractActiveStep(thought),
          isThinking: true,
        );
      }
    }

    if (accumulatedThinking != null && accumulatedThinking.isNotEmpty) {
      final isStillThinking = rawAccumulated.trim().isEmpty;
      return ParsedThoughtResult(
        content: rawAccumulated,
        rawThought: accumulatedThinking.trim(),
        activeStep:
            isStillThinking ? extractActiveStep(accumulatedThinking) : null,
        isThinking: isStillThinking,
      );
    }

    return ParsedThoughtResult(
      content: rawAccumulated,
      rawThought: null,
      activeStep: null,
      isThinking: false,
    );
  }

  static String stripThinkingTags(String text) {
    var result = text.replaceAll(_thinkTagRegex, '').trim();
    final thinkingProcessIdx = result.indexOf('Thinking Process:');
    if (thinkingProcessIdx != -1) {
      final nextDoubleNewline = result.indexOf('\n\n', thinkingProcessIdx);
      if (nextDoubleNewline != -1) {
        result = (result.substring(0, thinkingProcessIdx) +
                result.substring(nextDoubleNewline + 2))
            .trim();
      } else {
        result = result.substring(0, thinkingProcessIdx).trim();
      }
    }
    return result;
  }
}
