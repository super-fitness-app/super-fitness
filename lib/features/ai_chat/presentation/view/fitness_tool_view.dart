// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:super_fitness/config/di/di.dart';
// import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';
// import 'package:super_fitness/features/ai_chat/domain/tools/fitness_tool_executor.dart';

// class FitnessToolsTestPage extends StatefulWidget {
//   const FitnessToolsTestPage({super.key});

//   @override
//   State<FitnessToolsTestPage> createState() => _FitnessToolsTestPageState();
// }

// class _FitnessToolsTestPageState extends State<FitnessToolsTestPage> {
//   final _executor = getIt<FitnessToolExecutor>();

//   final _argumentsController = TextEditingController(text: '{}');

//   String? _result;
//   bool _loading = false;
//   String? _selectedTool;

//   final _tools = [
//     ToolNames.searchExercises,
//     ToolNames.getExerciseDetails,
//     ToolNames.searchMeals,
//     ToolNames.getMealDetails,
//   ];

//   Future<void> _execute() async {
//     if (_selectedTool == null) return;

//     try {
//       final arguments =
//           jsonDecode(_argumentsController.text) as Map<String, dynamic>;

//       setState(() {
//         _loading = true;
//         _result = null;
//       });

//       final result = await _executor.executeTool(_selectedTool!, arguments);

//       final decoded = jsonDecode(result.result);

//       setState(() {
//         _result = const JsonEncoder.withIndent('  ').convert(decoded);
//       });
//     } catch (e) {
//       setState(() {
//         _result = 'ERROR: $e';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _loading = false);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _argumentsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Fitness Tools Tester')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             DropdownButtonFormField<String>(
//               // ignore: deprecated_member_use
//               value: _selectedTool,
//               decoration: const InputDecoration(
//                 labelText: 'Select Tool',
//                 border: OutlineInputBorder(),
//               ),
//               items: _tools.map((tool) {
//                 return DropdownMenuItem(value: tool, child: Text(tool));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedTool = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _argumentsController,
//               maxLines: 8,
//               decoration: const InputDecoration(
//                 labelText: 'Arguments (JSON)',
//                 border: OutlineInputBorder(),
//                 alignLabelWithHint: true,
//               ),
//             ),
//             const SizedBox(height: 16),
//             FilledButton(
//               onPressed: _loading ? null : _execute,
//               child: _loading
//                   ? const CircularProgressIndicator()
//                   : const Text('Execute Tool'),
//             ),
//             const SizedBox(height: 20),
//             if (_result != null) ...[
//               const Text(
//                 'Execution Result',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               SelectableText(_result!),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
