import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show  rootBundle;
import 'package:learning/lang/lang.dart';
import 'package:learning/services/app_remote_config.dart';
import 'package:learning/states/app_state.dart';

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  static Translations of(BuildContext context){
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    try {
      return _localizedValues[key] ?? '**$key**';
    } catch(exception) {
      return '';
    }

  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = Translations(locale);

//    String jsonContent = await rootBundle.loadString("lang/${locale.languageCode}.json");
//    _localizedValues = json.decode(jsonContent);

//    if(appRemoteConfig.remoteConfig != null) {
//      String jsonContent = appRemoteConfig.remoteConfig.getString('lang_${locale.languageCode}');
//      _localizedValues = json.decode(jsonContent);
//    } else {
//      _localizedValues = translation_value['${locale.languageCode}'];
//    }

    _localizedValues = translationValue['${locale.languageCode}'];

    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => AppState.supportedLanguages.contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}

class SpecificLocalizationDelegate extends LocalizationsDelegate<Translations> {
  final Locale overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<Translations> load(Locale locale) => Translations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => true;
}