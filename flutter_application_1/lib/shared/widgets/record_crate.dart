import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RecordCrate extends StatelessWidget {
  final String label;
  const RecordCrate({super.key, this.label = 'DISCHI'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0, left: 0, right: 0, height: 58,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8A542B),
                border: Border.all(color: const Color(0xFFB77B43), width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(19, (_) => Container(width: 4, color: const Color(0xFF5B351D))),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF171311),
                border: Border.all(color: AppColors.muted, width: 5),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8)],
              ),
              child: Center(
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.amber, border: Border.all(color: AppColors.cream, width: 3)),
                  child: const Center(child: Icon(Icons.album, color: AppColors.brownText, size: 22)),
                ),
              ),
            ),
          ),
          Positioned(bottom: 17, child: Text(label, style: const TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold, letterSpacing: 2))),
        ],
      ),
    );
  }
}
