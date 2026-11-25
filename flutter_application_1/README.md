# Discoteca

![Flutter](https://img.shields.io/badge/Flutter-app-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3-0175C2?logo=dart&logoColor=white)
![API](https://img.shields.io/badge/API-Discogs-333333)

App Flutter per gestire la propria collezione di dischi (vinili, CD e cassette) e la lista dei dischi da cercare al mercatino. I dati dei dischi arrivano dall'API pubblica di **Discogs**.

## L'idea

Quando si va a caccia di dischi è facile non ricordarsi cosa si ha già e cosa si stava cercando. Discoteca tiene tutto in tre schede (Libreria, Da cercare, Cerca), così basta aprire l'app davanti alla bancarella.

## Funzioni

| Scheda | Cosa fa |
| --- | --- |
| **Libreria** | I dischi che possiedi, con ricerca e filtro per formato. Tieni premuto un disco per rimuoverlo (con conferma). |
| **Da cercare** | La lista del mercatino. Scegli un album e la sua copertina appare sulla cassa dei dischi; toccala per aprire il dettaglio. **TROVATO!** sposta il disco in Libreria, con lo swipe lo rimuovi. |
| **Cerca** | Ricerca su Discogs per tutto, artista, titolo, etichetta, anno o genere, con filtro per formato (Vinile, CD, Cassetta), loading, errori e **Riprova**. |
| **Dettaglio** | Copertina, info, prezzo di mercato e tracklist; aggiunta a Libreria o a Da cercare. |
| **Impostazioni** | Icona a forma di ingranaggio: tema marrone o chiaro, lingua italiano o inglese. |

Libreria, lista e impostazioni sono salvate sul dispositivo con `shared_preferences`, quindi non serve nessun server.

## Endpoint Discogs usati

| Metodo | Endpoint | A cosa serve |
| --- | --- | --- |
| `GET` | `https://api.discogs.com/database/search` | Ricerca dei dischi |
| `GET` | `https://api.discogs.com/releases/{id}` | Dettaglio: etichetta, generi, tracklist, prezzo più basso, copie in vendita |

**Parametri della ricerca:** `q` (oppure `artist`, `release_title`, `label`, `year`, `genre`), `type=release`, `per_page=50` e, per il formato, `format` con valore `Vinyl`, `CD` o `Cassette`.

**Header di ogni richiesta:**

```http
Authorization: Discogs token=<token del progetto>
User-Agent: DiscotecaApp/1.0
```

## Come avviarla

Il token Discogs è già incluso nel progetto (`lib/core/config.dart`), quindi non serve configurare niente.

1. Apri l'emulatore Android: da Android Studio vai su **Device Manager** e premi ▶ sul dispositivo (da terminale: `flutter emulators --launch <nome>`).
2. Dalla cartella del progetto scarica i pacchetti e avvia l'app:

```bash
flutter pub get
flutter run
```

`flutter run` installa e apre l'app sull'emulatore acceso. La prima volta ci mette qualche minuto. Se hai più dispositivi collegati, scegli quello giusto con `flutter run -d <id>` (gli id si vedono con `flutter devices`).

Da VS Code basta scegliere l'emulatore in basso a destra e premere **F5**.

## Gestione degli errori

Sono gestiti: niente internet, token non valido (401), disco non trovato (404), troppe richieste (429) e timeout di 15 secondi. In tutti i casi compare un messaggio con il tasto **Riprova**.

## Struttura del codice

```text
lib/
├── core/            config, tema, testi in italiano e inglese
├── models/          Album, ReleaseDetail
├── services/        client Discogs
├── state/           libreria e impostazioni
├── shared/widgets/  componenti riusati
└── features/        una cartella per schermata
```

## Test

```bash
flutter test
```