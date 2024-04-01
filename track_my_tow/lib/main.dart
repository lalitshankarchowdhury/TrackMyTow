import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'util/app_theme.dart';
import 'util/cookie_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade900,
    systemNavigationBarColor: Colors.grey.shade900,
  ));

  String? cookie = await CookieManager.getCookie("token");
  final StatefulWidget page;

  if (CookieManager.isCookieExpired(cookie)) {
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
