import 'package:flutter/material.dart';
import '../game/dino_game.dart';

// معادل بخش HUD (نمایش امتیاز و سرعت) در پایتون
// + یک دکمه لمسی برای «خم شدن» چون روی گوشی کلید جهت‌دار وجود نداره
class HudOverlay extends StatelessWidget {
  final DinoGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final currentSpeed = game.speedGame + game.extraSpeed;
    final textColor = game.nightMode ? Colors.white : Colors.black;

    return Stack(
      children: [
        Positioned(
          left: 15,
          top: 15,
          child: Text('Score: ${game.score}',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        ),
        Positioned(
          left: 15,
          top: 45,
          child: Text('Best: ${game.data.highScore}',
              style: TextStyle(fontSize: 14, color: textColor)),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: Text('Speed: ${currentSpeed.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 14, color: textColor)),
        ),
        // دکمه خم شدن (Duck) - نگه دارید تا خم بمونه
        Positioned(
          left: 20,
          bottom: 20,
          child: GestureDetector(
            onTapDown: (_) => game.setDucking(true),
            onTapUp: (_) => game.setDucking(false),
            onTapCancel: () => game.setDucking(false),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.keyboard_double_arrow_down,
                  color: Colors.white, size: 34),
            ),
          ),
        ),
      ],
    );
  }
}
