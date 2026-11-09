import 'package:equatable/equatable.dart';
import 'package:super_fitness/core/const/api_params.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';

class StructuredFitnessCardModel extends Equatable {
  final String cardType;
  final String title;
  final String? subtitle;
  final String? badge;
  final Map<String, String> metrics;
  final List<String> bulletPoints;

  const StructuredFitnessCardModel({
    required this.cardType,
    required this.title,
    this.subtitle,
    this.badge,
    this.metrics = const {},
    this.bulletPoints = const [],
  });

  factory StructuredFitnessCardModel.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json[ApiParams.cardDetails] ?? json['metrics'];
    final Map<String, String> parsedMetrics = {};
    if (rawMetrics is Map) {
      rawMetrics.forEach((key, value) {
        parsedMetrics[key.toString()] = value.toString();
      });
    }

    final rawBullets =
        json[ApiParams.cardItems] ??
        json['bullet_points'] ??
        json['instructions'];
    final List<String> parsedBullets = [];
    if (rawBullets is List) {
      for (final item in rawBullets) {
        if (item != null) parsedBullets.add(item.toString());
      }
    }

    return StructuredFitnessCardModel(
      cardType: (json[ApiParams.cardType] as String?) ?? 'exercise',
      title: (json[ApiParams.cardTitle] ?? json['title'] as String?) ?? '',
      subtitle: json[ApiParams.cardSubtitle] ?? json['subtitle'] as String?,
      badge: json['badge'] ?? json['target_muscle'] ?? json['goal'] as String?,
      metrics: parsedMetrics,
      bulletPoints: parsedBullets,
    );
  }

  Map<String, dynamic> toJson() => {
    ApiParams.cardType: cardType,
    ApiParams.cardTitle: title,
    ApiParams.cardSubtitle: subtitle,
    'badge': badge,
    ApiParams.cardDetails: metrics,
    ApiParams.cardItems: bulletPoints,
  };

  FitnessCardEntity toEntity() => FitnessCardEntity(
    cardType:
        cardType.toLowerCase().contains('meal') ||
            cardType.toLowerCase().contains('nutrition')
        ? FitnessCardType.meal
        : FitnessCardType.exercise,
    title: title,
    subtitle: subtitle,
    badge: badge,
    metrics: metrics,
    bulletPoints: bulletPoints,
  );

  @override
  List<Object?> get props => [
    cardType,
    title,
    subtitle,
    badge,
    metrics,
    bulletPoints,
  ];
}
