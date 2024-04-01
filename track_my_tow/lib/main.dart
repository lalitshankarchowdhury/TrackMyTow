import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'util/app_theme.dart';
import 'util/cookie_manager.dart';

bool isCookieExpired(String? cookie) {
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade900,
    systemNavigationBarColor: Colors.grey.shade900,
  ));

  String? cookie = await CookieManager.getCookie("token");
  final StatefulWidget page;

  if (isCookieExpired(cookie)) {
    CookieManager.deleteCookie("token");
    page = const LoginPage();
  } else {
    page = const MainPage();
  }

  runApp(MaterialApp(
    home: page,
    theme: AppTheme.theme,
  ));
}
