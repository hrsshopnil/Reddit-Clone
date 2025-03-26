import 'package:flutter/material.dart';

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      surface: blackColor,
      brightness: Brightness.dark,
      onSurface: whiteColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(color: whiteColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: drawerColor),
    primaryColor: redColor,
    listTileTheme: const ListTileThemeData(
      textColor: whiteColor,
      iconColor: whiteColor,
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: whiteColor),
      bodyMedium: const TextStyle(color: whiteColor),
      bodySmall: const TextStyle(color: whiteColor),
      displayLarge: const TextStyle(color: whiteColor),
      displayMedium: const TextStyle(color: whiteColor),
      displaySmall: const TextStyle(color: whiteColor),
      headlineLarge: const TextStyle(color: whiteColor),
      headlineMedium: const TextStyle(color: whiteColor),
      headlineSmall: const TextStyle(color: whiteColor),
      titleLarge: const TextStyle(color: whiteColor),
      titleMedium: const TextStyle(color: whiteColor),
      titleSmall: const TextStyle(color: whiteColor),
      labelLarge: const TextStyle(color: whiteColor),
      labelMedium: const TextStyle(color: whiteColor),
      labelSmall: const TextStyle(color: whiteColor),
    ),
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: blackColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
    primaryColor: redColor,
  );
}
