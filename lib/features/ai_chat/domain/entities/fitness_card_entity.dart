import 'package:equatable/equatable.dart';

enum FitnessCardType { exercise, meal }

class FitnessCardEntity extends Equatable {
  final FitnessCardType cardType;
  final String title;
  final String? subtitle;
  final String? badge;
  final Map<String, String> metrics;
  final List<String> bulletPoints;

  const FitnessCardEntity({
    required this.cardType,
    required this.title,
    this.subtitle,
    this.badge,
    this.metrics = const {},
    this.bulletPoints = const [],
  });

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
