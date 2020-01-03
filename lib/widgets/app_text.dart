import 'package:flutter/material.dart';

class AppText {
  static Widget title(BuildContext context, {String title = '', double padding = 20, double fontSize = 30}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(title, style: Theme.of(context).textTheme.title.copyWith(fontSize: fontSize, color: Theme.of(context).primaryColor),));
  }
}