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
  // Etichetta del pulsante -> parametro di Discogs
  static const Map<String, String> _fields = {
    'TUTTO': 'q',
    'ARTISTA': 'artist',
    'TITOLO': 'release_title',
    'ETICHETTA': 'label',
    'ANNO': 'year',
    'GENERE': 'genre',
  };

  // Etichetta del filtro -> valore del parametro `format` di Discogs
  static const Map<String, String?> _formats = {
    'TUTTI': null,
    'VINILE': 'Vinyl',
    'CD': 'CD',
    'CASSETTA': 'Cassette',
  };

  static const Map<String, String> _hints = {
    'TUTTO': 'Cerca un album o un artista…',
    'ARTISTA': 'Nome dell\'artista…',
    'TITOLO': 'Titolo dell\'album…',
    'ETICHETTA': 'Etichetta discografica…',
    'ANNO': 'Anno (es. 1991)…',
    'GENERE': 'Genere (es. Rock, Jazz)…',
  };

  final _service = DiscogsService();
  final _controller = TextEditingController();
  Timer? _debounce;
  int _requestId = 0; // ignora le risposte di ricerche ormai superate

  String _field = 'TUTTO';
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
      final results = await _service.searchReleases(
        query,
        format: _formats[_format],
        field: _fields[_field]!,
      );
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = e is DiscogsException
            ? e.message
            : 'Errore imprevisto. Riprova.';
        _loading = false;
      });
    }
  }

  void _addToWanted(Album album) {
    widget.store.addToWanted(album);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('✓ «${album.title}» aggiunto a Da cercare')),
      );
  }

  /// Riga di pulsanti a scelta singola.
  Widget _chips(
    List<String> labels,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: labels.map((label) {
        final isSelected = selected == label;
        return ChoiceChip(
          label: Text(
            label,
            style: const TextStyle(fontSize: 10, letterSpacing: 1),
          ),
          selected: isSelected,
          onSelected: (_) => onSelected(label),
          selectedColor: AppColors.amber,
          backgroundColor: AppColors.panelLight,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.brownText : AppColors.cream,
          ),
          side: BorderSide(
            color: isSelected ? Colors.black : AppColors.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        );
      }).toList(),
    );
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
            keyboardType: _field == 'ANNO'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: _hints[_field],
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
          const Text(
            'CERCA PER',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          _chips(_fields.keys.toList(), _field, (label) {
            setState(() => _field = label);
            _runSearch();
          }),
          const SizedBox(height: 10),
          const Text(
            'FORMATO',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          _chips(_formats.keys.toList(), _format, (label) {
            setState(() => _format = label);
            _runSearch();
          }),
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
      return Center(
        child: ErrorView(message: _error!, onRetry: _runSearch),
      );
    }
    if (_controller.text.trim().isEmpty) {
      return const Center(
        child: Text(
          'Cerca un disco per iniziare',
          style: TextStyle(color: AppColors.muted),
        ),
      );
    }
    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'Nessun risultato',
          style: TextStyle(color: AppColors.muted),
        ),
      );
    }

    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_results.length} dischi trovati · fonte: Discogs',
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
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
