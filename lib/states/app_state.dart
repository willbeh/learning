import 'package:flutter/material.dart';
import 'package:learning/models/banner.dart';
import 'package:learning/models/profile.dart';

class AppState with ChangeNotifier {
  String lang;
  List<AppBanner> banners;
  bool isLightTheme;

  // store user profile
  List<Profile> profiles;

  static List supportedLanguages = ['en','zh'];
  // Returns the list of supported Locales
  static Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => Locale(lang as String, ''));

  AppState({this.lang, this.isLightTheme = true, this.banners, this.profiles});

  void setLang(String language){
    lang = language;
    notifyListeners();
  }

  // don't need to notify listener
  // ignore: use_setters_to_change_properties
  void initLang(String language){
    lang = language;
  }

  // ignore: avoid_setters_without_getters
  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }

  void invertTheme() {
    isLightTheme = !isLightTheme;
    notifyListeners();
  }
}