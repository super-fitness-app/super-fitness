abstract final class ToolArgumentsParser {
  static Map<String, dynamic> parse(dynamic rawArguments) {
    if (rawArguments is Map<String, dynamic>) {
      return rawArguments;
    }
    return <String, dynamic>{};
  }

  static String? getString(Map<String, dynamic> args, String key) {
    return args[key]?.toString();
  }

  static int? getInt(Map<String, dynamic> args, String key) {
    final value = args[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
