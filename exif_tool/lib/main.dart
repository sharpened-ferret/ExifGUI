import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExifTool',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
      ],
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        //primarySwatch: Colors.red,
        indicatorColor: Colors.blue,
        splashColor: Colors.redAccent,

        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: const HomePage(title: 'ExifGUI'),
    );
  }

  void changeTheme() {
    if (_themeMode == ThemeMode.light) {
      setState(() {
        _themeMode = ThemeMode.dark;
      });
    } else {
      setState(() {
        _themeMode = ThemeMode.light;
      });
    }
  }

  bool getTheme() {
    if (_themeMode == ThemeMode.dark) {
      return true;
    } else {
      return false;
    }
  }
}
