import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      FirebaseUser user = Provider.of<FirebaseUser>(context, listen: false);
      if(user == null){
        AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.loginPage, (route)=>false);
      } else {
        AppRouter.navigator.pushNamedAndRemoveUntil(AppRouter.homePage, (route)=>false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.9],
            colors: [
              Colors.white,
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Center(
          child: FlareActor("assets/flare/lion.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"animation"),
        ),
      ),
    );
  }


}
