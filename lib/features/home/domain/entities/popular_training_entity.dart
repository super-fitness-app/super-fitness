import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class PopularTrainingEntity extends Equatable {
  final String id;
  final String title;
  final int totalTasks;
  final String levelText;
  final String imageUrl;
  final String? videoUrl;

  const PopularTrainingEntity({
    required this.id,
    required this.title,
    required this.totalTasks,
    required this.levelText,
    required this.imageUrl,
    this.videoUrl,
  });

  Color get levelColor {
    final lower = levelText.toLowerCase();
    if (lower.contains('beginner') || lower.contains('novice')) {
      return AppColors.primaryColor;
    } else if (lower.contains('intermediate')) {
      return const Color(0xFFFF9500);
    } else {
      return const Color(0xFFFF3B30);
    }
  }

  PopularTrainingEntity copyWith({
    String? id,
    String? title,
    int? totalTasks,
    String? levelText,
    String? imageUrl,
    String? videoUrl,
  }) {
    return PopularTrainingEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      totalTasks: totalTasks ?? this.totalTasks,
      levelText: levelText ?? this.levelText,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    totalTasks,
    levelText,
    imageUrl,
    videoUrl,
  ];
}
