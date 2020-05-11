import 'package:flutter/material.dart';
import 'package:looper/pages/home.dart';
import 'package:looper/pages/projects.dart';
import 'package:looper/pages/record.dart';
import 'package:looper/pages/play.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int currentPage = 0;
  List<Widget> pages = [
    Home(),
    ProjectView(),
    Play(),
  ];
  final navigatorKey = GlobalKey<NavigatorState>();
  final routePages = {
    '/': () => MaterialPageRoute(builder: (context) => Home()),
    '/projects': () => MaterialPageRoute(builder: (context) => ProjectView()),
    '/play': () => MaterialPageRoute(builder: (context) => Play()),
  };
  final List<BottomNavigationBarItem> _pageIcons = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder_open),
      title: Text('Projects'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack),
      title: Text('Play'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: (route) {
          if(route.name == '/record')
            return MaterialPageRoute(builder: (context) => Recorder(route.arguments));
          else
            return routePages[route.name]();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[900],
        onTap: (routeName) {
          setState(() {
            navigatorKey.currentState.pushReplacementNamed(routePages.keys.toList()[routeName]);
            currentPage = routeName;
          });
        },
        currentIndex: currentPage,
        items: _pageIcons,
      ),
    );
  }
}
