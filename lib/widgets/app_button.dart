import 'package:flutter/material.dart';

class AppButton {
  static roundedButton(BuildContext context, {String text, Function onPressed, Widget child, double width = 200, Color textColor, Color color, double borderRadius = 5, double paddingVertical = 15,
    Color borderColor, double elevation = 1
  }) {
    return RaisedButton(
      textColor: textColor == null ? Colors.white : textColor,
      color: color != null ? color : Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        width: width,
        child: (child != null) ? child : Text(text, textAlign: TextAlign.center,),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor == null ? Theme.of(context).primaryColor : borderColor),
      ),
      elevation: elevation,
    );
  }
}