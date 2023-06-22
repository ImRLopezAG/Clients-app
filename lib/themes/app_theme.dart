import 'package:flutter/material.dart'
    show
        AppBarTheme,
        Color,
        Colors,
        FloatingActionButtonThemeData,
        IconThemeData,
        ThemeData;

class AppTheme {
  static const Color primary = Colors.blue;
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blue[400],
    scaffoldBackgroundColor: Colors.grey[800],
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[400],
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlueAccent,
      iconSize: 30,
    ),
  );
}
