import 'package:flutter/material.dart';

const Color bluishColor = Color(0xFF4e5ae8);
const Color yellowColor = Color(0xFFffb746);
const Color pinkColor = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(color: primaryColor),
    brightness: Brightness.light, // find text color based on the bg color automatically
  );

  static final dark = ThemeData(
    primaryColor: darkGreyColor,
    appBarTheme: const AppBarTheme(color: darkGreyColor),
    brightness: Brightness.dark,
  );
}
