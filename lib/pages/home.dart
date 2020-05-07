import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// home screen, create new project, look at old projects

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Looper',
                style: TextStyle(
                  fontSize: 50.0,
                  letterSpacing: 3.0,
                ),
              ),
              RaisedButton.icon(
                onPressed: () {

                },
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                label: Text(
                  'Create New Project'
                ),
                disabledColor: Colors.white,
              ),
              RaisedButton.icon(
                onPressed: () async {
                  Directory appDoc = await getApplicationDocumentsDirectory();
                  appDoc.delete(recursive: true);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
                label: Text(
                    'Clear data'
                ),
                disabledColor: Colors.white,
              ),
              RaisedButton.icon(
                onPressed: () {

                },
                icon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                label: Text(
                  'About',
                ),
                disabledColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
