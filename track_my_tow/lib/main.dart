import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'pages/intro_page.dart';
import 'util/app_theme.dart';
import 'util/profile_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade900,
    systemNavigationBarColor: Colors.grey.shade900,
  ));

  profile = await ProfileManager.getProfile();
  Widget page;

  if (profile != null) {
    if (ProfileManager.isCookieExpired(jsonDecode(profile!)['cookie'])) {
      ProfileManager.deleteProfile();
      page = const LoginPage();
    } else {
      page = const MainPage();
    }
  } else {
    page = const IntroPage();
  }

  runApp(MaterialApp(
    home: page,
    theme: AppTheme.theme,
  ));
}
