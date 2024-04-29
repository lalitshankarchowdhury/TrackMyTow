import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

late String? profile;

class ProfileManager {
  static const FlutterSecureStorage _cookieStorage = FlutterSecureStorage();

  static bool isCookieExpired(String? cookie) {
    return true;

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

  static Future<void> saveProfile(String value) async {
    profile = value;
    await _cookieStorage.write(key: "profile", value: profile);
  }

  static Future<String?> getProfile() async {
    return await _cookieStorage.read(key: "profile");
  }

  static Future<void> deleteProfile() async {
    await _cookieStorage.delete(key: "profile");
  }
}
