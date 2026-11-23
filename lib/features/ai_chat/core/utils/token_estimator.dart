/// Pure Dart utility to estimate token counts based on character length.
abstract final class TokenEstimator {
  /// Standard heuristic: ~4 characters per token for English & numeric sequences.
  static int estimate(String text) {
    if (text.isEmpty) return 0;
    return (text.length / 4).ceil();
  }

  /// Calculates total token usage for an exchange between user prompt and assistant response.
  static int estimateExchange(String prompt, String response) {
    return estimate(prompt) + estimate(response);
  }
}
