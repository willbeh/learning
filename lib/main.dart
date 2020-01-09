import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/app_routes.dart';
import 'package:learning/dark_theme.dart';
import 'package:learning/light_theme.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/states/theme_state.dart';
import 'package:learning/states/vimeo_state.dart';
import 'package:learning/utils/app_localization.dart';
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
      supportedLocales: [
        Locale('en'),
        Locale('zh'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).translate('title'),
      debugShowCheckedModeBanner: false,
      theme: (Provider.of<ThemeState>(context).isLightTheme) ? lightTheme : darkTheme, // AppTheme.themeData(),
      darkTheme: darkTheme,
      home: SplashPage(),
      routes: AppRoutes.appRoutes(context),
    );
  }
}

