import 'package:equatable/equatable.dart';

class ToolResultEntity extends Equatable {
  final String toolCallId;
  final String toolName;
  final String result;

  const ToolResultEntity({
    required this.toolCallId,
    required this.toolName,
    required this.result,
  });

  @override
  List<Object?> get props => [toolCallId, toolName, result];
}
