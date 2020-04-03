import 'package:coronaapp/Style/colors.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;
  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? darkTheme : lightTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}

final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: lightBlack,
    textTheme: TextTheme(
        title: TextStyle(
            color: lightWhite, fontSize: 18, fontWeight: FontWeight.w800),
        subtitle: TextStyle(
            color: lightWhite, fontSize: 16, fontWeight: FontWeight.w600)),
    iconTheme: IconThemeData(color: lightWhite));

final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: lightWhite,
    textTheme: TextTheme(
        title: TextStyle(
            color: mediumBlack, fontSize: 18, fontWeight: FontWeight.w800),
        subtitle: TextStyle(
            color: mediumBlack, fontSize: 16, fontWeight: FontWeight.w700)),
    iconTheme: IconThemeData(color: mediumBlack));
