import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/exercise_list_view.dart';

void main() {
  group('ExerciseListView Widget Tests', () {
    testWidgets('should render without errors when exercises list is empty', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 500, child: ExerciseListView(exercises: [])),
          ),
        ),
      );

      // Assert
      expect(find.byType(ExerciseListView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
