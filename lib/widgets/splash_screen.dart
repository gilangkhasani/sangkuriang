import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  SharedPreferences sharedPreferences;
  bool checkLogin = false;
  String page = "";

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkLogin = sharedPreferences.getBool("checkLogin");
      if (checkLogin != null) {
        if (checkLogin) {
          page = "themes";
        } else {
          page = "login";
        }
      } else {
        page = "login";
        checkLogin = false;
      }
    });
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed("/" + page);
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    getPrefs();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context)
    );
  }

  Widget _buildOldContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                //child:new Image.asset('assets/images/Logomark.png',height: 25.0,fit: BoxFit.scaleDown,)
                child: new Text("ITBS Jabar"))
          ],
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              'assets/images/flutter1.png',
              width: animation.value * 250,
              height: animation.value * 250,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5],
              colors: [
                Color(0xFF00BFA5),
                Colors.black87,
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      'SANGKURIANG',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.white54,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text(
                    'LOADING',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
