import 'package:flutter/material.dart';

class CommonUI {
  static Widget heightPadding({double height = 20.0, Widget child}){
    return SizedBox(
      height: height,
      child: child,
    );
  }

  static Widget widthPadding({double width = 20.0}){
    return SizedBox(
      width: width,
    );
  }

  static Widget appContainerPadding({double horizontal = 20, double vertical = 10, Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }

  static Widget appHeader(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.headline,);
  }

  static alertBox(BuildContext context, {String title, String msg, Function onPress}) {
    return showDialog<void>(
      context: context,
//      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: (onPress == null) ? Navigator.pop(context) : onPress,
            ),
          ],
        );
      },
    );
  }

  static SnackBar showSnackBarWithAction({String content, String label, Function onPressed}) {
    return SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: label,
        onPressed: onPressed,
      ),
    );
  }

  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}