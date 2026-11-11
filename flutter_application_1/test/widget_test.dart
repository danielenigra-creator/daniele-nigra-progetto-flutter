import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/models/album.dart';
import 'package:flutter_application_1/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter_application_1/state/collection_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Album.fromSearchResult separa artista e titolo (formato Discogs)', () {
    final album = Album.fromSearchResult({
      'id': 249504,
      'title': 'Fleetwood Mac - Rumours',
      'year': '1977',
      'format': ['Vinyl', 'LP', 'Album'],
      'genre': ['Rock'],
      'cover_image': 'https://example.com/cover.jpg',
    });

    expect(album.id, '249504');
    expect(album.artist, 'Fleetwood Mac');
    expect(album.title, 'Rumours');
    expect(album.year, 1977);
    expect(album.format, 'Vinile');
    expect(album.genre, 'Rock');
  });

  test('"Trovato" sposta il disco da "da cercare" alla libreria', () {
    final store = CollectionStore();
    const album = Album(id: '1', title: 'Blue', artist: 'Joni Mitchell');

    store.addToWanted(album);
    expect(store.inWanted('1'), isTrue);

    store.addToLibrary(album);
    expect(store.inWanted('1'), isFalse);
    expect(store.inLibrary('1'), isTrue);
  });

  testWidgets('si può navigare tra le tre schermate', (tester) async {
    await tester.pumpWidget(DiscotecaApp(store: CollectionStore()));

    expect(find.text('La libreria è vuota'), findsOneWidget);

    final nav = find.byType(BottomNavBar);

    await tester.tap(find.descendant(of: nav, matching: find.text('DA CERCARE')));
    await tester.pump();
    expect(find.text('Nessun disco in lista'), findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('CERCA')));
    await tester.pump();
    expect(find.text('Cerca un disco per iniziare'), findsOneWidget);
  });
}
