import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? _preferences;
  static CacheService? _instance;

  CacheService._();

  static CacheService getInstance() {
    _instance ??= CacheService._();
    return _instance!;
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  Future<void> remove(String key) async {
    await _preferences!.remove(key);
  }

  Future<void> clear() async {
    await _preferences!.clear();
  }
}
