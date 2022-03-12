import 'package:flutter/material.dart';


class CustomTheme {
  static ThemeData get penzzTheme {
    return ThemeData(
        scaffoldBackgroundColor: const Color(0XFFECF0F3),
        fontFamily: 'Fredoka',
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.lightBlue,
        )
    );
  }
}