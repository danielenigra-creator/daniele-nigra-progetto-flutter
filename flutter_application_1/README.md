# Discoteca

App Flutter per gestire la propria collezione di dischi (vinili e CD) e la lista dei dischi
da cercare al mercatino. I dati dei dischi arrivano dall'API pubblica di **Discogs**.

## Funzioni
- **Cerca**: ricerca per album/artista su Discogs (filtro Vinile/CD), con loading, errori e "Riprova".
- **Dettaglio**: cover, info e tracklist del disco; aggiunta a Libreria o a Da cercare.
- **Libreria**: i dischi che possiedi, con ricerca e filtro per formato (tieni premuto per rimuovere).
- **Da cercare**: la lista del mercatino; "TROVATO!" sposta il disco in libreria (swipe per rimuovere).
- Libreria e lista sono salvate sul dispositivo (SharedPreferences).

## Endpoint Discogs usati
- `GET https://api.discogs.com/database/search?q=...&type=release&format=...` (serve il token)
- `GET https://api.discogs.com/releases/{id}`

## Configurazione (obbligatoria per la ricerca)
1. Crea un token su discogs.com → Settings → Developers → *Generate new token*.
2. Avvia l'app passando il token (non committarlo su Git):

```
flutter pub get
flutter run --dart-define=DISCOGS_TOKEN=il_tuo_token
```

Test: `flutter test`
