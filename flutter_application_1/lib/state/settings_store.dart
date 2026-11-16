import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/l10n/strings.dart';
import '../core/theme/app_theme.dart';

/// Impostazioni dell'utente: tema (marrone / chiaro) e lingua (italiano / inglese).
/// Si salvano su SharedPreferences e vengono applicate a [AppColors] e [S].
class SettingsStore extends ChangeNotifier {
  static const _lightKey = 'theme_light_v1';
  static const _englishKey = 'lang_english_v1';

  bool _light = false;
  bool _english = false;

  bool get isLight => _light;
  bool get isEnglish => _english;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _light = prefs.getBool(_lightKey) ?? false;
      _english = prefs.getBool(_englishKey) ?? false;
    } catch (_) {
      // Se la lettura fallisce si parte con tema marrone e italiano.
    }
    _apply();
    notifyListeners();
  }

  void setLight(bool value) {
    if (_light == value) return;
    _light = value;
    _apply();
    notifyListeners();
    _save();
  }

  void setEnglish(bool value) {
    if (_english == value) return;
    _english = value;
    _apply();
    notifyListeners();
    _save();
  }

  void _apply() {
    AppColors.light = _light;
    S.english = _english;
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_lightKey, _light);
      await prefs.setBool(_englishKey, _english);
    } catch (_) {
      // Salvataggio non riuscito: le impostazioni valgono solo per questa sessione.
    }
  }
}
