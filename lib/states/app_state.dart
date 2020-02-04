import 'package:flutter/material.dart';
import 'package:learning/models/banner.dart';

class AppState with ChangeNotifier {
  String lang;
  List<AppBanner> banners;
  bool isLightTheme;

  static List supportedLanguages = ['en','zh'];
  // Returns the list of supported Locales
  static Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  AppState({this.lang, this.isLightTheme = true});

  setLang(String language){
    lang = language;
    notifyListeners();
  }

  // don't need to notify listener
  initLang(String language){
    lang = language;
  }

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