import 'package:flutter/material.dart';
import 'package:sangkuriang/widgets/home.dart';
import 'package:sangkuriang/widgets/about/about.dart';
import 'package:sangkuriang/widgets/ticket/history.dart';
import 'package:sangkuriang/widgets/login_screen/login_screen.dart';
import 'package:sangkuriang/widgets/themes.dart';
import 'package:sangkuriang/widgets/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "SANGKURIANG",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => new HomePage(),
        "/history": (BuildContext context) => new HistoryPage(),
        "/about": (BuildContext context) => new AboutPage(),
        "/login": (BuildContext context) => new LoginPage(),
        "/themes": (BuildContext context) => new ThemesPage(),
      },
    );
  }
}


