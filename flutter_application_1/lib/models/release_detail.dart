import 'album.dart';

class Track {
  final String position;
  final String title;
  final String duration;
  const Track({required this.position, required this.title, required this.duration});
}

/// Dettagli di una release da GET /releases/{id}.
class ReleaseDetail {
  final String label;
  final String catalogNumber;
  final String country;
  final List<String> genres;
  final List<String> styles;
  final List<Track> tracks;
  final double? lowestPrice;
  final int? numForSale;

  const ReleaseDetail({
    this.label = '',
    this.catalogNumber = '',
    this.country = '',
    this.genres = const [],
    this.styles = const [],
    this.tracks = const [],
    this.lowestPrice,
    this.numForSale,
  });

  factory ReleaseDetail.fromJson(Map<String, dynamic> json) {
    final labels = _maps(json['labels']);
    final firstLabel = labels.isNotEmpty ? labels.first : const {};

    final tracks = _maps(json['tracklist'])
        .where((t) => t['type_'] != 'heading')
        .map((t) => Track(
              position: '${t['position'] ?? ''}',
              title: '${t['title'] ?? ''}',
              duration: '${t['duration'] ?? ''}',
            ))
        .toList();

    return ReleaseDetail(
      label: Album.cleanArtist('${firstLabel['name'] ?? ''}'),
      catalogNumber: '${firstLabel['catno'] ?? ''}',
      country: '${json['country'] ?? ''}',
      genres: _strings(json['genres']),
      styles: _strings(json['styles']),
      tracks: tracks,
      lowestPrice: json['lowest_price'] is num
          ? (json['lowest_price'] as num).toDouble()
          : null,
      numForSale:
          json['num_for_sale'] is num ? (json['num_for_sale'] as num).toInt() : null,
    );
  }
}

List<Map> _maps(dynamic v) => v is List ? v.whereType<Map>().toList() : <Map>[];
List<String> _strings(dynamic v) =>
    v is List ? v.map((e) => e.toString()).toList() : <String>[];
