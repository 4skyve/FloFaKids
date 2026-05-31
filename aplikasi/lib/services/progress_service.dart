import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {

  static Future<void> saveScore(int level, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'score_level_$level';
    final existing = prefs.getInt(key) ?? 0;
    if (score > existing) {
      await prefs.setInt(key, score); 
    }
  }

  static Future<int> getScore(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('score_level_$level') ?? 0;
  }

  static Future<void> saveStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'stars_level_$level';
    final existing = prefs.getInt(key) ?? 0;
    if (stars > existing) {
      await prefs.setInt(key, stars); 
    }
  }

  //  Ambil bintang per level 
  static Future<int> getStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('stars_level_$level') ?? 0;
  }

  //  Unlock level berikutnya 
  static Future<void> unlockLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('unlocked_level_$level', true);
  }

  //  Cek apakah level sudah terbuka 
  static Future<bool> isUnlocked(int level) async {
    if (level == 1) return true; // level 1 sll terbuka
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('unlocked_level_$level') ?? false;
  }
}