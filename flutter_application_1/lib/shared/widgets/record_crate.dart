import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/album.dart';
import 'cover_image.dart';

/// Cassa dei dischi. Se [album] è indicato mostra la sua copertina al posto
/// del disco; se è null (lista vuota) mostra il disco nero.
class RecordCrate extends StatelessWidget {
  final String label;
  final Album? album;
  const RecordCrate({super.key, this.label = 'DISCHI', this.album});

  /// Disco nero (quando non c'è nessun album da mostrare).
  Widget _disc() {
    return Container(
      key: ValueKey('disc'),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF171311),
        border: Border.all(color: AppColors.muted, width: 5),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.amber,
            border: Border.all(color: AppColors.onWood, width: 3),
          ),
          child: Center(
            child: Icon(Icons.album, color: AppColors.onAmber, size: 22),
          ),
        ),
      ),
    );
  }

  /// Copertina dell'album scelto, nello stesso punto del disco.
  Widget _cover(Album a) {
    return Container(
      key: ValueKey(a.id),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.panelLight,
        border: Border.all(color: AppColors.onWood, width: 4),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: CoverImage(url: a.coverUrl, title: a.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = album;
    return SizedBox(
      height: 210, // il disco arriva a 198: serve spazio per non tagliarlo
      child: Stack(
        clipBehavior: Clip.none, // non taglia ciò che esce dal contenitore
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 58,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8A542B),
                border: Border.all(color: Color(0xFFB77B43), width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  19,
                  (_) => Container(width: 4, color: Color(0xFF5B351D)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            // Dissolvenza quando cambia l'album scelto
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: current == null ? _disc() : _cover(current),
            ),
          ),
          Positioned(
            bottom: 17,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.onWood,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
