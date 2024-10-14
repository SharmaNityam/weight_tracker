import 'package:flutter/material.dart';

class AppTheme {

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent,
    scaffoldBackgroundColor: Color(0xFF1E1E2E),
    colorScheme: ColorScheme.dark(
      primary: Colors.tealAccent,
      secondary: Colors.teal,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2A2A3C),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF2A2A3C),
      elevation: 2,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2A3C),
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}