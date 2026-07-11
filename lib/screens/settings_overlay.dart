import 'package:flutter/material.dart';
import '../game/dino_game.dart';
import '../game/data_manager.dart';

// معادل کلاس Settings در پایتون
class SettingsOverlay extends StatefulWidget {
  final DinoGame game;
  const SettingsOverlay({super.key, required this.game});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  @override
  Widget build(BuildContext context) {
    final data = widget.game.data;
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('SETTINGS',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C3C3C))),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('SFX'),
              value: data.sfx,
              onChanged: (v) {
                setState(() => data.sfx = v);
                DataManager.save(data);
              },
            ),
            SwitchListTile(
              title: const Text('Music'),
              value: data.music,
              onChanged: (v) {
                setState(() => data.music = v);
                DataManager.save(data);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => widget.game.goToMenu(),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
