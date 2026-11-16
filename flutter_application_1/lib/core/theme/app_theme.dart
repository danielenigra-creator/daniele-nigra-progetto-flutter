import 'package:flutter/material.dart';

/// Palette dell'app. I colori sono "getter": restituiscono la versione marrone
/// (scura) o quella chiara a seconda di [AppColors.light], che viene impostato
/// da SettingsStore quando cambi tema.
class AppColors {
  /// true = tema chiaro, false = tema marrone (default).
  static bool light = false;

  static Color get background =>
      light ? const Color(0xFFF6EFE0) : const Color(0xFF1F1510);
  static Color get header =>
      light ? const Color(0xFFEBDFC6) : const Color(0xFF140D09);
  static Color get panel =>
      light ? const Color(0xFFFFFBF2) : const Color(0xFF2E2018);
  static Color get panelLight =>
      light ? const Color(0xFFEFE4CC) : const Color(0xFF3D2B20);
  static Color get border =>
      light ? const Color(0xFFD3C3A2) : const Color(0xFF5A4030);

  /// Colore del testo principale (crema sul marrone, marrone scuro sul chiaro).
  static Color get cream =>
      light ? const Color(0xFF2A1A12) : const Color(0xFFF1E3C3);
  static Color get amber =>
      light ? const Color(0xFFB06A00) : const Color(0xFFF0A830);
  static Color get muted =>
      light ? const Color(0xFF7A6347) : const Color(0xFFC2A982);

  /// Sfondo delle copertine nella griglia della libreria.
  static Color get card =>
      light ? const Color(0xFFFFFDF7) : const Color(0xFFF1E3C3);

  // Colori fissi (uguali in entrambi i temi)
  static const brownText = Color(0xFF2A1A12);

  /// Testo chiaro da usare sopra superfici sempre scure/marroni (es. la cassa dei dischi).
  static const onWood = Color(0xFFF1E3C3);
}

class AppTheme {
  static const double textScale = 1.2;

  /// Tema corrente, in base a [AppColors.light].
  static ThemeData get current {
    final scheme = AppColors.light
        ? ColorScheme.light(
            primary: AppColors.amber,
            onPrimary: AppColors.brownText,
            secondary: AppColors.cream,
            surface: AppColors.panel,
            onSurface: AppColors.cream,
          )
        : ColorScheme.dark(
            primary: AppColors.amber,
            onPrimary: AppColors.brownText,
            secondary: AppColors.cream,
            surface: AppColors.panel,
            onSurface: AppColors.cream,
          );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: AppColors.cream),
        bodySmall: TextStyle(color: AppColors.muted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.panel,
        hintStyle: TextStyle(color: AppColors.muted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.amber, width: 2),
        ),
      ),
    );
  }
}
