import 'package:flutter/material.dart';
import '../game/dino_game.dart';

// معادل کلاس Menu در پایتون
class MenuOverlay extends StatelessWidget {
  final DinoGame game;
  const MenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'DINO EVOLUTION',
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C3C3C)),
            ),
            const SizedBox(height: 8),
            Text('Best: ${game.data.highScore}',
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            _btn('Play', () => game.startGame()),
            _btn('Skins', () => game.openSkins()),
            _btn('Settings', () => game.openSettings()),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 200,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0F0F0),
            foregroundColor: const Color(0xFF3C3C3C),
          ),
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
