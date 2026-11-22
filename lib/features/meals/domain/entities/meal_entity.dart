import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;

  const MealEntity({
    this.id,
    this.name,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}