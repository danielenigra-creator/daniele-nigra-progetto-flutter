import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/album.dart';
import '../../../models/release_detail.dart';
import '../../../services/discogs_service.dart';
import '../../../shared/widgets/cover_image.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../state/collection_store.dart';

/// Schermata di dettaglio (ispirata a "Lettore album" del design).
/// Cover/titolo si vedono subito; tracklist e info arrivano da GET /releases/{id}.
class DettaglioPage extends StatefulWidget {
  final Album album;
  final CollectionStore store;
  const DettaglioPage({super.key, required this.album, required this.store});

  static Future<void> open(BuildContext context, Album album, CollectionStore store) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DettaglioPage(album: album, store: store)),
    );
  }

  @override
  State<DettaglioPage> createState() => _DettaglioPageState();
}

class _DettaglioPageState extends State<DettaglioPage> {
  final _service = DiscogsService();
  late Future<ReleaseDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getRelease(widget.album.id);
  }

  void _retry() {
    setState(() => _future = _service.getRelease(widget.album.id));
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        foregroundColor: AppColors.cream,
        title: const Text('DETTAGLIO', style: TextStyle(fontSize: 13, letterSpacing: 2)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CoverImage(url: album.coverUrl, title: album.title),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(album.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cream, fontFamily: 'serif')),
            const SizedBox(height: 6),
            Text(album.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 16),
            _buildActions(),
            const SizedBox(height: 16),
            FutureBuilder<ReleaseDetail>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return ErrorView(
                    message: error is DiscogsException ? error.message : 'Errore imprevisto.',
                    onRetry: _retry,
                  );
                }
                return _DetailBody(detail: snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final store = widget.store;
        final album = widget.album;
        final inLibrary = store.inLibrary(album.id);
        final inWanted = store.inWanted(album.id);

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    inLibrary ? store.removeFromLibrary(album.id) : store.addToLibrary(album),
                style: ElevatedButton.styleFrom(
                  backgroundColor: inLibrary ? AppColors.panelLight : AppColors.amber,
                  foregroundColor: inLibrary ? AppColors.cream : AppColors.brownText,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text(
                  inLibrary ? '✓ IN LIBRERIA · RIMUOVI' : 'AGGIUNGI ALLA LIBRERIA',
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12),
                ),
              ),
            ),
            if (!inLibrary) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      inWanted ? store.removeFromWanted(album.id) : store.addToWanted(album),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.amber,
                    side: const BorderSide(color: AppColors.amber, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    inWanted ? '✓ DA CERCARE · RIMUOVI' : '+ DA CERCARE',
                    style: const TextStyle(letterSpacing: 1, fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final ReleaseDetail detail;
  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    final info = <String>[
      if (detail.label.isNotEmpty)
        detail.catalogNumber.isNotEmpty ? '${detail.label} (${detail.catalogNumber})' : detail.label,
      if (detail.country.isNotEmpty) detail.country,
      ...detail.genres,
      ...detail.styles,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (info.isNotEmpty)
          Text(info.join(' · '), style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        if (detail.lowestPrice != null) ...[
          const SizedBox(height: 8),
          Text(
            'Mercato Discogs: da \$${detail.lowestPrice!.toStringAsFixed(2)}'
            '${detail.numForSale != null ? ' · ${detail.numForSale} in vendita' : ''}',
            style: const TextStyle(color: AppColors.amber, fontSize: 11),
          ),
        ],
        const SizedBox(height: 16),
        const Text('BRANI', style: TextStyle(color: AppColors.amber, letterSpacing: 1, fontSize: 10)),
        const Divider(color: AppColors.border),
        if (detail.tracks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Tracklist non disponibile.', style: TextStyle(color: AppColors.muted)),
          )
        else
          for (final track in detail.tracks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(track.position,
                        style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  ),
                  Expanded(
                    child: Text(track.title,
                        style: const TextStyle(color: AppColors.cream, fontSize: 14)),
                  ),
                  Text(track.duration, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                ],
              ),
            ),
      ],
    );
  }
}
