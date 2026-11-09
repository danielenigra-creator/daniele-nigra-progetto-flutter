import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  Color get _cover {
    switch (album.coverColor) {
      case 'blue': return const Color(0xFF314A67);
      case 'green': return const Color(0xFF66734D);
      case 'cream': return const Color(0xFFB98B58);
      default: return const Color(0xFF704A32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [BoxShadow(color: Colors.black54, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: _cover,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.album, size: 74, color: Colors.white24),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(album.title.toUpperCase(), textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.brownText, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 3),
          Text('${album.artist} · ${album.year}', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF6B5236), fontSize: 9)),
        ],
      ),
    );
  }
}
