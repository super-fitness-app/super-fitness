import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary & Orange Accent Palette
  static const Color primary = Color(0xFFFF541A); // Main orange brand color
  static const Color primaryDark = Color(0xFFCC0E00);
  static const Color primaryLight = Color(0xFFFF8D66);
  static const Color orangeBase = Color(0xFFFF4100);
  static const Color orangeButton = Color(0xFFFF6A00); 

  // Orange MaterialColor Swatch
  static const MaterialColor orange = MaterialColor(
    0xFFFF541A,
    <int, Color>{
      50: Color(0xFFFFECE5),
      100: Color(0xFFFFD9CC),
      200: Color(0xFFFFC6B2),
      300: Color(0xFFFFB399),
      400: Color(0xFFFFA080),
      500: Color(0xFFFF8D66),
      600: Color(0xFFFF7A4D),
      700: Color(0xFFFF6733),
      800: Color(0xFFFF541A),
      900: Color(0xFFE52800),
    },
  );

  // Backward-compatible getter aliases for orange tints
  static Color get orange50 => orange[50]!;
  static Color get orange100 => orange[100]!;
  static Color get orange200 => orange[200]!;
  static Color get orange300 => orange[300]!;
  static Color get orange400 => orange[400]!;
  static Color get orange500 => orange[500]!;
  static Color get orange600 => orange[600]!;
  static Color get orange700 => orange[700]!;
  static Color get orange800 => orange[800]!;
  static Color get orange900 => orange[900]!;

  // Shades (Dark Scale)
  static const Color orangeShade900 = Color(0xFFE52800);
  static const Color orangeShade800 = Color(0xFFCC0E00);
  static const Color orangeShade700 = Color(0xFFB20000);
  static const Color orangeShade600 = Color(0xFF990000);
  static const Color orangeShade500 = Color(0xFF800000);
  static const Color orangeShade400 = Color(0xFF660000);
  static const Color orangeShade300 = Color(0xFF4D0000);
  static const Color orangeShade200 = Color(0xFF330000);
  static const Color orangeShade100 = Color(0xFF1A0000);

  // Neutrals & Dark Surfaces
  static const Color background = Color(0xFF000000); // Figma canvas background
  static const Color surface = Color(0xFF242424);
  static const Color surfaceVariant = Color(0xFF3A3A3A);
  static const Color cardBackground = Color(0xFF0B0B0B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteBase = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color blackBase = Color(0xFF0B0B0B);
  static const Color transparent = Color(0x00000000);

  // Grays (Mapped to Figma selection)
  static const Color grey10 = Color(0xFFE9E9E9);
  static const Color grey20 = Color(0xFFBDBDBD);
  static const Color grey30 = Color(0xFFA7A7A7); // Figma Font 2
  static const Color grey40 = Color(0xFF919191);
  static const Color grey50 = Color(0xFF7C7C7C);
  static const Color grey60 = Color(0xFF666666);
  static const Color grey70 = Color(0xFF505050);
  static const Color grey80 = Color(0xFF3A3A3A);
  static const Color grey90 = Color(0xFF242424);
  static const Color grey = Color(0xFFA7A7A7);

  // Inspected Strokes & Borders
  static const Color borderLight = Color(0xFFD9D9D9); // Figma input stroke
  static const Color borderSubtle = Color(0xFFD3D3D3);
  static const Color divider = Color(0xFF3A3A3A);
  static const Color overlay = Color(0x80000000);

  // Semantic Colors
  static const Color error = Color(0xFFFF4D4F);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2979FF);
}
