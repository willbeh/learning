import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/utils/logger.dart';
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
  final log = getLogger('_SplashPageState');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _setTimer();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        log.d("onMessage 😊: $message");
        final snackBar = SnackBar(content: Text('onMessage: $message'));
        Scaffold.of(context).showSnackBar(snackBar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        log.d("onLaunch: $message");
        final snackBar = SnackBar(content: Text('onLaunch: $message'));
        Scaffold.of(context).showSnackBar(snackBar);
      },
      onResume: (Map<String, dynamic> message) async {
        log.d("onResume: $message");
        final snackBar = SnackBar(content: Text('onResume: $message'));
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      log.d("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
//      log.d('Push Messaging token: $token');
    });
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
