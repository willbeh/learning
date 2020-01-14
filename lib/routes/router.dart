import 'package:auto_route/auto_route_annotations.dart';
import 'package:learning/pages/exam/exam.dart';
import 'package:learning/pages/home/home.dart';
import 'package:learning/pages/session/forget.dart';
import 'package:learning/pages/session/login.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/pages/video/video.dart';
import 'package:learning/pages/video/video_player.dart';

@autoRouter
class $AppRouter {
  HomePage homePage;
  @initial
  SplashPage splashPage;
  LoginPage loginPage;
  ForgetPage forgetPage;
  VideoPage videoPage;
  VideoPlayerPage videoPlayerPage;
  ExamPage examPage;
}

/// run - flutter pub run build_runner build