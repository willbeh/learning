import 'package:flutter/material.dart';

class AppButton {
  static roundedButton(BuildContext context, {String text, Function onPressed, Widget child, double width = 200, double height = 48, Color textColor, Color color, double borderRadius = 5, double paddingVertical = 15,
    Color borderColor, double elevation = 1, TextStyle textStyle,
  }) {
    return RaisedButton(
      color: color != null ? color : Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        width: width,
        height: height,
        child: (child != null) ? child : Text(text, textAlign: TextAlign.center, style: (textStyle != null) ? textStyle : Theme.of(context).textTheme.display3.copyWith(color: textColor == null ? Colors.white : textColor),),
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