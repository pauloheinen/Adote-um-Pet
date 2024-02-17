import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(229, 20, 171, 93),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(229, 20, 171, 93),
        selectedItemColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: const Color.fromARGB(255, 254, 250, 224),
        brightness: Brightness.light,
      ).copyWith(
        error: Colors.red,
        primary: Colors.black38,
      ),
      primaryColor: const Color.fromARGB(229, 20, 171, 93),
      fontFamily: 'Quicksand',
      textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            color: Colors.black87,
          ),
          displayMedium: TextStyle(
            fontSize: 20,
            overflow: TextOverflow.ellipsis,
            color: Colors.black87,
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            color: Colors.black87,
          ),
          labelSmall: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 60, 253, 53),
          )),
    );
  }
}

extension AppThemeExtension on BuildContext {
  ThemeData get appThemeData => AppTheme.themeData();
}
