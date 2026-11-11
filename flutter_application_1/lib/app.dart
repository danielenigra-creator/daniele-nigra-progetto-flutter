import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/da_cercare/pages/da_cercare_page.dart';
import 'features/libreria/pages/libreria_page.dart';
import 'features/ricerca/pages/ricerca_page.dart';
import 'shared/widgets/app_header.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'state/collection_store.dart';

class DiscotecaApp extends StatelessWidget {
  final CollectionStore store;
  const DiscotecaApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discoteca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: HomeShell(store: store),
    );
  }
}

/// Struttura principale: header + 3 schede con barra di navigazione in basso.
class HomeShell extends StatefulWidget {
  final CollectionStore store;
  const HomeShell({super.key, required this.store});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  LibreriaPage(store: store),
                  DaCercarePage(store: store),
                  RicercaPage(store: store),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
