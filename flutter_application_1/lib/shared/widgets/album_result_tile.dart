import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/album.dart';
import 'cover_image.dart';

/// Riga di risultato di ricerca (come "Cerca" nel design Figma).
class AlbumResultTile extends StatelessWidget {
  final Album album;
  final bool inLibrary;
  final bool inWanted;
  final VoidCallback onTap;
  final VoidCallback onAddWanted;

  const AlbumResultTile({
    super.key,
    required this.album,
    required this.inLibrary,
    required this.inWanted,
    required this.onTap,
    required this.onAddWanted,
  });

  @override
  Widget build(BuildContext context) {
    final meta = [
      if (album.year != null) '${album.year}',
      album.format,
      if (album.genre.isNotEmpty) album.genre,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CoverImage(url: album.coverUrl, title: album.title),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.cream, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(album.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      const SizedBox(height: 3),
                      Text(meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _action(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _action() {
    if (inLibrary || inWanted) {
      return Text(
        inLibrary ? '✓ IN LIBRERIA' : '✓ AGGIUNTO',
        style: const TextStyle(color: AppColors.amber, fontSize: 9, letterSpacing: .5),
      );
    }
    return OutlinedButton(
      onPressed: onAddWanted,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.amber,
        side: const BorderSide(color: AppColors.amber, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text('+ DA CERCARE', style: TextStyle(fontSize: 9, letterSpacing: .5)),
    );
  }
}
