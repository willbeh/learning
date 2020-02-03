import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String lang;

  static List supportedLanguages = ['en','zh'];
  // Returns the list of supported Locales
  static Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  AppState({this.lang});

  setLang(String language){
    lang = language;
    notifyListeners();
  }

  // don't need to notify listener
  initLang(String language){
    lang = language;
  }
}