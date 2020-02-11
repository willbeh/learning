import 'package:flutter/material.dart';

class AppButton {
  static Widget roundedButton(BuildContext context, {String text, Function onPressed, Widget child, double width = 200, double height = 48, Color textColor, Color color, double borderRadius = 5, double paddingVertical = 15,
    Color borderColor, double elevation = 1, TextStyle textStyle,
  }) {
    return RaisedButton(
      color: color ?? Theme.of(context).primaryColor,
      // TODO find out how
      // ignore: argument_type_not_assignable
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor ?? Theme.of(context).primaryColor),
      ),
      elevation: elevation,
      child: Container(
        alignment: Alignment.center,
//        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        width: width,
        height: height,
        child: (child != null) ? child : Text(text, textAlign: TextAlign.center,
          style: (textStyle != null) ? textStyle : Theme.of(context).textTheme.display3.copyWith(color: textColor ?? Colors.white),),
      ),
    );
  }
}