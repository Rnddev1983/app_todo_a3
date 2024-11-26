//theme configs

import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
    useMaterial3: true,
  );

  static ThemeData themeDataDark = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
    ),
    // Define the default brightness and colors.
    primaryColor: Colors.grey[800],
  );

  static ThemeData themeDataLight = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.black,
    ),
    primaryColor: Colors.blue[800],
    fontFamily: 'Roboto',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
      ),
    ),
  );
}
