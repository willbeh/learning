import 'package:flutter/material.dart';

class AppButton {
  static roundedButton(BuildContext context, {String text, Function onPressed, double width = 200, Color color, TextStyle style, double borderRadius = 10}) {
    return RaisedButton(
      textColor: Colors.white,
      color: color,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        width: width,
        child: Text(text, style: style ?? TextStyle(color: Colors.white), textAlign: TextAlign.center,),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}