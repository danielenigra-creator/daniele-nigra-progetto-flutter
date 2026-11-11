import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/album.dart';
import 'cover_image.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const AlbumCard({super.key, required this.album, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
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
              child: SizedBox(
                width: double.infinity,
                child: CoverImage(url: album.coverUrl, title: album.title),
              ),
            ),
            const SizedBox(height: 8),
            Text(album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.brownText, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 3),
            Text(
              [album.artist, if (album.year != null) '${album.year}'].join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF6B5236), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
