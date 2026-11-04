import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_fitness/core/const/app_colors.dart';

abstract final class AppTextStyles {
  // 31px (3.875rem) - Display & Hero Headlines
  static final TextStyle display31 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 31,
    color: AppColors.white,
  );

  static final TextStyle appTitle = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 31,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );

  static final TextStyle headlineLarge = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 31,
    color: AppColors.white,
  );

  // 24px (3.000rem) - Medium Headlines
  static final TextStyle headline24 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.white,
  );

  static final TextStyle bold24 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.white,
  );

  static final TextStyle headlineMedium = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: AppColors.white,
  );

  // 20px (2.500rem) - Small Headlines & Sections
  static final TextStyle headlineSmall = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.white,
  );

  static final TextStyle bold20 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.white,
  );
  static final TextStyle bold20w800 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w800,
    fontSize: 20,
    color: AppColors.white,
  );

  static final TextStyle bold20Inter = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.white,
  );

  static final TextStyle medium20 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.white,
  );

  // 16px (2.000rem) - Standard Body & Buttons
  static final TextStyle regular16 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.white,
  );
  static final TextStyle regular18 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: AppColors.white,
  );

  static final TextStyle medium16 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.white,
  );

  static final TextStyle medium16Inter = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.white,
  );

  static final TextStyle medium16Roboto = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.white,
  );

  static final TextStyle bold16 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.white,
  );

  static final TextStyle buttonText = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.white,
  );

  static final TextStyle extraBold14 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w800,
    fontSize: 14,
    color: AppColors.white,
  );

  // 13px (1.625rem) - Body Secondary, Inputs & Links
  static final TextStyle regular13 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: AppColors.grey30,
  );

  static final TextStyle regular14 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: AppColors.grey30,
  );

  static final TextStyle regular14Roboto = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: AppColors.grey30,
  );

  static final TextStyle medium13 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.white,
  );

  static final TextStyle medium14 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.white,
  );

  static final TextStyle medium18 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColors.white,
  );

  static final TextStyle linkText = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // 10px (1.250rem) - Captions & Helper Texts
  static final TextStyle regular10 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.grey40,
  );

  static final TextStyle regular12 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.grey40,
  );

  static final TextStyle regular12Roboto = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.grey40,
  );

  // 8px, 6px, 5px - Micro Scales
  static final TextStyle caption8 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 8,
    color: AppColors.grey50,
  );

  static final TextStyle caption6 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 6,
    color: AppColors.grey50,
  );

  static final TextStyle caption5 = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w400,
    fontSize: 5,
    color: AppColors.grey50,
  );

  // Bottom Navigation Bar
  static final TextStyle bottomNavSelected = GoogleFonts.balooThambi2(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.primary,
  );
}
