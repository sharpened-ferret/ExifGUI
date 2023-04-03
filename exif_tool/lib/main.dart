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

  // This widget is the root of your application.
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
