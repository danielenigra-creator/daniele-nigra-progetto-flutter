import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/record_crate.dart';

class SpotifyPage extends StatefulWidget {
  const SpotifyPage({super.key});

  @override
  State<SpotifyPage> createState() => _SpotifyPageState();
}

class _SpotifyPageState extends State<SpotifyPage> {
  bool _favorites = true;
  final Set<String> _saved = {'Rumours', 'Blue', 'Abbey Road'};
  final tracks = ['Second Hand News', 'Dreams', 'Never Going Back Again', "Don't Stop", 'Go Your Own Way'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _switchButton('♥ PREFERITI', _favorites, () => setState(() => _favorites = true))),
          SizedBox(width: 8),
          Expanded(child: _switchButton('CERCA', !_favorites, () => setState(() => _favorites = false))),
        ]),
        SizedBox(height: 10),
        Row(children: [
          Expanded(child: _switchButton('ALBUM SALVATI', true, () {})),
          SizedBox(width: 8),
          Expanded(child: _switchButton('ARTISTI SEGUITI', false, () {})),
        ]),
        SizedBox(height: 18),
        if (_favorites) ...[
          RecordCrate(label: 'SPOTIFY'),
          SizedBox(height: 10),
          Center(child: Text('I TUOI ALBUM PREFERITI', style: TextStyle(color: AppColors.amber, letterSpacing: 1, fontSize: 10))),
          SizedBox(height: 8),
          Expanded(child: ListView(
            children: _saved.map((name) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.album, color: AppColors.amber),
              title: Text(name, style: TextStyle(color: AppColors.cream)),
              trailing: IconButton(icon: Icon(Icons.favorite, color: AppColors.amber), onPressed: () => setState(() => _saved.remove(name))),
            )).toList(),
          )),
        ] else ...[
          Text('Cerca nella tua musica', style: TextStyle(color: AppColors.cream, fontSize: 18)),
          SizedBox(height: 10),
          TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cerca album o artista…')),
          SizedBox(height: 16),
          Text('Album salvati', style: TextStyle(color: AppColors.amber)),
          Expanded(child: ListView(children: _saved.map((name) => ListTile(title: Text(name), leading: Icon(Icons.album, color: AppColors.amber))).toList())),
        ],
      ]),
    );
  }

  Widget _switchButton(String label, bool selected, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.amber : AppColors.panelLight,
        foregroundColor: selected ? AppColors.brownText : AppColors.cream,
        side: BorderSide(color: selected ? Colors.black : AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, letterSpacing: .5)),
    );
  }
}
