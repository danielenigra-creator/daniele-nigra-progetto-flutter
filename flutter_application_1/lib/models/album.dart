/// Un disco (release Discogs) salvato in libreria o nella lista "da cercare".
class Album {
  final String id; // id della release su Discogs
  final String title;
  final String artist;
  final int? year;
  final String format; // 'Vinile', 'CD', ...
  final String genre;
  final String coverUrl;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    this.year,
    this.format = 'Altro',
    this.genre = '',
    this.coverUrl = '',
  });

  /// "Artista · 1977 · Vinile"
  String get subtitle => [
        artist,
        if (year != null) '$year',
        format,
      ].join(' · ');

  /// Elemento di /database/search. Il campo `title` ha la forma "Artista - Titolo".
  factory Album.fromSearchResult(Map<String, dynamic> json) {
    final fullTitle = (json['title'] ?? '').toString();
    final sep = fullTitle.indexOf(' - ');
    final artist =
        sep > 0 ? cleanArtist(fullTitle.substring(0, sep)) : 'Artista sconosciuto';
    final title = sep > 0 ? fullTitle.substring(sep + 3) : fullTitle;

    final genres = json['genre'];
    final formats = json['format'];

    return Album(
      id: '${json['id']}',
      title: title.isEmpty ? 'Senza titolo' : title,
      artist: artist,
      year: int.tryParse('${json['year'] ?? ''}'),
      format: formatFromNames(
        formats is List ? formats.map((e) => e.toString()) : const <String>[],
      ),
      genre: genres is List && genres.isNotEmpty ? genres.first.toString() : '',
      coverUrl: _validUrl(json['cover_image']) ?? _validUrl(json['thumb']) ?? '',
    );
  }

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: '${json['id']}',
        title: '${json['title'] ?? ''}',
        artist: '${json['artist'] ?? ''}',
        year: json['year'] is int ? json['year'] as int : null,
        format: '${json['format'] ?? 'Altro'}',
        genre: '${json['genre'] ?? ''}',
        coverUrl: '${json['coverUrl'] ?? ''}',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'year': year,
        'format': format,
        'genre': genre,
        'coverUrl': coverUrl,
      };

  /// Discogs aggiunge "(2)" ai nomi omonimi: lo togliamo.
  static String cleanArtist(String name) =>
      name.replaceFirst(RegExp(r'\s\(\d+\)$'), '').trim();

  static String formatFromNames(Iterable<String> names) {
    final lower = names.map((e) => e.toLowerCase()).toList();
    if (lower.contains('vinyl')) return 'Vinile';
    if (lower.contains('cd')) return 'CD';
    if (lower.contains('cassette')) return 'Cassetta';
    return names.isNotEmpty ? names.first : 'Altro';
  }

  static String? _validUrl(dynamic value) {
    final url = (value ?? '').toString();
    if (url.isEmpty || url.contains('spacer.gif')) return null;
    return url;
  }
}
