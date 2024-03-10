import 'package:flutter/material.dart';
import 'pages/intro_page.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade900,
    systemNavigationBarColor: Colors.grey.shade900,
  ));
  runApp(MaterialApp(
    home: const IntroPage(),
    theme: ThemeData(
        fontFamily: 'Inter',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade900,
          selectedItemColor: const Color(0xFFFCB001),
          unselectedItemColor: Colors.white70,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white70,
        ),
        cardTheme: CardTheme(
          color: Colors.grey.shade800,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
        ),
        textButtonTheme: TextButtonThemeData(
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFFFCB001))),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          extendedTextStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: const Color(0xFFFCB001),
          foregroundColor: Colors.grey.shade900,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
            foregroundColor: Colors.grey.shade900,
            backgroundColor: const Color(0xFFFCB001),
          ),
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Color(0xFFFCB001)),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(color: Colors.white70),
            labelStyle: const TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white70, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFFCB001), width: 2.0),
            )),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white70),
            bodySmall: TextStyle(color: Colors.white70),
            displayLarge: TextStyle(color: Colors.white70),
            displayMedium: TextStyle(color: Colors.white70),
            displaySmall: TextStyle(color: Colors.white70),
            headlineLarge: TextStyle(color: Colors.white70),
            headlineMedium: TextStyle(color: Colors.white70),
            headlineSmall: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white70),
            titleMedium: TextStyle(color: Colors.white70),
            titleSmall: TextStyle(color: Colors.white70),
            labelLarge: TextStyle(color: Colors.white70),
            labelMedium: TextStyle(color: Colors.white70),
            labelSmall: TextStyle(color: Colors.white70)),
        appBarTheme: AppBarTheme(
            color: Colors.grey.shade900, foregroundColor: Colors.white70),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        })),
  ));
}
