import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/dark_theme.dart';
import 'package:learning/light_theme.dart';
import 'package:learning/models/series.dart';
import 'package:learning/models/series.service.dart';
import 'package:learning/models/video.dart';
import 'package:learning/models/watch.dart';
import 'package:learning/pages/splash.dart';
import 'package:learning/routes/router.gr.dart';
import 'package:learning/models/video.service.dart';
import 'package:learning/models/watch.service.dart';
import 'package:learning/services/user_repository.dart';
import 'package:learning/states/theme_state.dart';
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
        ChangeNotifierProvider(
          create: (_) => ThemeState(isLightTheme: true),
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

class MyAppLoad extends StatelessWidget {
  final log = getLogger('MyAppLoad');

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);
    Stream<List<Watch>> watchStream = watchFirebaseService.find(query: watchFirebaseService.colRef.where('uid', isEqualTo: user?.uid));
    Stream<List<Video>> videoStream = videoFirebaseService.find(
      query: videoFirebaseService.colRef.where('sid', isEqualTo: Provider.of<VideoState>(context).selectedSeries?.id),
      orderField: 'order'
    ); //
    // VideoService.findBySeries(id: Provider.of<VideoState>(context).selectedSeries?.id);
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MultiProvider(
      providers: [

        StreamProvider<List<Watch>>.value(
          value: watchStream,
          lazy: false,
          catchError: (context, error) {
            log.w('watchStream error $error');
            return;
          } ,
        ),
        StreamProvider<List<Series>>(
          create: (_) => seriesFirebaseService.find(
            query: seriesFirebaseService.colRef.where('status', isEqualTo: 'publish'),
            orderField: 'order'
          ),
          lazy: false,
          catchError: (context, error) {
            log.w('SeriesService error $error');
            return;
          } ,
        ),
        StreamProvider<List<Video>>.value(
          value: videoStream,
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
          if (locale == null) {
            return supportedLocales.first;
          }

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
//      darkTheme: darkTheme,
        home: SplashPage(),
        initialRoute: AppRouter.splashPage,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: AppRouter.navigatorKey,
      ),
    );
  }
}

