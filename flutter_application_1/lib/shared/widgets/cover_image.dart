import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Copertina da rete, con spinner mentre carica e segnaposto se manca o fallisce.
class CoverImage extends StatelessWidget {
  final String url;
  final String title;
  const CoverImage({super.key, required this.url, this.title = ''});

  Widget _placeholder() => Container(
        color: const Color(0xFF704A32),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.album, size: 48, color: Colors.white24),
            if (title.isNotEmpty)
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.cream,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.panelLight,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
