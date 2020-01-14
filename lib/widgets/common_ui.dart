import 'package:flutter/material.dart';
import 'package:learning/widgets/app_button.dart';

enum AlertType { error, success }

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

  static alertBox(BuildContext context, {@required String title, String msg, Widget child, Color titleColor = Colors.black, List<Widget> actions, String closeText}) {
    return showDialog<void>(
      context: context,
//      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(title, style: Theme.of(context).textTheme.headline.copyWith(color: titleColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: (child != null) ? child : Text(msg, textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                  (closeText != null) ?
                      [AppButton.roundedButton(context,
                        text: closeText,
                        paddingVertical: 5,
                        textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
                        onPressed: () => Navigator.pop(context)
                      )] :
                  actions
                ,
              ),
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