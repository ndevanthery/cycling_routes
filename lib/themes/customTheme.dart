import 'package:flutter/material.dart';

ThemeData CustomTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(218, 234, 230, 229),
      appBarTheme: AppBarTheme(color: Colors.white),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      
    
      );
}

ThemeData CustomNightTheme() {
  return ThemeData.dark();
}
