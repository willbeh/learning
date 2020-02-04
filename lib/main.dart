import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/dark_theme.dart';
import 'package:learning/light_theme.dart';
import 'package:learning/models/profile.dart';
import 'package:learning/models/series_watch.dart';
import 'package:learning/models/series_watch.service.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/models/video.service.dart';
import 'package:learning/models/watch.service.dart';
import 'package:learning/models/profile.service.dart';
import 'package:learning/services/app_remote_config.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/states/app_state.dart';
import 'package:learning/states/video_state.dart';
import 'package:learning/utils/app_localization.dart';
import 'package:learning/utils/logger.dart';
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
        StreamProvider<FirebaseUser>(create: (_) => userRepository.onAuthStateChange, lazy: false,),
        FutureProvider<SharedPreferences>(create: (_) => SharedPreferences.getInstance(), lazy: false,),
        FutureProvider<RemoteConfig>(create: (_) => getRemoteConfig(), lazy: false,),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(lang: 'en', isLightTheme: true),
          lazy: false,
        ),
        ChangeNotifierProvider<VideoState>(
          create: (_) => VideoState(),
        ),
      ],
      child: MyAppLoad(),
    );
  }
}

class MyAppLoad extends StatefulWidget {
  @override
  _MyAppLoadState createState() => _MyAppLoadState();
}

class _MyAppLoadState extends State<MyAppLoad> {
  final log = getLogger('MyAppLoad');
  SharedPreferences prefs;
  SpecificLocalizationDelegate _localeOverrideDelegate;
  AppState appState;
  String _currentLang;

  onLocaleChange(Locale locale){
    setState((){
      _currentLang = locale.languageCode;
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(appState == null) {
//      appState = Provider.of(context);
    } else {
      if(appState.lang != _currentLang){
        onLocaleChange(Locale('${appState.lang}'));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MultiProvider(
      providers: [

        StreamProvider<List<Watch>>.value(
          value: watchFirebaseService.find(query: watchFirebaseService.colRef.where('uid', isEqualTo: user?.uid), orderField: 'date', descending: true),
          lazy: false,
          catchError: (context, error) {
            log.w('watchStream error $error');
            return;
          } ,
        ),
        StreamProvider<List<SeriesWatch>>.value(
          value: series_watchFirebaseService.find(query: series_watchFirebaseService.colRef.where('uid', isEqualTo: user?.uid), orderField: 'date', descending: true),
          lazy: false,
          catchError: (context, error) {
            log.w('seriesWatchStream error $error');
            return;
          } ,
        ),
        StreamProvider<Profile>.value(
          value: profileFirebaseService.findById(id: user?.uid),
          lazy: false,
          catchError: (context, error) {
            log.w('profileFirebaseService error $error');
            return;
          } ,
        ),
        StreamProvider<List<Video>>.value(
          value: videoFirebaseService.find(
              query: videoFirebaseService.colRef.where('sid', isEqualTo: Provider.of<VideoState>(context).selectedSeries?.id),
              orderField: 'order'
          ),
          catchError: (context, error) {
            log.w('VideoService error $error');
            return;
          } ,
        )
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        supportedLocales: AppState.supportedLocales(),
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
//          AppLocalizations.delegate,
          _localeOverrideDelegate,
          const TranslationsDelegate(),
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if(appState == null) {
            appState = Provider.of(context);
          }
//           Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {

//            if (supportedLocale.languageCode == locale.languageCode &&
//                supportedLocale.countryCode == locale.countryCode) {
            if (supportedLocale.languageCode == locale.languageCode) {
              _currentLang = locale.languageCode;
              appState.initLang(_currentLang);
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          _currentLang = 'en';
          appState.initLang('en');
          return supportedLocales.first;
        },
        onGenerateTitle: (BuildContext context) => Translations.of(context).text('title'),
        debugShowCheckedModeBanner: false,
        theme: (Provider.of<AppState>(context, listen: false).isLightTheme) ? lightTheme : darkTheme, // AppTheme.themeData(),
//      darkTheme: darkTheme,
        home: SplashPage(),
        initialRoute: AppRouter.splashPage,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: AppRouter.navigatorKey,
      ),
    );
  }
}

