import 'package:flutter/material.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/record_crate.dart';
import '../../../state/collection_store.dart';
import '../../dettaglio/pages/dettaglio_page.dart';

class DaCercarePage extends StatefulWidget {
  final CollectionStore store;
  const DaCercarePage({super.key, required this.store});

  @override
  State<DaCercarePage> createState() => _DaCercarePageState();
}

class _DaCercarePageState extends State<DaCercarePage> {
  // Album scelto dalla lista: il suo nome compare sotto al disco.
  // Se è null (o l'album è stato rimosso) si mostra l'ultimo aggiunto.
  String? _selectedId;
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _select(String id) {
    setState(() => _selectedId = id);
    // Torna in cima, così si vede subito il nome sotto al disco.
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final albums = store.wanted;
        final current = albums.isEmpty
            ? null
            : albums.firstWhere(
                (a) => a.id == _selectedId,
                orElse: () => albums.first,
              );

        return ListView(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.wantedListTitle,
                    style: TextStyle(color: AppColors.cream, fontSize: 15),
                  ),
                ),
                Text(
                  S.recordsCount(albums.length),
                  style: TextStyle(color: AppColors.amber, fontSize: 10),
                ),
              ],
            ),
            SizedBox(height: 22),
            // Toccando il disco si aprono i dettagli dell'album mostrato
            GestureDetector(
              onTap: current == null
                  ? null
                  : () => DettaglioPage.open(context, current, store),
              child: RecordCrate(label: S.navWanted),
            ),
            SizedBox(height: 16),
            if (current == null) ...[
              SizedBox(height: 12),
              Text(
                S.wantedEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.cream, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                S.wantedEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ] else ...[
              // Nome sotto al disco: toccandolo si apre la pagina con le canzoni
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => DettaglioPage.open(context, current, store),
                child: Column(
                  children: [
                    Text(
                      current.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cream,
                        fontFamily: 'serif',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      current.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    SizedBox(height: 6),
                    Text(
                      S.tapForDetails,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.amber, fontSize: 10),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: ElevatedButton(
                  onPressed: () => store.addToLibrary(current),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: AppColors.brownText,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    S.foundIt,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: AppColors.border),
              for (final album in albums)
                Dismissible(
                  key: ValueKey(album.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red.shade900,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) => store.removeFromWanted(album.id),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    // Tocco sulla riga: l'album va sotto al disco
                    onTap: () => _select(album.id),
                    title: Text(
                      album.title,
                      style: TextStyle(
                        // l'album scelto è evidenziato in ambra
                        color: album.id == current.id
                            ? AppColors.amber
                            : AppColors.cream,
                        fontWeight: album.id == current.id
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      album.subtitle,
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                    trailing: IconButton(
                      tooltip: S.foundItTooltip,
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: AppColors.amber,
                      ),
                      onPressed: () => store.addToLibrary(album),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  S.swipeToRemove,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
