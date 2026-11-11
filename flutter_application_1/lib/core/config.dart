class AppConfig {
  static const String discogsToken = String.fromEnvironment(
    'DISCOGS_TOKEN',
    defaultValue: 'ijtZnUOydKQwKAISCTjZrEcPUnNWdwCOgYnwJfzl',
  );

  static bool get hasToken =>
      discogsToken.isNotEmpty && discogsToken != 'INCOLLA_QUI_IL_TUO_TOKEN';

  /// Discogs richiede uno User-Agent identificativo.
  static const String userAgent = 'DiscotecaApp/1.0';
}