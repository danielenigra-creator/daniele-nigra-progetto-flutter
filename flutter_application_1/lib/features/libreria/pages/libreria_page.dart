import 'package:flutter/material.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/album.dart';
import '../../../shared/widgets/album_card.dart';
import '../../../state/collection_store.dart';
import '../../dettaglio/pages/dettaglio_page.dart';

class LibreriaPage extends StatefulWidget {
  final CollectionStore store;
  const LibreriaPage({super.key, required this.store});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  String _filter = 'TUTTI';
  String _query = '';

  Future<void> _confirmRemove(Album album) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.removeTitle),
        content: Text(S.removeBody(album.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.remove),
          ),
        ],
      ),
    );
    if (ok == true) widget.store.removeFromLibrary(album.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final all = widget.store.library;
        final q = _query.toLowerCase();
        final albums = all.where((album) {
          final matchesFormat =
              _filter == 'TUTTI' || album.format.toUpperCase() == _filter;
          return matchesFormat &&
              '${album.title} ${album.artist}'.toLowerCase().contains(q);
        }).toList();

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppColors.muted),
                  hintText: S.searchTitleArtist,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                //aggiunta del formato cassetta
                children: ['TUTTI', 'VINILE', 'CD', 'CASSETTA'].map((item) {
                  final selected = _filter == item;
                  return ChoiceChip(
                    label: Text(
                      S.chip(item),
                      style: TextStyle(fontSize: 10, letterSpacing: 1),
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = item),
                    selectedColor: AppColors.amber,
                    backgroundColor: AppColors.panelLight,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.brownText : AppColors.cream,
                    ),
                    side: BorderSide(
                      color: selected ? Colors.black : AppColors.border,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 14),
              Text(
                S.recordsInCollection(all.length),
                style: TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              SizedBox(height: 12),
              Expanded(
                child: all.isEmpty
                    ? Center(
                        child: Text(
                          S.libraryEmpty,
                          style: TextStyle(
                            color: AppColors.cream,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : albums.isEmpty
                    ? Center(
                        child: Text(
                          S.noRecordsFound,
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    : GridView.builder(
                        itemCount: albums.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: .78,
                            ),
                        itemBuilder: (_, index) {
                          final album = albums[index];
                          return AlbumCard(
                            album: album,
                            onTap: () => DettaglioPage.open(
                              context,
                              album,
                              widget.store,
                            ),
                            onLongPress: () => _confirmRemove(album),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
