import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exercise_entity.dart';

part 'exercise_model.g.dart';

@JsonSerializable()
class ExerciseModel extends Equatable {
  final String id;

  @JsonKey(fromJson: _toLowerCase)
  final String name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'muscle_group')
  final String? muscleGroup;

  @JsonKey(name: 'muscle_group_ar')
  final String? muscleGroupAr;

  @JsonKey(name: 'prime_mover')
  final String? primeMover;

  @JsonKey(name: 'prime_mover_ar')
  final String? primeMoverAr;

  @JsonKey(name: 'difficulty')
  final String? difficulty;

  @JsonKey(name: 'difficulty_rank')
  final int? difficultyRank;

  final String? equipment;

  @JsonKey(name: 'body_region')
  final String? bodyRegion;

  final String? mechanics;
  final String? posture;
  final String? laterality;

  @JsonKey(name: 'force_type')
  final String? forceType;

  @JsonKey(name: 'demo_url')
  final String? demoUrl;

  @JsonKey(name: 'explain_url')
  final String? explainUrl;

  final int? popularity;

  @JsonKey(name: 'movement_patterns')
  final String? movementPatterns;

  const ExerciseModel({
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

  static String _toLowerCase(String value) => value.toLowerCase();

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? muscleGroup,
    String? muscleGroupAr,
    String? primeMover,
    String? primeMoverAr,
    String? difficulty,
    int? difficultyRank,
    String? equipment,
    String? bodyRegion,
    String? mechanics,
    String? posture,
    String? laterality,
    String? forceType,
    String? demoUrl,
    String? explainUrl,
    int? popularity,
    String? movementPatterns,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      muscleGroupAr: muscleGroupAr ?? this.muscleGroupAr,
      primeMover: primeMover ?? this.primeMover,
      primeMoverAr: primeMoverAr ?? this.primeMoverAr,
      difficulty: difficulty ?? this.difficulty,
      difficultyRank: difficultyRank ?? this.difficultyRank,
      equipment: equipment ?? this.equipment,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      mechanics: mechanics ?? this.mechanics,
      posture: posture ?? this.posture,
      laterality: laterality ?? this.laterality,
      forceType: forceType ?? this.forceType,
      demoUrl: demoUrl ?? this.demoUrl,
      explainUrl: explainUrl ?? this.explainUrl,
      popularity: popularity ?? this.popularity,
      movementPatterns: movementPatterns ?? this.movementPatterns,
    );
  }

  factory ExerciseModel.fromDomain(ExerciseEntity entity) => ExerciseModel(
    id: entity.id,
    name: entity.name,
    nameAr: entity.nameAr,
    muscleGroup: entity.muscleGroup,
    muscleGroupAr: entity.muscleGroupAr,
    primeMover: entity.primeMover,
    primeMoverAr: entity.primeMoverAr,
    difficulty: entity.difficulty,
    difficultyRank: entity.difficultyRank,
    equipment: entity.equipment,
    bodyRegion: entity.bodyRegion,
    mechanics: entity.mechanics,
    posture: entity.posture,
    laterality: entity.laterality,
    forceType: entity.forceType,
    demoUrl: entity.demoUrl,
    explainUrl: entity.explainUrl,
    popularity: entity.popularity,
    movementPatterns: entity.movementPatterns,
  );

  ExerciseEntity toEntity() => ExerciseEntity(
    id: id,
    name: name,
    nameAr: nameAr,
    muscleGroup: muscleGroup,
    muscleGroupAr: muscleGroupAr,
    primeMover: primeMover,
    primeMoverAr: primeMoverAr,
    difficulty: difficulty,
    difficultyRank: difficultyRank,
    equipment: equipment,
    bodyRegion: bodyRegion,
    mechanics: mechanics,
    posture: posture,
    laterality: laterality,
    forceType: forceType,
    demoUrl: demoUrl,
    explainUrl: explainUrl,
    popularity: popularity,
    movementPatterns: movementPatterns,
  );

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
