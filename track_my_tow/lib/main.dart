import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'util/app_theme.dart';
import 'util/cookie_manager.dart';

bool isCookieExpired(String? cookie) {
  if (cookie == null || cookie.isEmpty) {
    return true;
  }

  print(cookie);

  RegExp regex = RegExp(r'Max-Age=(\d+)');
  Iterable<Match> matches = regex.allMatches(cookie);

  if (matches.isNotEmpty) {
    Match match = matches.first;
    int maxAgeSeconds = int.parse(match.group(1)!);

    DateTime now = DateTime.now();
    DateTime expirationTime = now.add(Duration(seconds: maxAgeSeconds));

    return expirationTime.isBefore(DateTime.now());
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
    page = const LoginPage();
  } else {
    CookieManager.deleteCookie("token");
    page = const MainPage();
  }

  runApp(MaterialApp(
    home: page,
    theme: AppTheme.theme,
  ));
}
