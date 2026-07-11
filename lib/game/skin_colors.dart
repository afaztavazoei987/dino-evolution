import 'package:flutter/material.dart';

// معادل رنگ‌های هر اسکین در تابع create_dino_pixel پایتون
class SkinColors {
  final Color body;
  final Color dark;
  final Color eye;
  final Color pupil;
  const SkinColors(this.body, this.dark, this.eye, this.pupil);
}

const Map<String, SkinColors> kSkins = {
  'classic': SkinColors(
      Color(0xFF505050), Color(0xFF323232), Colors.white, Colors.black),
  'pixel': SkinColors(
      Color(0xFF64C864), Color(0xFF329632), Color(0xFFFFFF64), Colors.black),
  'neon': SkinColors(
      Color(0xFF00FFFF), Color(0xFF00C8C8), Color(0xFFFF00FF), Colors.white),
  'golden': SkinColors(
      Color(0xFFFFD700), Color(0xFFC8AA00), Colors.white, Colors.blue),
};

const List<String> kSkinOrder = ['classic', 'pixel', 'neon', 'golden'];
const List<String> kSkinNames = ['Classic', 'Pixel', 'Neon', 'Golden'];
