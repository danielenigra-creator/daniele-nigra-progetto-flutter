import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../state/settings_store.dart';

/// Pannello che si apre dall'icona impostazioni nell'header:
/// interruttore del tema chiaro + tasto per cambiare lingua.
class SettingsSheet extends StatelessWidget {
  final SettingsStore settings;
  const SettingsSheet({super.key, required this.settings});

  static Future<void> show(BuildContext context, SettingsStore settings) {
    return showModalBottomSheet<void>(
      context: context,
      // Lo sfondo lo disegna il widget stesso, così si aggiorna quando cambi tema.
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsSheet(settings: settings),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(top: BorderSide(color: AppColors.amber, width: 2)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: AppColors.amber),
                      const SizedBox(width: 10),
                      Text(
                        S.settings,
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // --- Tema: acceso = chiaro, spento = marrone
                  Row(
                    children: [
                      Icon(
                        settings.isLight
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          S.lightTheme,
                          style: TextStyle(color: AppColors.cream, fontSize: 15),
                        ),
                      ),
                      Switch(
                        value: settings.isLight,
                        onChanged: settings.setLight,
                      ),
                    ],
                  ),
                  Divider(color: AppColors.border, height: 24),
                  // --- Lingua
                  Row(
                    children: [
                      Icon(Icons.language, color: AppColors.muted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          S.language,
                          style: TextStyle(color: AppColors.cream, fontSize: 15),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => settings.setEnglish(!settings.isEnglish),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.amber,
                          side: BorderSide(color: AppColors.amber, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          S.switchLanguageButton,
                          style: const TextStyle(letterSpacing: 1, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
