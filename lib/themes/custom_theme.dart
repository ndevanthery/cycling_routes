import 'package:flutter/material.dart';

ThemeData CustomTheme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(218, 234, 230, 229),
    appBarTheme:
        const AppBarTheme(color: Colors.white, foregroundColor: Colors.black),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
    ),
  );
}

ThemeData CustomNightTheme() {
  return ThemeData.dark();
}
