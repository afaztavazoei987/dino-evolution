import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/dino_game.dart';
import 'game/constants.dart';
import 'screens/menu_overlay.dart';
import 'screens/settings_overlay.dart';
import 'screens/skins_overlay.dart';
import 'screens/game_over_overlay.dart';
import 'screens/hud_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DinoApp());
}

class DinoApp extends StatelessWidget {
  const DinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = DinoGame();
    return MaterialApp(
      title: 'Dino Evolution',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: kGameWidth / kGameHeight,
            // تپ روی هر جای صفحه بازی = پرش (معادل کلیک ماوس در پایتون)
            child: GestureDetector(
              onTapDown: (_) => game.handleTap(),
              child: GameWidget(
                game: game,
                overlayBuilderMap: {
                  'menu': (context, DinoGame g) => MenuOverlay(game: g),
                  'settings': (context, DinoGame g) => SettingsOverlay(game: g),
                  'skins': (context, DinoGame g) => SkinsOverlay(game: g),
                  'gameOver': (context, DinoGame g) => GameOverOverlay(game: g),
                  'hud': (context, DinoGame g) => HudOverlay(game: g),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
