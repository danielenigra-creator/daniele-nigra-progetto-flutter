import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/sample_albums.dart';
import 'features/da_cercare/pages/da_cercare_page.dart';
import 'features/libreria/pages/libreria_page.dart';
import 'features/ricerca/pages/ricerca_page.dart';
import 'features/spotify/pages/spotify_page.dart';
import 'models/album.dart';
import 'shared/widgets/app_header.dart';
import 'shared/widgets/bottom_nav_bar.dart';

class DiscotecaApp extends StatefulWidget {
  const DiscotecaApp({super.key});

  @override
  State<DiscotecaApp> createState() => _DiscotecaAppState();
}

class _DiscotecaAppState extends State<DiscotecaApp> {
  int _currentIndex = 0;
  final List<Album> _library = List.of(sampleLibrary);
  final List<Album> _wanted = List.of(sampleWanted);

  void _addToWanted(Album album) {
    setState(() {
      if (!_wanted.any((item) => item.id == album.id)) {
        _wanted.add(album);
      }
    });
  }

  void _markFound(Album album) {
    setState(() {
      _wanted.removeWhere((item) => item.id == album.id);
      if (!_library.any((item) => item.id == album.id)) {
        _library.add(album);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LibreriaPage(albums: _library),
      DaCercarePage(albums: _wanted, onFound: _markFound),
      const SpotifyPage(),
      RicercaPage(onAdd: _addToWanted, wantedAlbums: _wanted),
    ];

    return MaterialApp(
      title: 'Discoteca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
