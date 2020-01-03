import 'package:flutter/material.dart';

class AppTheme {
  static const colorWhatsapp = Color(0xff25D366);
  static const primaryColor = const Color(0xFF214e9c);
  static const accentColor = Color(0xff2d69d2);

  static ThemeData themeData() {
    const MaterialColor appBlue = const MaterialColor(
      0xFF0075FF,
      const <int, Color>{
        50: const Color(0xFFD0E5FF),
        100: const Color(0xFFB9D9FF),
        200: const Color(0xFFA2CCFF),
        300: const Color(0xFF73B3FF),
        400: const Color(0xFF459AFF),
        500: const Color(0xFF0075FF),
        600: const Color(0xFF006BE8),
        700: const Color(0xFF0060D1),
        800: const Color(0xFF0056BA),
        900: const Color(0xFF004BA3),
      },
    );

//    const accentColor = Color(0xff0086c1);

//    const primaryColor = Color(0xFF6c22a4);


    return ThemeData(
      fontFamily: 'SFPro',
//      primaryColor: primaryColor,
      accentColor: accentColor,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: appBlue,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: primaryColor
        ),
        textTheme: TextTheme(
          title: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
          display1: TextStyle(color: Colors.black),
          body1: TextStyle(color: Colors.black),
        ),
        elevation: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 20.0
        ),
        headline: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        body1: TextStyle(fontSize: 18.0),
        display1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        display2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        display3: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
        display4: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
        subtitle: TextStyle(fontSize: 12.0),
        caption: TextStyle(fontSize: 10.0),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey.shade500,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 40.0),
          borderSide: BorderSide(
            width: 2.0,
            color: primaryColor,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      )
    );
  }
}