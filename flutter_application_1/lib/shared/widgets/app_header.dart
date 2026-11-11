import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Il padding in alto per la status bar lo gestisce la SafeArea di chi lo usa.
    return Container(
      width: double.infinity,
      color: AppColors.header,
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.amber, width: 3),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Disco', style: TextStyle(color: AppColors.cream)),
              TextSpan(text: 'teca', style: TextStyle(color: AppColors.amber)),
            ]),
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'serif'),
          ),
        ],
      ),
    );
  }
}
