import 'package:flutter/material.dart';
import 'package:looper/pages/home.dart';
import 'package:looper/pages/record.dart';
import 'package:looper/pages/play.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPage = 0;
  final List<Widget> _pages = [
    Home(),
    Recorder(),
    Play()
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
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            title: Text('Play'),
          ),
        ],
      ),
    );
  }
}
