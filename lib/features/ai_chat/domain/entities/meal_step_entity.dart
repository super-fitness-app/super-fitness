import 'package:equatable/equatable.dart';

class MealStepEntity extends Equatable {
  final String mealId;
  final int position;
  final String text;

  const MealStepEntity({
    required this.mealId,
    required this.position,
    required this.text,
  });

  @override
  List<Object?> get props => [mealId, position, text];
}
