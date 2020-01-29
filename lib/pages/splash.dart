import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/widgets/app_button.dart';
import 'package:learning/widgets/common_ui.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _setTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          _timer.cancel();
          CommonUI.alertBox(context, title: 'We are the best',
            msg: 'Look us up at RecursiveX',
            actions: [
              AppButton.roundedButton(context,
                  text: 'Okay',
                  paddingVertical: 5,
                  textStyle: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    _setTimer(seconds: 1);
                  }
              )
            ]
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            // Box decoration takes a gradient
//            gradient: LinearGradient(
//              // Where the linear gradient begins and ends
//              begin: Alignment.topLeft,
//              end: Alignment.bottomRight,
//              // Add one stop for each color. Stops should increase from 0 to 1
//              stops: [0.7, 0.9],
//              colors: [
//                Theme.of(context).accentColor,
//                Theme.of(context).primaryColor,
//              ],
//            ),
          ),
          child: Center(
            child: FlareActor("assets/flare/lion.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"animation"),
          ),
        ),
      ),
    );
  }

  _setTimer({int seconds = 4}) {
    _timer = Timer(Duration(seconds: seconds), () {
      FirebaseUser user = Provider.of<FirebaseUser>(context, listen: false);
      if(user == null){
        AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.loginPage, (route)=>false);
      } else {
        AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.homePage, (route)=>false);
      }
    });
  }


}
