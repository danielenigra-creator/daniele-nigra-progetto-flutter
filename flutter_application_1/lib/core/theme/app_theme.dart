import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF1F1510);
  static const header = Color(0xFF140D09);
  static const panel = Color(0xFF2E2018);
  static const panelLight = Color(0xFF3D2B20);
  static const border = Color(0xFF5A4030);
  static const cream = Color(0xFFF1E3C3);
  static const amber = Color(0xFFF0A830);
  static const muted = Color(0xFFC2A982);
  static const brownText = Color(0xFF2A1A12);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.amber,
      secondary: AppColors.cream,
      surface: AppColors.panel,
    ),
    fontFamily: 'Courier',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.cream),
      bodySmall: TextStyle(color: AppColors.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.panel,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.amber, width: 2),
      ),
    ),
  );
}
