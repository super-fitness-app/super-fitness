class ToolArgumentParser {
  const ToolArgumentParser();

  String? getString(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }

  double? getDouble(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  int? getInt(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  bool? getBool(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    final normalized = value.toString().toLowerCase();

    if (normalized == 'true') {
      return true;
    }

    if (normalized == 'false') {
      return false;
    }

    return null;
  }

  List<String> getStringList(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) {
      return const [];
    }

    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return const [];
    }

    return stringValue
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String requireString(Map<String, dynamic> arguments, String key) {
    final value = getString(arguments, key);

    if (value == null) {
      throw ArgumentError('Missing required argument: $key');
    }

    return value;
  }

  int requireInt(Map<String, dynamic> arguments, String key) {
    final value = getInt(arguments, key);

    if (value == null) {
      throw ArgumentError('Missing required argument: $key');
    }

    return value;
  }
}
