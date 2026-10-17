import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_styles.dart';

abstract final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      elevation: 0,
      titleTextStyle: AppStyles.medium20,
      iconTheme: const IconThemeData(color: AppColors.white, size: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey40,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        textStyle: AppStyles.buttonText,
        disabledBackgroundColor: AppColors.grey70,
        disabledForegroundColor: AppColors.grey40,
        padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        textStyle: AppStyles.medium16Roboto,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey70,
        side: const BorderSide(color: AppColors.grey60),
        padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return AppStyles.regular12.copyWith(color: AppColors.error);
        }
        if (states.contains(WidgetState.focused)) {
          return AppStyles.regular12.copyWith(color: AppColors.primary);
        }
        return AppStyles.regular12.copyWith(color: AppColors.grey40);
      }),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: AppStyles.regular12.copyWith(color: AppColors.error),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: AppStyles.regular14.copyWith(color: AppColors.grey50),
      labelStyle: AppStyles.regular12.copyWith(color: AppColors.grey40),
      contentPadding: const EdgeInsetsDirectional.only(
        top: 16,
        bottom: 16,
        start: 16,
        end: 16,
      ),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey70, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey70, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}
