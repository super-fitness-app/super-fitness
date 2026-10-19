import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';

void main() {
  group('AppColors Swatch Tests', () {
    test('orange MaterialColor swatch has correct primary and tint values', () {
      expect(AppColors.orange, isA<MaterialColor>());
      expect(AppColors.orange[50], const Color(0xFFFFECE5));
      expect(AppColors.orange[100], const Color(0xFFFFD9CC));
      expect(AppColors.orange[200], const Color(0xFFFFC6B2));
      expect(AppColors.orange[300], const Color(0xFFFFB399));
      expect(AppColors.orange[400], const Color(0xFFFFA080));
      expect(AppColors.orange[500], const Color(0xFFFF8D66));
      expect(AppColors.orange[600], const Color(0xFFFF7A4D));
      expect(AppColors.orange[700], const Color(0xFFFF6733));
      expect(AppColors.orange[800], const Color(0xFFFF541A));
      expect(AppColors.orange[900], const Color(0xFFE52800));
    });

    test('backward-compatible getters return corresponding swatch colors', () {
      expect(AppColors.orange50, equals(AppColors.orange[50]));
      expect(AppColors.orange100, equals(AppColors.orange[100]));
      expect(AppColors.orange200, equals(AppColors.orange[200]));
      expect(AppColors.orange300, equals(AppColors.orange[300]));
      expect(AppColors.orange400, equals(AppColors.orange[400]));
      expect(AppColors.orange500, equals(AppColors.orange[500]));
      expect(AppColors.orange600, equals(AppColors.orange[600]));
      expect(AppColors.orange700, equals(AppColors.orange[700]));
      expect(AppColors.orange800, equals(AppColors.orange[800]));
      expect(AppColors.orange900, equals(AppColors.orange[900]));
    });
  });
}
