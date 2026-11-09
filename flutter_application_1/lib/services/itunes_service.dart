
import 'dart:convert';
import 'package:http/http.dart' as http;

class ItunesService {
  Future<List<Map<String, dynamic>>> searchAlbums(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.https(
      'itunes.apple.com',
      '/search',
      {
        'term': query,
        'entity': 'album',
        'limit': '25',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Errore durante la ricerca degli album');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results
        .where((item) => item['collectionName'] != null)
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }
}
