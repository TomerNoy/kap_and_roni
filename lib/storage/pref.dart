import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  late SharedPreferences _prefs;

  /// set difficulty
  Future<void> setDifficulty(int i) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('difficulty', i);
  }

  /// get difficulty
  Future<int> getDifficulty() async {
    _prefs = await SharedPreferences.getInstance();
    final difficulty = _prefs.getInt('difficulty') ?? 0;
    return difficulty;
  }
}
