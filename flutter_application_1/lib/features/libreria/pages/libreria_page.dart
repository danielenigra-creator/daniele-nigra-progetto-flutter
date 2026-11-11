import 'package:flutter/material.dart';
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
        title: const Text('Rimuovere il disco?'),
        content: Text('«${album.title}» verrà tolto dalla libreria.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULLA')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('RIMUOVI')),
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
          final matchesFormat = _filter == 'TUTTI' || album.format.toUpperCase() == _filter;
          return matchesFormat && '${album.title} ${album.artist}'.toLowerCase().contains(q);
        }).toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppColors.muted),
                  hintText: 'Cerca titolo o artista…',
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['TUTTI', 'VINILE', 'CD'].map((item) {
                  final selected = _filter == item;
                  return ChoiceChip(
                    label: Text(item, style: const TextStyle(fontSize: 10, letterSpacing: 1)),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = item),
                    selectedColor: AppColors.amber,
                    backgroundColor: AppColors.panelLight,
                    labelStyle: TextStyle(color: selected ? AppColors.brownText : AppColors.cream),
                    side: BorderSide(color: selected ? Colors.black : AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Text('${all.length} dischi in collezione',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 12),
              Expanded(
                child: all.isEmpty
                    ? const Center(
                        child: Text(
                          'La libreria è vuota',
                          style: TextStyle(color: AppColors.cream, fontSize: 16),
                        ),
                      )
                    : albums.isEmpty
                        ? const Center(
                            child: Text('Nessun disco trovato', style: TextStyle(color: AppColors.muted)),
                          )
                        : GridView.builder(
                            itemCount: albums.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: .78,
                            ),
                            itemBuilder: (_, index) {
                              final album = albums[index];
                              return AlbumCard(
                                album: album,
                                onTap: () => DettaglioPage.open(context, album, widget.store),
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
