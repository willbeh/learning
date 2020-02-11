import 'package:auto_route/auto_route_annotations.dart';
import 'package:learning/pages/exam/exam.dart';
import 'package:learning/pages/home/home.dart';
import 'package:learning/pages/profile/edit_profile.dart';
import 'package:learning/pages/profile/my_videos.dart';
import 'package:learning/pages/profile/profile.dart';
import 'package:learning/pages/session/forget.dart';
import 'package:learning/pages/session/login.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/pages/video/video_series_player.dart';

@autoRouter
class $AppRouter {
  HomePage homePage;
  @initial
  SplashPage splashPage;
  LoginPage loginPage;
  ForgetPage forgetPage;
  ExamPage examPage;
  ProfilePage profilePage;
  MyVideosPage myVideosPage;
  VideoSeriesPlayerPage videoSeriesPlayerPage;
  EditProfilePage editProfilePage;
}

/// run - flutter pub run build_runner build