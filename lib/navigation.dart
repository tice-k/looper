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
    Recorder(),
    Play(),
  ];
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
      icon: Icon(Icons.headset_mic),
      title: Text('Clips'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack),
      title: Text('Play'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: currentPage == 0 ? null : Text('Looper'),
        centerTitle: true,
        elevation: 0,
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[900],
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        currentIndex: currentPage,
        items: _pageIcons,
      ),
    );
  }
}
