import 'package:flutter/material.dart';
import 'package:sangkuriang/widgets/home.dart';
import 'package:sangkuriang/widgets/about/about.dart';
import 'package:sangkuriang/widgets/ticket/history.dart';

class ThemesPage extends StatefulWidget {
  @override
  State createState() => new _themesPageState();
}

class _themesPageState extends State<ThemesPage> {
  int _page = 0;
  List<Widget> initialWidgets = <Widget>[
    new HomePage(),
    new HistoryPage(),
    new AboutPage(),
  ];

  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children:
          new List<Widget>.generate(initialWidgets.length, (int index) {
            return new IgnorePointer(
              ignoring: index != _page,
              child: new Opacity(
                opacity: _page == index ? 1.0 : 0.0,
                child: new Navigator(
                  onGenerateRoute: (RouteSettings settings) {
                    return new MaterialPageRoute(
                      builder: (_) => initialWidgets[index],
                    );
                  },
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            //canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Color(0xFF00BFA5),
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.black54))),
          child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _page,
            onTap: (int index) {
              setState(() {
                _page = index;
              });
            },
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.history),
                title: new Text('History'),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle),
                title: new Text('About'),
              ),
            ],
          ),
        ));
  }
}
