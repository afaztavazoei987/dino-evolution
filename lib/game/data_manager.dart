import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// معادل load_data / save_data در پایتون
// به جای فایل dino_data.json، از حافظه داخلی اپ (SharedPreferences) استفاده می‌کنیم
// چون روی اندروید دسترسی مستقیم به فایل کنار برنامه ساده نیست.
class DinoData {
  int highScore;
  List<String> unlockedSkins;
  String currentSkin;
  bool sfx;
  bool music;

  DinoData({
    this.highScore = 0,
    List<String>? unlockedSkins,
    this.currentSkin = 'classic',
    this.sfx = true,
    this.music = true,
  }) : unlockedSkins = unlockedSkins ?? ['classic', 'pixel', 'neon', 'golden'];

  Map<String, dynamic> toJson() => {
        'high_score': highScore,
        'unlocked_skins': unlockedSkins,
        'current_skin': currentSkin,
        'settings': {'sfx': sfx, 'music': music},
      };

  factory DinoData.fromJson(Map<String, dynamic> json) => DinoData(
        highScore: json['high_score'] ?? 0,
        unlockedSkins: List<String>.from(
            json['unlocked_skins'] ?? ['classic', 'pixel', 'neon', 'golden']),
        currentSkin: json['current_skin'] ?? 'classic',
        sfx: json['settings']?['sfx'] ?? true,
        music: json['settings']?['music'] ?? true,
      );
}

class DataManager {
  static const _key = 'dino_data';

  static Future<DinoData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return DinoData();
    try {
      return DinoData.fromJson(jsonDecode(raw));
    } catch (_) {
      return DinoData();
    }
  }

  static Future<void> save(DinoData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data.toJson()));
  }
}
