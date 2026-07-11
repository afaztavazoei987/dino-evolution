import 'package:flutter/material.dart';
import '../game/dino_game.dart';

// معادل بخش GAME_OVER در حلقه اصلی پایتون
class GameOverOverlay extends StatelessWidget {
  final DinoGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('GAME OVER',
                style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6464))),
            const SizedBox(height: 16),
            Text('Score: ${game.score}',
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Best: ${game.data.highScore}',
                style: const TextStyle(fontSize: 22, color: Colors.yellow)),
            const SizedBox(height: 24),
            const Text('Tap to Restart',
                style: TextStyle(fontSize: 20, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
