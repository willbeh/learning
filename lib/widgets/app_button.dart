import 'package:flutter/material.dart';

class AppButton {
  static roundedButton(BuildContext context, {String text, Function onPressed, double width = 200, Color color, TextStyle style, double borderRadius}) {
    return RaisedButton(
      textColor: Colors.white,
      color: color,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        width: width,
        child: Text(text, style: style ?? Theme.of(context).textTheme.headline.copyWith(color: Colors.white), textAlign: TextAlign.center,),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}