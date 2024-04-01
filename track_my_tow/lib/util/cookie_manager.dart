import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieManager {
  static const FlutterSecureStorage _cookieStorage = FlutterSecureStorage();

  static Future<void> saveCookie(String key, String value) async {
    await _cookieStorage.write(key: key, value: value);
  }

  static Future<String?> getCookie(String key) async {
    return await _cookieStorage.read(key: key);
  }

  static Future<void> deleteCookie(String key) async {
    await _cookieStorage.delete(key: key);
  }
}
