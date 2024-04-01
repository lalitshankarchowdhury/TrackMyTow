import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CookieManager {
  static const FlutterSecureStorage _cookieStorage = FlutterSecureStorage();

  static bool isCookieExpired(String? cookie) {
    if (cookie == null || cookie.isEmpty) {
      return true;
    }

    RegExp expiresRegex = RegExp(r'Expires=([^;]+)');
    Iterable<Match> expiresMatches = expiresRegex.allMatches(cookie);

    if (expiresMatches.isNotEmpty) {
      Match match = expiresMatches.first;
      String expiresString = match.group(1)!;

      try {
        DateFormat dateFormat = DateFormat('E, dd MMM yyyy HH:mm:ss');
        DateTime expirationTime = dateFormat.parse(expiresString);
        expirationTime =
            expirationTime.add(const Duration(hours: 5, minutes: 30));
        DateTime currentTime = DateTime.now();

        return currentTime.isAfter(expirationTime);
      } catch (_) {
        return true;
      }
    }

    return true;
  }

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
