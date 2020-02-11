import 'package:flutter/material.dart';

class AppText {
  static Widget title(BuildContext context, {String title = '', double padding = 20, double fontSize = 30}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(title, style: Theme.of(context).textTheme.title.copyWith(fontSize: fontSize, color: Theme.of(context).primaryColor),));
  }

  static bool validateEmail(String value) {
    const Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
}