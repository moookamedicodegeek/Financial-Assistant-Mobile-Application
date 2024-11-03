import 'package:finance_flow_1/theme/theme_data.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  /// Switches the app theme between light and dark modes.
  void toggleTheme() {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}
