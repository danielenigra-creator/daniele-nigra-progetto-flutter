import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../state/settings_store.dart';
import 'settings_sheet.dart';

class AppHeader extends StatelessWidget {
  final SettingsStore settings;
  const AppHeader({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    // Il padding in alto per la status bar lo gestisce la SafeArea di chi lo usa.
    return Container(
      width: double.infinity,
      color: AppColors.header,
      padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
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
                decoration: BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Disco', style: TextStyle(color: AppColors.cream)),
              TextSpan(text: 'teca', style: TextStyle(color: AppColors.amber)),
            ]),
            style: const TextStyle(
                fontSize: 27, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'serif'),
          ),
          const Spacer(),
          IconButton(
            tooltip: S.settings,
            icon: Icon(Icons.settings, color: AppColors.cream),
            onPressed: () => SettingsSheet.show(context, settings),
          ),
        ],
      ),
    );
  }
}
