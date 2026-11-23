import 'package:equatable/equatable.dart';

class MealCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;

  const MealCategoryEntity({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, thumbnailUrl, description];
}
