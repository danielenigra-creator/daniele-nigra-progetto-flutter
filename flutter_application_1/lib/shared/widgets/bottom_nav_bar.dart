import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.album_outlined, 'LIBRERIA'),
    (Icons.queue_music, 'DA CERCARE'),
    (Icons.graphic_eq, 'SPOTIFY'),
    (Icons.search, 'CERCA'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.header,
        border: Border(top: BorderSide(color: AppColors.amber, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final selected = currentIndex == index;
          final item = _items[index];
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppColors.panelLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.$1, size: 23, color: selected ? AppColors.amber : AppColors.muted),
                    const SizedBox(height: 4),
                    Text(item.$2, style: TextStyle(fontSize: 8, letterSpacing: .4, color: selected ? AppColors.amber : AppColors.muted)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
