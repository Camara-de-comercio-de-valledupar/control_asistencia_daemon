import 'package:get_storage/get_storage.dart';

/// Servicio de Cache para manejar almacenamiento local utilizando GetStorage.
class CacheService {
  /// Instancia única de CacheService.
  static CacheService? _cacheServiceInstance;

  /// Constructor privado para evitar instanciación directa.
  CacheService._();

  /// Obtiene la instancia única de CacheService.
  ///
  /// Si la instancia no existe, la crea.
  static CacheService getInstance() {
    _cacheServiceInstance ??= CacheService._();
    return _cacheServiceInstance!;
  }

  /// Inicializa el almacenamiento de GetStorage.
  ///
  /// Debe ser llamado antes de usar cualquier otro método de esta clase.
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Guarda un valor de tipo String en el almacenamiento local.
  ///
  /// [key] La clave con la que se guardará el valor.
  /// [value] El valor que se guardará.
  Future<void> setString(String key, String value) async {
    await GetStorage().write(key, value);
  }

  /// Obtiene un valor de tipo String del almacenamiento local.
  ///
  /// [key] La clave del valor que se desea obtener.
  /// Retorna el valor asociado a la clave, o null si no existe.
  String? getString(String key) {
    return GetStorage().read(key);
  }

  /// Guarda un valor de tipo bool en el almacenamiento local.
  ///
  /// [key] La clave con la que se guardará el valor.
  /// [value] El valor que se guardará.
  Future<void> setBool(String key, bool value) async {
    await GetStorage().write(key, value);
  }

  /// Obtiene un valor de tipo bool del almacenamiento local.
  ///
  /// [key] La clave del valor que se desea obtener.
  /// Retorna el valor asociado a la clave, o null si no existe.
  bool? getBool(String key) {
    return GetStorage().read(key);
  }

  /// Elimina un valor del almacenamiento local.
  ///
  /// [key] La clave del valor que se desea eliminar.
  Future<void> remove(String key) async {
    await GetStorage().remove(key);
  }

  /// Limpia todo el almacenamiento local.
  Future<void> clear() async {
    await GetStorage().erase();
  }
}
