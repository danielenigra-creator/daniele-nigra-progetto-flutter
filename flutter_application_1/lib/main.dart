import 'package:flutter/material.dart';
import 'app.dart';
import 'state/collection_store.dart';
import 'state/settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsStore();
  await settings.load(); // ripristina tema e lingua scelti
  final store = CollectionStore();
  await store.load(); // ripristina libreria e lista salvate
  runApp(DiscotecaApp(store: store, settings: settings));
}
