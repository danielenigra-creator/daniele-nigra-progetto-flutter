import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/album.dart';
import '../../../shared/widgets/record_crate.dart';

class DaCercarePage extends StatelessWidget {
  final List<Album> albums;
  final ValueChanged<Album> onFound;
  const DaCercarePage({super.key, required this.albums, required this.onFound});

  @override
  Widget build(BuildContext context) {
    final current = albums.isEmpty ? null : albums.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(children: [
        Row(children: [
          const Expanded(child: Text('La tua lista del mercatino', style: TextStyle(color: AppColors.cream, fontSize: 15))),
          Text('${albums.length} DISCHI', style: const TextStyle(color: AppColors.amber, fontSize: 10)),
        ]),
        const SizedBox(height: 22),
        const RecordCrate(label: 'DA CERCARE'),
        const SizedBox(height: 16),
        if (current != null) ...[
          Text(current.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: AppColors.cream, fontFamily: 'serif')),
          const SizedBox(height: 8),
          Text('${current.artist} · ${current.year} · ${current.format}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => onFound(current),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber, foregroundColor: AppColors.brownText, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            child: const Text('TROVATO!', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const SizedBox(height: 12),
          Text('1 / ${albums.length}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: albums.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.border),
              itemBuilder: (_, i) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(albums[i].title, style: const TextStyle(color: AppColors.cream)),
                subtitle: Text('${albums[i].artist} · ${albums[i].year}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                trailing: IconButton(icon: const Icon(Icons.check_circle_outline, color: AppColors.amber), onPressed: () => onFound(albums[i])),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 28),
          const Text('Hai trovato tutti i dischi!', style: TextStyle(color: AppColors.cream, fontSize: 18)),
          const Text('Aggiungine altri dalla sezione Cerca.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ]),
    );
  }
}
