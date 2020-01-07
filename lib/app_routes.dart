import 'package:flutter/material.dart';
import 'package:learning/pages/home/home.dart';
import 'package:learning/pages/video/video.dart';
import 'package:learning/pages/video/video_player.dart';
import 'package:learning/pages/video/video_player_2.dart';
import 'package:learning/pages/video/video_web.dart';
import 'dart:convert';

import './pages/session/login.dart';

class AppRoutes {
  static const String routeHomePage         = '/home/home';
  static const String routeSplashPage       = '/splash';
  static const String routeLoginPage        = '/session/login';
  static const String routeVideo            = '/video/home';
  static const String routeVideoWeb         = '/video/web';
  static const String routeVideoPlayer      = '/video/player';

  static Map<String, WidgetBuilder> appRoutes(BuildContext context) {
    return {
      routeLoginPage: (BuildContext context) => LoginPage(),
      routeHomePage: (BuildContext context) => HomePage(),
      routeVideo: (BuildContext context) => VideoPage(),
      routeVideoWeb: (BuildContext context) => VideoWebPage(),
      routeVideoPlayer: (BuildContext context) => VideoPlayerPage(),
    };
  }

  static msgRoute(BuildContext context, String routeName, String arg){
    Navigator.pushNamed(context, routeName, arguments: jsonDecode(arg));
  }
}