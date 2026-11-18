/// Testi dell'app in italiano e inglese.
/// La lingua attiva è [S.english], impostata da SettingsStore.
class S {
  static bool english = false;

  static String _t(String it, String en) => english ? en : it;

  // ---- Impostazioni
  static String get settings => _t('Impostazioni', 'Settings');
  static String get lightTheme => _t('Tema chiaro', 'Light theme');
  static String get language => _t('Lingua', 'Language');

  /// Etichetta del tasto: mostra la lingua verso cui si passa.
  static String get switchLanguageButton => _t('ENGLISH', 'ITALIANO');

  // ---- Navigazione
  static String get navLibrary => _t('LIBRERIA', 'LIBRARY');
  static String get navWanted => _t('DA CERCARE', 'TO FIND');
  static String get navSearch => _t('CERCA', 'SEARCH');

  // ---- Libreria
  static String get removeTitle =>
      _t('Rimuovere il disco?', 'Remove this record?');
  static String removeBody(String title) => _t(
    '«$title» verrà tolto dalla libreria.',
    '«$title» will be removed from your library.',
  );
  static String get cancel => _t('ANNULLA', 'CANCEL');
  static String get remove => _t('RIMUOVI', 'REMOVE');
  static String get searchTitleArtist =>
      _t('Cerca titolo o artista…', 'Search title or artist…');
  static String recordsInCollection(int n) =>
      _t('$n dischi in collezione', '$n records in your collection');
  static String get libraryEmpty =>
      _t('La libreria è vuota', 'Your library is empty');
  static String get noRecordsFound =>
      _t('Nessun disco trovato', 'No records found');

  // ---- Da cercare
  static String get wantedListTitle =>
      _t('La tua lista del mercatino', 'Your flea-market list');
  static String recordsCount(int n) => _t('$n DISCHI', '$n RECORDS');
  static String get wantedEmpty =>
      _t('Nessun disco in lista', 'No records on the list');
  static String get wantedEmptyHint =>
      _t('Aggiungine dalla sezione Cerca.', 'Add some from the Search tab.');
  static String get foundIt => _t('TROVATO!', 'FOUND IT!');
  static String get foundItTooltip => _t('Trovato!', 'Found it!');
  static String get tapForDetails =>
      _t('tocca per vedere i brani', 'tap to see the tracks');
  static String get swipeToRemove =>
      _t('scorri a sinistra per rimuovere', 'swipe left to remove');

  // ---- Dettaglio
  static String get details => _t('DETTAGLIO', 'DETAILS');
  static String get unexpectedError =>
      _t('Errore imprevisto.', 'Unexpected error.');
  static String get inLibraryRemove =>
      _t('✓ IN LIBRERIA · RIMUOVI', '✓ IN LIBRARY · REMOVE');
  static String get addToLibrary =>
      _t('AGGIUNGI ALLA LIBRERIA', 'ADD TO LIBRARY');
  static String get wantedRemove =>
      _t('✓ DA CERCARE · RIMUOVI', '✓ TO FIND · REMOVE');
  static String get inLibraryShort => _t('✓ IN LIBRERIA', '✓ IN LIBRARY');
  static String get addedShort => _t('✓ AGGIUNTO', '✓ ADDED');
  static String get addToWanted => _t('+ DA CERCARE', '+ TO FIND');
  static String market(String price, int? forSale) => english
      ? 'Discogs market: from \$$price${forSale != null ? ' · $forSale for sale' : ''}'
      : 'Mercato Discogs: da \$$price${forSale != null ? ' · $forSale in vendita' : ''}';
  static String get tracks => _t('BRANI', 'TRACKS');
  static String get noTracklist =>
      _t('Tracklist non disponibile.', 'Tracklist not available.');

  // ---- Ricerca
  static String get searchBy => _t('CERCA PER', 'SEARCH BY');
  static String get format => _t('FORMATO', 'FORMAT');
  static String get missingToken => _t(
    'Manca il token Discogs: la ricerca non funzionerà (vedi README).',
    'Discogs token missing: search will not work (see README).',
  );
  static String get searchToStart =>
      _t('Cerca un disco per iniziare', 'Search for a record to start');
  static String get noResults => _t('Nessun risultato', 'No results');
  static String resultsFound(int n) => _t(
    '$n dischi trovati · fonte: Discogs',
    '$n records found · source: Discogs',
  );
  static String get unexpectedErrorRetry =>
      _t('Errore imprevisto. Riprova.', 'Unexpected error. Try again.');
  static String addedToWanted(String title) =>
      _t('✓ «$title» aggiunto a Da cercare', '✓ «$title» added to To find');
  static String get retry => _t('RIPROVA', 'RETRY');

  static String hint(String field) {
    switch (field) {
      case 'ARTISTA':
        return _t("Nome dell'artista…", 'Artist name…');
      case 'TITOLO':
        return _t("Titolo dell'album…", 'Album title…');
      case 'ETICHETTA':
        return _t('Etichetta discografica…', 'Record label…');
      case 'ANNO':
        return _t('Anno (es. 1991)…', 'Year (e.g. 1991)…');
      case 'GENERE':
        return _t('Genere (es. Rock, Jazz)…', 'Genre (e.g. Rock, Jazz)…');
      default:
        return _t(
          'Cerca un album o un artista…',
          'Search for an album or an artist…',
        );
    }
  }

  /// Etichetta dei pulsanti-filtro. Le chiavi interne restano in italiano.
  static String chip(String key) {
    if (!english) return key;
    switch (key) {
      case 'TUTTI':
      case 'TUTTO':
        return 'ALL';
      case 'VINILE':
        return 'VINYL';
      case 'CASSETTA':
        return 'CASSETTE';
      case 'ARTISTA':
        return 'ARTIST';
      case 'TITOLO':
        return 'TITLE';
      case 'ETICHETTA':
        return 'LABEL';
      case 'ANNO':
        return 'YEAR';
      case 'GENERE':
        return 'GENRE';
      default:
        return key; // CD
    }
  }

  // ---- Valori salvati nei dati (restano in italiano nel salvataggio)
  static String formatName(String stored) {
    if (!english) return stored;
    switch (stored) {
      case 'Vinile':
        return 'Vinyl';
      case 'Cassetta':
        return 'Cassette';
      case 'Altro':
        return 'Other';
      default:
        return stored;
    }
  }

  static String artistName(String stored) =>
      english && stored == 'Artista sconosciuto' ? 'Unknown artist' : stored;

  // ---- Errori Discogs
  static String get errMissingToken => _t(
    'Token Discogs mancante. Vedi il README per configurarlo.',
    'Discogs token missing. See the README to set it up.',
  );
  static String get errInvalidToken => _t(
    'Token Discogs non valido o scaduto.',
    'Discogs token invalid or expired.',
  );
  static String get errNotFound =>
      _t('Disco non trovato su Discogs.', 'Record not found on Discogs.');
  static String get errTooMany => _t(
    'Troppe richieste a Discogs. Aspetta un minuto e riprova.',
    'Too many requests to Discogs. Wait a minute and try again.',
  );
  static String errDiscogs(int code) =>
      _t('Errore Discogs ($code).', 'Discogs error ($code).');
  static String get errInvalidResponse =>
      _t('Risposta di Discogs non valida.', 'Invalid response from Discogs.');
  static String get errTimeout => _t(
    'Discogs non risponde. Riprova.',
    'Discogs is not responding. Try again.',
  );
  static String get errOffline =>
      _t('Nessuna connessione a internet.', 'No internet connection.');
}
