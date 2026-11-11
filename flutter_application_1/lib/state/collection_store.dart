import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/album.dart';

/// Stato condiviso dell'app: dischi in libreria e dischi "da cercare".
/// Notifica la UI a ogni cambiamento e salva su SharedPreferences.
class CollectionStore extends ChangeNotifier {
  static const _libraryKey = 'library_v1';
  static const _wantedKey = 'wanted_v1';

  final List<Album> _library = [];
  final List<Album> _wanted = [];

  List<Album> get library => List.unmodifiable(_library);
  List<Album> get wanted => List.unmodifiable(_wanted);

  bool inLibrary(String id) => _library.any((a) => a.id == id);
  bool inWanted(String id) => _wanted.any((a) => a.id == id);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _library
        ..clear()
        ..addAll(_decode(prefs.getString(_libraryKey)));
      _wanted
        ..clear()
        ..addAll(_decode(prefs.getString(_wantedKey)));
      notifyListeners();
    } catch (_) {
      // Se la lettura fallisce si parte con liste vuote.
    }
  }

  void addToWanted(Album album) {
    if (inLibrary(album.id) || inWanted(album.id)) return;
    _wanted.add(album);
    _changed();
  }

  /// Aggiunge alla libreria e toglie da "da cercare" (usato da "TROVATO!").
  void addToLibrary(Album album) {
    _wanted.removeWhere((a) => a.id == album.id);
    if (!inLibrary(album.id)) _library.insert(0, album);
    _changed();
  }

  void removeFromLibrary(String id) {
    _library.removeWhere((a) => a.id == id);
    _changed();
  }

  void removeFromWanted(String id) {
    _wanted.removeWhere((a) => a.id == id);
    _changed();
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_libraryKey, _encode(_library));
      await prefs.setString(_wantedKey, _encode(_wanted));
    } catch (_) {
      // Salvataggio non riuscito: l'app continua a funzionare in memoria.
    }
  }

  static String _encode(List<Album> albums) =>
      jsonEncode(albums.map((a) => a.toJson()).toList());

  static List<Album> _decode(String? raw) {
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(Album.fromJson).toList();
    } catch (_) {
      return [];
    }
  }
}
