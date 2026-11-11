import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/album.dart';
import '../../../services/discogs_service.dart';
import '../../../shared/widgets/album_result_tile.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../state/collection_store.dart';
import '../../dettaglio/pages/dettaglio_page.dart';

class RicercaPage extends StatefulWidget {
  final CollectionStore store;
  const RicercaPage({super.key, required this.store});

  @override
  State<RicercaPage> createState() => _RicercaPageState();
}

class _RicercaPageState extends State<RicercaPage> {
  // Etichetta del filtro -> valore del parametro `format` di Discogs
  static const Map<String, String?> _formats = {
    'TUTTI': null,
    'VINILE': 'Vinyl',
    'CD': 'CD',
  };

  final _service = DiscogsService();
  final _controller = TextEditingController();
  Timer? _debounce;
  int _requestId = 0; // ignora le risposte di ricerche ormai superate

  String _format = 'TUTTI';
  List<Album> _results = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    _debounce?.cancel();
    if (_controller.text.trim().isEmpty) {
      _requestId++;
      setState(() {
        _results = [];
        _loading = false;
        _error = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), _runSearch);
  }

  Future<void> _runSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final id = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _service.searchReleases(query, format: _formats[_format]);
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = e is DiscogsException ? e.message : 'Errore imprevisto. Riprova.';
        _loading = false;
      });
    }
  }

  void _addToWanted(Album album) {
    widget.store.addToWanted(album);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('✓ «${album.title}» aggiunto a Da cercare')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: (_) => _runSearch(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cerca un album o un artista…',
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: AppColors.muted),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _formats.keys.map((label) {
              final selected = _format == label;
              return ChoiceChip(
                label: Text(label, style: const TextStyle(fontSize: 10, letterSpacing: 1)),
                selected: selected,
                onSelected: (_) {
                  setState(() => _format = label);
                  _runSearch();
                },
                selectedColor: AppColors.amber,
                backgroundColor: AppColors.panelLight,
                labelStyle: TextStyle(color: selected ? AppColors.brownText : AppColors.cream),
                side: BorderSide(color: selected ? Colors.black : AppColors.border, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          if (!AppConfig.hasToken)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Manca il token Discogs: la ricerca non funzionerà (vedi README).',
                style: TextStyle(color: AppColors.amber, fontSize: 11),
              ),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: ErrorView(message: _error!, onRetry: _runSearch));
    }
    if (_controller.text.trim().isEmpty) {
      return const Center(
        child: Text('Cerca un disco per iniziare', style: TextStyle(color: AppColors.muted)),
      );
    }
    if (_results.isEmpty) {
      return const Center(
        child: Text('Nessun risultato', style: TextStyle(color: AppColors.muted)),
      );
    }

    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_results.length} dischi trovati · fonte: Discogs',
              style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, i) {
                final album = _results[i];
                return AlbumResultTile(
                  album: album,
                  inLibrary: widget.store.inLibrary(album.id),
                  inWanted: widget.store.inWanted(album.id),
                  onTap: () => DettaglioPage.open(context, album, widget.store),
                  onAddWanted: () => _addToWanted(album),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
