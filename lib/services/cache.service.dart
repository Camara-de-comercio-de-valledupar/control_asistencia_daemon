import 'package:get_storage/get_storage.dart';

class CacheService {
  static CacheService? _instance;

  CacheService._();

  static CacheService getInstance() {
    _instance ??= CacheService._();
    return _instance!;
  }

  static Future<void> init() async {
    await GetStorage.init();
  }

  Future<void> setString(String key, String value) async {
    await GetStorage().write(key, value);
  }

  String? getString(String key) {
    return GetStorage().read(key);
  }

  Future<void> setBool(String key, bool value) async {
    await GetStorage().write(key, value);
  }

  bool? getBool(String key) {
    return GetStorage().read(key);
  }

  Future<void> remove(String key) async {
    await GetStorage().remove(key);
  }

  Future<void> clear() async {
    await GetStorage().erase();
  }
}
