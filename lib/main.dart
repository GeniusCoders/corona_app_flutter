import 'package:coronaapp/DemoMapView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Theme/ThemeProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(
        isLightTheme: false,
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Changer',
      theme: themeProvider.getThemeData,
      home: DemoMapview(),
    );
  }
}
