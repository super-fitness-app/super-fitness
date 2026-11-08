import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:super_fitness/core/const/api_params.dart';

class ToolCallFunctionModel extends Equatable {
  final String name;
  final Map<String, dynamic> arguments;

  const ToolCallFunctionModel({
    required this.name,
    required this.arguments,
  });

  factory ToolCallFunctionModel.fromJson(Map<String, dynamic> json) {
    final rawArgs = json[ApiParams.arguments];
    Map<String, dynamic> parsedArgs = {};
    if (rawArgs is Map<String, dynamic>) {
      parsedArgs = rawArgs;
    } else if (rawArgs is String) {
      try {
        final decoded = jsonDecode(rawArgs);
        if (decoded is Map<String, dynamic>) {
          parsedArgs = decoded;
        }
      } catch (_) {
        parsedArgs = {};
      }
    }

    return ToolCallFunctionModel(
      name: (json[ApiParams.name] as String?) ?? '',
      arguments: parsedArgs,
    );
  }

  Map<String, dynamic> toJson() => {
    ApiParams.name: name,
    ApiParams.arguments: arguments,
  };

  @override
  List<Object?> get props => [name, arguments];
}

class ToolCallModel extends Equatable {
  final ToolCallFunctionModel function;

  const ToolCallModel({required this.function});

  String get name => function.name;
  Map<String, dynamic> get arguments => function.arguments;

  factory ToolCallModel.fromJson(Map<String, dynamic> json) {
    final rawFunction = json[ApiParams.function];
    if (rawFunction is Map<String, dynamic>) {
      return ToolCallModel(
        function: ToolCallFunctionModel.fromJson(rawFunction),
      );
    }

    return ToolCallModel(
      function: ToolCallFunctionModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
    ApiParams.function: function.toJson(),
  };

  @override
  List<Object?> get props => [function];
}
