import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/record_crate.dart';
import '../../../state/collection_store.dart';
import '../../dettaglio/pages/dettaglio_page.dart';

class DaCercarePage extends StatelessWidget {
  final CollectionStore store;
  const DaCercarePage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final albums = store.wanted;
        final current = albums.isEmpty ? null : albums.first;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          children: [
            Row(children: [
              const Expanded(
                child: Text('La tua lista del mercatino',
                    style: TextStyle(color: AppColors.cream, fontSize: 15)),
              ),
              Text('${albums.length} DISCHI',
                  style: const TextStyle(color: AppColors.amber, fontSize: 10)),
            ]),
            const SizedBox(height: 22),
            const RecordCrate(label: 'DA CERCARE'),
            const SizedBox(height: 16),
            if (current == null) ...[
              const SizedBox(height: 12),
              const Text('Nessun disco in lista',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.cream, fontSize: 18)),
              const SizedBox(height: 6),
              const Text('Aggiungine dalla sezione Cerca.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 12)),
            ] else ...[
              Text(current.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold, color: AppColors.cream, fontFamily: 'serif')),
              const SizedBox(height: 8),
              Text(current.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 18),
              Center(
                child: ElevatedButton(
                  onPressed: () => store.addToLibrary(current),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: AppColors.brownText,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('TROVATO!',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.border),
              for (final album in albums)
                Dismissible(
                  key: ValueKey(album.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red.shade900,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) => store.removeFromWanted(album.id),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onTap: () => DettaglioPage.open(context, album, store),
                    title: Text(album.title, style: const TextStyle(color: AppColors.cream)),
                    subtitle: Text(album.subtitle,
                        style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    trailing: IconButton(
                      tooltip: 'Trovato!',
                      icon: const Icon(Icons.check_circle_outline, color: AppColors.amber),
                      onPressed: () => store.addToLibrary(album),
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('scorri a sinistra per rimuovere',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 10)),
              ),
            ],
          ],
        );
      },
    );
  }
}
