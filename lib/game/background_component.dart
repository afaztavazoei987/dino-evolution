import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class _Hill {
  double x;
  final double w;
  final double h;
  final Color color;
  _Hill(this.x, this.w, this.h, this.color);
}

// معادل کلاس Background در پایتون
class BackgroundComponent extends Component {
  final List<_Hill> _hills = [];
  bool night = false;

  BackgroundComponent() {
    final rnd = Random();
    for (int i = 0; i < 5; i++) {
      _hills.add(_Hill(
        rnd.nextDouble() * kGameWidth * 2,
        150 + rnd.nextDouble() * 200,
        40 + rnd.nextDouble() * 40,
        rnd.nextDouble() > 0.5
            ? const Color(0xFFC8D7E6)
            : const Color(0xFFBECDDC),
      ));
    }
  }

  @override
  int priority = -10; // همیشه پشت بقیه رسم بشه

  void updateBg(double speed) {
    final rnd = Random();
    for (final hill in _hills) {
      hill.x -= speed * 0.3;
      if (hill.x + hill.w < 0) {
        hill.x = kGameWidth + rnd.nextDouble() * 150 + 50;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, kGameWidth, kGameHeight),
      Paint()..color = night ? const Color(0xFF1E2846) : const Color(0xFFDCEBFA),
    );
    for (final hill in _hills) {
      final color = night ? const Color(0xFFB4C3D7) : hill.color;
      final path = Path()
        ..moveTo(hill.x, kGroundY)
        ..lineTo(hill.x + hill.w / 2, kGroundY - hill.h)
        ..lineTo(hill.x + hill.w, kGroundY)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }
    canvas.drawLine(
      const Offset(0, kGroundY),
      const Offset(kGameWidth, kGroundY),
      Paint()
        ..color = Colors.grey
        ..strokeWidth = 3,
    );
  }
}
