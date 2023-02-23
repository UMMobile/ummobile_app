import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppColorThemes {
  /// The bright theme of the application
  static final brightTeme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      secondary: Color.fromRGBO(110, 86, 198, 1),
    ),
    hintColor: Colors.grey,
    secondaryHeaderColor: Color.fromRGBO(110, 86, 198, 1),
    primarySwatch: MaterialColor(0xFF6E56C6, {
      50: Color.fromRGBO(110, 86, 198, .1),
      100: Color.fromRGBO(110, 86, 198, .2),
      200: Color.fromRGBO(110, 86, 198, .3),
      300: Color.fromRGBO(110, 86, 198, .4),
      400: Color.fromRGBO(110, 86, 198, .5),
      500: Color.fromRGBO(110, 86, 198, .6),
      600: Color.fromRGBO(110, 86, 198, .7),
      700: Color.fromRGBO(110, 86, 198, .8),
      800: Color.fromRGBO(110, 86, 198, .9),
      900: Color.fromRGBO(110, 86, 198, 1),
    }),

    // Define the default font family.
    fontFamily: 'Open Sans',
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(
          color: AppColorThemes.textColor,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal),
      bodyMedium: TextStyle(fontSize: 14.0),
    ),

    appBarTheme: AppBarTheme(
      color: Colors.white,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );

  /// The dark theme of the application
  static final darkTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.lightBlue,
    ),
    primaryColor: Colors.white,
    hintColor: Colors.white70,
    secondaryHeaderColor: Colors.lightBlue,

    /*primarySwatch: MaterialColor(0xFF6E56C6, {
      50: Color.fromRGBO(110, 86, 198, .1),
      100: Color.fromRGBO(110, 86, 198, .2),
      200: Color.fromRGBO(110, 86, 198, .3),
      300: Color.fromRGBO(110, 86, 198, .4),
      400: Color.fromRGBO(110, 86, 198, .5),
      500: Color.fromRGBO(110, 86, 198, .6),
      600: Color.fromRGBO(110, 86, 198, .7),
      700: Color.fromRGBO(110, 86, 198, .8),
      800: Color.fromRGBO(110, 86, 198, .9),
      900: Color.fromRGBO(110, 86, 198, 1),
    }),*/

    // Define the default font family.
    fontFamily: 'Open Sans',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0),
    ),

    appBarTheme: AppBarTheme(
      color: Colors.white,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );

  static Color get textColor => Get.isDarkMode ? Colors.white : Colors.black;

  static final colorSecondary = LinearGradient(
      colors: [Color.fromRGBO(0, 208, 216, 1), Color.fromRGBO(5, 188, 200, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.7],
      tileMode: TileMode.clamp);

  static final mainGradient = LinearGradient(
      colors: [Color.fromRGBO(0, 208, 216, 1), Color.fromRGBO(110, 86, 198, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.7],
      tileMode: TileMode.clamp);

  static final inputGradientCorrect = LinearGradient(
      colors: [Color.fromRGBO(0, 208, 216, 1), Color.fromRGBO(110, 86, 198, 1)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 0.7],
      tileMode: TileMode.clamp);

  static final inputGradientError = LinearGradient(
      colors: [Colors.red, Colors.red],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 0.7],
      tileMode: TileMode.clamp);

  static final inputGradientIdle = LinearGradient(
      colors: [Colors.grey, Colors.grey],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 0.7],
      tileMode: TileMode.clamp);
}
