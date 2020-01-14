// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:learning/pages/home/home.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/pages/session/login.dart';
import 'package:learning/pages/session/forget.dart';
import 'package:learning/pages/video/video.dart';
import 'package:learning/pages/video/video_player.dart';
import 'package:learning/pages/exam/exam.dart';

class AppRouter {
  static const homePage = '/homePage';
  static const splashPage = '/';
  static const loginPage = '/loginPage';
  static const forgetPage = '/forgetPage';
  static const videoPage = '/videoPage';
  static const videoPlayerPage = '/videoPlayerPage';
  static const examPage = '/examPage';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<AppRouter>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRouter.homePage:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case AppRouter.splashPage:
        return MaterialPageRoute(
          builder: (_) => SplashPage(),
          settings: settings,
        );
      case AppRouter.loginPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case AppRouter.forgetPage:
        return MaterialPageRoute(
          builder: (_) => ForgetPage(),
          settings: settings,
        );
      case AppRouter.videoPage:
        return MaterialPageRoute(
          builder: (_) => VideoPage(),
          settings: settings,
        );
      case AppRouter.videoPlayerPage:
        return MaterialPageRoute(
          builder: (_) => VideoPlayerPage(),
          settings: settings,
        );
      case AppRouter.examPage:
        return MaterialPageRoute(
          builder: (_) => ExamPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}