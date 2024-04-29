import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
      fontFamily: 'Inter',
      useMaterial3: true,
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          indicatorColor: const Color(0xFFFCB001),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.black);
            } else {
              return IconThemeData(color: Colors.grey.shade400);
            }
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: Color(0xFFFCB001),
              );
            } else {
              return TextStyle(color: Colors.grey.shade400);
            }
          })),
      listTileTheme: ListTileThemeData(
        textColor: Colors.grey.shade400,
        iconColor: const Color(0xFFFCB001),
      ),
      cardTheme: const CardTheme(
        color: Color.fromARGB(255, 45, 45, 45),
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
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: Color(0xFFFCB001)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 10,
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
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFCB001),
          selectionColor: Color(0x7EFCB001),
          selectionHandleColor: Color(0xFFFCB001)),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey.shade400),
          labelStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFFCB001), width: 2.0),
          )),
      textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey.shade400),
          bodyMedium: TextStyle(color: Colors.grey.shade400),
          bodySmall: TextStyle(color: Colors.grey.shade400),
          displayLarge: TextStyle(color: Colors.grey.shade400),
          displayMedium: TextStyle(color: Colors.grey.shade400),
          displaySmall: TextStyle(color: Colors.grey.shade400),
          headlineLarge: TextStyle(color: Colors.grey.shade400),
          headlineMedium: TextStyle(color: Colors.grey.shade400),
          headlineSmall: TextStyle(color: Colors.grey.shade400),
          titleLarge: TextStyle(color: Colors.grey.shade400),
          titleMedium: TextStyle(color: Colors.grey.shade400),
          titleSmall: TextStyle(color: Colors.grey.shade400),
          labelLarge: TextStyle(color: Colors.grey.shade400),
          labelMedium: TextStyle(color: Colors.grey.shade400),
          labelSmall: TextStyle(color: Colors.grey.shade400)),
      appBarTheme: AppBarTheme(
          toolbarHeight: 77,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
          color: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          foregroundColor: Colors.grey.shade400),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      }));
}
