import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../models/album.dart';
import '../models/release_detail.dart';

/// Errore "leggibile" da mostrare direttamente all'utente.
class DiscogsException implements Exception {
  final String message;
  const DiscogsException(this.message);

  @override
  String toString() => message;
}

class DiscogsService {
  DiscogsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _host = 'api.discogs.com';
  static const _timeout = Duration(seconds: 15);

  Map<String, String> get _headers => {
        'User-Agent': AppConfig.userAgent,
        'Accept': 'application/json',
        if (AppConfig.hasToken) 'Authorization': 'Discogs token=${AppConfig.discogsToken}',
      };

  /// GET /database/search (richiede autenticazione).
  /// [format] può essere 'Vinyl', 'CD' o null (tutti).
  Future<List<Album>> searchReleases(String query, {String? format}) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    if (!AppConfig.hasToken) {
      throw const DiscogsException(
        'Token Discogs mancante. Vedi il README per configurarlo.',
      );
    }

    final json = await _get('/database/search', {
      'q': q,
      'type': 'release',
      'per_page': '25',
      if (format != null) 'format': format,
    });

    final results = json['results'];
    if (results is! List) return [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(Album.fromSearchResult)
        .toList();
  }

  /// GET /releases/{id}
  Future<ReleaseDetail> getRelease(String id) async {
    final json = await _get('/releases/$id');
    return ReleaseDetail.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(String path, [Map<String, String>? params]) async {
    final uri = Uri.https(_host, path, params);
    try {
      final response = await _client.get(uri, headers: _headers).timeout(_timeout);

      if (response.statusCode == 401) {
        throw const DiscogsException('Token Discogs non valido o scaduto.');
      }
      if (response.statusCode == 404) {
        throw const DiscogsException('Disco non trovato su Discogs.');
      }
      if (response.statusCode == 429) {
        throw const DiscogsException(
          'Troppe richieste a Discogs. Aspetta un minuto e riprova.',
        );
      }
      if (response.statusCode != 200) {
        throw DiscogsException('Errore Discogs (${response.statusCode}).');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const DiscogsException('Risposta di Discogs non valida.');
      }
      return decoded;
    } on TimeoutException {
      throw const DiscogsException('Discogs non risponde. Riprova.');
    } on http.ClientException {
      throw const DiscogsException('Nessuna connessione a internet.');
    } on FormatException {
      throw const DiscogsException('Risposta di Discogs non valida.');
    }
  }
}
