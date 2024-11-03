import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(240, 248, 255, 1),
    primary: Color.fromRGBO(189, 204, 212, 1),
    secondary: Color.fromRGBO(169, 214, 212, 1),
    tertiary: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[900]!,
    primary: Colors.grey[850]!,
    secondary: Colors.grey[800]!,
    tertiary: Colors.white70,
  ),
);
