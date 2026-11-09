class Album {
  final String id;
  final String title;
  final String artist;
  final int year;
  final String format;
  final String genre;
  final String coverColor;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.format,
    this.genre = 'Rock',
    this.coverColor = 'dark',
  });
}
