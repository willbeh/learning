import 'package:flutter/material.dart';
import 'package:learning/utils/app_localization.dart';
//import 'package:learning/utils/app_localization.dart';

class AppTranslate{
  static String text(BuildContext context, String t){
//    return AppLocalizations.of(context).translate(t) ?? '-';
    return Translations.of(context).text(t) ?? '-';
  }
}