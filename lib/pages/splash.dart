import 'package:flutter/material.dart';
import '../app_routes.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.routeLoginPage, (route)=>false);
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
        child: Container(),
      ),
    );
  }
}
