import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/album.dart';
import '../../../shared/widgets/album_card.dart';

class LibreriaPage extends StatefulWidget {
  final List<Album> albums;
  const LibreriaPage({super.key, required this.albums});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  String _filter = 'TUTTI';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final albums = widget.albums.where((album) {
      final matchesFormat = _filter == 'TUTTI' || album.format.toUpperCase() == _filter;
      final q = _query.toLowerCase();
      return matchesFormat && ('${album.title} ${album.artist}'.toLowerCase().contains(q));
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search, color: AppColors.muted), hintText: 'Cerca titolo o artista…'),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: ['TUTTI', 'VINILE', 'CD'].map((item) {
          final selected = _filter == item;
          return ChoiceChip(
            label: Text(item, style: const TextStyle(fontSize: 10, letterSpacing: 1)),
            selected: selected,
            onSelected: (_) => setState(() => _filter = item),
            selectedColor: AppColors.amber,
            backgroundColor: AppColors.panelLight,
            labelStyle: TextStyle(color: selected ? AppColors.brownText : AppColors.cream),
            side: BorderSide(color: selected ? Colors.black : AppColors.border, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          );
        }).toList()),
        const SizedBox(height: 14),
        Text('${widget.albums.length} dischi in collezione', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            itemCount: albums.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: .78),
            itemBuilder: (_, index) => AlbumCard(album: albums[index]),
          ),
        ),
      ]),
    );
  }
}
