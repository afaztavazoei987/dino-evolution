import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'skin_colors.dart';

// معادل کلاس Dino در پایتون
class DinoComponent extends PositionComponent {
  String skin;
  double velY = 0;
  bool isJumping = false;
  bool isDucking = false;
  int jumpCount = 0;
  final int maxJumps = 2;
  double frame = 0;
  final double animationSpeed = 0.15;
  bool dead = false;
  bool shieldActive = false;
  int shieldTimer = 0;

  static const double normalWidth = 45;
  static const double normalHeight = 50;
  static const double duckHeight = 35;

  DinoComponent({this.skin = 'classic'})
      : super(
          position: Vector2(80, kGroundY - normalHeight),
          size: Vector2(normalWidth, normalHeight),
        );

  // مستطیل برخورد فعلی (بسته به خم شده بودن یا نبودن)
  Rect get bounds => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void jump() {
    if (dead) return;
    if (!isJumping) {
      velY = -13;
      isJumping = true;
      jumpCount = 1;
      isDucking = false;
      size = Vector2(normalWidth, normalHeight);
    } else if (jumpCount < maxJumps) {
      velY = -11;
      jumpCount++;
    }
  }

  void setDucking(bool value) {
    if (dead || isJumping) return;
    isDucking = value;
    if (value) {
      size = Vector2(normalWidth, duckHeight);
      position.y = kGroundY - duckHeight;
    } else {
      size = Vector2(normalWidth, normalHeight);
      position.y = kGroundY - normalHeight;
    }
  }

  void updateDino(double dt) {
    if (dead) return;

    velY += kGravity;
    position.y += velY;

    final maxY = kGroundY - (isDucking ? duckHeight : normalHeight);
    if (position.y >= maxY) {
      position.y = maxY;
      isJumping = false;
      jumpCount = 0;
      velY = 0;
    }

    if (shieldActive) {
      shieldTimer--;
      if (shieldTimer <= 0) shieldActive = false;
    }

    if (!isJumping && !isDucking) {
      frame = (frame + animationSpeed) % 2;
    }
  }

  @override
  void render(Canvas canvas) {
    final colors = kSkins[skin] ?? kSkins['classic']!;
    final body = Paint()..color = colors.body;
    final dark = Paint()..color = colors.dark;
    final eye = Paint()..color = colors.eye;
    final pupil = Paint()..color = colors.pupil;

    if (dead) {
      _drawStanding(canvas, body, dark, eye, pupil);
    } else if (isDucking) {
      _drawDucking(canvas, body, dark, eye, pupil);
    } else if (isJumping) {
      _drawJumping(canvas, body, dark, eye, pupil);
    } else {
      _drawStanding(canvas, body, dark, eye, pupil, alt: frame >= 1);
    }

    if (shieldActive) {
      final shieldPaint = Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), 35, shieldPaint);
    }
  }

  // معادل create_dino_pixel
  void _drawStanding(
      Canvas c, Paint body, Paint dark, Paint eye, Paint pupil,
      {bool alt = false}) {
    c.drawRect(const Rect.fromLTWH(25, 2, 16, 14), body);
    c.drawRect(const Rect.fromLTWH(27, 4, 12, 10), dark);
    c.drawRect(const Rect.fromLTWH(30, 4, 6, 6), eye);
    c.drawRect(const Rect.fromLTWH(33, 6, 3, 3), pupil);
    c.drawRect(const Rect.fromLTWH(27, 14, 10, 6), body);
    c.drawRect(const Rect.fromLTWH(10, 18, 30, 20), body);
    c.drawRect(const Rect.fromLTWH(12, 20, 26, 16), dark);
    c.drawRect(const Rect.fromLTWH(6, 22, 6, 10), body);
    c.drawRect(const Rect.fromLTWH(33, 22, 6, 10), body);
    final legOffset = alt ? 4.0 : 0.0;
    c.drawRect(Rect.fromLTWH(12, 36 + legOffset, 8, 12 - legOffset), body);
    c.drawRect(const Rect.fromLTWH(25, 36, 8, 12), body);
    c.drawRect(Rect.fromLTWH(14, 38 + legOffset, 4, 8 - legOffset), dark);
    c.drawRect(const Rect.fromLTWH(27, 38, 4, 8), dark);
    c.drawRect(const Rect.fromLTWH(2, 24, 10, 6), body);
    c.drawRect(const Rect.fromLTWH(2, 26, 8, 4), dark);
  }

  // معادل create_dino_pixel_duck
  void _drawDucking(Canvas c, Paint body, Paint dark, Paint eye, Paint pupil) {
    c.drawRect(const Rect.fromLTWH(15, 2, 24, 20), body);
    c.drawRect(const Rect.fromLTWH(17, 4, 20, 16), dark);
    c.drawRect(const Rect.fromLTWH(30, 0, 14, 12), body);
    c.drawRect(const Rect.fromLTWH(32, 2, 10, 8), dark);
    c.drawRect(const Rect.fromLTWH(34, 2, 5, 5), eye);
    c.drawRect(const Rect.fromLTWH(36, 3, 3, 3), pupil);
    c.drawRect(const Rect.fromLTWH(18, 20, 8, 10), body);
    c.drawRect(const Rect.fromLTWH(28, 20, 8, 10), body);
    c.drawRect(const Rect.fromLTWH(20, 22, 4, 6), dark);
    c.drawRect(const Rect.fromLTWH(30, 22, 4, 6), dark);
    c.drawRect(const Rect.fromLTWH(2, 8, 14, 6), body);
  }

  // معادل create_dino_pixel_jump
  void _drawJumping(Canvas c, Paint body, Paint dark, Paint eye, Paint pupil) {
    c.drawRect(const Rect.fromLTWH(10, 8, 30, 26), body);
    c.drawRect(const Rect.fromLTWH(12, 10, 26, 22), dark);
    c.drawRect(const Rect.fromLTWH(24, 0, 18, 14), body);
    c.drawRect(const Rect.fromLTWH(26, 2, 14, 10), dark);
    c.drawRect(const Rect.fromLTWH(30, 2, 6, 6), eye);
    c.drawRect(const Rect.fromLTWH(33, 4, 3, 3), pupil);
    c.drawRect(const Rect.fromLTWH(4, 14, 8, 8), body);
    c.drawRect(const Rect.fromLTWH(33, 14, 8, 8), body);
    c.drawRect(const Rect.fromLTWH(14, 32, 8, 14), body);
    c.drawRect(const Rect.fromLTWH(24, 32, 8, 14), body);
    c.drawRect(const Rect.fromLTWH(16, 34, 4, 10), dark);
    c.drawRect(const Rect.fromLTWH(26, 34, 4, 10), dark);
    c.drawRect(const Rect.fromLTWH(2, 20, 10, 8), body);
  }
}
