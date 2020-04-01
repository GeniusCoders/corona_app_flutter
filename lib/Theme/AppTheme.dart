import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
      subtitle: TextStyle(
        color: Colors.black12,
        fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    iconTheme: IconThemeData(
      color: Color(0xFFDEDEDE),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF3E3F44),
    ),
    textTheme: TextTheme(
      title: TextStyle(
        color: Color(0xFFDEDEDE),
        fontSize: 20.0,
      ),
      subtitle: TextStyle(
        color: Color(0xFFDEDEDE),
        fontSize: 18.0,
      ),
    ),
  );
}
