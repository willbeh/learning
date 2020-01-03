import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/app_routes.dart';
import 'package:learning/dark_theme.dart';
import 'package:learning/light_theme.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/states/theme_state.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<SharedPreferences>(create: (_) => SharedPreferences.getInstance(), lazy: false,),
        ChangeNotifierProvider(
          create: (_) => ThemeState(isLightTheme: true),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => VimeoState(),
        )
      ],
      child: MyAppLoad(),
    );
  }
}

class MyAppLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample',
      debugShowCheckedModeBanner: false,
      theme: (Provider.of<ThemeState>(context).isLightTheme) ? lightTheme : darkTheme, // AppTheme.themeData(),
      darkTheme: darkTheme,
      home: SplashPage(),
      routes: AppRoutes.appRoutes(context),
    );
  }
}

