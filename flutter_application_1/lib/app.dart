import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'features/da_cercare/pages/da_cercare_page.dart';
import 'features/libreria/pages/libreria_page.dart';
import 'features/ricerca/pages/ricerca_page.dart';
import 'shared/widgets/app_header.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'state/collection_store.dart';
import 'state/settings_store.dart';

class DiscotecaApp extends StatelessWidget {
  final CollectionStore store;
  final SettingsStore settings;
  const DiscotecaApp({super.key, required this.store, required this.settings});

  @override
  Widget build(BuildContext context) {
    // Ricostruisce l'app quando cambiano tema o lingua.
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        title: 'Discoteca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.current,
        builder: (context, child) {
          // Rispetta anche la dimensione del testo scelta nelle impostazioni del telefono
          final system = MediaQuery.textScalerOf(context).scale(1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(system * AppTheme.textScale),
            ),
            child: child!,
          );
        },
        home: HomeShell(store: store, settings: settings),
      ),
    );
  }
}

/// Struttura principale: header + 3 schede con barra di navigazione in basso.
class HomeShell extends StatefulWidget {
  final CollectionStore store;
  final SettingsStore settings;
  const HomeShell({super.key, required this.store, required this.settings});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    // Si ricostruisce quando cambiano tema/lingua, così tutti i widget
    // sotto rileggono colori e testi aggiornati.
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) {
        final light = widget.settings.isLight;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          // Icone della status bar scure sul tema chiaro, chiare sul marrone.
          value: (light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light)
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppHeader(settings: widget.settings),
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
          ),
        );
      },
    );
  }
}
