// import 'dart:convert';

import 'package:equatable/equatable.dart';

// import 'package:super_fitness/core/const/api_params.dart';

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
    return {'id': id, 'type': type, 'function': function.toJson()};
  }
}

class ToolCallFunctionModel extends Equatable {
  final String name;
  final Map<String, dynamic> arguments;

  const ToolCallFunctionModel({required this.name, required this.arguments});

  factory ToolCallFunctionModel.fromJson(Map<String, dynamic> json) {
    // final rawArgs = json[ApiParams.arguments];
    // Map<String, dynamic> parsedArgs = {};
    // if (rawArgs is Map<String, dynamic>) {
    //   parsedArgs = rawArgs;
    // } else if (rawArgs is String) {
    //   try {
    //     final decoded = jsonDecode(rawArgs);
    //     if (decoded is Map<String, dynamic>) {
    //       parsedArgs = decoded;
    //     }
    //   } catch (_) {
    //     parsedArgs = {};
    //   }
    // }

    return ToolCallFunctionModel(
      name: json['name'] as String? ?? '',
      arguments:
          json['arguments'] as Map<String, dynamic>? ?? <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'arguments': arguments};
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
