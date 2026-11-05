class ToolCallModel {
  final String id;
  final String type;
  final ToolCallFunctionModel function;

  const ToolCallModel({
    required this.id,
    this.type = 'function',
    required this.function,
  });

  factory ToolCallModel.fromJson(Map<String, dynamic> json) {
    return ToolCallModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'function',
      function: ToolCallFunctionModel.fromJson(
        json['function'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'function': function.toJson(),
    };
  }
}

class ToolCallFunctionModel {
  final String name;
  final Map<String, dynamic> arguments;

  const ToolCallFunctionModel({
    required this.name,
    required this.arguments,
  });

  factory ToolCallFunctionModel.fromJson(Map<String, dynamic> json) {
    return ToolCallFunctionModel(
      name: json['name'] as String? ?? '',
      arguments: json['arguments'] as Map<String, dynamic>? ?? <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arguments': arguments,
    };
  }
}
