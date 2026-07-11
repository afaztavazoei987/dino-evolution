import 'dart:math';
import 'package:flame/game.dart';
import 'constants.dart';
import 'dino.dart';
import 'obstacle.dart';
import 'background_component.dart';
import 'data_manager.dart';

enum GameState { menu, playing, gameOver, settings, skins }

// معادل حلقه اصلی و متغیرهای بازی (game_state, score, speed_game, ...)
class DinoGame extends FlameGame {
  GameState state = GameState.menu;
  late DinoComponent dino;
  late BackgroundComponent bg;
  final List<ObstacleComponent> obstacles = [];

  int score = 0;
  double speedGame = 7;
  double extraSpeed = 0;
  int frameCounter = 0;
  int scoreDelay = 4;
  bool nightMode = false;

  DinoData data = DinoData();

  DinoGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: kGameWidth,
            height: kGameHeight,
          ),
        );

  @override
  Future<void> onLoad() async {
    data = await DataManager.load();
    bg = BackgroundComponent();
    dino = DinoComponent(skin: data.currentSkin);
    world.add(bg);
    overlays.add('menu');
  }

  // معادل reset_game()
  void resetGame() {
    for (final o in obstacles) {
      o.removeFromParent();
    }
    obstacles.clear();
    if (dino.isMounted) dino.removeFromParent();
    dino = DinoComponent(skin: data.currentSkin);
    world.add(dino);
    score = 0;
    speedGame = 7;
    extraSpeed = 0;
    frameCounter = 0;
    nightMode = false;
    bg.night = false;
  }

  void startGame() {
    overlays.remove('menu');
    overlays.remove('gameOver');
    overlays.remove('settings');
    overlays.remove('skins');
    overlays.add('hud');
    resetGame();
    state = GameState.playing;
  }

  void goToMenu() {
    overlays.remove('settings');
    overlays.remove('skins');
    overlays.remove('gameOver');
    overlays.remove('hud');
    overlays.add('menu');
    state = GameState.menu;
  }

  void openSettings() {
    overlays.remove('menu');
    overlays.add('settings');
    state = GameState.settings;
  }

  void openSkins() {
    overlays.remove('menu');
    overlays.add('skins');
    state = GameState.skins;
  }

  void selectSkin(String skin) {
    data.currentSkin = skin;
    DataManager.save(data);
  }

  void jump() => dino.jump();
  void setDucking(bool v) => dino.setDucking(v);

  // معادل رویداد کلیک ماوس / تپ روی صفحه
  void handleTap() {
    if (state == GameState.playing) {
      jump();
    } else if (state == GameState.gameOver) {
      startGame();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != GameState.playing) return;

    bg.updateBg(speedGame + extraSpeed);

    final currentSpeed = speedGame + extraSpeed;
    scoreDelay = max(2, (4 * (speedGame / currentSpeed)).round());
    frameCounter++;
    if (frameCounter >= scoreDelay) {
      frameCounter = 0;
      score++;

      if (score % 100 == 0 && score != 0) extraSpeed += 0.25;

      if (score > data.highScore) {
        data.highScore = score;
        DataManager.save(data);
      }

      if (score % 500 == 0) {
        nightMode = !nightMode;
        bg.night = nightMode;
      }
    }

    dino.updateDino(dt);

    // اسپاون موانع - معادل بخش spawn در پایتون
    final rnd = Random();
    final lastFarEnough = obstacles.isEmpty ||
        obstacles.last.position.x < kGameWidth - (400 + rnd.nextInt(200));
    if (lastFarEnough && rnd.nextDouble() < 0.02 + (extraSpeed / 150)) {
      final kind = rnd.nextDouble() < 0.75 ? ObstacleType.cactus : ObstacleType.bird;
      final obs = ObstacleComponent(type: kind, speed: speedGame);
      obstacles.add(obs);
      world.add(obs);
    }

    for (final obs in List<ObstacleComponent>.from(obstacles)) {
      obs.updateObstacle(extraSpeed);

      if (!dino.dead && dino.bounds.overlaps(obs.bounds)) {
        if (dino.shieldActive) {
          dino.shieldActive = false;
          obstacles.remove(obs);
          obs.removeFromParent();
        } else {
          dino.dead = true;
          state = GameState.gameOver;
          overlays.remove('hud');
          overlays.add('gameOver');
        }
      }

      if (obs.isOut) {
        obstacles.remove(obs);
        obs.removeFromParent();
      }
    }
  }
}
