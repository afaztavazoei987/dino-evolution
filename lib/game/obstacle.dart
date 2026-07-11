import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

enum ObstacleType { cactus, bird }

// معادل کلاس Obstacle در پایتون
class ObstacleComponent extends PositionComponent {
  final ObstacleType type;
  final double speed;
  double wingAngle = 0;
  final List<Rect> parts = []; // بخش‌های تشکیل‌دهنده (نسبت به موقعیت خودش)

  ObstacleComponent({
    required this.type,
    required this.speed,
  }) : super(position: Vector2(kGameWidth, 0)) {
    final rnd = Random();
    if (type == ObstacleType.cactus) {
      final count = rnd.nextInt(3) + 1;
      for (int i = 0; i < count; i++) {
        parts.add(Rect.fromLTWH(i * 25, 0, 25, 45));
      }
      position.y = kGroundY - 45;
      size = Vector2(count * 25.0, 45);
    } else {
      final levels = [kGroundY - 80, kGroundY - 120, kGroundY - 170];
      final y = levels[rnd.nextInt(levels.length)];
      parts.add(const Rect.fromLTWH(0, 0, 35, 25));
      if (rnd.nextDouble() < 0.2) {
        parts.add(const Rect.fromLTWH(50, -5, 35, 22));
      }
      position.y = y;
      size = Vector2(85, 30);
    }
  }

  Rect get bounds => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void updateObstacle(double extraSpeed) {
    final currentSpeed = speed + extraSpeed;
    position.x -= currentSpeed;
    if (type == ObstacleType.bird) {
      wingAngle += 0.2;
      position.y += sin(wingAngle) * 0.5;
    }
  }

  bool get isOut => position.x < -100;

  @override
  void render(Canvas canvas) {
    if (type == ObstacleType.cactus) {
      final main = Paint()..color = const Color(0xFF228B22);
      final darker = Paint()..color = const Color(0xFF146414);
      for (final r in parts) {
        canvas.drawRect(r, main);
        canvas.drawRect(r.deflate(3), darker);
      }
    } else {
      final orange = Paint()..color = const Color(0xFFFFA500);
      final darkOrange = Paint()..color = const Color(0xFFFF8C00);
      for (final r in parts) {
        canvas.drawOval(r, orange);
        canvas.drawOval(r.deflate(3), darkOrange);
      }
    }
  }
}
