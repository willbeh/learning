import 'package:flutter/material.dart';

class LoadingStackScreen extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String text;
  final bool translate;

  LoadingStackScreen({this.child, this.isLoading = false, this.text, this.translate = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        (isLoading == true) ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.7),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                (text != null) ? Text(text,
                  style: TextStyle(color: Colors.white),
                ) : Container(),
              ],
            ),
          ),
        ) : Container(),
      ],
    );
  }
}
