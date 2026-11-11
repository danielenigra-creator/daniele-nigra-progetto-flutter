import 'package:flutter/material.dart';
import 'app.dart';
import 'state/collection_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = CollectionStore();
  await store.load(); // ripristina libreria e lista salvate
  runApp(DiscotecaApp(store: store));
}
