import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final String? muscleGroup;
  final String? muscleGroupAr;
  final String? primeMover;
  final String? primeMoverAr;
  final String? difficulty;
  final int? difficultyRank;
  final String? equipment;
  final String? bodyRegion;
  final String? mechanics;
  final String? posture;
  final String? laterality;
  final String? forceType;
  final String? demoUrl;
  final String? explainUrl;
  final int? popularity;
  final String? movementPatterns;

  const ExerciseEntity({
    required this.id,
    required this.name,
    this.nameAr,
    this.muscleGroup,
    this.muscleGroupAr,
    this.primeMover,
    this.primeMoverAr,
    this.difficulty,
    this.difficultyRank,
    this.equipment,
    this.bodyRegion,
    this.mechanics,
    this.posture,
    this.laterality,
    this.forceType,
    this.demoUrl,
    this.explainUrl,
    this.popularity,
    this.movementPatterns,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    muscleGroup,
    muscleGroupAr,
    primeMover,
    primeMoverAr,
    difficulty,
    difficultyRank,
    equipment,
    bodyRegion,
    mechanics,
    posture,
    laterality,
    forceType,
    demoUrl,
    explainUrl,
    popularity,
    movementPatterns,
  ];
}
