import 'package:flutter/material.dart';

class ThemeState with ChangeNotifier {
  bool isLightTheme;

  ThemeState({this.isLightTheme});

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }

  invertTheme() {
    isLightTheme = !isLightTheme;
    notifyListeners();
  }
}