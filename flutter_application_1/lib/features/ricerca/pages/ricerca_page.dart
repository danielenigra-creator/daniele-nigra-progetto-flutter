
import 'dart:async';
import 'package:flutter/material.dart';
import '/services/itunes_service.dart';

class RicercaPage extends StatefulWidget {
  const RicercaPage({super.key});

  @override
  State<RicercaPage> createState() => _RicercaPageState();
}

class _RicercaPageState extends State<RicercaPage> {
  final ItunesService _itunesService = ItunesService();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<Map<String, dynamic>> _albums = [];
  bool _loading = false;
  String? _error;

  void _search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _albums = [];
        _loading = false;
        _error = null;
      });
      return;
    }

    // Aspetta che l'utente finisca di scrivere
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        final results = await _itunesService.searchAlbums(query);

        if (!mounted || query != _controller.text) return;

        setState(() {
          _albums = results;
          _loading = false;
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _error = 'Errore durante la ricerca. Riprova.';
          _loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Cerca un album o un artista...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      _search('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _albums.isEmpty
                          ? const Center(
                              child: Text('Cerca un album per iniziare'),
                            )
                          : ListView.builder(
                              itemCount: _albums.length,
                              itemBuilder: (context, index) {
                                final album = _albums[index];

                                return ListTile(
                                  leading: Image.network(
                                    (album['artworkUrl100'] ?? '')
                                        .toString()
                                        .replaceAll('100x100', '300x300'),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.album, size: 50),
                                  ),
                                  title: Text(
                                    album['collectionName'] ?? 'Senza titolo',
                                  ),
                                  subtitle: Text(
                                    album['artistName'] ?? 'Artista sconosciuto',
                                  ),
                                  trailing: const Icon(Icons.add),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
