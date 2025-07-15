import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static late SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    await _pref.setBool(key, value);
  }

  static bool getBool(String key) {
    final bool value = _pref.getBool(key) ?? false;
    return value;
  }

  static Future<void> remove(String key) async {
    await _pref.remove(key);
  }

  static Future<void> setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  static String getString(String key) {
    final String value = _pref.getString(key) ?? '';
    return value;
  }
}
